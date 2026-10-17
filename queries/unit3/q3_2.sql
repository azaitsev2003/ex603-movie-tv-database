-- 3.2A.1: How many ratings are not marked as spam?
-- Requirement: Reproduce the NULL problem using an inequality. This query intentionally misses rows with a NULL withdrawal reason.
-- Finding: The inequality returns 22 ratings but excludes ratings with no withdrawal reason recorded.

SELECT COUNT(*) AS not_marked_as_spam_count
FROM ratings
WHERE withdrawn_reason <> 'Spam detected';

-- 3.2A.2: How do the comparison counts and missing reasons compare with all ratings?
-- Requirement: Show the omitted NULL rows and compare the counts with the table total.
-- Finding: The two comparisons count 34 of 200 ratings and leave out 166 ratings with a NULL withdrawal reason.

SELECT
    COUNT(*) FILTER (
        WHERE withdrawn_reason <> 'Spam detected'
    ) AS other_reason_count,
    COUNT(*) FILTER (
        WHERE withdrawn_reason = 'Spam detected'
    ) AS spam_count,
    COUNT(*) FILTER (
        WHERE withdrawn_reason IS NULL
    ) AS missing_reason_count,
    COUNT(*) AS total_ratings
FROM ratings;

-- 3.2A.3: How many ratings are not marked as spam, including those with no withdrawal reason?
-- Requirement: Repair the inequality by explicitly including NULL values.
-- Finding: Including NULL withdrawal reasons increases the count from 22 to 188 ratings.

SELECT COUNT(*) AS not_marked_as_spam_count
FROM ratings
WHERE withdrawn_reason <> 'Spam detected'
   OR withdrawn_reason IS NULL;

-- 3.2B.1: Which ratings were withdrawn because of spam?
-- Requirement: Demonstrate an error caused by using a SELECT alias in WHERE. This query is intentionally incorrect.
-- Finding: WHERE cannot use an alias defined in the same query's SELECT.
/*
SELECT rating_id, rating_status, withdrawn_reason,
       CASE
           WHEN rating_status = 'withdrawn'
                AND withdrawn_reason = 'Spam detected'
               THEN 'Spam withdrawal'
           ELSE 'Other'
       END AS rating_category
FROM ratings
WHERE rating_category = 'Spam withdrawal'; */

-- 3.2B.2: Which ratings were withdrawn because of spam?
-- Requirement: Fix the alias error by repeating the expression in WHERE.
-- Finding: Repeating the CASE expression in WHERE returns 12 ratings withdrawn because of spam.

SELECT rating_id, rating_status, withdrawn_reason,
       CASE
           WHEN rating_status = 'withdrawn'
                AND withdrawn_reason = 'Spam detected'
               THEN 'Spam withdrawal'
           ELSE 'Other'
       END AS rating_category
FROM ratings
WHERE CASE
          WHEN rating_status = 'withdrawn'
               AND withdrawn_reason = 'Spam detected'
              THEN 'Spam withdrawal'
          ELSE 'Other'
      END = 'Spam withdrawal'
ORDER BY rating_id;

-- 3.2B.3: Which ratings were withdrawn because of spam?
-- Requirement: Fix the alias error using a CTE.
-- Finding: The CTE allows WHERE to use rating_category and returns the same 12 spam withdrawals.

WITH categorized_ratings AS (
    SELECT rating_id, rating_status, withdrawn_reason,
           CASE
               WHEN rating_status = 'withdrawn'
                    AND withdrawn_reason = 'Spam detected'
                   THEN 'Spam withdrawal'
               ELSE 'Other'
           END AS rating_category
    FROM ratings
)
SELECT rating_id, rating_status, withdrawn_reason, rating_category
FROM categorized_ratings
WHERE rating_category = 'Spam withdrawal'
ORDER BY rating_id;