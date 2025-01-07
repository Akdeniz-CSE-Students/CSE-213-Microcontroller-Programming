let snippets = [];

async function loadSnippets() {
    try {
        console.log('Loading snippets...');
        const response = await fetch('snippets.json'); // Relative path kullanımı
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        console.log('Loaded data:', data);
        
        if (!data.snippets || !Array.isArray(data.snippets)) {
            throw new Error('Invalid snippets data format');
        }
        
        snippets = data.snippets;
        displaySnippets();
        
        // Başlangıçta ilk snippet'i göster
        if (snippets.length > 0) {
            showPreview(snippets[0].id);
        }
    } catch (error) {
        console.error('Error loading snippets:', error);
        document.getElementById('snippetList').innerHTML = `
            <div class="snippet-card error">
                <h3>Error loading snippets</h3>
                <p>${error.message}</p>
                <p>Try refreshing the page</p>
            </div>
        `;
    }
}

function displaySnippets() {
    console.log('Displaying snippets:', snippets);
    const snippetList = document.getElementById('snippetList');
    snippetList.innerHTML = snippets.map(snippet => `
        <div class="snippet-card" onclick="showPreview(${snippet.id})">
            <h3>${snippet.title}</h3>
            <div class="snippet-preview">
                <pre><code>${snippet.code.slice(0, 50)}${snippet.code.length > 50 ? '...' : ''}</code></pre>
            </div>
        </div>
    `).join('');
}

function showPreview(id) {
    const snippet = snippets.find(s => s.id === id);
    if (!snippet) return;

    console.log('Showing preview for snippet:', snippet);
    const previewContent = document.getElementById('previewContent');
    previewContent.innerHTML = `
        <h3>${snippet.title}</h3>
        <div class="code-container">
            <pre><code>${snippet.code}</code></pre>
            <button onclick="showModal(${snippet.id})" class="expand-button">Genişlet</button>
        </div>
    `;
}

function showModal(id) {
    const snippet = snippets.find(s => s.id === id);
    if (!snippet) return;

    console.log('Showing modal for snippet:', snippet);
    const modal = document.getElementById('modal');
    const modalTitle = document.getElementById('modalTitle');
    const modalCode = document.getElementById('modalCode');
    
    modalTitle.textContent = snippet.title;
    modalCode.textContent = snippet.code;
    modal.style.display = 'block';
}

document.querySelector('.close').onclick = function() {
    document.getElementById('modal').style.display = 'none';
}

document.getElementById('copyButton').onclick = function() {
    const code = document.getElementById('modalCode').textContent;
    navigator.clipboard.writeText(code).then(() => {
        alert('Code copied to clipboard!');
    });
}

window.onclick = function(event) {
    const modal = document.getElementById('modal');
    if (event.target == modal) {
        modal.style.display = 'none';
    }
}

// Sayfa yüklendiğinde ve DOM hazır olduğunda çalıştır
window.addEventListener('DOMContentLoaded', () => {
    console.log('DOM loaded, initializing...');
    loadSnippets();
});
