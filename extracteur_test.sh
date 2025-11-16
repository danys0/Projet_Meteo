#!/bin/bash
Ville_defaut="Toulouse"
if [ -z "$1" ];
then
        Ville="$Ville_defaut"
fi
donnees=$(curl -s "wttr.in/$Ville?format=%l|%t|%x")

Ville=$(echo "$donnees" | cut -d '|' -f 1)
temp=$(echo "$donnees" | cut -d '|' -f 2)
prevision=$(echo "$donnees" | cut -d '|' -f 3)
date_heure=$(date +%Y-%m-%d-%H:%M)
enregistrement="${date_heure}-${Ville}: ${temp} - ${prevision}"
echo "$enregistrement" >> meteo_test.txt
echo "Enregistrement réussi dans meteo.txt : "
echo "$enregistrement"


