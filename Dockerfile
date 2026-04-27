# Image de base imposée
FROM debian:latest

# Installation du serveur web
RUN apt-get update && apt-get install -y nginx

# Copie des vidéos dans le bon dossier
COPY videos/ /var/www/html/videos/

# Copie du script d'automatisation
COPY entrypoint.sh /entrypoint.sh

# On donne le droit à Linux d'exécuter le script
RUN chmod +x /entrypoint.sh

EXPOSE 80

# Au lieu de lancer Nginx direct, on lance notre générateur !
CMD ["/entrypoint.sh"]
