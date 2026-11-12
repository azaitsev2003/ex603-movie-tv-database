# Unit 5 Analysis

## Rating history

A rating history page could show who rated each movie and when. The ratings
table gives me the time. I can use the user ID to get the reviewer's name
and the movie ID to get the title.

Each row in `movie_genres` links one movie to one genre. A movie can have
several genres. Without those links, finding every comedy could mean searching
through a list of tags on each movie. Title_02 and Title_03 both came out in
2023 and both have the Comedy tag.

## Movies with no ratings

The inner join shows 13 movies. The left join shows all 15. Movies 14 and 15
have no ratings, so the inner join leaves them out. Looking at that report
alone, I would think every movie had been rated. Both titles are available.
People might have missed them or had trouble leaving a rating. I would check
how often people opened each listing and test whether I could submit a rating.

I reversed the tables for the right join and compared the results both ways.
Every movie and rating count matched. A full join can show an unrated movie
and a rating with no matching movie in the same report. Here, every rating
has a matching movie.

`NOT EXISTS` checks each movie for a matching rating. `EXCEPT` takes the
rated IDs out of the full list of movie IDs. Both returned 14 and 15.

## Join performance

Pairing 15 movies with 5 genres gave me 75 pairs. I could compare that list
with the saved tags to find unused pairs. If I used it to list actual genres,
every movie would show up as a comedy.

PostgreSQL plans to scan ratings and users and use a hash join on user ID.
The query needs all 200 ratings, and the user table is small enough to build
a lookup table. A nested loop uses the movie's primary key index to find each
title. It saves the result for each movie ID so it can reuse it. The last
step sorts the rows by rating ID. That is one step I would check as more
ratings come in, since sorting more rows takes time and memory.

## Reflection

If the ratings table grew to a million rows, I would first look at how
many of those ratings I needed. For the full rating history, PostgreSQL
would still have to read every rating. If the same few movies kept getting
rated, it could keep reusing the movie lookups like it does now. If the
ratings covered many more movies, it might make sense to build a hash
table of movie IDs and titles and look up each rating there.

For the history of one movie, an index on the movie ID in ratings could
help PostgreSQL go straight to that movie's ratings. If it had only a few,
a nested loop could look up each reviewer by ID. If one movie had half
the ratings on the platform, the same query would have many more reviewers
to look up. I would check the plan again to see if PostgreSQL chose to
scan the users once and match them with a hash join.
