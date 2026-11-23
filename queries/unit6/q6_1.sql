-- 6.1a
-- Which ratings are above or below their movie's average score?
SELECT rating_id, movie_id, score,
       ROUND(AVG(score) OVER (PARTITION BY movie_id), 2) AS movie_average,
       ROUND(score - AVG(score) OVER (PARTITION BY movie_id), 2) AS difference
FROM ratings
ORDER BY movie_id, rated_at, rating_id;

-- 6.1b
-- How many movie averages remain when the ratings are grouped?
SELECT movie_id, COUNT(*) AS rating_count,
       ROUND(AVG(score), 2) AS movie_average
FROM ratings
GROUP BY movie_id
ORDER BY movie_id;

-- 6.1c
-- How do the three ranking methods handle movies with the same rating count?
WITH movie_counts AS (
    SELECT m.movie_id, m.title, COUNT(r.rating_id) AS rating_count
    FROM movies AS m
    LEFT JOIN ratings AS r ON r.movie_id = m.movie_id
    GROUP BY m.movie_id, m.title
)
SELECT movie_id, title, rating_count,
       ROW_NUMBER() OVER (ORDER BY rating_count DESC, movie_id) AS row_number,
       RANK() OVER (ORDER BY rating_count DESC) AS rank,
       DENSE_RANK() OVER (ORDER BY rating_count DESC) AS dense_rank
FROM movie_counts
ORDER BY rating_count DESC, movie_id;

-- 6.1d
-- Can movies with the same rating count end up in different bands?
WITH movie_counts AS (
    SELECT m.movie_id, m.title, COUNT(r.rating_id) AS rating_count
    FROM movies AS m
    LEFT JOIN ratings AS r ON r.movie_id = m.movie_id
    GROUP BY m.movie_id, m.title
)
SELECT movie_id, title, rating_count,
       NTILE(4) OVER (ORDER BY rating_count DESC, movie_id) AS activity_band
FROM movie_counts
ORDER BY rating_count DESC, movie_id;