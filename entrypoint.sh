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
    <style>
        body { background-color: #141414; color: white; font-family: Arial, sans-serif; text-align: center; }
        h1 { color: #E50914; margin-top: 30px; font-size: 3em;}
        .catalogue { display: flex; flex-wrap: wrap; justify-content: center; gap: 30px; padding: 20px; }
        .video-card { background: #222; padding: 15px; border-radius: 10px; box-shadow: 0 4px 8px rgba(0,0,0,0.5); }
        video { width: 400px; border-radius: 5px; outline: none; }
        h3 { margin-bottom: 10px; font-size: 1em; color: #aaa; word-wrap: break-word; max-width: 400px;}
    </style>
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
