-- 4.1a: What do the scores and number of reviewers look like across all ratings?
-- Requirement: COUNT, SUM, AVG, MIN, MAX, and COUNT DISTINCT across the event table.
-- Finding: 200 ratings from 30 reviewers total 569.3 points, average 2.85, and range from 0.5 to 5.0.

SELECT COUNT(score) AS rating_count,
       SUM(score) AS total_score,
       ROUND(AVG(score), 2) AS average_score,
       MIN(score) AS minimum_score,
       MAX(score) AS maximum_score,
       COUNT(DISTINCT user_id) AS reviewer_count
FROM ratings;

-- 4.1b: How many ratings does each movie have, and what is its average score?
-- Requirement: Group by producer and sort from most events to fewest.
-- Finding: 13 movies have ratings. Movie 6 has the most with 21 ratings.

SELECT movie_id,
       COUNT(*) AS rating_count,
       ROUND(AVG(score), 2) AS average_score
FROM ratings
GROUP BY movie_id
ORDER BY rating_count DESC, movie_id;

-- 4.1c: Which movies have at least 10 ratings for comparison?
-- Requirement: Filter grouped results using HAVING and explain the threshold. Ten ratings is a starting point.
-- Finding: 12 movies have at least 10 ratings; movie 4 does not.

SELECT movie_id,
       COUNT(*) AS rating_count,
       ROUND(AVG(score), 2) AS average_score
FROM ratings
GROUP BY movie_id
HAVING COUNT(*) >= 10
ORDER BY rating_count DESC, movie_id;

-- 4.1d: How do rating counts and average scores vary by country and status?
-- Requirement: Group by two dimensions, including region. Region means the device_country recorded on each rating.
-- Finding: There are 14 country and status combinations. India has no flagged ratings.

SELECT device_country,
       rating_status,
       COUNT(*) AS rating_count,
       ROUND(AVG(score), 2) AS average_score
FROM ratings
GROUP BY device_country, rating_status
ORDER BY device_country, rating_status;