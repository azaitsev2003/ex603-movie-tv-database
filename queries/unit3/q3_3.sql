-- 3.3.1: Which users have no ratings withdrawn because of spam?
-- Requirement: Answer a two-step question using a NOT IN subquery.
-- Finding: 20 users have no ratings withdrawn because of spam.

SELECT user_id, user_name
FROM users
WHERE user_id NOT IN (
    SELECT user_id
    FROM ratings
    WHERE rating_status = 'withdrawn'
      AND withdrawn_reason = 'Spam detected'
)
ORDER BY user_id;

-- 3.3.2: Which users have no ratings withdrawn because of spam?
-- Requirement: Answer the same question using a CTE.
-- Finding: The CTE version returns 20 users with no ratings withdrawn because of spam.

WITH spam_users AS (
    SELECT user_id
    FROM ratings
    WHERE rating_status = 'withdrawn'
      AND withdrawn_reason = 'Spam detected'
)
SELECT user_id, user_name
FROM users
WHERE user_id NOT IN (
    SELECT user_id
    FROM spam_users
)
ORDER BY user_id;

-- 3.3.3: Which users have no ratings withdrawn because of spam?
-- Requirement: Answer the same question using NOT EXISTS.
-- Finding: The NOT EXISTS version returns 20 users with no ratings withdrawn because of spam.

SELECT users.user_id, users.user_name
FROM users
WHERE NOT EXISTS (
    SELECT 1
    FROM ratings
    WHERE ratings.user_id = users.user_id
      AND rating_status = 'withdrawn'
      AND withdrawn_reason = 'Spam detected'
)
ORDER BY users.user_id;

-- Result comparison:
-- All three versions return the same 20 user IDs and names and the top and bottom screenshots show every row, ordered by user_id.

-- Condition that could change the results:
-- If a spam withdrawal had a NULL user_id, both NOT IN versions would return no users. The NOT EXISTS version would still return users
-- without a matching spam withdrawal. The provided database prevents this because ratings.user_id is NOT NULL.