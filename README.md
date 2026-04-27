# DebianFlix - Projet SAE 2.03

Bienvenue sur le projet DebianFlix, un mini-serveur de Vidéo à la Demande (VOD) conteneurisé.

## Architecture
Ce projet propose un service hébergé dans un conteneur Docker. 
Il respecte la contrainte d'utiliser `debian:latest` comme image de base et de ne fournir qu'un seul service (Serveur Web Nginx).

## Prérequis
- Avoir [Git](https://git-scm.com/) installé.
- Avoir [Docker](https://www.docker.com/) installé.

## Comment lancer le projet ?

**1. Cloner le dépot :**
\`\`\`bash
git clone https://github.com/EstebanBUniv/docker-sae203.git
cd docker-sae203
\`\`\`

**2. Construire l'image Docker :**
\`\`\`bash
docker build -t debianflix .
\`\`\`

**3. Lancer le conteneur :**
*(Remplacez `8080` par votre port personnel si nécessaire)*
\`\`\`bash
docker run -d -p 8080:80 --name serveur_vod debianflix
\`\`\``

**4. Profiter du service :**
Ouvrez votre navigateur web et allez sur : [http://localhost:8080](http://localhost:8080)
