const bookId = Number(document.body.dataset.bookId);

async function fetchJson(url, options = {}) {
  const response = await fetch(url, options);
  const payload = await response.json().catch(() => ({}));

  if (!response.ok) {
    throw new Error(payload.error || "Request failed");
  }

  return payload;
}

function reviewCard(review) {
  return `
    <article class="review-card">
      <div class="section-title-row">
        <strong>${review.reviewer_name}</strong>
        <span class="badge">⭐ ${review.rating}</span>
      </div>
      <p>${review.review_text}</p>
      <p class="muted">${new Date(review.created_at).toLocaleString()}</p>
    </article>
  `;
}

function relatedCard(book) {
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

async function toggleFavorite(isFavorite) {
  await fetchJson(`/api/books/${bookId}/favorite`, {
    method: isFavorite ? "DELETE" : "POST"
  });
  await loadBook();
}

async function toggleReadingList(inReadingList) {
  await fetchJson(`/api/books/${bookId}/reading-list`, {
    method: inReadingList ? "DELETE" : "POST"
  });
  await loadBook();
}

async function loadBook() {
  const data = await fetchJson(`/api/books/${bookId}`);
  const hero = document.getElementById("bookHero");
  const reviewsList = document.getElementById("reviewsList");
  const relatedBooks = document.getElementById("relatedBooks");

  hero.innerHTML = `
    <img class="hero-cover" src="${data.cover_url}" alt="${data.title}">
    <div class="stack">
      <div>
        <p class="eyebrow">${data.genre}</p>
        <h1>${data.title}</h1>
        <p class="muted">${data.author} · ${data.published_year}</p>
      </div>
      <p>${data.description}</p>
      <div class="badge-row">
        <span class="badge">⭐ ${Number(data.average_rating).toFixed(1)}</span>
        <span class="badge">${data.review_count} review(s)</span>
      </div>
      <div class="action-row">
        <button id="favoriteButton" class="${data.favorite ? "secondary" : ""}">
          ${data.favorite ? "Remove Favorite" : "Add Favorite"}
        </button>
        <button id="readingListButton" class="${data.in_reading_list ? "secondary" : ""}">
          ${data.in_reading_list ? "Remove from Reading List" : "Add to Reading List"}
        </button>
      </div>
    </div>
  `;

  document.getElementById("favoriteButton").addEventListener("click", () => {
    toggleFavorite(data.favorite).catch(console.error);
  });

  document.getElementById("readingListButton").addEventListener("click", () => {
    toggleReadingList(data.in_reading_list).catch(console.error);
  });

  reviewsList.innerHTML = data.reviews.length
    ? data.reviews.map(reviewCard).join("")
    : '<div class="empty-state">No reviews yet.</div>';

  relatedBooks.innerHTML = data.related_books.length
    ? data.related_books.map(relatedCard).join("")
    : '<div class="empty-state">No related books found.</div>';
}

document.getElementById("reviewForm").addEventListener("submit", async (event) => {
  event.preventDefault();
  const form = event.currentTarget;
  const message = document.getElementById("formMessage");
  const payload = Object.fromEntries(new FormData(form).entries());

  try {
    await fetchJson(`/api/books/${bookId}/reviews`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload)
    });
    form.reset();
    message.textContent = "Review saved.";
    await loadBook();
  } catch (error) {
    message.textContent = error.message;
  }
});

window.addEventListener("DOMContentLoaded", () => {
  loadBook().catch(console.error);
});
