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

exports.rebuildTrending = async (req, res) => {
  try {
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

    res.json({ ok: true });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
