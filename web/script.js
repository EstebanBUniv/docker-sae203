document.addEventListener('DOMContentLoaded', () => {
    console.log("Démarrage du script DebianFlix...");
    const container = document.getElementById('catalogue');

    // 1. Vérification vidéo list
    if (typeof videoList === 'undefined') {
        console.error("ERREUR : videoList introuvable (videos.js manquant)");
        container.innerHTML = "<p style='color:red;'>Erreur de chargement des vidéos.</p>";
        return;
    }

    if (videoList.length === 0) {
        container.innerHTML = "<p>Aucune vidéo trouvée.</p>";
        return;
    }

    // 2. Génération HTML
    let htmlContent = "";

    videoList.forEach(video => {
        const cleanName = video.trim();
        if (!cleanName) return;

        htmlContent += `
            <div class="video-card" data-video="${cleanName}">
                <h3>${cleanName}</h3>

                <video controls>
                    <source src="videos/${cleanName}" type="video/mp4">
                    Votre navigateur ne supporte pas la lecture de vidéos.
                </video>

                <div class="like-section">
                    <button class="like-btn">🤍</button>
                    <span class="like-count">0</span>
                </div>
            </div>
        `;
    });

    container.innerHTML = htmlContent;

    initLikes();
});

function initLikes() {
    document.querySelectorAll('.video-card').forEach(card => {
        const videoName = card.dataset.video;
        const countSpan = card.querySelector('.like-count');
        const btn = card.querySelector('.like-btn');

        // état initial
        let liked = false;
        let current = getLikes(videoName);

        countSpan.textContent = current;

        btn.addEventListener('click', () => {

            if (liked) {
                current--;
                liked = false;
                btn.classList.remove("liked");
            } else {
                current++;
                liked = true;
                btn.textContent = ❤️
                btn.classList.add("liked");
            }

            setLikes(videoName, current);
            countSpan.textContent = current;
        });
    });
}
function getLikes(videoName) {
    return parseInt(localStorage.getItem("like_" + videoName)) || 0;
}

function setLikes(videoName, value) {
    localStorage.setItem("like_" + videoName, value);
}
