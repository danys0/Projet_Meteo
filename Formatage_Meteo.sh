#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage : $0 Ville"
    exit 1
fi

ville="$1"

# --- MÉTÉO ACTUELLE (NE PAS TOUCHER) ---
donnees_auj=$(curl -s "wttr.in/${ville}?format=%t+%C+%w+%h")
temp_actuelle=$(echo "$donnees_auj" | awk '{print $1}')
humidite_actuelle=$(echo "$donnees_auj" | awk '{print $NF}')
vent_actuel=$(echo "$donnees_auj" | awk '{print $(NF-1)}')
condition_actuelle=$(echo "$donnees_auj" | awk '{for(i=2;i<=NF-2;i++) printf $i " "; print ""}')

# --- RÉCUPÉRATION DES DONNÉES BRUTES POUR DEMAIN ---
meteo_raw=$(curl -s "wttr.in/${ville}?2&T&lang=fr")

# --- EXTRACTION TEMP MOYENNE DEMAIN ---
temp_demain=$(echo "$meteo_raw" | awk '
BEGIN {
    tab_count=0
    in_second=0
    sum=0
    count=0
}
/^┌/ && /┤/ {
    tab_count++
    if(tab_count==2) in_second=1
}
in_second {
    if($0 !~ /°C/ || $0 ~ /km\/h/ || $0 ~ /mm/ || $0 ~ / km/) next
    ligne=$0
    while(match(ligne, /[+-]?[0-9]+(\([0-9]+\))? ?°C/)) {
        temp=substr(ligne,RSTART,RLENGTH)
        gsub(/ ?°C/,"",temp)
        gsub(/\(.*\)/,"",temp)
        sum+=temp
        count++
        ligne=substr(ligne,RSTART+RLENGTH)
    }
}
END {
    if(count>0) {
        avg=sum/count
        if(avg>0) printf "+%.0f°C", avg
        else printf "%.0f°C", avg
    }
}
')

# --- CONDITION / VENT / HUMIDITÉ DEMAIN ---
condition_demain=$(echo "$meteo_raw" | grep -A2 "┤" | tail -n20 | grep -E "Sunny|Rain|Clear|Cloud|Thunder|Fog|Neige|Pluie" | head -n1)
vent_demain=$(echo "$meteo_raw" | grep -oE "[0-9]+-[0-9]+ km/h" | head -n1)
humidite_demain=$(echo "$meteo_raw" | grep -oE "[0-9]{1,3}%$" | head -n1)

# Valeurs par défaut si vide
temp_demain=${temp_demain:-N/A}
condition_demain=${condition_demain:-N/A}
vent_demain=${vent_demain:-N/A}
humidite_demain=${humidite_demain:-N/A}

# --- AFFICHAGE ---
fichier_sortie="meteo.txt"

echo "--- Météo actuelle pour $ville ---"
echo "Température : $temp_actuelle"
echo "Condition   : $condition_actuelle"
echo "Vent        : $vent_actuel"
echo "Humidité    : $humidite_actuelle"
echo
echo "--- Prévision pour demain ---"
echo "Température : $temp_demain"
echo "Condition   : $condition_demain"
echo "Vent        : $vent_demain"
echo "Humidité    : $humidite_demain"

date=$(date +"%Y-%m-%d")
heure_precise=$(date +"%H:%M")

# Enregistrement dans meteo.txt
echo "${date} - ${heure_precise} - ${ville} : ${temp_actuelle} - ${temp_demain}" >> "$fichier_sortie"
