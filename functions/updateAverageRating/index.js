const { Pool } = require("pg");

function buildConfig() {
  const host = process.env.DB_HOST || (process.env.INSTANCE_CONNECTION_NAME ? `/cloudsql/${process.env.INSTANCE_CONNECTION_NAME}` : "127.0.0.1");
  return {
    host,
    port: Number(process.env.DB_PORT || 5432),
    database: process.env.DB_NAME || "bookmark",
    user: process.env.DB_USER || "postgres",
    password: process.env.DB_PASSWORD || "postgres",
    ssl: false
  };
}

const pool = new Pool(buildConfig());

exports.updateAverageRating = async (req, res) => {
  try {
    const bookId = Number(req.body?.book_id || req.query.book_id || 0);
    if (!bookId) {
      return res.status(400).json({ error: "book_id is required" });
    }

    await pool.query(`
      UPDATE books b
      SET
        average_rating = COALESCE(stats.average_rating, 0),
        review_count = COALESCE(stats.review_count, 0)
      FROM (
        SELECT book_id, ROUND(AVG(rating)::numeric, 2) AS average_rating, COUNT(*) AS review_count
        FROM reviews
        WHERE book_id = $1
        GROUP BY book_id
      ) stats
      WHERE b.id = stats.book_id
    `, [bookId]);

    res.json({ ok: true, book_id: bookId });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
