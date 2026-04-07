BEGIN;

DELETE FROM reviews
WHERE book_id IN (
  SELECT id FROM books WHERE title IN ('Atomic Habits', '1984')
);

DELETE FROM books
WHERE title IN ('Atomic Habits', '1984');

INSERT INTO authors (name) VALUES ('Louisa May Alcott') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('L.M. Montgomery') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Frances Hodgson Burnett') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('E.B. White') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('A.A. Milne') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Kenneth Grahame') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Madeleine L''Engle') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('L. Frank Baum') ON CONFLICT (name) DO NOTHING;

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT 'Little Women', (SELECT id FROM authors WHERE name = 'Louisa May Alcott'), 'Classic',
'Four sisters grow up, dream boldly, and learn what family means through changing seasons of life.',
'https://placehold.co/600x900/png?text=Little+Women', 1868
WHERE NOT EXISTS (SELECT 1 FROM books b JOIN authors a ON a.id=b.author_id WHERE b.title='Little Women' AND a.name='Louisa May Alcott');

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT 'Anne of Green Gables', (SELECT id FROM authors WHERE name = 'L.M. Montgomery'), 'Classic',
'Anne Shirley brings imagination, energy, and warmth to Green Gables and to everyone around her.',
'https://placehold.co/600x900/png?text=Anne+of+Green+Gables', 1908
WHERE NOT EXISTS (SELECT 1 FROM books b JOIN authors a ON a.id=b.author_id WHERE b.title='Anne of Green Gables' AND a.name='L.M. Montgomery');

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT 'The Secret Garden', (SELECT id FROM authors WHERE name = 'Frances Hodgson Burnett'), 'Classic',
'A hidden garden becomes the center of healing, friendship, and renewal for a lonely young girl.',
'https://placehold.co/600x900/png?text=The+Secret+Garden', 1911
WHERE NOT EXISTS (SELECT 1 FROM books b JOIN authors a ON a.id=b.author_id WHERE b.title='The Secret Garden' AND a.name='Frances Hodgson Burnett');

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT 'Charlotte''s Web', (SELECT id FROM authors WHERE name = 'E.B. White'), 'Children''s',
'A gentle story about friendship, kindness, and the small acts that can change a life.',
'https://placehold.co/600x900/png?text=Charlotte%27s+Web', 1952
WHERE NOT EXISTS (SELECT 1 FROM books b JOIN authors a ON a.id=b.author_id WHERE b.title='Charlotte''s Web' AND a.name='E.B. White');

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT 'Winnie-the-Pooh', (SELECT id FROM authors WHERE name = 'A.A. Milne'), 'Children''s',
'Pooh and friends wander through simple adventures filled with charm, humor, and affection.',
'https://placehold.co/600x900/png?text=Winnie-the-Pooh', 1926
WHERE NOT EXISTS (SELECT 1 FROM books b JOIN authors a ON a.id=b.author_id WHERE b.title='Winnie-the-Pooh' AND a.name='A.A. Milne');

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT 'The Wind in the Willows', (SELECT id FROM authors WHERE name = 'Kenneth Grahame'), 'Classic',
'Mole, Rat, Badger, and Toad share a series of memorable journeys through the English countryside.',
'https://placehold.co/600x900/png?text=The+Wind+in+the+Willows', 1908
WHERE NOT EXISTS (SELECT 1 FROM books b JOIN authors a ON a.id=b.author_id WHERE b.title='The Wind in the Willows' AND a.name='Kenneth Grahame');

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT 'A Wrinkle in Time', (SELECT id FROM authors WHERE name = 'Madeleine L''Engle'), 'Science Fiction',
'A young girl crosses strange worlds in a brave search for her father and for hope.',
'https://books.google.com/books/content?id=BYsDLOsntpAC&printsec=frontcover&img=1&zoom=3&source=gbs_api', 1962
WHERE NOT EXISTS (SELECT 1 FROM books b JOIN authors a ON a.id=b.author_id WHERE b.title='A Wrinkle in Time' AND a.name='Madeleine L''Engle');

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT 'The Wonderful Wizard of Oz', (SELECT id FROM authors WHERE name = 'L. Frank Baum'), 'Fantasy',
'Dorothy follows the yellow brick road through a colorful land in search of home.',
'https://placehold.co/600x900/png?text=The+Wonderful+Wizard+of+Oz', 1900
WHERE NOT EXISTS (SELECT 1 FROM books b JOIN authors a ON a.id=b.author_id WHERE b.title='The Wonderful Wizard of Oz' AND a.name='L. Frank Baum');

COMMIT;