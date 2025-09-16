const API_URL = 'http://localhost:3000/books';

// Fetch and render books
async function fetchBooks() {
  try {
    const res = await fetch(API_URL);
    const books = await res.json();

    const tbody = document.querySelector('#booksTable tbody');
    tbody.innerHTML = '';

    books.forEach(book => {
      const row = document.createElement('tr');

      row.innerHTML = `
        <td>${book.id}</td>
        <td>${book.title}</td>
        <td>${book.author}</td>
        <td>${book.publishedDate}</td>
        <td>
          <a href="edit.html?id=${book.id}" class="btn-small edit-btn">Edit</a>
          <button class="btn-small delete-btn" data-id="${book.id}">Delete</button>
        </td>
      `;

      tbody.appendChild(row);
    });

    attachDeleteHandlers();
  } catch (err) {
    console.error('Error fetching books:', err);
  }
}

// Attach delete listeners to all buttons
function attachDeleteHandlers() {
  document.querySelectorAll('.delete-btn').forEach(btn => {
    btn.addEventListener('click', async () => {
      const id = btn.getAttribute('data-id');

      if (!confirm('Are you sure you want to delete this book?')) return;

      try {
        const res = await fetch(`${API_URL}/${id}`, { method: 'DELETE' });
        if (!res.ok) throw new Error(`Failed with status ${res.status}`);
        fetchBooks(); // Refresh table
      } catch (err) {
        alert('Error deleting book: ' + err.message);
      }
    });
  });
}

fetchBooks();
