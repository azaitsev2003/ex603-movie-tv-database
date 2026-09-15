# Integrity Constraints

## Primary Keys

The primary keys defined in schema-definition.md uniquely identify records, and the composite key in movie_genres prevents duplicate movie and genre links.

## Required values and valid data

|Constraint|Reason|
|---|---|
|Every attribute must have a value (NOT NULL)|Prevents incomplete records, such as a user without a display_name|
|Every ID must be a whole number greater than 0|Keeps all IDs within a positive number domain|
|All TEXT attributes must be nonblank|Ensures that each name or title is not just tabs or spaces|
|movies.runtime_minutes must be a whole number greater than 0|Ensures that runtime is a positive number of minutes|
|ratings.score must be a whole number from 1 through 5, inclusive|Keeps every rating within a 5 star system|
|The combination (user_id, movie_id) must be unique in ratings|Ensures that each user has maximum only 1 review per movie|

## Foreign keys and deletion behavior

Foreign key|References|ON DELETE|Behavior and reason|
|---|---|---|---|
|ratings.user_id|users.user_id|CASCADE|Deleting a user automatically deletes that user's ratings. This design treats ratings as part of the user.|
|ratings.movie_id|movies.movie_id|RESTRICT|A movie cannot be deleted while it has ratings. This protects its rating data from total deletion. Each movie can be marked inactive instead to prevent this.|
|movie_genres.movie_id|movies.movie_id|CASCADE|If a movie is deleted, its genre links are deleted because those links no longer connect to an existing movie.|
|movie_genres.genre_id|genres.genre_id|CASCADE|Deleting a genre deletes the associated movie and genre links. The movies and their ratings remain.|
