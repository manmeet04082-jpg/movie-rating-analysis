create database movie_rating;
use movie_rating;
CREATE TABLE movies (
    movieId INT PRIMARY KEY,
    title VARCHAR(255),
    genres VARCHAR(255)
);
CREATE TABLE ratings (
    userId INT,
    movieId INT,
    rating FLOAT,
    timestamp BIGINT
);
CREATE TABLE tags (
    userId INT,
    movieId INT,
    tag VARCHAR(255),
    timestamp BIGINT
);
USE movie_rating;

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/Admin/3D Objects/project/movie-rating-analysis/ml-latest-small/movies.csv'
INTO TABLE movies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(movieId, title, genres);

LOAD DATA LOCAL INFILE 'C:/Users/Admin/3D Objects/project/movie-rating-analysis/ml-latest-small/ratings.csv'
INTO TABLE ratings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(userId, movieId, rating, timestamp);

LOAD DATA LOCAL INFILE 'C:/Users/Admin/3D Objects/project/movie-rating-analysis/ml-latest-small/tags.csv'
INTO TABLE tags
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(userId, movieId, tag, timestamp);

-- See all movies
SELECT * FROM movies;

-- Count total number of movies
SELECT COUNT(*) AS total_movies 
FROM movies;

-- Count total number of ratings
select count(*) as total_ratings
from ratings;

-- Find unique users who gave ratings
select count(distinct userId) as total_users
from ratings;

-- Average rating per movie
SELECT 
    movieId, 
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(rating) AS total_ratings
FROM ratings
GROUP BY movieId
ORDER BY avg_rating DESC;

-- Top 10 highest-rated movies (with at least 50 ratings)
SELECT 
    m.title,
    ROUND(AVG(r.rating), 2) AS avg_rating,
    COUNT(r.rating) AS total_ratings
FROM ratings r
JOIN movies m ON r.movieId = m.movieId
GROUP BY m.title
HAVING COUNT(r.rating) >= 50
ORDER BY avg_rating DESC
LIMIT 10;

-- Bottom 10 lowest-rated movies (with at least 50 ratings)
SELECT 
    m.title,
    ROUND(AVG(r.rating), 2) AS avg_rating,
    COUNT(r.rating) AS total_ratings
FROM ratings r
JOIN movies m ON r.movieId = m.movieId
GROUP BY m.title
HAVING COUNT(r.rating) >= 50
ORDER BY avg_rating ASC
LIMIT 10;

-- Most common genres in the dataset
SELECT 
    genres, 
    COUNT(*) AS movie_count
FROM movies
GROUP BY genres
ORDER BY movie_count DESC
LIMIT 10;

-- Average rating by genre (uses LIKE to match genre tags)
SELECT 
    CASE 
        WHEN m.genres LIKE '%Action%' THEN 'Action'
        WHEN m.genres LIKE '%Comedy%' THEN 'Comedy'
        WHEN m.genres LIKE '%Drama%' THEN 'Drama'
        WHEN m.genres LIKE '%Thriller%' THEN 'Thriller'
        WHEN m.genres LIKE '%Romance%' THEN 'Romance'
        WHEN m.genres LIKE '%Horror%' THEN 'Horror'
        WHEN m.genres LIKE '%Animation%' THEN 'Animation'
        ELSE 'Other'
    END AS genre,
    ROUND(AVG(r.rating), 2) AS avg_rating,
    COUNT(r.rating) AS total_ratings
FROM ratings r
JOIN movies m ON r.movieId = m.movieId
GROUP BY genre
ORDER BY avg_rating DESC;

-- Most active users (who rated the most movies)
SELECT 
    userId, 
    COUNT(movieId) AS movies_rated,
    ROUND(AVG(rating), 2) AS their_avg_rating
FROM ratings
GROUP BY userId
ORDER BY movies_rated DESC
LIMIT 10;

-- Rating distribution (how many 1★, 2★, 3★... ratings exist)
SELECT 
    rating, 
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ratings), 2) AS percentage
FROM ratings
GROUP BY rating
ORDER BY rating DESC;

-- Movies released per decade with average rating
SELECT 
    CASE
        WHEN title LIKE '%(199%)' THEN '1990s'
        WHEN title LIKE '%(200%)' THEN '2000s'
        WHEN title LIKE '%(201%)' THEN '2010s'
        WHEN title LIKE '%(198%)' THEN '1980s'
        ELSE 'Other'
    END AS decade,
    COUNT(DISTINCT m.movieId) AS total_movies,
    ROUND(AVG(r.rating), 2) AS avg_rating
FROM movies m
JOIN ratings r ON m.movieId = r.movieId
GROUP BY decade
ORDER BY avg_rating DESC;