# Unit 6 Analysis

## 6.1

Which ratings are above or below their movie's average? The window query keeps all 200 ratings and shows the average beside each score. GROUP BY returns 13 rows, one per rated movie. It does not show the individual scores needed for that comparison.

I would use DENSE_RANK for a most-rated movies page because equal counts share a place without skipping the next place. Movies 5 and 7 both have 18 ratings. ROW_NUMBER puts them in places 4 and 5, while RANK and DENSE_RANK give both place 4. The next movie gets rank 6 with RANK and rank 5 with DENSE_RANK.

NTILE puts movies 5 and 7 in different bands despite their equal counts. The bands divide the rows into similar-sized groups, so they do not always keep ties together.

## 6.2

A large score change for movie 2 means consecutive ratings were very different. I would check those ratings and their status before treating the change as a shift in viewer opinion.

My example target was 250 ratings for 2023. The running total reaches 200, or 80%. A plain SUM only gives the total, while the running total shows progress by date.

I chose seven recorded days for the moving average to smooth daily changes while still showing recent activity. A longer window would smooth more changes. Dates without ratings are skipped, so seven rows can cover more than a week. ROWS counts individual rows; RANGE can include tied ORDER BY values together. Each date appears once in this query.

Movie 9 has a gap of 112 days, 13 hours, and 58 minutes between January 5 and April 28, 2023, above my 90-day cutoff. This is a gap in recorded ratings. The data alone cannot show whether activity stopped or records are missing. I would compare the source records with the database and check the rating form before deciding what needs fixing.

## 6.3

The top-three query could show three ratings on each movie's page. One gives little variety, while ten takes up too much space. ROW_NUMBER keeps three ratings per movie in this dataset. The lower rating ID breaks score ties so the selection stays consistent. FIRST_VALUE shows the movie's highest score.

All 12 months have ratings. The calendar check keeps missing months in the series so LAG compares consecutive months. NULLIF prevents division by zero.

A large monthly increase in the spam rate would be a reason to review the ratings and accounts involved. November has no spam withdrawals out of 14 ratings, while December has 2 out of 16, or 12.50%. I would review those two ratings for repeat submissions. With counts this small, I would check both the count and rate before calling it a trend. The query reports rating-volume changes as percentages and spam-rate changes as percentage points.

## Reflection

I would use a window function to answer this question: how does each rating compare with the movie's average and the rating before it? I would want the score, date, average, and previous score on the same row. That would make a sudden change easier to find without losing the details of the rating. I could then check its status before deciding what the change means.

GROUP BY alone would give me one average per movie. It would not keep each rating and date beside that average, so it would not answer the full question. I could join the averages back to the ratings, but I would still need a way to get the previous score. Window functions handle both while keeping the individual rows. The order matters too. I used the rating ID after the timestamp so ratings with the same timestamp stay in a consistent order. Otherwise, the previous rating could be unclear.
