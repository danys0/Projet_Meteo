#!/bin/bash

if [ -z "$1" ]; then
    echo "Erreur : Aucun paramètre en entrée"
    echo "Usage : $0 Ville"
    exit 1
fi

Ville="$1"
fichier="meteo_${Ville}.txt"

./Extracteur_Meteo.sh "$Ville"

jour1et2=$(awk '
/┌──────────────────────────────┬/ {block++}
block >= 1 && block <= 2
/└──────────────────────────────┴/ && block == 2 {exit}
' "$fichier")

echo "$jour1et2"
