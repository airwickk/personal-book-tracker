-- Personal Book Tracker Database Schema
-- A Goodreads-style database for tracking personal reading

-- Authors of books
CREATE TABLE "authors" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    PRIMARY KEY("id")
);

-- Genres (e.g. Fiction, Mystery, Science Fiction)
CREATE TABLE "genres" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    PRIMARY KEY("id")
);

-- Books
CREATE TABLE "books" (
    "id" INTEGER,
    "title" TEXT NOT NULL,
    "year_published" INTEGER,
    "isbn" TEXT UNIQUE,
    "description" TEXT,
    "page_count" INTEGER,
    PRIMARY KEY("id")
);

-- A book can have multiple authors (e.g. co-authored books)
CREATE TABLE "book_authors" (
    "book_id" INTEGER,
    "author_id" INTEGER,
    PRIMARY KEY("book_id", "author_id"),
    FOREIGN KEY("book_id") REFERENCES "books"("id"),
    FOREIGN KEY("author_id") REFERENCES "authors"("id")
);

-- A book can belong to multiple genres
CREATE TABLE "book_genres" (
    "book_id" INTEGER,
    "genre_id" INTEGER,
    PRIMARY KEY("book_id", "genre_id"),
    FOREIGN KEY("book_id") REFERENCES "books"("id"),
    FOREIGN KEY("genre_id") REFERENCES "genres"("id")
);

-- Personal reading list: tracks reading status, rating, and notes per book
CREATE TABLE "reading_list" (
    "id" INTEGER,
    "book_id" INTEGER NOT NULL UNIQUE,
    -- Status: 'read', 'reading', 'want to read', 'did not finish'
    "status" TEXT NOT NULL CHECK("status" IN ('read', 'reading', 'want to read', 'did not finish')),
    "rating" INTEGER CHECK("rating" BETWEEN 1 AND 5),  -- NULL if not yet rated
    "date_started" NUMERIC,
    "date_finished" NUMERIC,
    "review" TEXT,       -- Personal notes or review
    "favourite" INTEGER NOT NULL DEFAULT 0 CHECK("favourite" IN (0, 1)),  -- 1 = favourite
    PRIMARY KEY("id"),
    FOREIGN KEY("book_id") REFERENCES "books"("id")
);

-- Personal shelves/collections (e.g. "Beach Reads", "Book Club", "Classics")
CREATE TABLE "shelves" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "description" TEXT,
    PRIMARY KEY("id")
);

-- A book can be on multiple shelves
CREATE TABLE "shelf_books" (
    "shelf_id" INTEGER,
    "book_id" INTEGER,
    PRIMARY KEY("shelf_id", "book_id"),
    FOREIGN KEY("shelf_id") REFERENCES "shelves"("id"),
    FOREIGN KEY("book_id") REFERENCES "books"("id")
);

-- Indexes to speed up common queries
CREATE INDEX "reading_list_status" ON "reading_list"("status");
CREATE INDEX "reading_list_rating" ON "reading_list"("rating");
CREATE INDEX "book_authors_author_id" ON "book_authors"("author_id");
CREATE INDEX "book_genres_genre_id" ON "book_genres"("genre_id");

-- View: full book details joined with reading status and author
CREATE VIEW "book_overview" AS
SELECT
    "books"."id",
    "books"."title",
    "authors"."first_name" || ' ' || "authors"."last_name" AS "author",
    "genres"."name" AS "genre",
    "books"."year_published",
    "reading_list"."status",
    "reading_list"."rating",
    "reading_list"."favourite"
FROM "books"
LEFT JOIN "book_authors" ON "books"."id" = "book_authors"."book_id"
LEFT JOIN "authors" ON "book_authors"."author_id" = "authors"."id"
LEFT JOIN "book_genres" ON "books"."id" = "book_genres"."book_id"
LEFT JOIN "genres" ON "book_genres"."genre_id" = "genres"."id"
LEFT JOIN "reading_list" ON "books"."id" = "reading_list"."book_id";
