# Personal Book Tracker - Design Document

## Scope

This database serves as a personal book tracking system, similar to Goodreads, designed for a single user to manage their reading life. The database tracks books, authors, genres, reading statuses, ratings, reviews, and custom shelves.

**Within scope:**
- Books and their metadata (title, ISBN, publication year, page count, description)
- Authors, including support for books with multiple authors
- Genres, with support for books belonging to multiple genres
- Personal reading status for each book (read, reading, want to read, did not finish)
- Personal ratings (1–5), reviews, and favourite flags
- Custom shelves for organising books into user-defined collections

**Out of scope:**
- Multiple users — this is a personal, single-user database
- Social features such as following other readers or seeing friends' activity
- Streaming or audiobook formats
- Publisher or edition tracking

___

## Functional Requirements

A user of this database should be able to:

- Add books, authors, and genres to the database
- Track which books they have read, are currently reading, want to read, or did not finish
- Rate and review books they have read
- Mark books as favourites
- Organise books into custom shelves (e.g. "Book Club", "Beach Reads", "Classics")
- Query books by author, genre, status, or rating
- View reading statistics, such as books read per genre or average rating

___

## Representation


### Entities

**books** - the core entity of the database. Stores title, ISBN, publication year, page count, and a brief description. ISBN is kept unique to avoid duplicate entries for the same edition.

**authors** - stores first and last names. Kept separate from books to allow many-to-many relationships (a book can have multiple authors; an author can have written multiple books).

**genres** - stores genre names (e.g. Fiction, Mystery, Science Fiction). Genre names are unique. Kept separate from books to support many-to-many relationships.

**book_authors** - a junction table linking books to authors. The composite primary key of (book_id, author_id) prevents duplicate pairings.

**book_genres** - a junction table linking books to genres. Same composite primary key approach as book_authors.

**reading_list** - the personal tracking table. Each book can appear only once (book_id is UNIQUE). Tracks status using a CHECK constraint limiting values to 'read', 'reading', 'want to read', and 'did not finish'. Rating is constrained to integers between 1 and 5 and may be NULL if a book has not been rated. Dates use NUMERIC type to store ISO8601 date strings, consistent with SQLite best practices. The favourite column uses an integer flag (0 or 1) since SQLite has no native boolean type.

**shelves** - user-defined collections with a name and optional description. Shelf names are unique.

**shelf_books** - a junction table linking shelves to books, supporting many-to-many relationships.

### Relationships

The entity relationship diagram below summarises the relationships between entities:

![Entitle Relationship Diagram](diagram.png)

- A **book** has one or more **authors** (via book_authors)
- A **book** belongs to one or more **genres** (via book_genres)
- A **book** has at most one entry in the **reading_list**
- A **book** can appear on zero or more **shelves** (via shelf_books)
___

## Optimisations

### Indexes

Several indexes have been created to speed up the most common queries:

- `reading_list_status` on `reading_list(status)` — queries filtering by reading status (e.g. "show me all books I want to read") are very common and benefit greatly from this index.
- `reading_list_rating` on `reading_list(rating)` — supports efficient sorting and filtering by rating.
- `book_authors_author_id` on `book_authors(author_id)` — speeds up lookups for all books by a given author, since author_id is the foreign key side of the join.
- `book_genres_genre_id` on `book_genres(genre_id)` — speeds up lookups for all books in a given genre.

Note: indexes were not created on primary key columns as SQLite automatically indexes these.

### Views

A `book_overview` view joins books, authors, genres, and reading list data into a single convenient table. This simplifies common queries that would otherwise require multiple joins, making the database easier to query day-to-day.

___

## Limitations


- **Single user** - the schema is designed for personal use only. Adding multi-user support would require a `users` table and associating reading_list and shelves entries with individual users.
- **Single edition per book** - the schema tracks books at the title level rather than edition level. If a user owns multiple editions of the same book, this is not representable without adding an editions table.
- **Single author display in view** - the `book_overview` view joins to one author row per book. For books with multiple authors, the view will return multiple rows for the same book. A more sophisticated view could aggregate author names into a single string.
- **No reading progress tracking** - the schema tracks whether a user is currently reading a book but does not track their current page or percentage progress.



