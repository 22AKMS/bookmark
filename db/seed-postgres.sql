BEGIN;

INSERT INTO authors (name) VALUES ('J.R.R. Tolkien') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Jane Austen') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Andy Weir') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Louisa May Alcott') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('L.M. Montgomery') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Frances Hodgson Burnett') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('E.B. White') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('A.A. Milne') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Kenneth Grahame') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Madeleine L''Engle') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('L. Frank Baum') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Paulo Coelho') ON CONFLICT (name) DO NOTHING;

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Hobbit',
  (SELECT id FROM authors WHERE name = 'J.R.R. Tolkien'),
  'Fantasy',
  'Bilbo Baggins is swept into a grand adventure that leads him far beyond the quiet comfort of home.',
  'https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&w=700&q=80',
  1937
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Hobbit' AND a.name = 'J.R.R. Tolkien'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Pride and Prejudice',
  (SELECT id FROM authors WHERE name = 'Jane Austen'),
  'Classic',
  'Elizabeth Bennet navigates family expectations, social pressure, and a slow-blooming romance with wit and heart.',
  'https://images.unsplash.com/photo-1516979187457-637abb4f9353?auto=format&fit=crop&w=700&q=80',
  1813
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Pride and Prejudice' AND a.name = 'Jane Austen'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Martian',
  (SELECT id FROM authors WHERE name = 'Andy Weir'),
  'Science Fiction',
  'An astronaut stranded on Mars relies on humor, grit, and practical problem-solving to make it home.',
  'https://images.unsplash.com/photo-1519682337058-a94d519337bc?auto=format&fit=crop&w=700&q=80',
  2011
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Martian' AND a.name = 'Andy Weir'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Little Women',
  (SELECT id FROM authors WHERE name = 'Louisa May Alcott'),
  'Classic',
  'Four sisters grow up, dream boldly, and learn what family means through changing seasons of life.',
  'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?auto=format&fit=crop&w=700&q=80',
  1868
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Little Women' AND a.name = 'Louisa May Alcott'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Anne of Green Gables',
  (SELECT id FROM authors WHERE name = 'L.M. Montgomery'),
  'Classic',
  'Anne Shirley brings imagination, energy, and warmth to Green Gables and to everyone around her.',
  'https://images.unsplash.com/photo-1495446815901-a7297e633e8d?auto=format&fit=crop&w=700&q=80',
  1908
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Anne of Green Gables' AND a.name = 'L.M. Montgomery'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Secret Garden',
  (SELECT id FROM authors WHERE name = 'Frances Hodgson Burnett'),
  'Classic',
  'A hidden garden becomes the center of healing, friendship, and renewal for a lonely young girl.',
  'https://images.unsplash.com/photo-1511108690759-009324a90311?auto=format&fit=crop&w=700&q=80',
  1911
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Secret Garden' AND a.name = 'Frances Hodgson Burnett'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Charlotte''s Web',
  (SELECT id FROM authors WHERE name = 'E.B. White'),
  'Children''s',
  'A gentle story about friendship, kindness, and the small acts that can change a life.',
  'https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&w=700&q=80',
  1952
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Charlotte''s Web' AND a.name = 'E.B. White'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Winnie-the-Pooh',
  (SELECT id FROM authors WHERE name = 'A.A. Milne'),
  'Children''s',
  'Pooh and friends wander through simple adventures filled with charm, humor, and affection.',
  'https://images.unsplash.com/photo-1507842217343-583bb7270b66?auto=format&fit=crop&w=700&q=80',
  1926
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Winnie-the-Pooh' AND a.name = 'A.A. Milne'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Wind in the Willows',
  (SELECT id FROM authors WHERE name = 'Kenneth Grahame'),
  'Classic',
  'Mole, Rat, Badger, and Toad share a series of memorable journeys through the English countryside.',
  'https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&w=700&q=80',
  1908
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Wind in the Willows' AND a.name = 'Kenneth Grahame'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'A Wrinkle in Time',
  (SELECT id FROM authors WHERE name = 'Madeleine L''Engle'),
  'Science Fiction',
  'A young girl crosses strange worlds in a brave search for her father and for hope.',
  'https://books.google.com/books/content?id=BYsDLOsntpAC&printsec=frontcover&img=1&zoom=3&source=gbs_api',
  1962
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'A Wrinkle in Time' AND a.name = 'Madeleine L''Engle'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Wonderful Wizard of Oz',
  (SELECT id FROM authors WHERE name = 'L. Frank Baum'),
  'Fantasy',
  'Dorothy follows the yellow brick road through a colorful land in search of home.',
  'https://images.unsplash.com/photo-1521587760476-6c12a4b040da?auto=format&fit=crop&w=700&q=80',
  1900
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Wonderful Wizard of Oz' AND a.name = 'L. Frank Baum'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Alchemist',
  (SELECT id FROM authors WHERE name = 'Paulo Coelho'),
  'Adventure',
  'A young shepherd travels far from home in search of treasure and personal meaning.',
  'https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?auto=format&fit=crop&w=700&q=80',
  1988
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Alchemist' AND a.name = 'Paulo Coelho'
);

INSERT INTO reviews (book_id, reviewer_name, rating, review_text)
SELECT b.id, 'Alex', 5, 'Warm, adventurous, and easy to revisit.'
FROM books b WHERE b.title = 'The Hobbit'
AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.book_id = b.id AND r.reviewer_name = 'Alex' AND r.review_text = 'Warm, adventurous, and easy to revisit.');
INSERT INTO reviews (book_id, reviewer_name, rating, review_text)
SELECT b.id, 'Maya', 4, 'A classic journey with a lot of charm.'
FROM books b WHERE b.title = 'The Hobbit'
AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.book_id = b.id AND r.reviewer_name = 'Maya' AND r.review_text = 'A classic journey with a lot of charm.');
INSERT INTO reviews (book_id, reviewer_name, rating, review_text)
SELECT b.id, 'Chris', 5, 'Funny, sharp, and full of memorable dialogue.'
FROM books b WHERE b.title = 'Pride and Prejudice'
AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.book_id = b.id AND r.reviewer_name = 'Chris' AND r.review_text = 'Funny, sharp, and full of memorable dialogue.');
INSERT INTO reviews (book_id, reviewer_name, rating, review_text)
SELECT b.id, 'Jordan', 5, 'Smart, fast, and surprisingly uplifting.'
FROM books b WHERE b.title = 'The Martian'
AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.book_id = b.id AND r.reviewer_name = 'Jordan' AND r.review_text = 'Smart, fast, and surprisingly uplifting.');
INSERT INTO reviews (book_id, reviewer_name, rating, review_text)
SELECT b.id, 'Taylor', 5, 'Comforting and full of personality.'
FROM books b WHERE b.title = 'Little Women'
AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.book_id = b.id AND r.reviewer_name = 'Taylor' AND r.review_text = 'Comforting and full of personality.');
INSERT INTO reviews (book_id, reviewer_name, rating, review_text)
SELECT b.id, 'Sam', 5, 'Anne is impossible not to like.'
FROM books b WHERE b.title = 'Anne of Green Gables'
AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.book_id = b.id AND r.reviewer_name = 'Sam' AND r.review_text = 'Anne is impossible not to like.');
INSERT INTO reviews (book_id, reviewer_name, rating, review_text)
SELECT b.id, 'Riley', 4, 'Gentle and hopeful from start to finish.'
FROM books b WHERE b.title = 'The Secret Garden'
AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.book_id = b.id AND r.reviewer_name = 'Riley' AND r.review_text = 'Gentle and hopeful from start to finish.');
INSERT INTO reviews (book_id, reviewer_name, rating, review_text)
SELECT b.id, 'Casey', 5, 'Sweet, simple, and unforgettable.'
FROM books b WHERE b.title = 'Charlotte''s Web'
AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.book_id = b.id AND r.reviewer_name = 'Casey' AND r.review_text = 'Sweet, simple, and unforgettable.');
INSERT INTO reviews (book_id, reviewer_name, rating, review_text)
SELECT b.id, 'Morgan', 4, 'Very cozy and easy to enjoy.'
FROM books b WHERE b.title = 'Winnie-the-Pooh'
AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.book_id = b.id AND r.reviewer_name = 'Morgan' AND r.review_text = 'Very cozy and easy to enjoy.');
INSERT INTO reviews (book_id, reviewer_name, rating, review_text)
SELECT b.id, 'Jamie', 4, 'Playful and full of atmosphere.'
FROM books b WHERE b.title = 'The Wind in the Willows'
AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.book_id = b.id AND r.reviewer_name = 'Jamie' AND r.review_text = 'Playful and full of atmosphere.');
INSERT INTO reviews (book_id, reviewer_name, rating, review_text)
SELECT b.id, 'Avery', 5, 'Creative, big-hearted, and imaginative.'
FROM books b WHERE b.title = 'A Wrinkle in Time'
AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.book_id = b.id AND r.reviewer_name = 'Avery' AND r.review_text = 'Creative, big-hearted, and imaginative.');
INSERT INTO reviews (book_id, reviewer_name, rating, review_text)
SELECT b.id, 'Parker', 4, 'Classic fantasy with a light touch.'
FROM books b WHERE b.title = 'The Wonderful Wizard of Oz'
AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.book_id = b.id AND r.reviewer_name = 'Parker' AND r.review_text = 'Classic fantasy with a light touch.');
INSERT INTO reviews (book_id, reviewer_name, rating, review_text)
SELECT b.id, 'Drew', 4, 'Short, reflective, and easy to read.'
FROM books b WHERE b.title = 'The Alchemist'
AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.book_id = b.id AND r.reviewer_name = 'Drew' AND r.review_text = 'Short, reflective, and easy to read.');

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
WHERE b.id = stats.book_id;

COMMIT;
