# 🎬 Movie Ratings Analysis — SQL Project

## 📌 Objective
Analyze 100,000+ movie ratings to uncover trends in genres, 
decades, and user behavior using SQL and MySQL Workbench.

## 📁 Dataset
- **Source:** MovieLens Small Dataset (GroupLens)
- **Size:** 100,836 ratings | 9,742 movies | 610 users
- **Download:** https://grouplens.org/datasets/movielens/

## 🛠️ Tools Used
- SQL (MySQL)
- MySQL Workbench

## 📂 Project Structure
| File | Description |
|------|-------------|
| `movie-rating-analysis.sql` | All SQL queries for the project |

## 📊 Analysis Performed
- ✅ Basic data exploration (total movies, ratings, users)
- ✅ Top 10 highest rated movies (min 50 ratings)
- ✅ Bottom 10 lowest rated movies (min 50 ratings)
- ✅ Most common genres in the dataset
- ✅ Average rating by genre
- ✅ Most active users
- ✅ Rating distribution (1★ to 5★)
- ✅ Movies by decade with average ratings

## 📝 Sample Query
```sql
-- Top 10 highest rated movies (with at least 50 ratings)
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
```

## 🔍 Key Insights
- Top rated genre: *(update after running queries)*
- Best decade for movies: *(update after running queries)*
- Highest rated movie: *(update after running queries)*
- Most common rating: *(update after running queries)*
