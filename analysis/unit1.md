# Unit 1 Analysis and Justification

## Modeling Justification

My chosen theme is Movie/TV. The five relations are users, movies, ratings, genres, and movie_genres. These cover the Actor, Producer, Event, Catalog, and Junction roles. Each row in ratings represents one user's current rating of one movie. This gives the platform a way to connect users to the movies they rate and calculate average scores.

I chose user_id, movie_id, rating_id, and genre_id as the primary keys for their relations. Every ID must be a whole number greater than 0, which keeps all IDs within a positive number domain. Using IDs means that records can be identified without depending on names or titles being unique. A user can also change their display_name without changing which ratings belong to them. The combination (user_id, movie_id) must be unique in ratings, so each user can have only 1 rating per movie.

For movie_genres, I used (movie_id, genre_id) as the composite primary key. Each row links one movie to one genre, and the composite key prevents duplicate movie and genre links. This allows a movie to have multiple genres and a genre to be used for multiple movies without storing a list of genres in one attribute.

I used TEXT for names and titles because the requirements did not set a maximum length. All TEXT attributes must be nonblank, which ensures that each name or title is not just tabs or spaces. runtime_minutes must be a whole number greater than 0 to ensure that runtime represents a positive number of minutes. score must be a whole number from 1 through 5, inclusive, which keeps every rating within a 5 star system.

For ratings.user_id, I chose ON DELETE CASCADE. Deleting a user automatically deletes that user's ratings. This design treats ratings as part of the user. For ratings.movie_id, I chose ON DELETE RESTRICT. A movie cannot be deleted while it has ratings. This protects its rating data from total deletion when someone tries to delete the movie. Each movie can be marked inactive instead using is_active.

Both foreign keys in movie_genres use ON DELETE CASCADE. If a movie is deleted, its genre links are deleted because those links no longer connect to an existing movie. Deleting a genre deletes the associated movie and genre links. The movies and their ratings remain. These choices remove links that are no longer valid without deleting everything associated.

I chose to define required values, valid domains, primary keys, foreign keys, and the unique user and movie combination in the schema. Every attribute must have a value (NOT NULL), which prevents incomplete records, such as a user without a display_name. Foreign keys ensure that ratings and genre links refer to existing records. Defining these rules in the database means invalid data is rejected even if the application misses an invalid input.

## Reflection

One decision I made was to limit one user's current rating to one per movie instead of keeping every rating they have submitted for that movie. The combination (user_id, movie_id) must be unique in ratings. A different designer could choose to allow multiple ratings from the same user for the same movie and use rated_at to keep a history of changes.

I chose one current rating because the platform needs to show users' ratings and calculate movie scores. When reading the data, each user contributes only one score to a movie's average. There is no need to first find the latest rating from each user or remove their older ratings from the calculation.

For write patterns, a user's first rating would create a record. If they changed their score, the application would update that record and its rated_at value. The unique combination would prevent a second record for the same user and movie.

This choice means the platform cannot show how a user's rating changed over time. Keeping that history could be useful, but using one current rating keeps the reads and writes straightforward and easier for the platform I am designing.
