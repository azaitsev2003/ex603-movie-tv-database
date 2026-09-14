# Schema Definition
**Theme:** Movie/TV
## users

**Role:** Actor

Each row represents one user account on the movie ratings platform.

**Relation schema:** users(user_id, display_name)

|Attribute|Domain|
|---|---|
|user_id|INTEGER, greater than 0|
|display_name|TEXT, nonblank|

**Primary key:** user_id

## movies

**Role:** Producer

Each row represents one movie that the platform stores information about.

**Relation schema:** movies(movie_id, title, is_active, runtime_minutes)

|Attribute|Domain|
|---|---|
|movie_id|INTEGER, greater than 0|
|title|TEXT, nonblank|
|is_active|BOOLEAN|
|runtime_minutes|INTEGER, greater than 0|

**Primary key:** movie_id

## ratings

**Role:** Event

Each row represents one user's current rating of one movie.

**Relation schema:** ratings(rating_id, user_id, movie_id, rated_at, score)

|Attribute|Domain|
|---|---|
|rating_id|INTEGER, greater than 0|
|user_id|INTEGER, greater than 0|
|movie_id|INTEGER, greater than 0|
|rated_at|TIMESTAMPTZ|
|score|INTEGER, 1-5|

**Primary key:** rating_id

## genres

**Role:** Catalog

Each row represents one genre used to classify movies.

**Relation schema:** genres(genre_id, genre_name)

|Attribute|Domain|
|---|---|
|genre_id|INTEGER, greater than 0|
|genre_name|TEXT, nonblank|

**Primary key:** genre_id

## movie_genres

**Role:** Junction

Each row links one movie to one genre.

**Relation schema:** movie_genres(movie_id, genre_id)

|Attribute|Domain|
|---|---|
|movie_id|INTEGER, greater than 0|
|genre_id|INTEGER, greater than 0|

**Primary key:** (movie_id, genre_id)
