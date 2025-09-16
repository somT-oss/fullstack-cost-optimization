// edit.js
const API_URL = 'http://localhost:3000/books';

function getBookIdFromUrl() {
  const params = new URLSearchParams(window.location.search);
  return params.get('id');
}

async function loadBook(id) {
  try {
    const res = await fetch(`${API_URL}/${id}`);
    if (!res.ok) throw new Error(`Book not found (status ${res.status})`);
    const book = await res.json();

    document.getElementById('title').value = book.title || '';
    document.getElementById('author').value = book.author || '';
    document.getElementById('publishedDate').value = book.publishedDate || '';
  } catch (err) {
    document.getElementById('error').textContent = 'Error: ' + err.message;
  }
}

async function updateBook(e) {
  e.preventDefault();
  const id = getBookIdFromUrl();

  const updatedBook = {
    title: document.getElementById('title').value,
    author: document.getElementById('author').value,
    publishedDate: document.getElementById('publishedDate').value,
  };

  try {
    const res = await fetch(`${API_URL}/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(updatedBook),
    });

    if (!res.ok) throw new Error(`Failed to update (status ${res.status})`);

    alert('Book updated successfully!');
    window.location.href = 'index.html';
  } catch (err) {
    document.getElementById('error').textContent = 'Error: ' + err.message;
  }
}

document.addEventListener('DOMContentLoaded', () => {
  const id = getBookIdFromUrl();
  if (id) {
    loadBook(id);
    document.getElementById('editForm').addEventListener('submit', updateBook);
  } else {
    document.getElementById('error').textContent = 'No book ID provided.';
  }
});
