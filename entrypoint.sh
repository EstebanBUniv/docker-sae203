#!/bin/bash

echo "Génération du catalogue DebianFlix en cours..."

# 1. On définit où sera créé le site
FICHIER_HTML="/var/www/html/index.html"

# 2. On écrit l'en-tête du site (avec un joli design Netflix)
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
		h3 { margin-bottom: 10px; }
	</style>
</head>
<body>
	<h1>DebianFlix</h1>
	<div class="catalogue">
EOF

# 3. LA BOUCLE INTELLIGENTE : on cherche toutes les vidéos
for video in /var/www/html/videos/*.mp4; do
	# Si le dossier est vide, on arrête pour ne pas faire d'erreur
	[ -e "$video" ] || continue 
	
	# On récupère juste le nom du fichier (ex: "film1.mp4")
	nom_fichier=$(basename "$video")
	
	# On ajoute un lecteur vidéo au site pour chaque fichier trouvé
	echo "        <div class='video-card'>" >> $FICHIER_HTML
	echo "            <h3>$nom_fichier</h3>" >> $FICHIER_HTML
	echo "            <video controls src='videos/$nom_fichier'></video>" >> $FICHIER_HTML
	echo "        </div>" >> $FICHIER_HTML
done

# 4. On ferme les balises HTML
echo "    </div></body></html>" >> $FICHIER_HTML

echo "Site généré avec succès ! Lancement de Nginx..."

# 5. On lance le serveur web Nginx au premier plan
nginx -g "daemon off;"
