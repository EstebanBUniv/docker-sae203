FROM debian:latest

# On installe Nginx ET l'outil de téléchargement wget
RUN apt-get update && apt-get install -y nginx wget \
    && rm -rf /var/lib/apt/lists/*

# On copie la liste des liens et le script
COPY liens_videos.txt /liens_videos.txt
COPY entrypoint.sh /entrypoint.sh
COPY style.css /var/www/html/style.css

RUN chmod +x /entrypoint.sh

EXPOSE 80

CMD ["/entrypoint.sh"]
