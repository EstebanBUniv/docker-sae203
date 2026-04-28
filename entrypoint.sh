#!/bin/bash

echo "Initialisation de DebianFlix..."

# On crée le dossier qui va accueillir les vidéos
mkdir -p /var/www/html/videos

echo "Téléchargement des vidéos en cours..."
# On lit le fichier texte ligne par ligne
while read -r url; do
    # Si la ligne est vide, on passe
    [ -z "$url" ] && continue
    echo "- Téléchargement de : $url"
    # wget télécharge le fichier et le range dans le dossier videos/
    wget -q --show-progress -P /var/www/html/videos/ "$url"
done < /liens_videos.txt

echo "Génération du catalogue HTML..."
FICHIER_HTML="/var/www/html/index.html"

cat <<EOF > $FICHIER_HTML
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>DebianFlix</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <h1>DebianFlix</h1>
    <div class="catalogue">
EOF

for video in /var/www/html/videos/*.mp4; do
    [ -e "$video" ] || continue 
    nom_fichier=$(basename "$video")
    
    echo "        <div class='video-card'>" >> $FICHIER_HTML
    echo "            <h3>$nom_fichier</h3>" >> $FICHIER_HTML
    echo "            <video controls src='videos/$nom_fichier'></video>" >> $FICHIER_HTML
    echo "        </div>" >> $FICHIER_HTML
done

echo "    </div></body></html>" >> $FICHIER_HTML

echo "Site prêt ! Allumage du serveur web..."
nginx -g "daemon off;"