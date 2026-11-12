-- 5.3a
-- CROSS JOIN: How many possible movie and genre pairs are there?
SELECT (SELECT COUNT(*) FROM movies) AS movies,
       (SELECT COUNT(*) FROM genres) AS genres,
       (SELECT COUNT(*) FROM movies) * (SELECT COUNT(*) FROM genres) AS expected_pairs,
       COUNT(*) AS actual_pairs
FROM movies CROSS JOIN genres;

-- 5.3b
-- EXPLAIN: How does PostgreSQL join ratings, users, and movies?
EXPLAIN
SELECT r.rating_id, u.user_name, m.movie_id, m.title, r.rated_at
FROM ratings AS r
INNER JOIN users AS u ON u.user_id = r.user_id
INNER JOIN movies AS m ON m.movie_id = r.movie_id
ORDER BY r.rating_id;

