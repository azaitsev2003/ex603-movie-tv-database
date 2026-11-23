-- 6.3a
-- Which three ratings would appear in each movie's highest-score section?
-- Show exactly three ratings per movie. For tied scores, use the lower
-- rating ID first so the same three entries appear each time.
WITH movie_picks AS (
    SELECT movie_id, rating_id, score,
           ROW_NUMBER() OVER (
               PARTITION BY movie_id
               ORDER BY score DESC, rating_id
           ) AS position,
           FIRST_VALUE(score) OVER (
               PARTITION BY movie_id
               ORDER BY score DESC, rating_id
           ) AS best_score
    FROM ratings
)
SELECT movie_id, rating_id, score, position, best_score
FROM movie_picks
WHERE position <= 3
ORDER BY movie_id, position;

-- 6.3b
-- Are spam withdrawals becoming more common as monthly rating activity changes?
-- Spam means a withdrawn rating marked Spam detected.
-- Include every month so the comparison does not skip a missing month.
WITH monthly_counts AS (
    SELECT DATE_TRUNC('month', rated_at)::date AS rating_month,
           COUNT(*) AS rating_count,
           COUNT(*) FILTER (
               WHERE rating_status = 'withdrawn'
                 AND withdrawn_reason = 'Spam detected'
           ) AS spam_count
    FROM ratings
    GROUP BY DATE_TRUNC('month', rated_at)::date
), calendar AS (
    SELECT GENERATE_SERIES(
               MIN(rating_month), MAX(rating_month), INTERVAL '1 month'
           )::date AS rating_month
    FROM monthly_counts
), monthly_rates AS (
    SELECT c.rating_month,
           COALESCE(m.rating_count, 0) AS rating_count,
           COALESCE(m.spam_count, 0) AS spam_count,
           m.rating_month IS NULL AS missing_month,
           100.0 * COALESCE(m.spam_count, 0)
               / NULLIF(m.rating_count, 0) AS spam_rate
    FROM calendar AS c
    LEFT JOIN monthly_counts AS m
        ON m.rating_month = c.rating_month
), monthly_changes AS (
    SELECT *,
           LAG(rating_count) OVER (
               ORDER BY rating_month
           ) AS previous_count,
           LAG(spam_rate) OVER (
               ORDER BY rating_month
           ) AS previous_rate
    FROM monthly_rates
)
SELECT rating_month, rating_count, spam_count, missing_month,
       ROUND(spam_rate, 2) AS spam_rate_percent,
       ROUND(
           100.0 * (rating_count - previous_count)
               / NULLIF(previous_count, 0), 2
       ) AS volume_change_percent,
       ROUND(spam_rate - previous_rate, 2) AS spam_change_points
FROM monthly_changes
ORDER BY rating_month;