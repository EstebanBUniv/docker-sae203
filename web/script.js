document.addEventListener('DOMContentLoaded', () => {
    console.log("Démarrage du script DebianFlix...");
    const container = document.getElementById('catalogue');

    // 1. Vérification si la variable existe
    if (typeof videoList === 'undefined') {
        console.error("ERREUR : La variable videoList n'existe pas. Le fichier videos.js est-il chargé ?");
        container.innerHTML = "<p style='color:red;'>Erreur de chargement des données (videos.js introuvable).</p>";
        return;
    }

    console.log("Vidéos détectées :", videoList);

    // 2. Vérification si la liste est vide
    if (videoList.length === 0) {
        container.innerHTML = "<p>Aucune vidéo trouvée dans le dossier /videos/.</p>";
        return;
    }

    // 3. Génération propre du HTML
    let htmlContent = "";
    videoList.forEach(video => {
        // On retire les virgules ou espaces traînants si le Bash a mal formaté
        const cleanName = video.trim();
        if (cleanName === "") return;

        htmlContent += `
            <div class="video-card">
                <h3>${cleanName}</h3>
                <video controls>
                    <source src="videos/${cleanName}" type="video/mp4">
                    Votre navigateur ne supporte pas la lecture de vidéos.
                </video>
            </div>
        `;
    });

    container.innerHTML = htmlContent;
});
