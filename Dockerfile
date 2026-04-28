FROM debian:latest

RUN apt-get update && apt-get install -y nginx wget

# On copie nos fichiers statiques
COPY web/index.html /var/www/html/index.html
COPY web/script.js /var/www/html/script.js
COPY web/style.css /var/www/html/style.css
COPY liens_videos.txt /liens_videos.txt
COPY entrypoint.sh /entrypoint.sh
COPY style.css /var/www/html/style.css

RUN chmod +x /entrypoint.sh

EXPOSE 80
ENTRYPOINT ["/entrypoint.sh"]
