-- 4.2A: How many ratings does each movie have, and how many were withdrawn for spam?
-- Requirement: Use CASE inside an aggregate to count all events and failures together. A failure is a withdrawn rating whose reason is Spam detected.
-- Finding: Movie 2 has 3 spam withdrawals out of 16 ratings. Movie 3 has 2 out of 13.

SELECT movie_id,
       COUNT(*) AS rating_count,
       SUM(CASE WHEN rating_status = 'withdrawn'
                     AND withdrawn_reason = 'Spam detected'
                THEN 1 ELSE 0 END) AS spam_count,
       ROUND(100.0 * SUM(CASE WHEN rating_status = 'withdrawn'
                                  AND withdrawn_reason = 'Spam detected'
                             THEN 1 ELSE 0 END)
             / COUNT(*), 2) AS spam_rate_percent
FROM ratings
GROUP BY movie_id
ORDER BY spam_count DESC, spam_rate_percent DESC, movie_id;

-- 4.2B: What are the rating totals and spam rates for each country and the platform?
-- Requirement: Use ROLLUP for regional subtotals and a grand total without detail rows.
-- Country rows are regional subtotals. All countries is the platform grand total.
-- Finding: The platform has 12 spam withdrawals out of 200 ratings, or 6%.

SELECT CASE WHEN GROUPING(device_country) = 1
            THEN 'All countries'
            ELSE device_country END AS region,
       COUNT(*) AS rating_count,
       SUM(CASE WHEN rating_status = 'withdrawn'
                     AND withdrawn_reason = 'Spam detected'
                THEN 1 ELSE 0 END) AS spam_count,
       ROUND(100.0 * SUM(CASE WHEN rating_status = 'withdrawn'
                                  AND withdrawn_reason = 'Spam detected'
                             THEN 1 ELSE 0 END)
             / COUNT(*), 2) AS spam_rate_percent
FROM ratings
GROUP BY ROLLUP(device_country)
ORDER BY GROUPING(device_country), device_country;

-- 4.2C: What is the combined spam withdrawal rate for movies with at least 10 ratings?
-- Requirement: Aggregate by producer in a CTE, then aggregate the qualifying producers.
-- Divide combined spam counts by combined rating counts so each rating counts equally.
-- Finding: 12 qualifying movies have 11 spam withdrawals out of 194 ratings, or 5.67%.

WITH movie_summary AS (
    SELECT movie_id,
           COUNT(*) AS rating_count,
           SUM(CASE WHEN rating_status = 'withdrawn'
                         AND withdrawn_reason = 'Spam detected'
                    THEN 1 ELSE 0 END) AS spam_count
    FROM ratings
    GROUP BY movie_id
)
SELECT COUNT(*) AS movie_count,
       SUM(rating_count) AS rating_count,
       SUM(spam_count) AS spam_count,
       ROUND(100.0 * SUM(spam_count)
             / SUM(rating_count), 2) AS spam_rate_percent
FROM movie_summary
WHERE rating_count >= 10;