
#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage : $0 Ville"
    exit 1
fi

ville="$1"

donnees_auj=$(curl -s "wttr.in/${ville}?format=%t+%C+%w+%h")
temp_actuelle=$(echo "$donnees_auj" | awk '{print $1}')
humidite_actuelle=$(echo "$donnees_auj" | awk '{print $NF}')
vent_actuel=$(echo "$donnees_auj" | awk '{print $(NF-1)}')
condition_actuelle=$(echo "$donnees_auj" | awk '{for(i=2;i<=NF-2;i++) printf $i " "; print ""}')

donnees_demain=$(curl -s "wttr.in/${ville}?format=%m+%M+%w+%h+%C&num_of_days=2" | sed -n '2p')

if [ -z "$donnees_demain" ]; then
    temp_min_demain="N/A"
    temp_max_demain="N/A"
    vent_demain="N/A"
    humidite_demain="N/A"
    condition_demain="N/A"
else
    temp_min_demain=$(echo "$donnees_demain" | awk '{print $1}')
    temp_max_demain=$(echo "$donnees_demain" | awk '{print $2}')
    vent_demain=$(echo "$donnees_demain" | awk '{print $(NF-1)}')
    humidite_demain=$(echo "$donnees_demain" | awk '{print $NF}')
    condition_demain=$(echo "$donnees_demain" | awk '{for(i=5;i<=NF-2;i++) printf $i " "; print ""}')
fi

fichier_sortie="meteo.txt"

echo "--- Météo actuelle pour $ville ---"
echo "Température : $temp_actuelle"
echo "Condition   : $condition_actuelle"
echo "Vent        : $vent_actuel"
echo "Humidité    : $humidite_actuelle"

echo "--- Prévision pour demain ---"
echo "Température : $temp_min_demain à $temp_max_demain"
echo "Condition   : $condition_demain"
echo "Vent        : $vent_demain"
echo "Humidité    : $humidite_demain"

date=$(date +"%Y-%m-%d")
heure=$(date +"%H:%M")


# Étape 4 : Enregistrement dans meteo.txt
echo "${date} - ${heure} - ${ville} : ${temp_actuelle} - ${temp_max_demain}" >> "$fichier_sortie"

# Message de confirmation
echo "Données enregistrées dans $fichier_sortie"
