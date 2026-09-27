-- =================================================================
-- EX 603 Assignment 2 — schema.sql
-- Theme: Movie/TV
-- Author: Andrei Zaitsev
-- Target: PostgreSQL 14+
-- =================================================================
-- Reset. Reverse creation order, so no dependency blocks a drop.
 
DROP TABLE IF EXISTS ratings CASCADE;
DROP TABLE IF EXISTS movie_genres CASCADE;
DROP TABLE IF EXISTS genres CASCADE;
DROP TABLE IF EXISTS movies CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- 1. users: created first because it does not reference another table.
CREATE TABLE users (
    user_id INTEGER GENERATED ALWAYS AS IDENTITY,
    display_name TEXT NOT NULL,

    CONSTRAINT pk_users PRIMARY KEY (user_id),
    CONSTRAINT chk_users_id_positive CHECK (user_id > 0),
    CONSTRAINT chk_users_display_name_nonblank
        CHECK (display_name ~ '[^[:space:]]')
);

-- 2. movies: its only foreign key references itself, so no other table is needed.
CREATE TABLE movies (
    movie_id INTEGER GENERATED ALWAYS AS IDENTITY,
    title TEXT NOT NULL,
    is_active BOOLEAN NOT NULL,
    runtime_minutes INTEGER NOT NULL,
    previous_movie_id INTEGER,

    CONSTRAINT pk_movies PRIMARY KEY (movie_id),
    CONSTRAINT chk_movies_id_positive CHECK (movie_id > 0),
    CONSTRAINT chk_movies_title_nonblank
        CHECK (title ~ '[^[:space:]]'),
    CONSTRAINT chk_movies_runtime_positive
        CHECK (runtime_minutes > 0),
    CONSTRAINT fk_movies_previous_movie
        FOREIGN KEY (previous_movie_id)
        REFERENCES movies (movie_id)
        ON DELETE SET NULL,
    CONSTRAINT chk_movies_no_self_reference
        CHECK (previous_movie_id IS DISTINCT FROM movie_id)
);

-- 3. genres: created before movie_genres because movie_genres references it.
CREATE TABLE genres (
    genre_id INTEGER GENERATED ALWAYS AS IDENTITY,
    genre_name TEXT NOT NULL,

    CONSTRAINT pk_genres PRIMARY KEY (genre_id),
    CONSTRAINT chk_genres_id_positive CHECK (genre_id > 0),
    CONSTRAINT chk_genres_name_nonblank
        CHECK (genre_name ~ '[^[:space:]]')
);

-- 4. movie_genres: requires movies and genres to exist first.
CREATE TABLE movie_genres (
    movie_id INTEGER NOT NULL,
    genre_id INTEGER NOT NULL,

    CONSTRAINT pk_movie_genres
        PRIMARY KEY (movie_id, genre_id),
    CONSTRAINT fk_movie_genres_movie
        FOREIGN KEY (movie_id)
        REFERENCES movies (movie_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_movie_genres_genre
        FOREIGN KEY (genre_id)
        REFERENCES genres (genre_id)
        ON DELETE CASCADE
);

-- 5. ratings: requires users and movies to exist first.
CREATE TABLE ratings (
    rating_id INTEGER GENERATED ALWAYS AS IDENTITY,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    rated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    score NUMERIC(3,2) NOT NULL,

    CONSTRAINT pk_ratings PRIMARY KEY (rating_id),
    CONSTRAINT chk_ratings_id_positive CHECK (rating_id > 0),
    CONSTRAINT chk_ratings_score
        CHECK (score IN (1, 2, 3, 4, 5)),
    CONSTRAINT uq_ratings_user_movie
        UNIQUE (user_id, movie_id),
    CONSTRAINT fk_ratings_user
        FOREIGN KEY (user_id)
        REFERENCES users (user_id)
        ON DELETE CASCADE,
    CONSTRAINT fk_ratings_movie
        FOREIGN KEY (movie_id)
        REFERENCES movies (movie_id)
        ON DELETE RESTRICT
);