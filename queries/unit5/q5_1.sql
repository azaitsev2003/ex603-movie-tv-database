-- 5.1a
-- Three-table join: Who rated which movie, and when?
SELECT r.rating_id, u.user_name, m.movie_id, m.title, r.rated_at
FROM ratings AS r
INNER JOIN users AS u ON u.user_id = r.user_id
INNER JOIN movies AS m ON m.movie_id = r.movie_id
ORDER BY r.rating_id;

-- 5.1b
-- Junction table: Which movies have the Comedy tag?
SELECT m.movie_id, m.title, g.genre_name
FROM movies AS m
JOIN movie_genres AS mg ON mg.movie_id = m.movie_id
JOIN genres AS g ON g.genre_id = mg.genre_id
WHERE g.genre_name = 'Comedy'
ORDER BY m.movie_id;

-- 5.1c
-- Self join: Which other movies came out in the same year as movies 2 and 3?
SELECT target.movie_id AS target_id, target.title, target.release_year,
       peer.movie_id AS other_id, peer.title AS other_title
FROM movies AS target
JOIN movies AS peer ON peer.release_year = target.release_year
                   AND peer.movie_id <> target.movie_id
WHERE target.movie_id IN (2, 3)
ORDER BY target.movie_id, peer.movie_id;