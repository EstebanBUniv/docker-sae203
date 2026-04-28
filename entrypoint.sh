#!/bin/bash

echo "Initialisation de DebianFlix..."

mkdir -p /var/www/html/videos

echo "{}" > /var/www/html/likes.json

mkdir -p /var/www/html/cgi-bin

cat <<'EOF' > /var/www/html/cgi-bin/like.sh
#!/bin/bash

echo "Content-type: text/html"
echo ""

VIDEO=$(echo "$QUERY_STRING" | sed -n 's/^video=\(.*\)$/\1/p')

FILE="/var/www/html/likes.json"

python3 - <<PY
import json

file = "$FILE"
video = "$VIDEO"

try:
    with open(file) as f:
        data = json.load(f)
except:
    data = {}

data[video] = data.get(video, 0) + 1

with open(file, "w") as f:
    json.dump(data, f)

print("OK")
PY

echo "<a href='/'>Retour</a>"
EOF

chmod +x /var/www/html/cgi-bin/like.sh

echo "Téléchargement des vidéos en cours..."
while read -r url; do
    [ -z "$url" ] && continue
    echo "- Téléchargement de : $url"
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

    likes=$(python3 - <<PY
import json
try:
    print(json.load(open('/var/www/html/likes.json')).get("$nom_fichier", 0))
except:
    print(0)
PY
)

    echo "        <div class='video-card'>" >> $FICHIER_HTML
    echo "            <h3>$nom_fichier</h3>" >> $FICHIER_HTML
    echo "            <video controls src='videos/$nom_fichier'></video>" >> $FICHIER_HTML
    echo "            <p class='likes'>👍 Likes : $likes</p>" >> $FICHIER_HTML
    echo "            <a class='like' href='/cgi-bin/like.sh?video=$nom_fichier'>Like 👍</a>" >> $FICHIER_HTML
    echo "        </div>" >> $FICHIER_HTML
done

echo "    </div></body></html>" >> $FICHIER_HTML

echo "Site prêt ! Allumage du serveur web..."
nginx -g "daemon off;"