#!/usr/bin/env node
const { execFileSync } = require('child_process');

const DB_HOST = process.env.DB_HOST || '127.0.0.1';
const DB_PORT = process.env.DB_PORT || '9470';
const DB_USER = process.env.DB_USER || 'appuser';
const DB_NAME = process.env.DB_NAME || 'bookfinder';
const PGPASSWORD = process.env.PGPASSWORD || process.env.DB_PASSWORD || '';

function psql(args, input) {
  return execFileSync('psql', [
    '-h', DB_HOST,
    '-p', DB_PORT,
    '-U', DB_USER,
    '-d', DB_NAME,
    ...args,
  ], {
    env: { ...process.env, PGPASSWORD },
    input,
    encoding: 'utf8',
    stdio: input == null ? ['ignore', 'pipe', 'pipe'] : ['pipe', 'pipe', 'pipe'],
  });
}

function sqlLiteral(value) {
  return `'${String(value).replace(/'/g, "''")}'`;
}

function normalizeTitle(value) {
  return String(value)
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

async function fetchBestCover(title, author) {
  const query = `intitle:${title} inauthor:${author}`;
  const url = `https://www.googleapis.com/books/v1/volumes?q=${encodeURIComponent(query)}&printType=books&langRestrict=en&maxResults=5`;
  const res = await fetch(url, { headers: { 'Accept': 'application/json' } });
  if (!res.ok) throw new Error(`Google Books HTTP ${res.status}`);
  const data = await res.json();
  const items = Array.isArray(data.items) ? data.items : [];
  if (!items.length) return null;

  const wanted = normalizeTitle(title);
  const pick = items.find((item) => {
    const got = normalizeTitle(item?.volumeInfo?.title || '');
    return got === wanted || got.includes(wanted) || wanted.includes(got);
  }) || items.find((item) => item?.volumeInfo?.imageLinks) || items[0];

  if (!pick?.id) return null;
  return `https://books.google.com/books/content?id=${encodeURIComponent(pick.id)}&printsec=frontcover&img=1&zoom=3&source=gbs_api`;
}

async function main() {
  const rowsRaw = psql([
    '-t', '-A', '-F', '\t', '-c',
    `SELECT b.id, b.title, a.name
     FROM books b
     JOIN authors a ON a.id = b.author_id
     WHERE b.cover_url IS NULL
        OR b.cover_url = ''
        OR b.cover_url LIKE 'https://placehold.co/%'
     ORDER BY b.id;`
  ]);

  const rows = rowsRaw
    .split('\n')
    .map((line) => line.trim())
    .filter(Boolean)
    .map((line) => {
      const [id, title, author] = line.split('\t');
      return { id: Number(id), title, author };
    });

  if (!rows.length) {
    console.log('No placeholder covers found.');
    return;
  }

  const updates = [];
  for (const row of rows) {
    try {
      const url = await fetchBestCover(row.title, row.author);
      if (url) {
        updates.push(`UPDATE books SET cover_url = ${sqlLiteral(url)} WHERE id = ${row.id};`);
        console.log(`Mapped: ${row.title} -> Google Books`);
      } else {
        console.log(`No Google Books cover found: ${row.title}`);
      }
    } catch (err) {
      console.log(`Lookup failed for ${row.title}: ${err.message}`);
    }
  }

  if (!updates.length) {
    console.log('No cover updates to apply.');
    return;
  }

  const sql = `BEGIN;\n${updates.join('\n')}\nCOMMIT;\n`;
  psql(['-v', 'ON_ERROR_STOP=1'], sql);
  console.log(`Applied ${updates.length} Google Books cover updates.`);
}

main().catch((err) => {
  console.error(err.stack || String(err));
  process.exit(1);
});
