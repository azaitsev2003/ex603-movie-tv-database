-- 5.2a.1
-- LEFT JOIN: How many ratings does each movie have, including movies with no ratings?
SELECT m.movie_id, m.title, COUNT(r.rating_id) AS rating_count
FROM movies AS m
LEFT JOIN ratings AS r ON r.movie_id = m.movie_id
GROUP BY m.movie_id, m.title
ORDER BY m.movie_id;

-- 5.2a.2
-- INNER JOIN: How many ratings does each movie with at least one rating have?
SELECT m.movie_id, m.title, COUNT(r.rating_id) AS rating_count
FROM movies AS m
INNER JOIN ratings AS r ON r.movie_id = m.movie_id
GROUP BY m.movie_id, m.title
ORDER BY m.movie_id;

-- 5.2a.3
-- Count comparison: How many movies does the inner join leave out?
SELECT COUNT(DISTINCT m.movie_id) AS all_movies,
       COUNT(DISTINCT r.movie_id) AS rated_movies,
       COUNT(DISTINCT m.movie_id) - COUNT(DISTINCT r.movie_id) AS excluded_movies
FROM movies AS m
LEFT JOIN ratings AS r ON r.movie_id = m.movie_id;

-- 5.2b.1
-- RIGHT JOIN: Do we still see every movie when we reverse the tables?
SELECT m.movie_id, m.title, COUNT(r.rating_id) AS rating_count
FROM ratings AS r
RIGHT JOIN movies AS m ON r.movie_id = m.movie_id
GROUP BY m.movie_id, m.title
ORDER BY m.movie_id;

-- 5.2b.2
-- Compare joins: Does either result contain a row the other one is missing?
WITH left_result AS (
    SELECT m.movie_id, m.title, COUNT(r.rating_id) AS rating_count
    FROM movies AS m
    LEFT JOIN ratings AS r ON r.movie_id = m.movie_id
    GROUP BY m.movie_id, m.title
), right_result AS (
    SELECT m.movie_id, m.title, COUNT(r.rating_id) AS rating_count
    FROM ratings AS r
    RIGHT JOIN movies AS m ON r.movie_id = m.movie_id
    GROUP BY m.movie_id, m.title
)
SELECT (SELECT COUNT(*) FROM
           (SELECT * FROM left_result EXCEPT SELECT * FROM right_result) AS a
       ) AS left_only,
       (SELECT COUNT(*) FROM
           (SELECT * FROM right_result EXCEPT SELECT * FROM left_result) AS b
       ) AS right_only;

-- 5.2b.3
-- FULL OUTER JOIN: Which movies and ratings match, and which have no match?
SELECT m.movie_id, m.title, r.rating_id, r.movie_id AS rated_movie_id
FROM movies AS m
FULL OUTER JOIN ratings AS r ON r.movie_id = m.movie_id
ORDER BY r.rating_id NULLS FIRST, m.movie_id;

-- 5.2c.1
-- NOT EXISTS: Which movie IDs have no ratings?
SELECT m.movie_id
FROM movies AS m
WHERE NOT EXISTS (
    SELECT 1
    FROM ratings AS r
    WHERE r.movie_id = m.movie_id
)
ORDER BY m.movie_id;

-- 5.2c.2
-- EXCEPT: Which movie IDs are missing from the ratings table?
SELECT movie_id FROM movies
EXCEPT
SELECT movie_id FROM ratings
ORDER BY movie_id;