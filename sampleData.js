const SAMPLE_BOOKS = [
  {
    title: "The Hobbit",
    author: "J.R.R. Tolkien",
    genre: "Fantasy",
    published_year: 1937,
    cover_url: "https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&w=700&q=80",
    description: "Bilbo Baggins is swept into a grand adventure that leads him far beyond the quiet comfort of home."
  },
  {
    title: "Pride and Prejudice",
    author: "Jane Austen",
    genre: "Classic",
    published_year: 1813,
    cover_url: "https://images.unsplash.com/photo-1516979187457-637abb4f9353?auto=format&fit=crop&w=700&q=80",
    description: "Elizabeth Bennet navigates family expectations, social pressure, and a slow-blooming romance with wit and heart."
  },
  {
    title: "The Martian",
    author: "Andy Weir",
    genre: "Science Fiction",
    published_year: 2011,
    cover_url: "https://images.unsplash.com/photo-1519682337058-a94d519337bc?auto=format&fit=crop&w=700&q=80",
    description: "An astronaut stranded on Mars relies on humor, grit, and practical problem-solving to make it home."
  },
  {
    title: "Little Women",
    author: "Louisa May Alcott",
    genre: "Classic",
    published_year: 1868,
    cover_url: "https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?auto=format&fit=crop&w=700&q=80",
    description: "Four sisters grow up, dream boldly, and learn what family means through changing seasons of life."
  },
  {
    title: "Anne of Green Gables",
    author: "L.M. Montgomery",
    genre: "Classic",
    published_year: 1908,
    cover_url: "https://images.unsplash.com/photo-1495446815901-a7297e633e8d?auto=format&fit=crop&w=700&q=80",
    description: "Anne Shirley brings imagination, energy, and warmth to Green Gables and to everyone around her."
  },
  {
    title: "The Secret Garden",
    author: "Frances Hodgson Burnett",
    genre: "Classic",
    published_year: 1911,
    cover_url: "https://images.unsplash.com/photo-1511108690759-009324a90311?auto=format&fit=crop&w=700&q=80",
    description: "A hidden garden becomes the center of healing, friendship, and renewal for a lonely young girl."
  },
  {
    title: "Charlotte's Web",
    author: "E.B. White",
    genre: "Children's",
    published_year: 1952,
    cover_url: "https://images.unsplash.com/photo-1544947950-fa07a98d237f?auto=format&fit=crop&w=700&q=80",
    description: "A gentle story about friendship, kindness, and the small acts that can change a life."
  },
  {
    title: "Winnie-the-Pooh",
    author: "A.A. Milne",
    genre: "Children's",
    published_year: 1926,
    cover_url: "https://images.unsplash.com/photo-1507842217343-583bb7270b66?auto=format&fit=crop&w=700&q=80",
    description: "Pooh and friends wander through simple adventures filled with charm, humor, and affection."
  },
  {
    title: "The Wind in the Willows",
    author: "Kenneth Grahame",
    genre: "Classic",
    published_year: 1908,
    cover_url: "https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&w=700&q=80",
    description: "Mole, Rat, Badger, and Toad share a series of memorable journeys through the English countryside."
  },
  {
    title: "A Wrinkle in Time",
    author: "Madeleine L'Engle",
    genre: "Science Fiction",
    published_year: 1962,
    cover_url: "https://images.unsplash.com/photo-1496104679561-38b7f37b1d56?auto=format&fit=crop&w=700&q=80",
    description: "A young girl crosses strange worlds in a brave search for her father and for hope."
  },
  {
    title: "The Wonderful Wizard of Oz",
    author: "L. Frank Baum",
    genre: "Fantasy",
    published_year: 1900,
    cover_url: "https://images.unsplash.com/photo-1521587760476-6c12a4b040da?auto=format&fit=crop&w=700&q=80",
    description: "Dorothy follows the yellow brick road through a colorful land in search of home."
  },
  {
    title: "The Alchemist",
    author: "Paulo Coelho",
    genre: "Adventure",
    published_year: 1988,
    cover_url: "https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?auto=format&fit=crop&w=700&q=80",
    description: "A young shepherd travels far from home in search of treasure and personal meaning."
  }
];

const SAMPLE_REVIEWS = [
  [1, "Alex", 5, "Warm, adventurous, and easy to revisit."],
  [1, "Maya", 4, "A classic journey with a lot of charm."],
  [2, "Chris", 5, "Funny, sharp, and full of memorable dialogue."],
  [3, "Jordan", 5, "Smart, fast, and surprisingly uplifting."],
  [4, "Taylor", 5, "Comforting and full of personality."],
  [5, "Sam", 5, "Anne is impossible not to like."],
  [6, "Riley", 4, "Gentle and hopeful from start to finish."],
  [7, "Casey", 5, "Sweet, simple, and unforgettable."],
  [8, "Morgan", 4, "Very cozy and easy to enjoy."],
  [9, "Jamie", 4, "Playful and full of atmosphere."],
  [10, "Avery", 5, "Creative, big-hearted, and imaginative."],
  [11, "Parker", 4, "Classic fantasy with a light touch."],
  [12, "Drew", 4, "Short, reflective, and easy to read."],
  [3, "Robin", 4, "The science stays fun instead of overwhelming."],
  [4, "Sky", 4, "A calm, pleasant read with lovable characters."],
  [6, "Blake", 5, "A lovely story about growth and friendship."]
];

module.exports = { SAMPLE_BOOKS, SAMPLE_REVIEWS };
