L’objectif de ce projet est de créer un script Shell qui extrait périodiquement la température actuelle d'une
ville donnée ainsi que les prévisions météorologiques pour le lendemain en utilisant le service wttr.in. Le
script enregistrera les informations extraites dans un fichier texte, chaque enregistrement devant apparaître
sur une seule ligne.
Pour automatiser ce script, il va falloir configurer une tache cron.
Etapes de configuration :
- Installation de Cron (si ce n'est pas déjà fait) :

sudo apt install cron

- Accéder au crontab :

crontab -e

- Ajouter la tâche :

* * * * * /chemin/absolu/vers/Extracteur_Météo.sh

Explication des champs de la commande :

La commande est divisé en 6 champs :

- 1er champ : minutes (0-59)

- 2eme champ : Heures (0-23)

- 3eme champ : Jour du mois (1-31)

- 4eme champ : Mois (1-12)

- 5eme champ : Jour de la semaine (0-7 avec 0 et 7 correspondant à Dimanche)

- 6eme champ : Commande

Par exemple, pour éxécuter le script tout les jours à 10h du matin :

0 10 * * * /chemin/absolu/vers/Extracteur_Météo.sh

Tout les Samedi à 12h :

0 12 * * 6 /chemin/absolu/vers/Extracteur_Meteo.sh 

