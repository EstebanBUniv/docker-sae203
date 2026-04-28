# DebianFlix - Projet SAE 2.03

Ce projet propose un service de Vidéo à la Demande (VOD) hébergé dans un conteneur Docker. 
Il respecte la contrainte d'utiliser `debian:latest` comme image de base et de ne fournir qu'un seul service (Serveur Web Nginx).

## Comment lancer le projet ?

**1. Construire l'image Docker :**
Ouvrez un terminal dans ce dossier et tapez :
`docker build -t debianflix .`

**2. Lancer le conteneur :**
Démarrez le service en mappant le port 80 du conteneur sur le port 8080 de votre machine :
`docker run -d -p 8080:80 --name serveur_vod debianflix`

**3. Profiter du service :**
Ouvrez votre navigateur web et allez sur : [http://localhost:8080](http://localhost:8080)