# Personal Book Tracker

A personal book tracking database, similar to Goodreads, built with SQLite. 
Track your reading life — log books, rate and review them, and organise 
them into custom shelves.

## Features
- Add books with metadata (title, ISBN, publication year, page count)
- Track reading status: *read*, *reading*, *want to read*, or *did not finish*
- Rate books (1–5) and write personal reviews
- Mark books as favourites
- Organise books into custom shelves (e.g. "Book Club", "Beach Reads")
- Query books by author, genre, status, or rating
- View reading statistics like books read per genre or average rating

## Database Schema
The database includes the following tables:
- `books` — core book metadata
- `authors` — author names, linked to books via `book_authors`
- `genres` — genre names, linked to books via `book_genres`
- `reading_list` — personal tracking (status, rating, review, favourite flag)
- `shelves` — user-defined collections, linked to books via `shelf_books`

## How to Run
1. Make sure you have SQLite installed
2. Clone this repository
3. Open the database:
```bash
   sqlite3 booktracker.db
```
4. Run the schema file to set up the tables:
```sql
   .read schema.sql
```

## Limitations
- Single user only — no multi-user support
- Tracks books at title level, not edition level
- No reading progress tracking (e.g. current page)

## Technologies Used
- SQLite
