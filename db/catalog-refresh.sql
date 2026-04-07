BEGIN;

DELETE FROM reviews
WHERE book_id IN (
  SELECT id FROM books WHERE title IN ('Atomic Habits', '1984')
);

DELETE FROM books
WHERE title IN ('Atomic Habits', '1984');


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
INSERT INTO authors (name) VALUES ('Charlotte Brontë') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Daphne du Maurier') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Arthur Conan Doyle') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Agatha Christie') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Alexander McCall Smith') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Richard Osman') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('C.S. Lewis') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Diana Wynne Jones') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Peter S. Beagle') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Norton Juster') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Patricia C. Wrede') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Gail Carson Levine') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Cornelia Funke') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Kelly Barnhill') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Robin McKinley') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Becky Chambers') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Peter Brown') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Lois Lowry') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Jasmine Warga') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Jeanne DuPrau') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Margot Lee Shetterly') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Daniel James Brown') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Laura Hillenbrand') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Robin Wall Kimmerer') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Sy Montgomery') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Bill Bryson') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('James Herriot') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Kimberly Brubaker Bradley') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Scott O''Dell') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Linda Sue Park') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Mildred D. Taylor') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Markus Zusak') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Louis Sachar') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Kate DiCamillo') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Astrid Lindgren') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Jeanne Birdsall') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('E.L. Konigsburg') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Natalie Babbitt') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Katherine Paterson') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Jean Craighead George') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Pam Muñoz Ryan') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Shel Silverstein') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Homer') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Betty Smith') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Johanna Spyri') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Anna Sewell') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Robert Louis Stevenson') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Jules Verne') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Mark Twain') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('E. Nesbit') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Noel Streatfeild') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Eva Ibbotson') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Trenton Lee Stewart') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Ellen Raskin') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Brian Selznick') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Louise Erdrich') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Nancy Farmer') ON CONFLICT (name) DO NOTHING;
INSERT INTO authors (name) VALUES ('Barbara Cooney') ON CONFLICT (name) DO NOTHING;

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Hobbit',
  (SELECT id FROM authors WHERE name = 'J.R.R. Tolkien'),
  'Fantasy',
  'Bilbo Baggins is swept into a grand adventure that leads him far beyond the quiet comfort of home.',
  'https://placehold.co/600x900/png?text=The+Hobbit',
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
  'https://placehold.co/600x900/png?text=Pride+and+Prejudice',
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
  'https://placehold.co/600x900/png?text=The+Martian',
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
  'https://placehold.co/600x900/png?text=Little+Women',
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
  'https://placehold.co/600x900/png?text=Anne+of+Green+Gables',
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
  'https://placehold.co/600x900/png?text=The+Secret+Garden',
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
  'https://placehold.co/600x900/png?text=Charlotte%27s+Web',
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
  'https://placehold.co/600x900/png?text=Winnie-the-Pooh',
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
  'https://placehold.co/600x900/png?text=The+Wind+in+the+Willows',
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
  'https://placehold.co/600x900/png?text=A+Wrinkle+in+Time',
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
  'https://placehold.co/600x900/png?text=The+Wonderful+Wizard+of+Oz',
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
  'https://placehold.co/600x900/png?text=The+Alchemist',
  1988
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Alchemist' AND a.name = 'Paulo Coelho'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Emma',
  (SELECT id FROM authors WHERE name = 'Jane Austen'),
  'Romance',
  'A confident matchmaker learns humility, empathy, and love in a village full of misunderstandings.',
  'https://placehold.co/600x900/png?text=Emma',
  1815
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Emma' AND a.name = 'Jane Austen'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Sense and Sensibility',
  (SELECT id FROM authors WHERE name = 'Jane Austen'),
  'Romance',
  'Two sisters balance reason and emotion while facing heartbreak, hope, and changing fortunes.',
  'https://placehold.co/600x900/png?text=Sense+and+Sensibility',
  1811
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Sense and Sensibility' AND a.name = 'Jane Austen'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Persuasion',
  (SELECT id FROM authors WHERE name = 'Jane Austen'),
  'Romance',
  'A quiet second chance at love unfolds with grace, regret, and emotional maturity.',
  'https://placehold.co/600x900/png?text=Persuasion',
  1817
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Persuasion' AND a.name = 'Jane Austen'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Northanger Abbey',
  (SELECT id FROM authors WHERE name = 'Jane Austen'),
  'Satire',
  'A young reader with a vivid imagination discovers that real life can be stranger than gothic fiction.',
  'https://placehold.co/600x900/png?text=Northanger+Abbey',
  1817
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Northanger Abbey' AND a.name = 'Jane Austen'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Jane Eyre',
  (SELECT id FROM authors WHERE name = 'Charlotte Brontë'),
  'Gothic',
  'An independent young woman seeks belonging, purpose, and love without surrendering her principles.',
  'https://placehold.co/600x900/png?text=Jane+Eyre',
  1847
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Jane Eyre' AND a.name = 'Charlotte Brontë'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Rebecca',
  (SELECT id FROM authors WHERE name = 'Daphne du Maurier'),
  'Mystery',
  'A newly married woman arrives at Manderley and finds herself haunted by the memory of the first Mrs. de Winter.',
  'https://placehold.co/600x900/png?text=Rebecca',
  1938
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Rebecca' AND a.name = 'Daphne du Maurier'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Hound of the Baskervilles',
  (SELECT id FROM authors WHERE name = 'Arthur Conan Doyle'),
  'Mystery',
  'Sherlock Holmes investigates a chilling legend on the moors with logic, nerve, and sharp observation.',
  'https://placehold.co/600x900/png?text=The+Hound+of+the+Baskervilles',
  1902
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Hound of the Baskervilles' AND a.name = 'Arthur Conan Doyle'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Murder on the Orient Express',
  (SELECT id FROM authors WHERE name = 'Agatha Christie'),
  'Mystery',
  'Hercule Poirot untangles a celebrated locked-room mystery aboard a snowbound train.',
  'https://placehold.co/600x900/png?text=Murder+on+the+Orient+Express',
  1934
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Murder on the Orient Express' AND a.name = 'Agatha Christie'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The No. 1 Ladies'' Detective Agency',
  (SELECT id FROM authors WHERE name = 'Alexander McCall Smith'),
  'Mystery',
  'A perceptive detective in Botswana solves everyday mysteries with patience, kindness, and common sense.',
  'https://placehold.co/600x900/png?text=The+No.+1+Ladies%27+Detective+Agency',
  1998
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The No. 1 Ladies'' Detective Agency' AND a.name = 'Alexander McCall Smith'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Thursday Murder Club',
  (SELECT id FROM authors WHERE name = 'Richard Osman'),
  'Mystery',
  'Four retirees turn their curiosity and wit toward a real murder case with delightful results.',
  'https://placehold.co/600x900/png?text=The+Thursday+Murder+Club',
  2020
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Thursday Murder Club' AND a.name = 'Richard Osman'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Lion, the Witch and the Wardrobe',
  (SELECT id FROM authors WHERE name = 'C.S. Lewis'),
  'Fantasy',
  'Four siblings step through a wardrobe into a magical world where courage and sacrifice matter.',
  'https://placehold.co/600x900/png?text=The+Lion%2C+the+Witch+and+the+Wardrobe',
  1950
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Lion, the Witch and the Wardrobe' AND a.name = 'C.S. Lewis'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Howl''s Moving Castle',
  (SELECT id FROM authors WHERE name = 'Diana Wynne Jones'),
  'Fantasy',
  'A young woman under a spell joins forces with a wizard whose strange castle roams the countryside.',
  'https://placehold.co/600x900/png?text=Howl%27s+Moving+Castle',
  1986
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Howl''s Moving Castle' AND a.name = 'Diana Wynne Jones'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Last Unicorn',
  (SELECT id FROM authors WHERE name = 'Peter S. Beagle'),
  'Fantasy',
  'The last unicorn sets out to discover what happened to the others in a lyrical, adventurous quest.',
  'https://placehold.co/600x900/png?text=The+Last+Unicorn',
  1968
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Last Unicorn' AND a.name = 'Peter S. Beagle'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Phantom Tollbooth',
  (SELECT id FROM authors WHERE name = 'Norton Juster'),
  'Fantasy',
  'A bored boy drives through a magical tollbooth and finds a world where words and numbers come alive.',
  'https://placehold.co/600x900/png?text=The+Phantom+Tollbooth',
  1961
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Phantom Tollbooth' AND a.name = 'Norton Juster'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Dealing with Dragons',
  (SELECT id FROM authors WHERE name = 'Patricia C. Wrede'),
  'Fantasy',
  'A princess rejects convention and chooses a dragon-filled adventure on her own terms.',
  'https://placehold.co/600x900/png?text=Dealing+with+Dragons',
  1990
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Dealing with Dragons' AND a.name = 'Patricia C. Wrede'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Ella Enchanted',
  (SELECT id FROM authors WHERE name = 'Gail Carson Levine'),
  'Fantasy',
  'A clever heroine fights a magical curse while holding tightly to her own voice and choices.',
  'https://placehold.co/600x900/png?text=Ella+Enchanted',
  1997
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Ella Enchanted' AND a.name = 'Gail Carson Levine'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Inkheart',
  (SELECT id FROM authors WHERE name = 'Cornelia Funke'),
  'Fantasy',
  'Books become dangerous and wondrous when characters can be read right off the page.',
  'https://placehold.co/600x900/png?text=Inkheart',
  2003
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Inkheart' AND a.name = 'Cornelia Funke'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Girl Who Drank the Moon',
  (SELECT id FROM authors WHERE name = 'Kelly Barnhill'),
  'Fantasy',
  'A child raised by a kind witch grows into extraordinary powers in a story about love and truth.',
  'https://placehold.co/600x900/png?text=The+Girl+Who+Drank+the+Moon',
  2016
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Girl Who Drank the Moon' AND a.name = 'Kelly Barnhill'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Blue Sword',
  (SELECT id FROM authors WHERE name = 'Robin McKinley'),
  'Fantasy',
  'An ordinary young woman discovers unexpected courage and destiny in a desert kingdom.',
  'https://placehold.co/600x900/png?text=The+Blue+Sword',
  1982
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Blue Sword' AND a.name = 'Robin McKinley'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Project Hail Mary',
  (SELECT id FROM authors WHERE name = 'Andy Weir'),
  'Science Fiction',
  'A lone astronaut wakes far from Earth and must solve impossible problems to save humanity.',
  'https://placehold.co/600x900/png?text=Project+Hail+Mary',
  2021
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Project Hail Mary' AND a.name = 'Andy Weir'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Long Way to a Small, Angry Planet',
  (SELECT id FROM authors WHERE name = 'Becky Chambers'),
  'Science Fiction',
  'A found-family crew crosses the galaxy in a warm, character-driven space adventure.',
  'https://placehold.co/600x900/png?text=The+Long+Way+to+a+Small%2C+Angry+Planet',
  2014
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Long Way to a Small, Angry Planet' AND a.name = 'Becky Chambers'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Wild Robot',
  (SELECT id FROM authors WHERE name = 'Peter Brown'),
  'Science Fiction',
  'A robot stranded on a remote island learns how to live gently among animals and wilderness.',
  'https://placehold.co/600x900/png?text=The+Wild+Robot',
  2016
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Wild Robot' AND a.name = 'Peter Brown'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Giver',
  (SELECT id FROM authors WHERE name = 'Lois Lowry'),
  'Dystopian',
  'A boy begins to see the cost of a perfectly controlled society when he inherits its hidden memories.',
  'https://placehold.co/600x900/png?text=The+Giver',
  1993
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Giver' AND a.name = 'Lois Lowry'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'A Rover''s Story',
  (SELECT id FROM authors WHERE name = 'Jasmine Warga'),
  'Science Fiction',
  'A Mars rover and the people who guide it share a heartfelt story about curiosity and connection.',
  'https://placehold.co/600x900/png?text=A+Rover%27s+Story',
  2022
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'A Rover''s Story' AND a.name = 'Jasmine Warga'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The City of Ember',
  (SELECT id FROM authors WHERE name = 'Jeanne DuPrau'),
  'Science Fiction',
  'Two children race to solve the mystery of a failing underground city before the lights go out for good.',
  'https://placehold.co/600x900/png?text=The+City+of+Ember',
  2003
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The City of Ember' AND a.name = 'Jeanne DuPrau'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Hidden Figures',
  (SELECT id FROM authors WHERE name = 'Margot Lee Shetterly'),
  'Biography',
  'The true story of brilliant Black women whose mathematics helped shape the American space program.',
  'https://placehold.co/600x900/png?text=Hidden+Figures',
  2016
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Hidden Figures' AND a.name = 'Margot Lee Shetterly'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Boys in the Boat',
  (SELECT id FROM authors WHERE name = 'Daniel James Brown'),
  'Sports',
  'A rowing team from the American Northwest rises from hardship to an unforgettable Olympic challenge.',
  'https://placehold.co/600x900/png?text=The+Boys+in+the+Boat',
  2013
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Boys in the Boat' AND a.name = 'Daniel James Brown'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Unbroken',
  (SELECT id FROM authors WHERE name = 'Laura Hillenbrand'),
  'Biography',
  'A remarkable life of endurance, survival, and resilience unfolds across war and hardship.',
  'https://placehold.co/600x900/png?text=Unbroken',
  2010
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Unbroken' AND a.name = 'Laura Hillenbrand'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Braiding Sweetgrass',
  (SELECT id FROM authors WHERE name = 'Robin Wall Kimmerer'),
  'Nature',
  'Science, gratitude, and storytelling meet in thoughtful essays about the living world.',
  'https://placehold.co/600x900/png?text=Braiding+Sweetgrass',
  2013
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Braiding Sweetgrass' AND a.name = 'Robin Wall Kimmerer'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Soul of an Octopus',
  (SELECT id FROM authors WHERE name = 'Sy Montgomery'),
  'Nature',
  'A compassionate look at octopuses, intelligence, and our relationship with the creatures around us.',
  'https://placehold.co/600x900/png?text=The+Soul+of+an+Octopus',
  2015
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Soul of an Octopus' AND a.name = 'Sy Montgomery'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'A Walk in the Woods',
  (SELECT id FROM authors WHERE name = 'Bill Bryson'),
  'Travel',
  'A funny and observant trek along the Appalachian Trail becomes an adventure in friendship and persistence.',
  'https://placehold.co/600x900/png?text=A+Walk+in+the+Woods',
  1998
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'A Walk in the Woods' AND a.name = 'Bill Bryson'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'All Creatures Great and Small',
  (SELECT id FROM authors WHERE name = 'James Herriot'),
  'Memoir',
  'Warm, funny stories from a country veterinarian capture everyday life with affection and humor.',
  'https://placehold.co/600x900/png?text=All+Creatures+Great+and+Small',
  1972
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'All Creatures Great and Small' AND a.name = 'James Herriot'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Number the Stars',
  (SELECT id FROM authors WHERE name = 'Lois Lowry'),
  'Historical Fiction',
  'A Danish girl shows quiet bravery while helping protect her friend during World War II.',
  'https://placehold.co/600x900/png?text=Number+the+Stars',
  1989
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Number the Stars' AND a.name = 'Lois Lowry'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The War That Saved My Life',
  (SELECT id FROM authors WHERE name = 'Kimberly Brubaker Bradley'),
  'Historical Fiction',
  'An abused child finds safety, dignity, and belonging after being evacuated from London during the war.',
  'https://placehold.co/600x900/png?text=The+War+That+Saved+My+Life',
  2015
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The War That Saved My Life' AND a.name = 'Kimberly Brubaker Bradley'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Island of the Blue Dolphins',
  (SELECT id FROM authors WHERE name = 'Scott O''Dell'),
  'Historical Fiction',
  'A young girl survives alone on an island, learning patience, skill, and self-reliance.',
  'https://placehold.co/600x900/png?text=Island+of+the+Blue+Dolphins',
  1960
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Island of the Blue Dolphins' AND a.name = 'Scott O''Dell'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'A Single Shard',
  (SELECT id FROM authors WHERE name = 'Linda Sue Park'),
  'Historical Fiction',
  'An orphan in medieval Korea pursues craftsmanship and honor through hard work and kindness.',
  'https://placehold.co/600x900/png?text=A+Single+Shard',
  2001
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'A Single Shard' AND a.name = 'Linda Sue Park'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Roll of Thunder, Hear My Cry',
  (SELECT id FROM authors WHERE name = 'Mildred D. Taylor'),
  'Historical Fiction',
  'A close-knit family faces injustice with courage and determination in the rural South.',
  'https://placehold.co/600x900/png?text=Roll+of+Thunder%2C+Hear+My+Cry',
  1976
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Roll of Thunder, Hear My Cry' AND a.name = 'Mildred D. Taylor'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Book Thief',
  (SELECT id FROM authors WHERE name = 'Markus Zusak'),
  'Historical Fiction',
  'Books, friendship, and quiet acts of humanity shine in a story set in wartime Germany.',
  'https://placehold.co/600x900/png?text=The+Book+Thief',
  2005
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Book Thief' AND a.name = 'Markus Zusak'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Holes',
  (SELECT id FROM authors WHERE name = 'Louis Sachar'),
  'Adventure',
  'A smartly layered desert adventure mixes humor, mystery, and long-buried history.',
  'https://placehold.co/600x900/png?text=Holes',
  1998
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Holes' AND a.name = 'Louis Sachar'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Because of Winn-Dixie',
  (SELECT id FROM authors WHERE name = 'Kate DiCamillo'),
  'Children''s',
  'A lonely girl and a scruffy dog help a small town open up in gentle, hopeful ways.',
  'https://placehold.co/600x900/png?text=Because+of+Winn-Dixie',
  2000
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Because of Winn-Dixie' AND a.name = 'Kate DiCamillo'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Tale of Despereaux',
  (SELECT id FROM authors WHERE name = 'Kate DiCamillo'),
  'Fantasy',
  'A brave little mouse follows music, light, and courage into a storybook adventure.',
  'https://placehold.co/600x900/png?text=The+Tale+of+Despereaux',
  2003
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Tale of Despereaux' AND a.name = 'Kate DiCamillo'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Pippi Longstocking',
  (SELECT id FROM authors WHERE name = 'Astrid Lindgren'),
  'Children''s',
  'Pippi''s fearless imagination and comic independence make every ordinary day feel extraordinary.',
  'https://placehold.co/600x900/png?text=Pippi+Longstocking',
  1945
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Pippi Longstocking' AND a.name = 'Astrid Lindgren'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Penderwicks',
  (SELECT id FROM authors WHERE name = 'Jeanne Birdsall'),
  'Children''s',
  'Four sisters share a summer full of mischief, affection, and old-fashioned charm.',
  'https://placehold.co/600x900/png?text=The+Penderwicks',
  2005
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Penderwicks' AND a.name = 'Jeanne Birdsall'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'From the Mixed-Up Files of Mrs. Basil E. Frankweiler',
  (SELECT id FROM authors WHERE name = 'E.L. Konigsburg'),
  'Adventure',
  'Two siblings run away to a museum and stumble into an art mystery that changes them.',
  'https://placehold.co/600x900/png?text=From+the+Mixed-Up+Files+of+Mrs.+Basil+E.+Frankweiler',
  1967
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'From the Mixed-Up Files of Mrs. Basil E. Frankweiler' AND a.name = 'E.L. Konigsburg'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Tuck Everlasting',
  (SELECT id FROM authors WHERE name = 'Natalie Babbitt'),
  'Fantasy',
  'A timeless story asks what makes life precious, fleeting, and worth embracing.',
  'https://placehold.co/600x900/png?text=Tuck+Everlasting',
  1975
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Tuck Everlasting' AND a.name = 'Natalie Babbitt'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Bridge to Terabithia',
  (SELECT id FROM authors WHERE name = 'Katherine Paterson'),
  'Children''s',
  'Friendship and imagination transform two children as they build a world of their own.',
  'https://placehold.co/600x900/png?text=Bridge+to+Terabithia',
  1977
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Bridge to Terabithia' AND a.name = 'Katherine Paterson'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'My Side of the Mountain',
  (SELECT id FROM authors WHERE name = 'Jean Craighead George'),
  'Adventure',
  'A resourceful boy lives in the wilderness and learns what independence really costs.',
  'https://placehold.co/600x900/png?text=My+Side+of+the+Mountain',
  1959
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'My Side of the Mountain' AND a.name = 'Jean Craighead George'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Esperanza Rising',
  (SELECT id FROM authors WHERE name = 'Pam Muñoz Ryan'),
  'Historical Fiction',
  'A young girl rebuilds her life after upheaval in a moving story of family and resilience.',
  'https://placehold.co/600x900/png?text=Esperanza+Rising',
  2000
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Esperanza Rising' AND a.name = 'Pam Muñoz Ryan'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Where the Sidewalk Ends',
  (SELECT id FROM authors WHERE name = 'Shel Silverstein'),
  'Poetry',
  'Playful poems and drawings invite readers into a world of humor, nonsense, and imagination.',
  'https://placehold.co/600x900/png?text=Where+the+Sidewalk+Ends',
  1974
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Where the Sidewalk Ends' AND a.name = 'Shel Silverstein'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Odyssey',
  (SELECT id FROM authors WHERE name = 'Homer'),
  'Epic',
  'An ancient journey home unfolds through danger, cleverness, longing, and mythic adventure.',
  'https://placehold.co/600x900/png?text=The+Odyssey',
  -700
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Odyssey' AND a.name = 'Homer'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'A Tree Grows in Brooklyn',
  (SELECT id FROM authors WHERE name = 'Betty Smith'),
  'Coming-of-Age',
  'A resilient girl grows up in a struggling family with intelligence, tenderness, and hope.',
  'https://placehold.co/600x900/png?text=A+Tree+Grows+in+Brooklyn',
  1943
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'A Tree Grows in Brooklyn' AND a.name = 'Betty Smith'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Heidi',
  (SELECT id FROM authors WHERE name = 'Johanna Spyri'),
  'Children''s',
  'A mountain childhood full of fresh air, kindness, and healing warmth becomes unforgettable.',
  'https://placehold.co/600x900/png?text=Heidi',
  1881
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Heidi' AND a.name = 'Johanna Spyri'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Black Beauty',
  (SELECT id FROM authors WHERE name = 'Anna Sewell'),
  'Classic',
  'A horse''s life reveals both hardship and compassion in a humane and enduring classic.',
  'https://placehold.co/600x900/png?text=Black+Beauty',
  1877
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Black Beauty' AND a.name = 'Anna Sewell'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Treasure Island',
  (SELECT id FROM authors WHERE name = 'Robert Louis Stevenson'),
  'Adventure',
  'A hidden map, a dangerous crew, and a perilous voyage make for one of adventure''s great tales.',
  'https://placehold.co/600x900/png?text=Treasure+Island',
  1883
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Treasure Island' AND a.name = 'Robert Louis Stevenson'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Around the World in Eighty Days',
  (SELECT id FROM authors WHERE name = 'Jules Verne'),
  'Adventure',
  'A bold wager sends Phileas Fogg on a race around the globe full of setbacks and surprises.',
  'https://placehold.co/600x900/png?text=Around+the+World+in+Eighty+Days',
  1872
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Around the World in Eighty Days' AND a.name = 'Jules Verne'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Twenty Thousand Leagues Under the Sea',
  (SELECT id FROM authors WHERE name = 'Jules Verne'),
  'Adventure',
  'A mysterious submarine captain leads a breathtaking journey beneath the waves.',
  'https://placehold.co/600x900/png?text=Twenty+Thousand+Leagues+Under+the+Sea',
  1870
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Twenty Thousand Leagues Under the Sea' AND a.name = 'Jules Verne'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Adventures of Tom Sawyer',
  (SELECT id FROM authors WHERE name = 'Mark Twain'),
  'Adventure',
  'Mischief, friendship, and a vivid river town shape this lively coming-of-age story.',
  'https://placehold.co/600x900/png?text=The+Adventures+of+Tom+Sawyer',
  1876
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Adventures of Tom Sawyer' AND a.name = 'Mark Twain'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Prince and the Pauper',
  (SELECT id FROM authors WHERE name = 'Mark Twain'),
  'Historical Fiction',
  'Two boys switch lives and discover how deeply circumstance shapes the world around them.',
  'https://placehold.co/600x900/png?text=The+Prince+and+the+Pauper',
  1881
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Prince and the Pauper' AND a.name = 'Mark Twain'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Railway Children',
  (SELECT id FROM authors WHERE name = 'E. Nesbit'),
  'Children''s',
  'Three siblings adapt to a new life in the countryside with warmth, curiosity, and loyalty.',
  'https://placehold.co/600x900/png?text=The+Railway+Children',
  1906
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Railway Children' AND a.name = 'E. Nesbit'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Ballet Shoes',
  (SELECT id FROM authors WHERE name = 'Noel Streatfeild'),
  'Coming-of-Age',
  'Three adopted sisters chase their talents and ambitions in a bustling theatrical London.',
  'https://placehold.co/600x900/png?text=Ballet+Shoes',
  1936
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Ballet Shoes' AND a.name = 'Noel Streatfeild'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Secret of Platform 13',
  (SELECT id FROM authors WHERE name = 'Eva Ibbotson'),
  'Fantasy',
  'A hidden gateway under London leads to a delightful rescue adventure full of magical creatures.',
  'https://placehold.co/600x900/png?text=The+Secret+of+Platform+13',
  1994
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Secret of Platform 13' AND a.name = 'Eva Ibbotson'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Mysterious Benedict Society',
  (SELECT id FROM authors WHERE name = 'Trenton Lee Stewart'),
  'Adventure',
  'Gifted children join forces for a clever mission that prizes kindness as much as intelligence.',
  'https://placehold.co/600x900/png?text=The+Mysterious+Benedict+Society',
  2007
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Mysterious Benedict Society' AND a.name = 'Trenton Lee Stewart'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Westing Game',
  (SELECT id FROM authors WHERE name = 'Ellen Raskin'),
  'Mystery',
  'A puzzle-like inheritance game turns strangers into suspects, partners, and sharp observers.',
  'https://placehold.co/600x900/png?text=The+Westing+Game',
  1978
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Westing Game' AND a.name = 'Ellen Raskin'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The View from Saturday',
  (SELECT id FROM authors WHERE name = 'E.L. Konigsburg'),
  'Children''s',
  'Four thoughtful students and a patient teacher form an unlikely team with quiet brilliance.',
  'https://placehold.co/600x900/png?text=The+View+from+Saturday',
  1996
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The View from Saturday' AND a.name = 'E.L. Konigsburg'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Invention of Hugo Cabret',
  (SELECT id FROM authors WHERE name = 'Brian Selznick'),
  'Historical Fiction',
  'Words and illustrations combine in a cinematic mystery about clocks, cinema, and finding a home.',
  'https://placehold.co/600x900/png?text=The+Invention+of+Hugo+Cabret',
  2007
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Invention of Hugo Cabret' AND a.name = 'Brian Selznick'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The House at Pooh Corner',
  (SELECT id FROM authors WHERE name = 'A.A. Milne'),
  'Children''s',
  'Pooh and friends return for more gentle adventures filled with tenderness and humor.',
  'https://placehold.co/600x900/png?text=The+House+at+Pooh+Corner',
  1928
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The House at Pooh Corner' AND a.name = 'A.A. Milne'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Stuart Little',
  (SELECT id FROM authors WHERE name = 'E.B. White'),
  'Children''s',
  'A small mouse with a big spirit sets out on a neat, funny adventure through the wide world.',
  'https://placehold.co/600x900/png?text=Stuart+Little',
  1945
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Stuart Little' AND a.name = 'E.B. White'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The Birchbark House',
  (SELECT id FROM authors WHERE name = 'Louise Erdrich'),
  'Historical Fiction',
  'A young Ojibwe girl grows through the seasons in a richly detailed story of family and place.',
  'https://placehold.co/600x900/png?text=The+Birchbark+House',
  1999
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The Birchbark House' AND a.name = 'Louise Erdrich'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'The House of the Scorpion',
  (SELECT id FROM authors WHERE name = 'Nancy Farmer'),
  'Science Fiction',
  'A boy created for one purpose must decide for himself what kind of life he will lead.',
  'https://placehold.co/600x900/png?text=The+House+of+the+Scorpion',
  2002
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'The House of the Scorpion' AND a.name = 'Nancy Farmer'
);

INSERT INTO books (title, author_id, genre, description, cover_url, published_year)
SELECT
  'Miss Rumphius',
  (SELECT id FROM authors WHERE name = 'Barbara Cooney'),
  'Picture Book',
  'A quiet, beautiful story about travel, purpose, and making the world a little more beautiful.',
  'https://placehold.co/600x900/png?text=Miss+Rumphius',
  1982
WHERE NOT EXISTS (
  SELECT 1 FROM books b JOIN authors a ON a.id = b.author_id
  WHERE b.title = 'Miss Rumphius' AND a.name = 'Barbara Cooney'
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
INSERT INTO reviews (book_id, reviewer_name, rating, review_text)
SELECT b.id, 'Robin', 4, 'The science stays fun instead of overwhelming.'
FROM books b WHERE b.title = 'The Martian'
AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.book_id = b.id AND r.reviewer_name = 'Robin' AND r.review_text = 'The science stays fun instead of overwhelming.');
INSERT INTO reviews (book_id, reviewer_name, rating, review_text)
SELECT b.id, 'Sky', 4, 'A calm, pleasant read with lovable characters.'
FROM books b WHERE b.title = 'Little Women'
AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.book_id = b.id AND r.reviewer_name = 'Sky' AND r.review_text = 'A calm, pleasant read with lovable characters.');
INSERT INTO reviews (book_id, reviewer_name, rating, review_text)
SELECT b.id, 'Blake', 5, 'A lovely story about growth and friendship.'
FROM books b WHERE b.title = 'The Secret Garden'
AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.book_id = b.id AND r.reviewer_name = 'Blake' AND r.review_text = 'A lovely story about growth and friendship.');
INSERT INTO reviews (book_id, reviewer_name, rating, review_text)
SELECT b.id, 'Quinn', 2, 'The pacing felt slow for me and I never really connected with the romance.'
FROM books b WHERE b.title = 'Pride and Prejudice'
AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.book_id = b.id AND r.reviewer_name = 'Quinn' AND r.review_text = 'The pacing felt slow for me and I never really connected with the romance.');
INSERT INTO reviews (book_id, reviewer_name, rating, review_text)
SELECT b.id, 'Reese', 3, 'Clever setup, but I wanted stronger characters and more tension.'
FROM books b WHERE b.title = 'The Martian'
AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.book_id = b.id AND r.reviewer_name = 'Reese' AND r.review_text = 'Clever setup, but I wanted stronger characters and more tension.');
INSERT INTO reviews (book_id, reviewer_name, rating, review_text)
SELECT b.id, 'Devon', 2, 'Well written, but it took too long for me to get invested.'
FROM books b WHERE b.title = 'Little Women'
AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.book_id = b.id AND r.reviewer_name = 'Devon' AND r.review_text = 'Well written, but it took too long for me to get invested.');
INSERT INTO reviews (book_id, reviewer_name, rating, review_text)
SELECT b.id, 'Taylor J.', 3, 'Charming in places, but the pacing dragged more than I expected.'
FROM books b WHERE b.title = 'The Wind in the Willows'
AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.book_id = b.id AND r.reviewer_name = 'Taylor J.' AND r.review_text = 'Charming in places, but the pacing dragged more than I expected.');
INSERT INTO reviews (book_id, reviewer_name, rating, review_text)
SELECT b.id, 'Harper', 2, 'The ideas are imaginative, but it felt more strange than moving to me.'
FROM books b WHERE b.title = 'A Wrinkle in Time'
AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.book_id = b.id AND r.reviewer_name = 'Harper' AND r.review_text = 'The ideas are imaginative, but it felt more strange than moving to me.');
INSERT INTO reviews (book_id, reviewer_name, rating, review_text)
SELECT b.id, 'Logan', 1, 'I found the message repetitive and the story too slight for me.'
FROM books b WHERE b.title = 'The Alchemist'
AND NOT EXISTS (SELECT 1 FROM reviews r WHERE r.book_id = b.id AND r.reviewer_name = 'Logan' AND r.review_text = 'I found the message repetitive and the story too slight for me.');

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