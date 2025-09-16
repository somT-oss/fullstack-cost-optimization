// === Configuration ===
const API_URL = 'http://localhost:3000/books'; // <-- Change if your backend uses another route

// === Select DOM elements ===
const form = document.getElementById('addForm');
const titleInput = document.getElementById('title');
const authorInput = document.getElementById('author');
const publishedDateInput = document.getElementById('publishedDate');
const msg = document.getElementById('message');

// === Handle form submit ===
form.addEventListener('submit', async (e) => {
  e.preventDefault();

  // Build the new book object
  const newBook = {
    title: titleInput.value.trim(),
    author: authorInput.value.trim(),
    publishedDate: publishedDateInput.value
  };

  try {
    const res = await fetch(API_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(newBook)
    });

    if (!res.ok) throw new Error(`Server responded with ${res.status}`);

    // Clear form
    titleInput.value = '';
    authorInput.value = '';
    publishedDateInput.value = '';

    msg.textContent = '✅ Book added successfully!';
    msg.style.color = 'green';

    // Optionally redirect back to view page after a short delay
    setTimeout(() => {
      window.location.href = 'index.html';
    }, 1000);
  } catch (err) {
    msg.textContent = '❌ Error adding book: ' + err.message;
    msg.style.color = 'red';
  }
});
