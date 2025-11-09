#!/bin/bash

if [ -z "$1" ]; then
	echo "Erreur :  Aucun paramètre en entrée "
	echo "Usage : ./Extracteur_Meteo.sh Ville"
fi

Ville="$1"

fichier="./meteo_${Ville}.txt"

curl -s https://wttr.in/${Ville} -o "$fichier"

meteo="./meteo_${Ville}.txt"


jour1et2=$(awk '
/┌──────────────────────────────┬/ {block++}
block >= 1 && block <= 2
/└──────────────────────────────┴/ && block == 2 {exit}
' "$meteo")

echo "$jour1et2"

