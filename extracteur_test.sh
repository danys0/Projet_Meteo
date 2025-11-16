#!/bin/bash
Ville="$1"
if [ -z "$1" ] || [ "$1" -ne 1];
then
        ville="Toulouse"
fi
donnees=$(curl -s "wttr.in/$CITY?format=%l|%t|%x")

Ville=$(echo "$donnees" | cut -d '|' -f 1)
temp=$(echo "$donnees" | cut -d '|' -f 2)
prevision=$(echo "$donnees" | cut -d '|' -f 3)
date_heure=$(date +%Y-%m-%d-%H:%M)
enregistrement="${date_heure}-${Ville}: ${temp} - ${prevision}"
echo "$enregistrement" >> meteo_test.txt
echo "Enregistrement réussi dans meteo.txt : "
echo "$enregistrement"


