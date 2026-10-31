# Unit 4 Analysis

## Task 4.1

The Trust and Data team lead could use these results to choose which
movies to check. An average hides how much the scores differ, and a
rating count does not show how many different people rated each movie.
I would look at the scores, reviewer IDs, dates, and withdrawal reasons next.

I used at least 10 ratings to leave out the smallest groups.
This keeps 12 movies and leaves out movie 4, which has 6 ratings.
Ten is a starting point for this dataset; it does not make a rate reliable.

I grouped the regional results by device country and rating status.
The country is where the rating was recorded. Scores range from 0.5
to 5.0, with no zeros. The averages include all statuses.
Movies 14 and 15 have no ratings, so they do not appear in these groups.

## Task 4.2

### Part A

This shows how many ratings each movie has and how many were withdrawn
for spam. Only withdrawn ratings with the reason Spam detected count
as failures. All ratings stay in the total.

### Part B

The regional director could use this to compare countries.
The five country rows are subtotals. All countries is the grand total:
12 spam withdrawals out of 200 ratings, or 6%.
This helps decide how much review is needed across the platform.
One country's rate cannot answer that question.

### Part C

This asks for the combined spam rate among movies with at least
10 ratings. The CTE counts ratings and spam withdrawals for each movie.
The outer query keeps qualifying movies and adds their counts.
The result is 11 out of 194 ratings across 12 movies, or 5.67%.
I divided the totals instead of averaging the movie percentages.

## Reflection

Counting all ratings and spam withdrawals in one query keeps both numbers
together. Every rating counts toward the total. The CASE statement adds
one to the spam count only when the rating was withdrawn for spam.
That makes it easier to check each movie's rate.

With two queries, I would count all ratings in one and spam withdrawals
in the other. Then I would have to match the results by movie ID.
Movies with no spam withdrawals would need a zero instead of being
left out. If ratings changed between the queries, the counts might
not match.

With a million rows, reading the table twice could take more time.
One query can avoid that extra read and the work of combining two
results. It will not always be faster because indexes and stored data
in memory can affect the time. For this report, I would use one query
because the counts are easier to compare and check.
