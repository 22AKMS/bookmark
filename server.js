const path = require("path");
const express = require("express");
const dotenv = require("dotenv");

dotenv.config({ path: path.join(__dirname, ".env") });

const { query, serializeBook, getBookById } = require("./lib/db");
const { UserStateStore } = require("./lib/firestoreStore");

const app = express();
const port = Number(process.env.PORT || 8080);
const defaultUserId = process.env.APP_USER_ID || "demo-user";
const appName = process.env.APP_NAME || "bookmark";
const store = new UserStateStore();

app.set("view engine", "ejs");
app.set("views", path.join(__dirname, "views"));
app.use(express.json());
app.use("/static", express.static(path.join(__dirname, "public")));

async function maybeCallFunction(url, payload) {
  if (!url || typeof fetch !== "function") {
    return;
  }

  try {
    await fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload)
    });
  } catch (error) {
    console.error("Cloud Function call failed:", error.message);
  }
}

app.get("/healthz", async (req, res) => {
  try {
    await query("SELECT 1");
    res.json({ ok: true, app: appName });
  } catch (error) {
    res.status(500).json({ ok: false, error: error.message });
  }
});

app.get("/", (req, res) => {
  res.render("index", { appUserId: defaultUserId, appName });
});

app.get("/books/:bookId", (req, res) => {
  res.render("book", {
    appUserId: defaultUserId,
    appName,
    bookId: Number(req.params.bookId)
  });
});

app.get("/api/books", async (req, res) => {
  try {
    const search = String(req.query.search || "").trim();
    const genre = String(req.query.genre || "").trim();
    const sort = String(req.query.sort || "title").trim();

    const orderBy = {
      title: "b.title ASC",
      rating: "b.average_rating DESC, b.title ASC",
      year: "b.published_year DESC, b.title ASC",
      trending: "b.trending_score DESC, b.title ASC"
    }[sort] || "b.title ASC";

    const clauses = [];
    const params = [];
    let i = 1;

    if (search) {
      clauses.push(`(b.title ILIKE $${i} OR a.name ILIKE $${i + 1} OR b.genre ILIKE $${i + 2})`);
      const wildcard = `%${search}%`;
      params.push(wildcard, wildcard, wildcard);
      i += 3;
    }

    if (genre) {
      clauses.push(`b.genre = $${i}`);
      params.push(genre);
      i += 1;
    }

    const whereSql = clauses.length ? `WHERE ${clauses.join(" AND ")}` : "";

    const booksResult = await query(`
      SELECT b.*, a.name AS author_name
      FROM books b
      JOIN authors a ON a.id = b.author_id
      ${whereSql}
      ORDER BY ${orderBy}
    `, params);

    const genresResult = await query("SELECT DISTINCT genre FROM books ORDER BY genre ASC");

    res.json({
      items: booksResult.rows.map(serializeBook),
      genres: genresResult.rows.map((row) => row.genre)
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get("/api/books/:bookId", async (req, res) => {
  try {
    const bookId = Number(req.params.bookId);
    const row = await getBookById(bookId);

    if (!row) {
      return res.status(404).json({ error: "Book not found" });
    }

    const reviewsResult = await query(`
      SELECT id, reviewer_name, rating, review_text, created_at
      FROM reviews
      WHERE book_id = $1
      ORDER BY created_at DESC, id DESC
    `, [bookId]);

    const relatedResult = await query(`
      SELECT b.*, a.name AS author_name
      FROM books b
      JOIN authors a ON a.id = b.author_id
      WHERE b.genre = $1 AND b.id != $2
      ORDER BY b.average_rating DESC, b.title ASC
      LIMIT 3
    `, [row.genre, bookId]);

    const favorites = await store.getFavorites(defaultUserId);
    const readingList = await store.getReadingList(defaultUserId);

    res.json({
      ...serializeBook(row),
      reviews: reviewsResult.rows,
      related_books: relatedResult.rows.map(serializeBook),
      favorite: favorites.includes(bookId),
      in_reading_list: readingList.includes(bookId)
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post("/api/books/:bookId/reviews", async (req, res) => {
  try {
    const bookId = Number(req.params.bookId);
    const reviewerName = String(req.body.reviewer_name || "").trim();
    const reviewText = String(req.body.review_text || "").trim();
    const rating = Number(req.body.rating || 0);

    if (!reviewerName || !reviewText || ![1, 2, 3, 4, 5].includes(rating)) {
      return res.status(400).json({ error: "Name, rating, and review text are required." });
    }

    const exists = await query("SELECT id FROM books WHERE id = $1", [bookId]);
    if (!exists.rows[0]) {
      return res.status(404).json({ error: "Book not found" });
    }

    await query(
      `INSERT INTO reviews (book_id, reviewer_name, rating, review_text)
       VALUES ($1, $2, $3, $4)`,
      [bookId, reviewerName, rating, reviewText]
    );

    await maybeCallFunction(process.env.AVG_RATING_FUNCTION_URL, { book_id: bookId });
    await maybeCallFunction(process.env.TRENDING_FUNCTION_URL, { book_id: bookId });

    res.json({ ok: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.get("/api/trending", async (req, res) => {
  try {
    const result = await query(`
      SELECT b.*, a.name AS author_name
      FROM books b
      JOIN authors a ON a.id = b.author_id
      ORDER BY b.trending_score DESC, b.average_rating DESC, b.title ASC
      LIMIT 5
    `);

    res.json({ items: result.rows.map(serializeBook) });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post("/api/books/:bookId/favorite", async (req, res) => {
  try {
    const bookId = Number(req.params.bookId);
    const exists = await query("SELECT id FROM books WHERE id = $1", [bookId]);
    if (!exists.rows[0]) {
      return res.status(404).json({ error: "Book not found" });
    }

    await store.addFavorite(defaultUserId, bookId);
    res.json({ ok: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.delete("/api/books/:bookId/favorite", async (req, res) => {
  try {
    const bookId = Number(req.params.bookId);
    await store.removeFavorite(defaultUserId, bookId);
    res.json({ ok: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post("/api/books/:bookId/reading-list", async (req, res) => {
  try {
    const bookId = Number(req.params.bookId);
    const exists = await query("SELECT id FROM books WHERE id = $1", [bookId]);
    if (!exists.rows[0]) {
      return res.status(404).json({ error: "Book not found" });
    }

    await store.addReadingList(defaultUserId, bookId);
    res.json({ ok: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.delete("/api/books/:bookId/reading-list", async (req, res) => {
  try {
    const bookId = Number(req.params.bookId);
    await store.removeReadingList(defaultUserId, bookId);
    res.json({ ok: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.listen(port, () => {
  console.log(`${appName} running on http://localhost:${port}`);
});
