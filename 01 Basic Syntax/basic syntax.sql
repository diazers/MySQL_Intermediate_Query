-- SELECT and FROM
-- To show you all content in your table 
-- using SELECT and FROM
-- select is choosing what columns/fields to choose in your table
-- and FROM is choosing what is your schema and table
-- if you want to choose all the fields in your table 
-- you can simply type "*" in SELECT
SELECT * FROM billboard.top_100_1956_2013;

-- if you want to select certain field or more than one fields, type the name of the fields and separate 
-- each fields name with comma but you dont need comma after the last field name
SELECT	year,
		artist,
        song_name
FROM billboard.top_100_1956_2013;

-- ALIASING
-- you can change field name with another name (aliasing) using AS
-- after the original field's name
SELECT	year AS Tahun,
		artist AS Penyanyi,
        song_name AS Nama_Lagu
FROM billboard.top_100_1956_2013;

-- LIMIT
-- sometimes you dont need to show all rows/records of your data to 
-- do exploratory data analysis, because if you do that you will always
-- make your system slow, you can just show a certain number of rows that you want to see
-- using LIMIT
SELECT	* 
  FROM	billboard.top_100_1956_2013
 LIMIT	15
 
-- WHERE 
-- WHERE is used to filtering columns/fields
SELECT 	year,
		artist,
        song_name
  FROM	billboard.top_100_1956_2013
 WHERE	year = 2000	

-- COMPARISON OPERATOR (to filter data)
-- Equal to	(=)
-- Not equal to	(<>) or (!=)
-- Greater than	(>)
-- Less than	(<)
-- Greater than or equal to	(>=)
-- Less than or equal to	(<=)

-- showing data when the year is above 2000
SELECT	* 
  FROM	billboard.top_100_1956_2013
 WHERE	year > 2000
 
 -- showing data when the year is 2000 or below 2000
 SELECT	* 
  FROM	billboard.top_100_1956_2013
 WHERE	year <= 2000
 
 -- showing data when the year is not 1956
 SELECT	* 
  FROM	billboard.top_100_1956_2013
 WHERE	year != 1956
 -- try another comparison operator by yourself
 
 -- comparison operators on non numerical data
 -- you could also use comparison operators to string datatype
  SELECT	artist
    FROM	billboard.top_100_1956_2013
   WHERE	artist != 'Elvis Presley'
   LIMIT	10
 -- always using single quote for string in where clause
 -- You can use >, <, and the rest of the comparison operators 
 -- on non-numeric columns as well—they filter based on 
 -- alphabetical order.  
SELECT	*
  FROM	billboard.top_100_1956_2013
 WHERE	artist > 'x'
 -- the output will show artist's name which starts from y to z
 -- The way SQL treats alphabetical ordering is a little bit tricky
 -- SQL considers 'Ja' to be greater than 'J' because it has an extra letter.
 
 -- Arithmetic in SQL
 -- You can perform arithmetic in SQL using arithmetic operators (+, -, *, /)
 -- in this example below, maybe the calculation doesnt make sense
 -- because the derived column doesnt makes sense, this is just to show you
 -- the syntax and example to do arithmetic operators
 SELECT	year,
		year_rank,
		year + year_rank AS nonsense_column
   FROM	billboard.top_100_1956_2013
   -- the nonsense_column is the derived column
 
-- you can use parentheses to manage the order of operations
-- or just to make your query easier to read.
  SELECT	year,
			year_rank,
			id,
			(year + year_rank)/id AS nonsense_column
   FROM	billboard.top_100_1956_2013
-- you can also use arithmetics operators in the WHERE CLAUSE
-- based on what filtering that you need
-- such as find a row in a column that more than the sum of two column
-- WHERE column_1 > (column_2 + column_3)
-- or make percentage
-- column_1/(column_1 + column_2 + column_3 + column_4)*100 AS column_1_pct


-- SQL Logical operators
-- (LIKE, IN, BETWEEN, IS NULL, AND, OR, NOT)

-- LIKE
-- LIKE is a logical operator in SQL that allows you 
-- to match on similar values rather than exact ones

-- query that return rows for which "artist" starts with "Elvis" 
-- and is followed by any number and selection of characters.
SELECT	*
  FROM  billboard.top_100_1956_2013
 WHERE  artist LIKE "%Elvis%"
 -- LIKE is case-sensitive
 -- use wildcard (%) to help find insensitive case 
 -- use (%) before the word to find result that begins with the word
 -- use (%) after the word to find result that ends with the word
 -- use (%) bothsid of the word to find result that contains the word in any position
 
 -- NOT LIKE
  SELECT	*
  FROM  billboard.top_100_1956_2013
 WHERE  artist NOT LIKE "%Elvis%"
 
 -- IN
 -- IN is a logical operator in SQL that allows you to specify a list of values 
 -- that you'd like to include in the results.
 SELECT *
  FROM billboard.top_100_1956_2013
 WHERE year_rank IN (1, 2, 3)
 
 SELECT *
  FROM billboard.top_100_1956_2013
 WHERE artist IN ('Taylor Swift', 'Usher', 'Ludacris')
 
 SELECT *
  FROM billboard.top_100_1956_2013
 WHERE feat IN ('M.C. Hammer', 'Hammer', 'Elvis Presley')
 
 -- BETWEEN
 -- BETWEEN is a logical operator in SQL that allows you to select only rows 
 -- that are within a specific range. It has to be paired with the AND operator
 SELECT *
  FROM billboard.top_100_1956_2013
 WHERE year_rank BETWEEN 5 AND 10
 
 -- the above query will return the exact same results as the following query:
 SELECT *
  FROM billboard.top_100_1956_2013
 WHERE year_rank >= 5 AND year_rank <= 10
 
 SELECT *
  FROM billboard.top_100_1956_2013
 WHERE year BETWEEN 1985 AND 1990
 
 -- IS NULL
 -- IS NULL is a logical operatorin SQL that allows you to exclude rows 
 -- with missing data from your results.

SELECT *
FROM billboard.top_100_1956_2013
WHERE artist = '' -- or you cant write WHERE artist IS NULL, in this example the blank value is blank space

SELECT *
FROM billboard.top_100_1956_2013
WHERE song_name IS NOT NULL

-- AND
-- AND is a logical operator in SQL that allows you to select only rows that 
-- satisfy two conditions
SELECT *
  FROM billboard.top_100_1956_2013
 WHERE year = 2012 AND year_rank <= 10
 -- You can use SQL's AND operator with additional AND statements or any other 
 -- comparison operator, as many times as you want.
 SELECT *
  FROM billboard.top_100_1956_2013
 WHERE year = 2012
   AND year_rank <= 10
   AND artist LIKE '%gotye%'
   
-- a query that surfaces the top-ranked records in 1990, 2000, and 2010.
SELECT *
  FROM billboard.top_100_1956_2013
 WHERE year_rank = 1
   AND year IN (1990, 2000, 2010)
   
-- a query that lists all songs from the 1960s with "love" in the title.
SELECT *
  FROM billboard.top_100_1956_2013
 WHERE year BETWEEN 1960 AND 1969
   AND song_name LIKE '%love%'
   
-- OR
-- OR is a logical operator in SQL that allows you to select rows that satisfy 
-- either of two conditions.
SELECT *
  FROM billboard.top_100_1956_2013
 WHERE year_rank = 5 OR artist = 'Gotye'
 -- gotye is year_rank number 1 but because that satisfy one of the two conditions
 -- it appeared in the result
 
 -- The following query will return rows that satisfy both of the following conditions:
 SELECT *
  FROM billboard.top_100_1956_2013
 WHERE year = 2013
   AND (feat LIKE '%macklemore%' OR feat LIKE '%timberlake%')

-- a query that returns all rows for top-10 songs that featured either Katy Perry 
-- or Bon Jovi.   
SELECT *
  FROM billboard.top_100_1956_2013
 WHERE year_rank BETWEEN 1 AND 10
 AND (feat LIKE '%katy perry%' OR feat LIKE '%bon jovi%')
 
-- a query that returns all rows for top-10 songs that sung by either Katy Perry 
-- or Bon Jovi.   
  SELECT *
  FROM billboard.top_100_1956_2013
 WHERE year_rank <= 10
 AND artist IN ('Katy Perry', 'Bon Jovi')
 -- you cant use % in IN
 
 -- a query that returns all songs with titles that contain the word "California" 
 -- in either the 1970s or 1990s.
 SELECT *
 FROM  billboard.top_100_1956_2013
 WHERE song_name LIKE '%California%'
 AND (year BETWEEN 1970 AND 1979 OR year BETWEEN 1990 AND 1999) 
   
-- a query that lists all top-100 recordings that feature 
-- Dr. Dre before 2001 or after 2009.
SELECT *
  FROM billboard.top_100_1956_2013
 WHERE feat LIKE '%dr. dre%'
   AND (year <= 2000 OR year >= 2010)
   
   
-- NOT
-- NOT is a logical operator in SQL that you can put before any conditional statement 
-- to select rows for which that statement is false.
SELECT *
  FROM billboard.top_100_1956_2013
 WHERE year = 2013
   AND year_rank NOT BETWEEN 2 AND 3
 
-- Using NOT with < and > usually doesn't make sense because you can simply use 
-- the opposite comparative operator instead. For example, this query will return 
-- an error:
SELECT *
  FROM billboard.top_100_1956_2013
 WHERE year = 2013
   AND year_rank NOT > 3
 
-- Instead, you would just write that as:
SELECT *
  FROM billboard.top_100_1956_2013
 WHERE year = 2013
   AND year_rank <= 3
   
-- NOT is commonly used with LIKE. 
SELECT *
  FROM billboard.top_100_1956_2013
 WHERE year = 2013
   AND feat NOT LIKE '%macklemore%'
-- Run this query and check out how Macklemore disappears

-- NOT is also frequently used to identify non-null rows, but the syntax is 
-- somewhat special—you need to include IS beforehand.
SELECT *
  FROM billboard.top_100_1956_2013
 WHERE year = 2013
   AND artist IS NOT NULL
   
-- a query that returns all rows for songs that were on the charts in 2013 
-- and do not contain the letter "a"
 SELECT *
      FROM billboard.top_100_1956_2013
     WHERE song_name NOT LIKE '%a%'
       AND year = 2013
       

-- Sorting data with SQL ORDER BY
-- order by one of the columns:
SELECT *
  FROM billboard.top_100_1956_2013
 ORDER BY artist
 -- the results are now ordered alphabetically from a to z 
 -- based on the content in the artist column.
 -- This is referred to as ascending order, and it's SQL's default
 SELECT *
  FROM billboard.top_100_1956_2013
 WHERE year = 2013
 ORDER BY year_rank
 -- If you'd like your results in the opposite order (referred to as descending order) 
 -- you need to add the DESC operator
 SELECT *
  FROM billboard.top_100_1956_2013
 WHERE year = 2013
 ORDER BY year_rank DESC
 
 -- a query that returns all rows from 2012, ordered by song title from Z to A.\
 SELECT *
  FROM billboard.top_100_1956_2013
 WHERE year = 2012
 ORDER BY song_name DESC
 
 
 -- Ordering data by multiple columns
 -- You can also order by mutiple columns
 SELECT *
  FROM billboard.top_100_1956_2013
  WHERE year_rank <= 3
 ORDER BY year DESC, year_rank
 --columns in the ORDER BY clause must be separated by commas. 
 -- Second, the DESC operator is only applied to the column that precedes it. 
 -- Finally, the results are sorted by the first column mentioned (year),
 -- then by year_rank afterward.
 
 -- the folowing query will differnt with the above query
 SELECT *
  FROM billboard.top_100_1956_2013
 WHERE year_rank <= 3
 ORDER BY year_rank, year DESC
 
 -- you can make your life a little easier by substituting numbers for column names 
 -- in the ORDER BY clause. The numbers will correspond to the order in which you 
 -- list columns in the SELECT clause. For example, 
 -- the following query is exactly equivalent to the previous query:
 SELECT *
  FROM billboard.top_100_1956_2013
 WHERE year_rank <= 3
 ORDER BY 2, 1 DESC
 -- number 2 and 1 is refering to year_rank and year column respectively

-- a query that returns all rows from 2010 ordered by rank, 
-- with artists ordered alphabetically for each song.
SELECT *
  FROM billboard.top_100_1956_2013
 WHERE year = 2010
 ORDER BY year_rank, artist
 
 -- a query that shows all rows for which T-Pain was a feat member, 
 -- ordered by rank on the charts, from lowest to highest rank (from 100 to 1).
 SELECT *
  FROM billboard.top_100_1956_2013
 WHERE feat LIKE '%t-pain%'
 ORDER BY year_rank DESC
 
 -- Write a query that returns songs that ranked between 10 and 20 (inclusive) 
 -- in 1993, 2003, or 2013. Order the results by year and rank, and leave a comment on 
 -- each line of the WHERE clause to indicate what that line does
 SELECT *
  FROM billboard.top_100_1956_2013
 WHERE year IN (2013, 2003, 1993)  -- Select the relevant years
   AND year_rank BETWEEN 10 AND 20  -- Limit the rank to 10-20
 ORDER BY year, year_rank