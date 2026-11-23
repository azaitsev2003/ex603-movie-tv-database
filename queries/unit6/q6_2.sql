-- 6.2a
-- How does each score for movie 2 compare with the scores before and after it?
WITH score_history AS (
    SELECT rating_id, movie_id, rated_at, score,
           LAG(score) OVER (
               PARTITION BY movie_id ORDER BY rated_at, rating_id
           ) AS previous_score,
           LEAD(score) OVER (
               PARTITION BY movie_id ORDER BY rated_at, rating_id
           ) AS next_score
    FROM ratings
)
SELECT rating_id, movie_id, rated_at, score, previous_score, next_score,
       score - previous_score AS score_change
FROM score_history
WHERE movie_id = 2
ORDER BY rated_at, rating_id;

-- 6.2b
-- How does rating activity build toward a target of 250 ratings for 2023?
-- The target is my example goal. The moving average uses seven recorded days.
WITH daily_counts AS (
    SELECT rated_at::date AS rating_day, COUNT(*) AS rating_count
    FROM ratings
    WHERE rated_at >= DATE '2023-01-01'
      AND rated_at < DATE '2024-01-01'
    GROUP BY rated_at::date
), daily_progress AS (
    SELECT rating_day, rating_count,
           SUM(rating_count) OVER (
               ORDER BY rating_day
               ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
           ) AS running_total,
           ROUND(AVG(rating_count) OVER (
               ORDER BY rating_day
               ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
           ), 2) AS moving_average
    FROM daily_counts
)
SELECT rating_day, rating_count, running_total, moving_average,
       250 AS target,
       ROUND(100.0 * running_total / 250, 2) AS target_percent
FROM daily_progress
ORDER BY rating_day;

-- 6.2c
-- Did movie 9 go more than 90 days without a rating?
-- I used 90 days to look for a long break in activity.
WITH movie_history AS (
    SELECT rated_at,
           LAG(rated_at) OVER (
               ORDER BY rated_at, rating_id
           ) AS last_rating
    FROM ratings
    WHERE movie_id = 9
)
SELECT last_rating,
       rated_at AS next_rating,
       rated_at - last_rating AS time_between
FROM movie_history
WHERE rated_at - last_rating > INTERVAL '90 days'
ORDER BY rated_at;