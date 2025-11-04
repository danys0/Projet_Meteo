#!/bin/bash

<<<<<<< HEAD
if [ -z "$1" ]; then
	echo "Erreur :  Aucun paramètre en entrée "
	echo "Usage : ./Extracteur_Meteo.sh Ville"
fi

Ville="$1"

fichier="./meteo_${Ville}.txt"

curl -s https://wttr.in/${Ville} -o "$fichier"

=======
>>>>>>> 344168cb5c9eeaec5549f0c5129024da124a05d4
