-- This dataset is apple historical stock price from the years of 2000 to 2014
SELECT * FROM applestock.historical_stock_price;

###-- Aggregate functions in SQL --###
-- COUNT counts how many rows are in a particular column.
-- SUM adds together all the values in a particular column.
-- MIN and MAX return the lowest and highest values in a particular column, respectively.
-- AVG calculates the average of a group of selected values.
-- aggregators only aggregate vertically (by column)




###-- COUNT --###
-- for counting the number of rows in a particular column.
-- COUNT can be used on columns with numerical and text values (non-numerical columns).
-- COUNT treats nulls as 0.
SELECT COUNT(*)
  FROM applestock.historical_stock_price;
-- Note: Typing COUNT(1) has the same effect as COUNT(*). its is a matter of personal preference.  
SELECT COUNT(1)
  FROM applestock.historical_stock_price;
  
-- Counting individual columns
SELECT COUNT(high)
  FROM applestock.historical_stock_price;
-- above result is lower than using with COUNT(*). That's because high column has some nulls.

-- COUNT PRACTICE
-- Write a query to count the number of non-null rows in the low column.
SELECT COUNT(low) AS low  -- add alias to make readibility easier 
  FROM applestock.historical_stock_price
 WHERE low IS NOT NULL
 -- you could also write without IS NOT NULL because SQL as default will include non NULL rows
 
-- Counting non-numerical columns
SELECT COUNT(date) AS count_of_date
  FROM applestock.historical_stock_price
-- in this date column, we stored the column in string data type, not date data type
-- later you will learn how to convert string to date data type and using standardized format for date in SQL

SELECT COUNT(date) AS "Count Of Date"  -- use double quotes for aliases if the word contains space
  FROM applestock.historical_stock_price
  
-- COUNT PRACTICE --
-- Write a query that determines counts of every single column. Which column has the most null values?
SELECT COUNT(date) as count_of_date,
	   COUNT(year) count_of_year,
       COUNT(month) count_of_month,
       COUNT(open) count_of_open,
       COUNT(high) count_of_high,
       COUNT(low) count_of_low,
       COUNT(close) count_of_close,
       COUNT(volume) count_of_volume,
       COUNT(id) count_of_id
 FROM  applestock.historical_stock_price;
 -- run this code to know the answear
 
 
 
 
###-- SUM --###
-- SUM is a SQL aggregate function. that totals the values in a given column.
-- SUM can only used on columns containing numerical values. 
-- SUM treats nulls as 0.
SELECT SUM(volume) AS total_volume
  FROM applestock.historical_stock_price;

-- SUM PRACTICE --
-- Write a query to calculate the average opening price 
-- (hint: you will need to use both COUNT and SUM, as well as some simple arithmetic.)
SELECT SUM(open) AS total_open,
	   COUNT(open) AS count_open,
       SUM(open) / COUNT(open) AS avg_open_price
  FROM applestock.historical_stock_price;
-- OR --
SELECT SUM(open)/COUNT(open) AS avg_open_price
  FROM applestock.historical_stock_price;    
 
 
 
 
###-- MIN & MAX --###
-- MIN and MAX are SQL aggregation functions that return the lowest and highest values in a particular column.
-- MIN & MAX can be used on columns with numerical and text value (non-numerical columns).
-- Depending on the column type, 
-- MIN will return the lowest number, earliest date, or non-numerical value as close alphabetically to "A" as possible.
-- MAX does the opposite
SELECT MIN(volume) AS min_volume,
       MAX(volume) AS max_volume
  FROM applestock.historical_stock_price;

-- MIN PRACTICE --
-- What was Apple's lowest stock price in this dataset ?
SELECT MIN(low) AS lowest_stock_price
  FROM applestock.historical_stock_price;
 
-- MAX PRACTICE -
SELECT MAX(close - open)
  FROM applestock.historical_stock_price;




###-- AVG --### 
-- AVG is a SQL aggregate function that calculates the average of a selected group of values.
-- AVG can only be used on numerical columns. 
-- AVG ignores nulls completely. 
SELECT AVG(high)
  FROM applestock.historical_stock_price
 WHERE high IS NOT NULL
 -- The above query produces the same result as the following query:
SELECT AVG(high)
  FROM applestock.historical_stock_price
  
-- There are some cases in which you'll want to treat null values as 0. 
-- For these cases, you'll want to write a statement that changes the nulls to 0

-- AVG PRACTICE --
SELECT AVG(volume) AS avg_daily_trade_volume
  FROM applestock.historical_stock_price

SELECT month,
       AVG(volume) AS avg_trade_volume
  FROM applestock.historical_stock_price
 GROUP BY month
 ORDER BY 2 DESC
  
  
  
  
###-- GROUP BY --###
-- GROUP BY allows you to separate data into groups, 
-- which can be aggregated independently of one another. 
-- if you want to aggregate only part of a table? For example, 
-- you might want to count the number of entries for each year.
SELECT year,
       COUNT(*) AS count
  FROM applestock.historical_stock_price
 GROUP BY year 
 
 -- You can group by multiple columns, 
 -- but you have to separate column names with commas
SELECT year,
       month,
       COUNT(*) AS count
  FROM applestock.historical_stock_price
 GROUP BY year, month
 
 -- GROUP BY PRACTICE --
 -- Calculate the total number of shares traded each month. 
 -- Order your results chronologically.
 SELECT year,
       month,
       SUM(volume) AS volume_sum
  FROM applestock.historical_stock_price
 GROUP BY year, month
 ORDER BY year, month

-- GROUP BY column numbers
-- you can substitute numbers for column names in the GROUP BY clause
-- generally recommended to do this only when you're grouping many columns, 
-- or if something else is causing the text in the GROUP BY clause to be excessively long
SELECT year,
       month,
       COUNT(*) AS count
  FROM applestock.historical_stock_price
 GROUP BY 1, 2
 
-- Using GROUP BY with ORDER BY --
-- If you want to control how the aggregations are grouped together, use ORDER BY
SELECT year,
       month,
       COUNT(*) AS count
  FROM applestock.historical_stock_price
 GROUP BY year, month
 ORDER BY month, year
 
-- Using GROUP BY with LIMIT --
SELECT year,
       month,
       COUNT(*) AS count
  FROM applestock.historical_stock_price
 GROUP BY year, month
 ORDER BY month, year
 limit 100
 
-- GROUP BY Modifiers WITH ROLLUP --
-- allows you to include extra rows that represent the subtotals, 
-- which are commonly referred to as super-aggregate rows, 
-- along with the grand total row.
SELECT year,
       month,
       COUNT(*) AS count
  FROM applestock.historical_stock_price
 GROUP BY year, month WITH ROLLUP
 
-- GROUP BY PRACTICE --
-- Write a query to calculate the average daily price change in Apple stock, 
-- grouped by year.
SELECT year,
       AVG(close - open) AS avg_daily_change
  FROM applestock.historical_stock_price
 GROUP BY 1
 ORDER BY 1
 
-- GROUP BY PRACTICE -- 
-- Write a query that calculates the lowest and highest prices 
-- that Apple stock achieved each month.
SELECT year,
       month,
       MIN(low) AS lowest_price,
       MAX(high) AS highest_price
  FROM applestock.historical_stock_price
 GROUP BY 1, 2
 ORDER BY 1, 2

 
 
 
###-- HAVING --### 
-- The WHERE clause won't work to filter on aggregate columns
-- that's where the HAVING clause comes in
SELECT year,
       month,
       MAX(high) AS month_high
  FROM applestock.historical_stock_price
 GROUP BY year, month
HAVING MAX(high) > 400
 ORDER BY year, month
-- HAVING is the "clean" way to filter a query that has been aggregated, but this is also commonly done using a subquery




###-- DISTINCT --###
-- using SELECT DISTINCT syntax used to look or to filter
-- at only the unique values in a particular column.
SELECT DISTINCT month
  FROM applestock.historical_stock_price

-- If you include two (or more) columns in a SELECT DISTINCT clause, 
-- your results will contain all of the unique pairs of those two columns:
SELECT DISTINCT year, month
  FROM applestock.historical_stock_price
  
-- Using DISTINCT in aggregations
-- You'll probably use it most commonly with the COUNT function
-- For MAX and MIN, you probably shouldn't ever use DISTINCT 
-- because the results will be the same as without DISTINCT
SELECT COUNT(DISTINCT month) AS unique_months
  FROM applestock.historical_stock_price

-- DISTINCT PRACTICE --
-- Write a query that counts the number of unique values in the month column 
-- for each year.
SELECT year,
       COUNT(DISTINCT month) AS months_count
  FROM applestock.historical_stock_price
 GROUP BY year
 ORDER BY year

-- Write a query that separately counts the number of unique values 
-- in the month column and the number of unique values in the `year` column.
SELECT COUNT(DISTINCT year) AS years_count,
       COUNT(DISTINCT month) AS months_count
  FROM applestock.historical_stock_price
