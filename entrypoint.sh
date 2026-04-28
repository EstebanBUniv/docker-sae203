#!/bin/bash

echo "Lecture du fichier /liens_videos.txt..."

# Ajout de || [ -n "$url" ] pour ne pas rater la dernière ligne
while read -r url || [ -n "$url" ]; do
    # On nettoie l'URL des éventuels caractères \r cachés
    url=$(echo "$url" | tr -d '\r')

    [ -z "$url" ] && continue
    
    echo "Tentative de téléchargement de : $url"
    # On enlève le -q pour voir l'erreur réelle
    wget --no-check-certificate -P /var/www/html/videos/ "$url"
done < /liens_videos.txt

echo "Fin du téléchargement, génération du JS..."
# 2. Génération du fichier DATA pour le JavaScript
echo "var videoList = [" > /var/www/html/videos.js
for video in /var/www/html/videos/*.mp4; do
    [ -e "$video" ] || continue
    nom=$(basename "$video")
    echo "  \"$nom\"," >> /var/www/html/videos.js
done
echo "];" >> /var/www/html/videos.js

echo "Données générées pour le JS."

# 3. Lancement de Nginx
nginx -g "daemon off;"
