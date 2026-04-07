const SAMPLE_BOOKS = [
  {
    title: "The Hobbit",
    author: "J.R.R. Tolkien",
    genre: "Fantasy",
    published_year: 1937,
    cover_url: "https://placehold.co/600x900/png?text=The+Hobbit",
    description: "Bilbo Baggins is swept into a grand adventure that leads him far beyond the quiet comfort of home."
  },
  {
    title: "Pride and Prejudice",
    author: "Jane Austen",
    genre: "Classic",
    published_year: 1813,
    cover_url: "https://placehold.co/600x900/png?text=Pride+and+Prejudice",
    description: "Elizabeth Bennet navigates family expectations, social pressure, and a slow-blooming romance with wit and heart."
  },
  {
    title: "The Martian",
    author: "Andy Weir",
    genre: "Science Fiction",
    published_year: 2011,
    cover_url: "https://placehold.co/600x900/png?text=The+Martian",
    description: "An astronaut stranded on Mars relies on humor, grit, and practical problem-solving to make it home."
  },
  {
    title: "Little Women",
    author: "Louisa May Alcott",
    genre: "Classic",
    published_year: 1868,
    cover_url: "https://placehold.co/600x900/png?text=Little+Women",
    description: "Four sisters grow up, dream boldly, and learn what family means through changing seasons of life."
  },
  {
    title: "Anne of Green Gables",
    author: "L.M. Montgomery",
    genre: "Classic",
    published_year: 1908,
    cover_url: "https://placehold.co/600x900/png?text=Anne+of+Green+Gables",
    description: "Anne Shirley brings imagination, energy, and warmth to Green Gables and to everyone around her."
  },
  {
    title: "The Secret Garden",
    author: "Frances Hodgson Burnett",
    genre: "Classic",
    published_year: 1911,
    cover_url: "https://placehold.co/600x900/png?text=The+Secret+Garden",
    description: "A hidden garden becomes the center of healing, friendship, and renewal for a lonely young girl."
  },
  {
    title: "Charlotte's Web",
    author: "E.B. White",
    genre: "Children's",
    published_year: 1952,
    cover_url: "https://placehold.co/600x900/png?text=Charlotte%27s+Web",
    description: "A gentle story about friendship, kindness, and the small acts that can change a life."
  },
  {
    title: "Winnie-the-Pooh",
    author: "A.A. Milne",
    genre: "Children's",
    published_year: 1926,
    cover_url: "https://placehold.co/600x900/png?text=Winnie-the-Pooh",
    description: "Pooh and friends wander through simple adventures filled with charm, humor, and affection."
  },
  {
    title: "The Wind in the Willows",
    author: "Kenneth Grahame",
    genre: "Classic",
    published_year: 1908,
    cover_url: "https://placehold.co/600x900/png?text=The+Wind+in+the+Willows",
    description: "Mole, Rat, Badger, and Toad share a series of memorable journeys through the English countryside."
  },
  {
    title: "A Wrinkle in Time",
    author: "Madeleine L'Engle",
    genre: "Science Fiction",
    published_year: 1962,
    cover_url: "https://placehold.co/600x900/png?text=A+Wrinkle+in+Time",
    description: "A young girl crosses strange worlds in a brave search for her father and for hope."
  },
  {
    title: "The Wonderful Wizard of Oz",
    author: "L. Frank Baum",
    genre: "Fantasy",
    published_year: 1900,
    cover_url: "https://placehold.co/600x900/png?text=The+Wonderful+Wizard+of+Oz",
    description: "Dorothy follows the yellow brick road through a colorful land in search of home."
  },
  {
    title: "The Alchemist",
    author: "Paulo Coelho",
    genre: "Adventure",
    published_year: 1988,
    cover_url: "https://placehold.co/600x900/png?text=The+Alchemist",
    description: "A young shepherd travels far from home in search of treasure and personal meaning."
  },
  {
    title: "Emma",
    author: "Jane Austen",
    genre: "Romance",
    published_year: 1815,
    cover_url: "https://placehold.co/600x900/png?text=Emma",
    description: "A confident matchmaker learns humility, empathy, and love in a village full of misunderstandings."
  },
  {
    title: "Sense and Sensibility",
    author: "Jane Austen",
    genre: "Romance",
    published_year: 1811,
    cover_url: "https://placehold.co/600x900/png?text=Sense+and+Sensibility",
    description: "Two sisters balance reason and emotion while facing heartbreak, hope, and changing fortunes."
  },
  {
    title: "Persuasion",
    author: "Jane Austen",
    genre: "Romance",
    published_year: 1817,
    cover_url: "https://placehold.co/600x900/png?text=Persuasion",
    description: "A quiet second chance at love unfolds with grace, regret, and emotional maturity."
  },
  {
    title: "Northanger Abbey",
    author: "Jane Austen",
    genre: "Satire",
    published_year: 1817,
    cover_url: "https://placehold.co/600x900/png?text=Northanger+Abbey",
    description: "A young reader with a vivid imagination discovers that real life can be stranger than gothic fiction."
  },
  {
    title: "Jane Eyre",
    author: "Charlotte Brontë",
    genre: "Gothic",
    published_year: 1847,
    cover_url: "https://placehold.co/600x900/png?text=Jane+Eyre",
    description: "An independent young woman seeks belonging, purpose, and love without surrendering her principles."
  },
  {
    title: "Rebecca",
    author: "Daphne du Maurier",
    genre: "Mystery",
    published_year: 1938,
    cover_url: "https://placehold.co/600x900/png?text=Rebecca",
    description: "A newly married woman arrives at Manderley and finds herself haunted by the memory of the first Mrs. de Winter."
  },
  {
    title: "The Hound of the Baskervilles",
    author: "Arthur Conan Doyle",
    genre: "Mystery",
    published_year: 1902,
    cover_url: "https://placehold.co/600x900/png?text=The+Hound+of+the+Baskervilles",
    description: "Sherlock Holmes investigates a chilling legend on the moors with logic, nerve, and sharp observation."
  },
  {
    title: "Murder on the Orient Express",
    author: "Agatha Christie",
    genre: "Mystery",
    published_year: 1934,
    cover_url: "https://placehold.co/600x900/png?text=Murder+on+the+Orient+Express",
    description: "Hercule Poirot untangles a celebrated locked-room mystery aboard a snowbound train."
  },
  {
    title: "The No. 1 Ladies' Detective Agency",
    author: "Alexander McCall Smith",
    genre: "Mystery",
    published_year: 1998,
    cover_url: "https://placehold.co/600x900/png?text=The+No.+1+Ladies%27+Detective+Agency",
    description: "A perceptive detective in Botswana solves everyday mysteries with patience, kindness, and common sense."
  },
  {
    title: "The Thursday Murder Club",
    author: "Richard Osman",
    genre: "Mystery",
    published_year: 2020,
    cover_url: "https://placehold.co/600x900/png?text=The+Thursday+Murder+Club",
    description: "Four retirees turn their curiosity and wit toward a real murder case with delightful results."
  },
  {
    title: "The Lion, the Witch and the Wardrobe",
    author: "C.S. Lewis",
    genre: "Fantasy",
    published_year: 1950,
    cover_url: "https://placehold.co/600x900/png?text=The+Lion%2C+the+Witch+and+the+Wardrobe",
    description: "Four siblings step through a wardrobe into a magical world where courage and sacrifice matter."
  },
  {
    title: "Howl's Moving Castle",
    author: "Diana Wynne Jones",
    genre: "Fantasy",
    published_year: 1986,
    cover_url: "https://placehold.co/600x900/png?text=Howl%27s+Moving+Castle",
    description: "A young woman under a spell joins forces with a wizard whose strange castle roams the countryside."
  },
  {
    title: "The Last Unicorn",
    author: "Peter S. Beagle",
    genre: "Fantasy",
    published_year: 1968,
    cover_url: "https://placehold.co/600x900/png?text=The+Last+Unicorn",
    description: "The last unicorn sets out to discover what happened to the others in a lyrical, adventurous quest."
  },
  {
    title: "The Phantom Tollbooth",
    author: "Norton Juster",
    genre: "Fantasy",
    published_year: 1961,
    cover_url: "https://placehold.co/600x900/png?text=The+Phantom+Tollbooth",
    description: "A bored boy drives through a magical tollbooth and finds a world where words and numbers come alive."
  },
  {
    title: "Dealing with Dragons",
    author: "Patricia C. Wrede",
    genre: "Fantasy",
    published_year: 1990,
    cover_url: "https://placehold.co/600x900/png?text=Dealing+with+Dragons",
    description: "A princess rejects convention and chooses a dragon-filled adventure on her own terms."
  },
  {
    title: "Ella Enchanted",
    author: "Gail Carson Levine",
    genre: "Fantasy",
    published_year: 1997,
    cover_url: "https://placehold.co/600x900/png?text=Ella+Enchanted",
    description: "A clever heroine fights a magical curse while holding tightly to her own voice and choices."
  },
  {
    title: "Inkheart",
    author: "Cornelia Funke",
    genre: "Fantasy",
    published_year: 2003,
    cover_url: "https://placehold.co/600x900/png?text=Inkheart",
    description: "Books become dangerous and wondrous when characters can be read right off the page."
  },
  {
    title: "The Girl Who Drank the Moon",
    author: "Kelly Barnhill",
    genre: "Fantasy",
    published_year: 2016,
    cover_url: "https://placehold.co/600x900/png?text=The+Girl+Who+Drank+the+Moon",
    description: "A child raised by a kind witch grows into extraordinary powers in a story about love and truth."
  },
  {
    title: "The Blue Sword",
    author: "Robin McKinley",
    genre: "Fantasy",
    published_year: 1982,
    cover_url: "https://placehold.co/600x900/png?text=The+Blue+Sword",
    description: "An ordinary young woman discovers unexpected courage and destiny in a desert kingdom."
  },
  {
    title: "Project Hail Mary",
    author: "Andy Weir",
    genre: "Science Fiction",
    published_year: 2021,
    cover_url: "https://placehold.co/600x900/png?text=Project+Hail+Mary",
    description: "A lone astronaut wakes far from Earth and must solve impossible problems to save humanity."
  },
  {
    title: "The Long Way to a Small, Angry Planet",
    author: "Becky Chambers",
    genre: "Science Fiction",
    published_year: 2014,
    cover_url: "https://placehold.co/600x900/png?text=The+Long+Way+to+a+Small%2C+Angry+Planet",
    description: "A found-family crew crosses the galaxy in a warm, character-driven space adventure."
  },
  {
    title: "The Wild Robot",
    author: "Peter Brown",
    genre: "Science Fiction",
    published_year: 2016,
    cover_url: "https://placehold.co/600x900/png?text=The+Wild+Robot",
    description: "A robot stranded on a remote island learns how to live gently among animals and wilderness."
  },
  {
    title: "The Giver",
    author: "Lois Lowry",
    genre: "Dystopian",
    published_year: 1993,
    cover_url: "https://placehold.co/600x900/png?text=The+Giver",
    description: "A boy begins to see the cost of a perfectly controlled society when he inherits its hidden memories."
  },
  {
    title: "A Rover's Story",
    author: "Jasmine Warga",
    genre: "Science Fiction",
    published_year: 2022,
    cover_url: "https://placehold.co/600x900/png?text=A+Rover%27s+Story",
    description: "A Mars rover and the people who guide it share a heartfelt story about curiosity and connection."
  },
  {
    title: "The City of Ember",
    author: "Jeanne DuPrau",
    genre: "Science Fiction",
    published_year: 2003,
    cover_url: "https://placehold.co/600x900/png?text=The+City+of+Ember",
    description: "Two children race to solve the mystery of a failing underground city before the lights go out for good."
  },
  {
    title: "Hidden Figures",
    author: "Margot Lee Shetterly",
    genre: "Biography",
    published_year: 2016,
    cover_url: "https://placehold.co/600x900/png?text=Hidden+Figures",
    description: "The true story of brilliant Black women whose mathematics helped shape the American space program."
  },
  {
    title: "The Boys in the Boat",
    author: "Daniel James Brown",
    genre: "Sports",
    published_year: 2013,
    cover_url: "https://placehold.co/600x900/png?text=The+Boys+in+the+Boat",
    description: "A rowing team from the American Northwest rises from hardship to an unforgettable Olympic challenge."
  },
  {
    title: "Unbroken",
    author: "Laura Hillenbrand",
    genre: "Biography",
    published_year: 2010,
    cover_url: "https://placehold.co/600x900/png?text=Unbroken",
    description: "A remarkable life of endurance, survival, and resilience unfolds across war and hardship."
  },
  {
    title: "Braiding Sweetgrass",
    author: "Robin Wall Kimmerer",
    genre: "Nature",
    published_year: 2013,
    cover_url: "https://placehold.co/600x900/png?text=Braiding+Sweetgrass",
    description: "Science, gratitude, and storytelling meet in thoughtful essays about the living world."
  },
  {
    title: "The Soul of an Octopus",
    author: "Sy Montgomery",
    genre: "Nature",
    published_year: 2015,
    cover_url: "https://placehold.co/600x900/png?text=The+Soul+of+an+Octopus",
    description: "A compassionate look at octopuses, intelligence, and our relationship with the creatures around us."
  },
  {
    title: "A Walk in the Woods",
    author: "Bill Bryson",
    genre: "Travel",
    published_year: 1998,
    cover_url: "https://placehold.co/600x900/png?text=A+Walk+in+the+Woods",
    description: "A funny and observant trek along the Appalachian Trail becomes an adventure in friendship and persistence."
  },
  {
    title: "All Creatures Great and Small",
    author: "James Herriot",
    genre: "Memoir",
    published_year: 1972,
    cover_url: "https://placehold.co/600x900/png?text=All+Creatures+Great+and+Small",
    description: "Warm, funny stories from a country veterinarian capture everyday life with affection and humor."
  },
  {
    title: "Number the Stars",
    author: "Lois Lowry",
    genre: "Historical Fiction",
    published_year: 1989,
    cover_url: "https://placehold.co/600x900/png?text=Number+the+Stars",
    description: "A Danish girl shows quiet bravery while helping protect her friend during World War II."
  },
  {
    title: "The War That Saved My Life",
    author: "Kimberly Brubaker Bradley",
    genre: "Historical Fiction",
    published_year: 2015,
    cover_url: "https://placehold.co/600x900/png?text=The+War+That+Saved+My+Life",
    description: "An abused child finds safety, dignity, and belonging after being evacuated from London during the war."
  },
  {
    title: "Island of the Blue Dolphins",
    author: "Scott O'Dell",
    genre: "Historical Fiction",
    published_year: 1960,
    cover_url: "https://placehold.co/600x900/png?text=Island+of+the+Blue+Dolphins",
    description: "A young girl survives alone on an island, learning patience, skill, and self-reliance."
  },
  {
    title: "A Single Shard",
    author: "Linda Sue Park",
    genre: "Historical Fiction",
    published_year: 2001,
    cover_url: "https://placehold.co/600x900/png?text=A+Single+Shard",
    description: "An orphan in medieval Korea pursues craftsmanship and honor through hard work and kindness."
  },
  {
    title: "Roll of Thunder, Hear My Cry",
    author: "Mildred D. Taylor",
    genre: "Historical Fiction",
    published_year: 1976,
    cover_url: "https://placehold.co/600x900/png?text=Roll+of+Thunder%2C+Hear+My+Cry",
    description: "A close-knit family faces injustice with courage and determination in the rural South."
  },
  {
    title: "The Book Thief",
    author: "Markus Zusak",
    genre: "Historical Fiction",
    published_year: 2005,
    cover_url: "https://placehold.co/600x900/png?text=The+Book+Thief",
    description: "Books, friendship, and quiet acts of humanity shine in a story set in wartime Germany."
  },
  {
    title: "Holes",
    author: "Louis Sachar",
    genre: "Adventure",
    published_year: 1998,
    cover_url: "https://placehold.co/600x900/png?text=Holes",
    description: "A smartly layered desert adventure mixes humor, mystery, and long-buried history."
  },
  {
    title: "Because of Winn-Dixie",
    author: "Kate DiCamillo",
    genre: "Children's",
    published_year: 2000,
    cover_url: "https://placehold.co/600x900/png?text=Because+of+Winn-Dixie",
    description: "A lonely girl and a scruffy dog help a small town open up in gentle, hopeful ways."
  },
  {
    title: "The Tale of Despereaux",
    author: "Kate DiCamillo",
    genre: "Fantasy",
    published_year: 2003,
    cover_url: "https://placehold.co/600x900/png?text=The+Tale+of+Despereaux",
    description: "A brave little mouse follows music, light, and courage into a storybook adventure."
  },
  {
    title: "Pippi Longstocking",
    author: "Astrid Lindgren",
    genre: "Children's",
    published_year: 1945,
    cover_url: "https://placehold.co/600x900/png?text=Pippi+Longstocking",
    description: "Pippi's fearless imagination and comic independence make every ordinary day feel extraordinary."
  },
  {
    title: "The Penderwicks",
    author: "Jeanne Birdsall",
    genre: "Children's",
    published_year: 2005,
    cover_url: "https://placehold.co/600x900/png?text=The+Penderwicks",
    description: "Four sisters share a summer full of mischief, affection, and old-fashioned charm."
  },
  {
    title: "From the Mixed-Up Files of Mrs. Basil E. Frankweiler",
    author: "E.L. Konigsburg",
    genre: "Adventure",
    published_year: 1967,
    cover_url: "https://placehold.co/600x900/png?text=From+the+Mixed-Up+Files+of+Mrs.+Basil+E.+Frankweiler",
    description: "Two siblings run away to a museum and stumble into an art mystery that changes them."
  },
  {
    title: "Tuck Everlasting",
    author: "Natalie Babbitt",
    genre: "Fantasy",
    published_year: 1975,
    cover_url: "https://placehold.co/600x900/png?text=Tuck+Everlasting",
    description: "A timeless story asks what makes life precious, fleeting, and worth embracing."
  },
  {
    title: "Bridge to Terabithia",
    author: "Katherine Paterson",
    genre: "Children's",
    published_year: 1977,
    cover_url: "https://placehold.co/600x900/png?text=Bridge+to+Terabithia",
    description: "Friendship and imagination transform two children as they build a world of their own."
  },
  {
    title: "My Side of the Mountain",
    author: "Jean Craighead George",
    genre: "Adventure",
    published_year: 1959,
    cover_url: "https://placehold.co/600x900/png?text=My+Side+of+the+Mountain",
    description: "A resourceful boy lives in the wilderness and learns what independence really costs."
  },
  {
    title: "Esperanza Rising",
    author: "Pam Muñoz Ryan",
    genre: "Historical Fiction",
    published_year: 2000,
    cover_url: "https://placehold.co/600x900/png?text=Esperanza+Rising",
    description: "A young girl rebuilds her life after upheaval in a moving story of family and resilience."
  },
  {
    title: "Where the Sidewalk Ends",
    author: "Shel Silverstein",
    genre: "Poetry",
    published_year: 1974,
    cover_url: "https://placehold.co/600x900/png?text=Where+the+Sidewalk+Ends",
    description: "Playful poems and drawings invite readers into a world of humor, nonsense, and imagination."
  },
  {
    title: "The Odyssey",
    author: "Homer",
    genre: "Epic",
    published_year: -700,
    cover_url: "https://placehold.co/600x900/png?text=The+Odyssey",
    description: "An ancient journey home unfolds through danger, cleverness, longing, and mythic adventure."
  },
  {
    title: "A Tree Grows in Brooklyn",
    author: "Betty Smith",
    genre: "Coming-of-Age",
    published_year: 1943,
    cover_url: "https://placehold.co/600x900/png?text=A+Tree+Grows+in+Brooklyn",
    description: "A resilient girl grows up in a struggling family with intelligence, tenderness, and hope."
  },
  {
    title: "Heidi",
    author: "Johanna Spyri",
    genre: "Children's",
    published_year: 1881,
    cover_url: "https://placehold.co/600x900/png?text=Heidi",
    description: "A mountain childhood full of fresh air, kindness, and healing warmth becomes unforgettable."
  },
  {
    title: "Black Beauty",
    author: "Anna Sewell",
    genre: "Classic",
    published_year: 1877,
    cover_url: "https://placehold.co/600x900/png?text=Black+Beauty",
    description: "A horse's life reveals both hardship and compassion in a humane and enduring classic."
  },
  {
    title: "Treasure Island",
    author: "Robert Louis Stevenson",
    genre: "Adventure",
    published_year: 1883,
    cover_url: "https://placehold.co/600x900/png?text=Treasure+Island",
    description: "A hidden map, a dangerous crew, and a perilous voyage make for one of adventure's great tales."
  },
  {
    title: "Around the World in Eighty Days",
    author: "Jules Verne",
    genre: "Adventure",
    published_year: 1872,
    cover_url: "https://placehold.co/600x900/png?text=Around+the+World+in+Eighty+Days",
    description: "A bold wager sends Phileas Fogg on a race around the globe full of setbacks and surprises."
  },
  {
    title: "Twenty Thousand Leagues Under the Sea",
    author: "Jules Verne",
    genre: "Adventure",
    published_year: 1870,
    cover_url: "https://placehold.co/600x900/png?text=Twenty+Thousand+Leagues+Under+the+Sea",
    description: "A mysterious submarine captain leads a breathtaking journey beneath the waves."
  },
  {
    title: "The Adventures of Tom Sawyer",
    author: "Mark Twain",
    genre: "Adventure",
    published_year: 1876,
    cover_url: "https://placehold.co/600x900/png?text=The+Adventures+of+Tom+Sawyer",
    description: "Mischief, friendship, and a vivid river town shape this lively coming-of-age story."
  },
  {
    title: "The Prince and the Pauper",
    author: "Mark Twain",
    genre: "Historical Fiction",
    published_year: 1881,
    cover_url: "https://placehold.co/600x900/png?text=The+Prince+and+the+Pauper",
    description: "Two boys switch lives and discover how deeply circumstance shapes the world around them."
  },
  {
    title: "The Railway Children",
    author: "E. Nesbit",
    genre: "Children's",
    published_year: 1906,
    cover_url: "https://placehold.co/600x900/png?text=The+Railway+Children",
    description: "Three siblings adapt to a new life in the countryside with warmth, curiosity, and loyalty."
  },
  {
    title: "Ballet Shoes",
    author: "Noel Streatfeild",
    genre: "Coming-of-Age",
    published_year: 1936,
    cover_url: "https://placehold.co/600x900/png?text=Ballet+Shoes",
    description: "Three adopted sisters chase their talents and ambitions in a bustling theatrical London."
  },
  {
    title: "The Secret of Platform 13",
    author: "Eva Ibbotson",
    genre: "Fantasy",
    published_year: 1994,
    cover_url: "https://placehold.co/600x900/png?text=The+Secret+of+Platform+13",
    description: "A hidden gateway under London leads to a delightful rescue adventure full of magical creatures."
  },
  {
    title: "The Mysterious Benedict Society",
    author: "Trenton Lee Stewart",
    genre: "Adventure",
    published_year: 2007,
    cover_url: "https://placehold.co/600x900/png?text=The+Mysterious+Benedict+Society",
    description: "Gifted children join forces for a clever mission that prizes kindness as much as intelligence."
  },
  {
    title: "The Westing Game",
    author: "Ellen Raskin",
    genre: "Mystery",
    published_year: 1978,
    cover_url: "https://placehold.co/600x900/png?text=The+Westing+Game",
    description: "A puzzle-like inheritance game turns strangers into suspects, partners, and sharp observers."
  },
  {
    title: "The View from Saturday",
    author: "E.L. Konigsburg",
    genre: "Children's",
    published_year: 1996,
    cover_url: "https://placehold.co/600x900/png?text=The+View+from+Saturday",
    description: "Four thoughtful students and a patient teacher form an unlikely team with quiet brilliance."
  },
  {
    title: "The Invention of Hugo Cabret",
    author: "Brian Selznick",
    genre: "Historical Fiction",
    published_year: 2007,
    cover_url: "https://placehold.co/600x900/png?text=The+Invention+of+Hugo+Cabret",
    description: "Words and illustrations combine in a cinematic mystery about clocks, cinema, and finding a home."
  },
  {
    title: "The House at Pooh Corner",
    author: "A.A. Milne",
    genre: "Children's",
    published_year: 1928,
    cover_url: "https://placehold.co/600x900/png?text=The+House+at+Pooh+Corner",
    description: "Pooh and friends return for more gentle adventures filled with tenderness and humor."
  },
  {
    title: "Stuart Little",
    author: "E.B. White",
    genre: "Children's",
    published_year: 1945,
    cover_url: "https://placehold.co/600x900/png?text=Stuart+Little",
    description: "A small mouse with a big spirit sets out on a neat, funny adventure through the wide world."
  },
  {
    title: "The Birchbark House",
    author: "Louise Erdrich",
    genre: "Historical Fiction",
    published_year: 1999,
    cover_url: "https://placehold.co/600x900/png?text=The+Birchbark+House",
    description: "A young Ojibwe girl grows through the seasons in a richly detailed story of family and place."
  },
  {
    title: "The House of the Scorpion",
    author: "Nancy Farmer",
    genre: "Science Fiction",
    published_year: 2002,
    cover_url: "https://placehold.co/600x900/png?text=The+House+of+the+Scorpion",
    description: "A boy created for one purpose must decide for himself what kind of life he will lead."
  },
  {
    title: "Miss Rumphius",
    author: "Barbara Cooney",
    genre: "Picture Book",
    published_year: 1982,
    cover_url: "https://placehold.co/600x900/png?text=Miss+Rumphius",
    description: "A quiet, beautiful story about travel, purpose, and making the world a little more beautiful."
  },
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
  [6, "Blake", 5, "A lovely story about growth and friendship."],
  [2, "Quinn", 2, "The pacing felt slow for me and I never really connected with the romance."],
  [3, "Reese", 3, "Clever setup, but I wanted stronger characters and more tension."],
  [4, "Devon", 2, "Well written, but it took too long for me to get invested."],
  [9, "Taylor J.", 3, "Charming in places, but the pacing dragged more than I expected."],
  [10, "Harper", 2, "The ideas are imaginative, but it felt more strange than moving to me."],
  [12, "Logan", 1, "I found the message repetitive and the story too slight for me."],
];

module.exports = { SAMPLE_BOOKS, SAMPLE_REVIEWS };
