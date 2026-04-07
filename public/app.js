const state = {
  books: [],
  genres: []
};

async function fetchJson(url, options = {}) {
  const response = await fetch(url, options);
  const payload = await response.json().catch(() => ({}));

  if (!response.ok) {
    throw new Error(payload.error || "Request failed");
  }

  return payload;
}


function placeholderCover(title) {
  return `https://placehold.co/600x900/png?text=${encodeURIComponent(title)}`;
}

function coverAttrs(book) {
  const src = book.cover_url || placeholderCover(book.title);
  const fallback = placeholderCover(book.title);
  return `src="${src}" alt="${book.title}" loading="lazy" onerror="this.onerror=null;this.src='${fallback}'"`;
}

function bookCard(book) {
  return `
    <article class="book-card">
      <img ${coverAttrs(book)}>
      <div class="book-card-body">
        <div>
          <h3>${book.title}</h3>
          <p class="muted">${book.author}</p>
        </div>
        <div class="badge-row">
          <span class="badge">${book.genre}</span>
          <span class="badge">⭐ ${Number(book.average_rating).toFixed(1)}</span>
        </div>
        <p class="muted">${book.published_year} · ${book.review_count} review(s)</p>
        <a class="inline-link" href="/books/${book.id}">Open details →</a>
      </div>
    </article>
  `;
}

function trendingCard(book) {
  return `
    <a class="card-link mini-card" href="/books/${book.id}">
      <strong>${book.title}</strong>
      <div class="muted">${book.author}</div>
      <div class="badge-row">
        <span class="badge">${book.genre}</span>
        <span class="badge">⭐ ${Number(book.average_rating).toFixed(1)}</span>
      </div>
    </a>
  `;
}

function renderBooks() {
  const grid = document.getElementById("bookGrid");
  const count = document.getElementById("bookCount");
  count.textContent = `${state.books.length} result(s)`;

  if (!state.books.length) {
    grid.innerHTML = '<div class="panel empty-state">No books matched your filters.</div>';
    return;
  }

  grid.innerHTML = state.books.map(bookCard).join("");
}

function renderGenres(selectedGenre = "") {
  const genreSelect = document.getElementById("genreSelect");
  genreSelect.innerHTML = '<option value="">All genres</option>' + state.genres
    .map((genre) => `<option value="${genre}">${genre}</option>`)
    .join("");
  if (selectedGenre) {
    genreSelect.value = selectedGenre;
  }
}

async function loadBooks() {
  const search = document.getElementById("searchInput").value.trim();
  const genre = document.getElementById("genreSelect").value;
  const sort = document.getElementById("sortSelect").value;
  const params = new URLSearchParams();

  if (search) params.set("search", search);
  if (genre) params.set("genre", genre);
  if (sort) params.set("sort", sort);

  const data = await fetchJson(`/api/books?${params.toString()}`);
  state.books = data.items;
  state.genres = data.genres;
  renderGenres(genre);
  renderBooks();
}

async function loadTrending() {
  const data = await fetchJson("/api/trending");
  const target = document.getElementById("trendingList");

  if (!data.items.length) {
    target.innerHTML = '<div class="empty-state">Nothing trending yet.</div>';
    return;
  }

  target.innerHTML = data.items.map(trendingCard).join("");
}

document.getElementById("searchButton").addEventListener("click", () => {
  loadBooks().catch(console.error);
});

document.getElementById("searchInput").addEventListener("keydown", (event) => {
  if (event.key === "Enter") {
    loadBooks().catch(console.error);
  }
});

window.addEventListener("DOMContentLoaded", async () => {
  await loadBooks();
  await loadTrending();
});
