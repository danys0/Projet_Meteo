#!/bin/bash

Ville="$1"
if [ -z "$1" ] || [ "$1" -ne 1];
then
	ville="Toulouse"
fi

fichier="./meteo_${Ville}.txt"

curl -s https://wttr.in/${Ville} -o "$fichier"

meteo="./meteo_${Ville}.txt"


jour1et2=$(awk '
/┌──────────────────────────────┬/ {block++}
block >= 1 && block <= 2
/└──────────────────────────────┴/ && block == 2 {exit}
' "$meteo")

echo "$jour1et2"


