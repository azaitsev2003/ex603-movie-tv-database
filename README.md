# Movie/TV Ratings Database

Relational database for a large-scale movie/TV ratings platform. EX603 BU course project.

**Theme:** Movie/TV

## Domain

This platform is designed to store information about users, movies, ratings, and genres. Each user can have one current rating per movie using a 5 star system. If a user changes their rating, their existing rating is updated. A movie can have multiple genres, and a genre can be used for multiple movies. The database also stores each movie's runtime and whether it is active.

The platform needs to answer questions such as which movies have the highest average scores, how many ratings each movie has, and which movies a user has rated. It also needs to show which movies belong to a selected genre and find active movies within a chosen runtime range. These questions use the relationships between users, movies, ratings, genres, and movie_genres.

## Entity Relationship Diagram

![Movie/TV ratings database ERD](schema/erd.png)

## Schema

|Table|Purpose|
|---|---|
|users|Stores user accounts and their display names.|
|movies|Stores movie titles, runtimes, and whether each movie is active.|
|ratings|Stores one current rating per user and movie, including the score and rated_at value.|
|genres|Stores the genres used to classify movies.|
|movie_genres|Links movies to genres, allowing a movie to have multiple genres and a genre to be used for multiple movies.|

users, movies, ratings, and genres use automatically generated integer primary keys. movie_genres uses (movie_id, genre_id) as its composite primary key, which prevents duplicate movie and genre links.

A movie cannot be deleted while it has ratings. It can be marked inactive instead using is_active. The optional previous_movie_id foreign key connects a movie to another movie in the same table, such as an earlier movie in a series.
