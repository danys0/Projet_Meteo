#!/bin/bash

Ville="$1"

fichier="./meteo_${Ville}.txt"

curl -s https://wttr.in/${Ville} -o "$fichier"
