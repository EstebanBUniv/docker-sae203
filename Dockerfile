# Base obligatoire pour la SAE
FROM debian:latest

# Installation du serveur Web Nginx
RUN apt-get update && apt-get install -y nginx && apt-get clean

# Suppression de la page d'accueil par défaut de Nginx
RUN rm /var/www/html/index.nginx-debian.html

# Copie du site DebianFlix et de la vidéo dans le conteneur
RUN ln -s src/ /var/www/html/

# Ouverture du port web
EXPOSE 80

# Lancement du service en premier plan
CMD ["nginx", "-g", "daemon off;"]
