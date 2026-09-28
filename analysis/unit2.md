# Unit 2 Analysis and Justification

## Table Creation Order

|Order|Table|Tables it references|
|---|---|---|
|1|users|None|
|2|movies|movies (itself)|
|3|genres|None|
|4|movie_genres|movies, genres|
|5|ratings|users, movies|

## Foreign Keys and Deletion Behavior

|Foreign key|ON DELETE|Reason|
|---|---|---|
|ratings.user_id|CASCADE|Deleting a user automatically deletes that user's ratings because this design treats ratings as part of the user.|
|ratings.movie_id|RESTRICT|A movie cannot be deleted while it has ratings, which protects its rating data from total deletion.|
|movie_genres.movie_id|CASCADE|Deleting a movie removes its genre links because those links no longer connect to an existing movie.|
|movie_genres.genre_id|CASCADE|Deleting a genre removes the associated movie and genre links while keeping the movies and their ratings.|
|movies.previous_movie_id|SET NULL|If deletion of a previous movie is allowed, this link is set to NULL to preserve the movies that referenced it.|

For ratings.user_id, a user deleting their account would also delete their ratings. Using RESTRICT would prevent the account from being deleted until its ratings were removed separately.

For ratings.movie_id, someone might try to remove a movie that users have already rated. RESTRICT keeps the movie and its ratings. The movie can be marked inactive instead using is_active. Using CASCADE would also delete the scores users submitted.

For movie_genres.movie_id, an unrated movie might have been added by mistake and need to be deleted. CASCADE removes its genre links while keeping the genres. Using RESTRICT would require those links to be deleted separately first.

For movie_genres.genre_id, someone might remove a genre that the platform no longer needs. CASCADE removes its associated links while keeping the movies and their ratings. Using RESTRICT would block the removal until those links were deleted separately.

For movies.previous_movie_id, an unrated movie might be removed even though other movies reference it as their previous movie. SET NULL clears those references while keeping the other movies. Using CASCADE could also delete movies that should remain on the platform.

## CHECK Constraints

- chk_users_id_positive, chk_movies_id_positive, chk_genres_id_positive, and chk_ratings_id_positive require their IDs to be greater than 0. An import that overrides generated IDs could otherwise supply 0 or a negative number.

- chk_users_display_name_nonblank, chk_movies_title_nonblank, and chk_genres_name_nonblank require their TEXT attributes to be nonblank. Someone could otherwise leave a name or title empty or enter only spaces or tabs.

- chk_movies_runtime_positive requires runtime_minutes to be greater than 0. Someone could otherwise enter a negative number by mistake or use 0 for an unknown runtime.

- chk_ratings_score limits stored scores to 1, 2, 3, 4, or 5. Without this check, an input such as 6 or 3.50 could be stored even though the platform uses whole-number ratings in a 5 star system.

- chk_movies_no_self_reference prevents previous_movie_id from equaling the same row's movie_id. Someone could otherwise enter the movie's own ID instead of the previous movie's ID.

## Changes from Unit 1

I added previous_movie_id to movies to connect a movie to its previous movie, such as an earlier movie in a series. This relationship belongs in movies because both records represent movies. The attribute can be NULL because not every movie has a previous movie linked to it. This is now the exception to the rule that every attribute must have a value.

I changed score from INTEGER to NUMERIC(3,2) to follow the Unit 2 type guidance. The CHECK still limits each score to 1, 2, 3, 4, or 5.

I changed rated_at from TIMESTAMPTZ to TIMESTAMP to follow the Unit 2 type guidance. I also added DEFAULT CURRENT_TIMESTAMP so a new rating receives the current time if no rated_at value is provided.

## Derived Values

Movie averages will be calculated from ratings when needed instead of stored in a separate column. This avoids having to update a stored average each time a rating is added, changed, or deleted.
