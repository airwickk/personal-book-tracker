-- Personal Book Tracker: Typical Queries

-- ========================
-- INSERT
-- ========================

-- Add a new author
INSERT INTO "authors" ("first_name", "last_name")
VALUES ('Donna', 'Tartt');

-- Add a new genre
INSERT INTO "genres" ("name")
VALUES ('Literary Fiction');

-- Add a new book
INSERT INTO "books" ("title", "year_published", "isbn", "page_count", "description")
VALUES ('The Secret History', 1992, '9780679410324', 524, 'A group of classics students at a Vermont college become entangled in a murder.');

-- Link the book to its author
INSERT INTO "book_authors" ("book_id", "author_id")
VALUES (1, 1);

-- Link the book to a genre
INSERT INTO "book_genres" ("book_id", "genre_id")
VALUES (1, 1);

-- Add a book to the reading list as 'want to read'
INSERT INTO "reading_list" ("book_id", "status")
VALUES (1, 'want to read');

-- Mark a book as currently reading
INSERT INTO "reading_list" ("book_id", "status", "date_started")
VALUES (2, 'reading', '2024-03-01');

-- Mark a book as read with rating and review
INSERT INTO "reading_list" ("book_id", "status", "rating", "date_started", "date_finished", "review", "favourite")
VALUES (3, 'read', 5, '2024-01-10', '2024-01-20', 'Absolutely loved it. Unputdownable.', 1);

-- Create a custom shelf
INSERT INTO "shelves" ("name", "description")
VALUES ('Book Club', 'Books read or planned for book club');

-- Add a book to a shelf
INSERT INTO "shelf_books" ("shelf_id", "book_id")
VALUES (1, 1);

-- ========================
-- SELECT
-- ========================

-- View all books and their reading status
SELECT "title", "author", "genre", "status", "rating"
FROM "book_overview";

-- View all books I want to read
SELECT "books"."title", "authors"."first_name" || ' ' || "authors"."last_name" AS "author"
FROM "reading_list"
JOIN "books" ON "reading_list"."book_id" = "books"."id"
JOIN "book_authors" ON "books"."id" = "book_authors"."book_id"
JOIN "authors" ON "book_authors"."author_id" = "authors"."id"
WHERE "reading_list"."status" = 'want to read';

-- View all books I have read, sorted by rating
SELECT "books"."title", "reading_list"."rating", "reading_list"."date_finished"
FROM "reading_list"
JOIN "books" ON "reading_list"."book_id" = "books"."id"
WHERE "reading_list"."status" = 'read'
ORDER BY "reading_list"."rating" DESC;

-- View my favourite books
SELECT "books"."title", "reading_list"."rating", "reading_list"."review"
FROM "reading_list"
JOIN "books" ON "reading_list"."book_id" = "books"."id"
WHERE "reading_list"."favourite" = 1;

-- Find all books by a specific author
SELECT "books"."title", "books"."year_published"
FROM "books"
JOIN "book_authors" ON "books"."id" = "book_authors"."book_id"
JOIN "authors" ON "book_authors"."author_id" = "authors"."id"
WHERE "authors"."last_name" = 'Tartt';

-- Find all books in a specific genre
SELECT "books"."title", "authors"."first_name" || ' ' || "authors"."last_name" AS "author"
FROM "books"
JOIN "book_genres" ON "books"."id" = "book_genres"."book_id"
JOIN "genres" ON "book_genres"."genre_id" = "genres"."id"
JOIN "book_authors" ON "books"."id" = "book_authors"."book_id"
JOIN "authors" ON "book_authors"."author_id" = "authors"."id"
WHERE "genres"."name" = 'Literary Fiction';

-- Count books read per genre
SELECT "genres"."name", COUNT(*) AS "books_read"
FROM "reading_list"
JOIN "books" ON "reading_list"."book_id" = "books"."id"
JOIN "book_genres" ON "books"."id" = "book_genres"."book_id"
JOIN "genres" ON "book_genres"."genre_id" = "genres"."id"
WHERE "reading_list"."status" = 'read'
GROUP BY "genres"."name"
ORDER BY "books_read" DESC;

-- View average rating across all read books
SELECT ROUND(AVG("rating"), 2) AS "average_rating"
FROM "reading_list"
WHERE "status" = 'read' AND "rating" IS NOT NULL;

-- View all books on a specific shelf
SELECT "books"."title"
FROM "shelf_books"
JOIN "books" ON "shelf_books"."book_id" = "books"."id"
JOIN "shelves" ON "shelf_books"."shelf_id" = "shelves"."id"
WHERE "shelves"."name" = 'Book Club';

-- Search for a book by title keyword
SELECT "title", "year_published", "page_count"
FROM "books"
WHERE "title" LIKE '%Secret%';

-- ========================
-- UPDATE
-- ========================

-- Update a book's status from 'want to read' to 'reading'
UPDATE "reading_list"
SET "status" = 'reading', "date_started" = '2024-04-01'
WHERE "book_id" = 1;

-- Mark a book as finished and add a rating
UPDATE "reading_list"
SET "status" = 'read', "date_finished" = '2024-04-15', "rating" = 4, "review" = 'Really enjoyed it.'
WHERE "book_id" = 1;

-- Mark a book as a favourite
UPDATE "reading_list"
SET "favourite" = 1
WHERE "book_id" = 1;

-- ========================
-- DELETE
-- ========================

-- Remove a book from the reading list
DELETE FROM "reading_list"
WHERE "book_id" = 1;

-- Remove a book from a shelf
DELETE FROM "shelf_books"
WHERE "shelf_id" = 1 AND "book_id" = 1;

-- Delete a shelf entirely
DELETE FROM "shelves"
WHERE "name" = 'Book Club';
