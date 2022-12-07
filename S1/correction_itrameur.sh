#!/usr/bin/env bash

# attention : ce script doit être lancé depuis la racine du projet.
# Cela lui permet de récupérer les fichiers dans les bons dossiers.
# 
# Se lancera donc comme ça :
# $ ./programmes/correction_itrameur.sh

if [[ $# -ne 2 ]]
then
	echo "Deux arguments attendus: <dossier> <langue>"
	exit
fi

folder=$1 # dumps-text OU contextes
basename=$2 # en, fr, ru, pl, it, jp, etc...

echo "<lang=\"$basename\">" > "./itrameur/$folder-$basename.txt"

for filepath in $(ls $folder/$basename-*.txt)
do
	# filepath == dumps-texts/fr-1.txt
	# 	==> pagename = fr-1
	pagename=$(basename -s .txt $filepath)

	echo "<page=\"$pagename\">" >> "./itrameur/$folder-$basename.txt"
	echo "<text>" >> "./itrameur/$folder-$basename.txt"
	
	# on récupère les dumps/contextes
	# et on écrit à l'intérieur de la balise text
	content=$(cat $filepath)
	# ordre important : & en premier
	# sinon : < => &lt; => &amp;lt;
	content=$(echo "$content" | sed 's/&/&amp;/g')
	content=$(echo "$content" | sed 's/</&lt;/g')
	content=$(echo "$content" | sed 's/>/&gt;/g')

	echo "$content" >> "./itrameur/$folder-$basename.txt"

	echo "</text>" >> "./itrameur/$folder-$basename.txt"
	echo "</page> §" >> "./itrameur/$folder-$basename.txt"
done

echo "</lang>" >> "./itrameur/$folder-$basename.txt"
