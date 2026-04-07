const { execFileSync } = require('child_process');

function sqlEscape(value) {
  return String(value).replace(/'/g, "''");
}

function runPsql(sql) {
  const args = [];
  if (process.env.DB_HOST) args.push('-h', process.env.DB_HOST);
  if (process.env.DB_PORT) args.push('-p', String(process.env.DB_PORT));
  args.push('-U', process.env.DB_USER || 'appuser');
  args.push('-d', process.env.DB_NAME || 'bookmark');
  args.push('-v', 'ON_ERROR_STOP=1');
  args.push('-t', '-A', '-F', '\t');
  args.push('-c', sql);
  return execFileSync('psql', args, {
    env: { ...process.env, PGPASSWORD: process.env.DB_PASSWORD || '' },
    encoding: 'utf8',
    stdio: ['ignore', 'pipe', 'pipe']
  }).trim();
}

function normalize(text) {
  return String(text || '')
    .toLowerCase()
    .normalize('NFKD')
    .replace(/[^a-z0-9]+/g, ' ')
    .trim();
}

function scoreItem(item, title, author, year) {
  const info = item.volumeInfo || {};
  const apiTitle = normalize(info.title);
  const apiSubtitle = normalize(info.subtitle);
  const fullTitle = `${apiTitle} ${apiSubtitle}`.trim();
  const wantedTitle = normalize(title);
  const wantedAuthor = normalize(author);
  const authors = Array.isArray(info.authors) ? info.authors.map(normalize) : [];

  let score = 0;
  if (apiTitle === wantedTitle || fullTitle === wantedTitle) score += 100;
  else if (apiTitle.includes(wantedTitle) || wantedTitle.includes(apiTitle)) score += 70;
  else if (fullTitle.includes(wantedTitle) || wantedTitle.includes(fullTitle)) score += 60;

  if (authors.includes(wantedAuthor)) score += 50;
  else if (authors.some((a) => a.includes(wantedAuthor) || wantedAuthor.includes(a))) score += 30;

  if (String(info.publishedDate || '').startsWith(String(year || ''))) score += 10;

  const links = info.imageLinks || {};
  if (links.extraLarge) score += 15;
  else if (links.large) score += 12;
  else if (links.medium) score += 9;
  else if (links.small) score += 6;
  else if (links.thumbnail) score += 4;
  else if (links.smallThumbnail) score += 2;

  return score;
}

function bestCoverUrl(item) {
  const links = (item && item.volumeInfo && item.volumeInfo.imageLinks) || {};
  const url = links.extraLarge || links.large || links.medium || links.small || links.thumbnail || links.smallThumbnail || '';
  return url.replace(/^http:/, 'https:');
}

async function fetchCover(title, author, year) {
  const q = encodeURIComponent(`intitle:${title} inauthor:${author}`);
  const url = `https://www.googleapis.com/books/v1/volumes?q=${q}&maxResults=10&printType=books`;
  const res = await fetch(url, { headers: { 'Accept': 'application/json' } });
  if (!res.ok) {
    throw new Error(`Google Books lookup failed: ${res.status}`);
  }
  const data = await res.json();
  const items = Array.isArray(data.items) ? data.items : [];
  const candidates = items.filter((item) => bestCoverUrl(item));
  if (!candidates.length) return '';
  candidates.sort((a, b) => scoreItem(b, title, author, year) - scoreItem(a, title, author, year));
  return bestCoverUrl(candidates[0]);
}

async function main() {
  const sql = `
    SELECT b.id, b.title, a.name AS author_name, b.published_year, COALESCE(b.cover_url, '') AS cover_url
    FROM books b
    JOIN authors a ON a.id = b.author_id
    WHERE b.cover_url IS NULL
       OR b.cover_url = ''
       OR b.cover_url LIKE 'https://placehold.co/%'
    ORDER BY b.id ASC;
  `;

  const output = runPsql(sql);
  if (!output) {
    console.log('Google Books cover hydration: nothing to update.');
    return;
  }

  const rows = output.split('\n').filter(Boolean).map((line) => {
    const [id, title, author_name, published_year, cover_url] = line.split('\t');
    return { id: Number(id), title, author_name, published_year: Number(published_year), cover_url };
  });

  let updated = 0;
  let skipped = 0;

  for (const row of rows) {
    try {
      const cover = await fetchCover(row.title, row.author_name, row.published_year);
      if (!cover) {
        skipped += 1;
        continue;
      }
      runPsql(`UPDATE books SET cover_url = '${sqlEscape(cover)}' WHERE id = ${row.id};`);
      updated += 1;
      await new Promise((resolve) => setTimeout(resolve, 100));
    } catch (error) {
      skipped += 1;
      console.error(`Cover lookup failed for ${row.title}: ${error.message}`);
    }
  }

  console.log(`Google Books cover hydration complete. Updated: ${updated}. Skipped: ${skipped}.`);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
