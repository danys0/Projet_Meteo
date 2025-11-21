#!/bin/bash

# --- Vérifie si une ville est passée en paramètre, sinon Toulouse par défaut ---
Ville="$1"
if [ -z "$1" ] || [ "$1" -ne 1 ]; then
    Ville="Toulouse"
fi

fichier="./meteo_${Ville}.txt"

# --- Récupère la météo complète du site wttr.in pour la ville ---
curl -s https://wttr.in/${Ville} -o "$fichier"
meteo="./meteo_${Ville}.txt"

# --- Extrait les deux premiers jours du tableau ASCII (pour info) ---
jour1et2=$(awk '
/┌──────────────────────────────┬/ {block++}
block >= 1 && block <= 2
/└──────────────────────────────┴/ && block == 2 {exit}
' "$meteo")

# --- Affiche le tableau brut pour voir rapidement ---
echo "$jour1et2"

# ===========================
# --- MÉTÉO ACTUELLE ---
# ===========================
donnees_auj=$(curl -s "wttr.in/${Ville}?format=%t+%C+%w+%h")
temp_actuelle=$(echo "$donnees_auj" | awk '{print $1}')
humidite_actuelle=$(echo "$donnees_auj" | awk '{print $NF}')
vent_actuel=$(echo "$donnees_auj" | awk '{print $(NF-1)}')
condition_actuelle=$(echo "$donnees_auj" | awk '{for(i=2;i<=NF-2;i++) printf $i " "; print ""}')

# ===========================
# --- MÉTÉO DEMAIN ---
# ===========================
# Récupère la météo brute pour demain
meteo_raw=$(curl -s "wttr.in/${Ville}?2&T&lang=fr")

# Calcule la température moyenne de demain
temp_demain=$(echo "$meteo_raw" | awk '
BEGIN { tab_count=0; in_second=0; sum=0; count=0 }
/^┌/ && /┤/ { tab_count++; if(tab_count==2) in_second=1 }
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

# Extrait condition, vent et humidité pour demain
condition_demain=$(echo "$meteo_raw" | grep -A2 "┤" | tail -n20 | grep -E "Sunny|Rain|Clear|Cloud|Thunder|Fog|Neige|Pluie" | head -n1)
vent_demain=$(echo "$meteo_raw" | grep -oE "[0-9]+-[0-9]+ km/h" | head -n1)
humidite_demain=$(echo "$meteo_raw" | grep -oE "[0-9]{1,3}%$" | head -n1)

# Met "N/A" si aucune info trouvée
temp_demain=${temp_demain:-N/A}
condition_demain=${condition_demain:-N/A}
vent_demain=${vent_demain:-N/A}
humidite_demain=${humidite_demain:-N/A}

# ===========================
# --- AFFICHAGE FORMATÉ ---
# ===========================
echo "--- Météo actuelle pour $Ville ---"
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

# ===========================
# --- ENREGISTREMENT DANS FICHIER ---
# ===========================
fichier_sortie="meteo.txt"
date=$(date +"%Y-%m-%d")
heure_precise=$(date +"%H:%M")
echo "${date} - ${heure_precise} - ${Ville} : ${temp_actuelle} - ${temp_demain}" >> "$fichier_sortie"

