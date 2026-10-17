-- 3.1a: Which available movies were released after 2015?
-- Requirement: SELECT, WHERE, ORDER BY, LIMIT.
-- Finding: Seven available movies were released after 2015.

SELECT movie_id, title, release_year, is_available
FROM movies
WHERE is_available = TRUE
  AND release_year > 2015
ORDER BY release_year DESC, movie_id ASC
LIMIT 10;

-- 3.1b: What rating statuses appear in the dataset?
-- Requirement: SELECT DISTINCT.
-- Finding: The three rating statuses are flagged, published, and withdrawn.

SELECT DISTINCT rating_status
FROM ratings
ORDER BY rating_status;

-- 3.1c: Which ratings have scores between 4 and 5?
-- Requirement: Filter events using a numeric range.
-- Finding: 70 ratings have scores between 4 and 5.

SELECT rating_id, movie_id, score, rating_status
FROM ratings
WHERE score BETWEEN 4 AND 5
ORDER BY score DESC, rating_id ASC;

-- 3.1d: Which ratings are flagged or withdrawn?
-- Requirement: Filter events using an explicit list with IN.
-- Finding: 44 ratings are flagged or withdrawn.

SELECT rating_id, movie_id, rating_status, withdrawn_reason
FROM ratings
WHERE rating_status IN ('flagged', 'withdrawn')
ORDER BY rating_status, rating_id;

-- 3.1e: Which movie titles contain the digit 1?
-- Requirement: Match producer names using LIKE.
-- Finding: Seven movie titles contain the digit 1.

SELECT movie_id, title
FROM movies
WHERE title LIKE '%1%'
ORDER BY movie_id;

-- 3.1f: Which ratings have no withdrawal reason recorded?
-- Requirement: Find NULL values and display a label using COALESCE.
-- Finding: 166 ratings have no withdrawal reason recorded.

SELECT rating_id, rating_status,
       COALESCE(withdrawn_reason, 'No reason provided') AS reason
FROM ratings
WHERE withdrawn_reason IS NULL
ORDER BY rating_id;

-- 3.1g: What outcome category does each rating belong to?
-- Requirement: Create a computed column using CASE.
-- Finding: Withdrawals include spam and other reasons, such as duplicate ratings.

SELECT rating_id, rating_status, withdrawn_reason,
       CASE
           WHEN rating_status = 'withdrawn'
                AND withdrawn_reason = 'Spam detected'
               THEN 'Spam withdrawal'
           WHEN rating_status = 'withdrawn'
               THEN 'Other withdrawal'
           WHEN rating_status = 'flagged'
               THEN 'Flagged'
           ELSE 'Published'
       END AS rating_category
FROM ratings
ORDER BY rating_id;