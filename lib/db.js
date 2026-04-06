const { Pool } = require("pg");

function getDbConfig() {
  const hasUnixSocket = Boolean(process.env.INSTANCE_CONNECTION_NAME) || String(process.env.DB_HOST || "").startsWith("/cloudsql/");
  const host = process.env.DB_HOST || (process.env.INSTANCE_CONNECTION_NAME ? `/cloudsql/${process.env.INSTANCE_CONNECTION_NAME}` : "127.0.0.1");

  return {
    host,
    port: Number(process.env.DB_PORT || 5432),
    database: process.env.DB_NAME || "bookmark",
    user: process.env.DB_USER || "postgres",
    password: process.env.DB_PASSWORD || "postgres",
    max: 10,
    idleTimeoutMillis: 30000,
    ssl: hasUnixSocket ? false : false
  };
}

const pool = new Pool(getDbConfig());

async function query(text, params = []) {
  return pool.query(text, params);
}

async function getBookById(bookId) {
  const { rows } = await query(`
    SELECT b.*, a.name AS author_name
    FROM books b
    JOIN authors a ON a.id = b.author_id
    WHERE b.id = $1
  `, [bookId]);

  return rows[0] || null;
}

function serializeBook(row) {
  return {
    id: Number(row.id),
    title: row.title,
    author: row.author_name,
    genre: row.genre,
    description: row.description,
    cover_url: row.cover_url,
    published_year: Number(row.published_year),
    average_rating: Number(row.average_rating || 0),
    review_count: Number(row.review_count || 0),
    trending_score: Number(row.trending_score || 0)
  };
}

module.exports = {
  pool,
  query,
  serializeBook,
  getBookById,
  getDbConfig
};
