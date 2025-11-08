#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage : $0 Ville"
    exit 1
fi

ville="$1"

donnees_auj=$(curl -s "wttr.in/${Ville}?format=%t+%C+%w+%h")
temp_actuelle=$(echo "$donnees_auj" | awk '{print $1}')
condition_actuelle=$(echo "$donnees_auj" | awk '{print $2, $3}')
vent_actuel=$(echo "$donnees_auj" | awk '{print $4}')
humidite_actuelle=$(echo "$donnees_auj" | awk '{print $5}')


donnees_demain=$(curl -s "wttr.in/${Ville}?format=%m+%M+%w+%h&num_of_days=2")


temp_min_demain=$(echo "$donnees_demain" | awk '{print $1}')
temp_max_demain=$(echo "$donnees_demain" | awk '{print $2}')
vent_demain=$(echo "$donnees_demain" | awk '{print $3}')
humidite_demain=$(echo "$donnees_demain" | awk '{print $4}')
condition_demain=$(echo "$donnees_demain" | awk '{print $5,$6}')

fichier_sortie="meteo.txt"

echo "--- Météo actuelle pour $Ville ---"
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
