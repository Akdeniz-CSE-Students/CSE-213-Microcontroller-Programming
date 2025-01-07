document.addEventListener('DOMContentLoaded', function() {
    const snippets = Array.from(document.querySelectorAll('#snippets .snippet')).map(snippet => ({
        id: parseInt(snippet.getAttribute('data-id')),
        title: snippet.getAttribute('data-title'),
        code: snippet.querySelector('code').textContent
    }));

    const snippetList = document.getElementById('snippet-list');
    snippets.forEach(snippet => {
        const listItem = document.createElement('li');
        listItem.textContent = snippet.title;
        listItem.addEventListener('click', () => {
            document.getElementById('snippet-title').textContent = snippet.title;
            document.getElementById('snippet-code').textContent = snippet.code;
            document.getElementById('snippet-preview').classList.add('active');
        });
        snippetList.appendChild(listItem);
    });

    // Chatbot functionality
    const chatContent = document.getElementById('chat-content');
    const userInput = document.getElementById('user-input');
    const sendButton = document.getElementById('send-button');

    sendButton.addEventListener('click', async () => {
        const userMessage = userInput.value.trim();
        if (userMessage === '') return;

        appendMessage('User', userMessage);
        userInput.value = '';

        try {
            const response = await fetch('https://api.together.xyz/v1/chat', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': 'Bearer 765119c4671dad7c878e8c3cb74c3ddfc366824a50600a52c70a3057690e8343'
                },
                body: JSON.stringify({ message: userMessage })
            });

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const data = await response.json();
            appendMessage('Bot', data.reply);
        } catch (error) {
            console.error('Error:', error);
            appendMessage('Bot', 'Sorry, something went wrong. Please try again later.');
        }
    });

    function appendMessage(sender, message) {
        const messageElement = document.createElement('div');
        messageElement.classList.add('message', sender.toLowerCase());
        messageElement.innerHTML = `<strong>${sender}:</strong> ${message}`;
        chatContent.appendChild(messageElement);
        chatContent.scrollTop = chatContent.scrollHeight;
    }
});
