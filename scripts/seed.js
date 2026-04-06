const fs = require("fs");
const path = require("path");
const dotenv = require("dotenv");

dotenv.config({ path: path.join(__dirname, "..", ".env") });

const { pool } = require("../lib/db");
const { SAMPLE_BOOKS, SAMPLE_REVIEWS } = require("../sampleData");

async function recomputeAll() {
  await pool.query(`
    UPDATE books b
    SET
      average_rating = COALESCE(stats.average_rating, 0),
      review_count = COALESCE(stats.review_count, 0),
      trending_score = COALESCE(stats.trending_score, 0)
    FROM (
      SELECT
        book_id,
        ROUND(AVG(rating)::numeric, 2) AS average_rating,
        COUNT(*) AS review_count,
        ROUND(((AVG(rating) * 20) + (COUNT(*) * 15))::numeric, 2) AS trending_score
      FROM reviews
      GROUP BY book_id
    ) stats
    WHERE b.id = stats.book_id
  `);
}

async function main() {
  const schemaPath = path.join(__dirname, "..", "db", "schema-postgres.sql");
  const schema = fs.readFileSync(schemaPath, "utf8");
  await pool.query(schema);

  const countResult = await pool.query("SELECT COUNT(*)::int AS count FROM books");
  if (countResult.rows[0].count > 0) {
    console.log("Books already exist. Skipping seed.");
    await pool.end();
    return;
  }

  const authorIds = new Map();

  for (const book of SAMPLE_BOOKS) {
    const authorResult = await pool.query(
      "INSERT INTO authors (name) VALUES ($1) ON CONFLICT (name) DO UPDATE SET name = EXCLUDED.name RETURNING id",
      [book.author]
    );
    authorIds.set(book.author, authorResult.rows[0].id);
  }

  for (const book of SAMPLE_BOOKS) {
    await pool.query(
      `INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
       VALUES ($1, $2, $3, $4, $5, $6)`,
      [book.title, authorIds.get(book.author), book.genre, book.description, book.cover_url, book.published_year]
    );
  }

  for (const [bookId, reviewerName, rating, reviewText] of SAMPLE_REVIEWS) {
    await pool.query(
      `INSERT INTO reviews (book_id, reviewer_name, rating, review_text)
       VALUES ($1, $2, $3, $4)`,
      [bookId, reviewerName, rating, reviewText]
    );
  }

  await recomputeAll();
  console.log("Seed complete.");
  await pool.end();
}

main().catch(async (error) => {
  console.error(error);
  await pool.end();
  process.exit(1);
});
