#!/bin/bash

if [ -z "$1" ]; then
	echo "Erreur :  Aucun paramètre en entrée "
	echo "Usage : ./Extracteur_Meteo.sh Ville"
fi

Ville="$1"

fichier="./meteo_${Ville}.txt"

curl -s https://wttr.in/${Ville} -o "$fichier"
# il faut ajouter le script Extraction_Auj_Dem.sh
#test tag
