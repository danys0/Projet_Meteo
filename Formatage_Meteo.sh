#!/bin/bash

if [ -z "$1" ]; then
    echo "Erreur : Aucun paramètre en entrée"
    echo "Usage : $0 Ville"
    exit 1
fi

Ville="$1"

# Récupérer directement la température actuelle et demain
temps=$(curl -s "wttr.in/${Ville}?format=%t+%T")
temp_actuelle=$(echo "$temps" | cut -d'+' -f1)
temp_demain=$(echo "$temps" | cut -d'+' -f2)

# Écrire sur une seule ligne dans meteo.txt
echo "Ville : $Ville | Température actuelle : $temp_actuelle | Prévision demain : $temp_demain" >> meteo.txt
echo "Données formatées ajoutées dans meteo.txt"

