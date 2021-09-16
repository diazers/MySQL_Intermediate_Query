SELECT * FROM fifa_20.players_data;

###-- CASE --###
-- The CASE statement is SQL's way of handling if/then logic
-- The CASE statement is followed by at least one pair of WHEN and THEN statements --
-- Every CASE statement must end with the END statement
-- The ELSE statement is optional, and provides a way to capture values not specified in the WHEN/THEN statements
SELECT short_name,
       club_name,
       CASE WHEN age  = 33 THEN "YES"
            ELSE NULL END AS 'is_33_years_old'
  FROM fifa_20.players_data;
-- this query returns players with the age of 33 years old

-- The CASE statement checks each row to see if the conditional statement—age = 33 is true.
-- For any given row, if that conditional statement is true, the word "YES" gets printed in the column that we have named 'is_33_years_old'.
-- In any row for which the conditional statement is false, nothing happens in that row, leaving a null value in the is_a_senior column.
-- At the same time all this is happening, SQL is retrieving and displaying all the values in the player_name and year columns.

-- if you don't want null values in the is_a_senior column? The following query replaces those nulls with "no":
SELECT short_name,
       club_name,
       CASE WHEN age  = 33 THEN "YES"
            ELSE "NO" END AS 'is_33_years_old'
  FROM fifa_20.players_data;

-- You can also define a number of outcomes in a CASE statement by including as many WHEN/THEN statements as you'd like:
SELECT short_name,
       weight_kg,
       CASE WHEN weight_kg > 100 THEN 'over 100'
            WHEN weight_kg >=75 THEN '75-100'
            WHEN weight_kg >= 50 THEN '50-74'
            ELSE 'below 50' END AS weight_group
  FROM fifa_20.players_data;
  
-- you could also write above query like the following query to avoid overlapping
SELECT short_name,
       weight_kg,
       CASE WHEN weight_kg > 100 THEN 'over 100'
            WHEN weight_kg >=75 AND weight_kg <= 100 THEN '75-100'
            WHEN weight_kg >= 50 AND weight_kg <= 74 THEN '50-74'
            ELSE 'below 50' END AS weight_group
  FROM fifa_20.players_data;
  
-- The CASE statement always goes in the SELECT clause
-- CASE must include the following components: WHEN, THEN, and END. ELSE is an optional component.
-- You can make any conditional statement using any conditional operator (like WHERE ) between WHEN and THEN. This includes stringing together multiple conditional statements using AND and OR.
-- You can include multiple WHEN statements, as well as an ELSE statement to deal with any unaddressed conditions.

-- Using CASE with aggregate functions --
SELECT COUNT(1) AS numbers_of_player_in_FC_Barcelona
  FROM fifa_20.players_data
 WHERE club_name = 'FC Barcelona'
 -- Using the WHERE clause only allows you to count one condition
 
 
 SELECT CASE WHEN team_position = 'GK' THEN 'Goal_Keeper'
            ELSE 'Not Goal Keeper' END AS year_group,
            COUNT(1) AS count
  FROM fifa_20.players_data
 GROUP BY CASE WHEN team_position = 'GK' THEN 'Goal_Keeper'
               ELSE 'Not Goal Keeper' END
-- Since COUNT ignores nulls, you could use a CASE statement to evaluate the condition and produce null or non-null values 
-- depending on the outcome


-- Here's an example of counting multiple conditions in one query:
SELECT CASE WHEN nationality = 'England' THEN 'England'
            WHEN nationality = 'France' THEN 'France'
            WHEN nationality = 'Germany' THEN 'Germany'
            WHEN nationality = 'Netherlands' THEN 'Netherlands'
            ELSE 'other countries' END AS year_group,
            COUNT(1) AS count
  FROM fifa_20.players_data
 GROUP BY 1  -- use the index number of your column instead of writing all the case when statements to grouping your column by column 1
 ORDER BY 2
 
 -- TIPS --
 -- Combining CASE statements with aggregations can be tricky at first. 
 -- It's often helpful to write a query containing the CASE statement first and all columns to overview what you need to aggregate
 SELECT CASE WHEN nationality = 'England' THEN 'England'
            WHEN nationality = 'France' THEN 'France'
            WHEN nationality = 'Germany' THEN 'Germany'
            WHEN nationality = 'Netherlands' THEN 'Netherlands'
            ELSE 'other countries' END AS year_group,
            *
  FROM fifa_20.players_data
-- From there, you can replace the * with an aggregation and add a GROUP BY clause. 

-- Pivoting --
-- In the previous examples, data was displayed vertically, 
-- but in some instances, you might want to show data horizontally. This is known as "pivoting" (like a pivot table in Excel).
 SELECT CASE WHEN nationality = 'England' THEN 'England'
            WHEN nationality = 'France' THEN 'France'
            WHEN nationality = 'Germany' THEN 'Germany'
            WHEN nationality = 'Netherlands' THEN 'Netherlands'
            ELSE 'other countries' END AS year_group,
            COUNT(1) AS count
  FROM fifa_20.players_data
  GROUP BY 1

-- And re-orient it horizontally:
 SELECT COUNT(CASE WHEN nationality = 'England' THEN 1 ELSE NULL END) AS 'England_Count',
        COUNT(CASE WHEN nationality = 'France' THEN 1 ELSE NULL END) AS 'France_Count',
        COUNT(CASE WHEN nationality = 'Germany' THEN 1 ELSE NULL END) AS 'Germany_Count',
		COUNT(CASE WHEN nationality = 'Netherlands' THEN 1 ELSE NULL END) AS 'Netherlands_Count'
  FROM fifa_20.players_data

-- IF --
-- IF function is one of control flow functions that returns a value based on a condition. 
-- The IF function is sometimes referred to as IF ELSE or IF THEN ELSE function.

SELECT IF(1 = 1,' true','false'); -- true
SELECT IF(1 = 2,'true','false'); -- false

-- IF function with aggregate functions
SELECT 
    SUM(IF(nationality = 'Argentina', 1, 0)) AS Argentina_total_player,
    SUM(IF(nationality = 'Spain', 1, 0)) AS Spain_total_player
FROM
    fifa_20.players_data
-- you can use other agregate function
-- you could also displaying N/A or other value instead of NULL using IF function




-- PRACTICE --
## 1
## Write a query that includes a column that is flagged "yes" when a player is from England,
## and sort the results with those players first.

-- 2
-- Write a query that includes players' names and a column that classifies them into four categories based on wage. 

## 3
## Write a query that selects all columns from fifa_20.players_data and adds an additional column 
## that displays the player's team jersey number if that player's number is 1, 5, and 10.

-- 4
-- Write a query that count the players with the height 180cm from 4 major league from europe 

## 5
## Write a query that calculates the average weight of all forward position (RF, LF, CF, ST) in spain League
## as well as the average weight of all forward position in england league

-- 6
-- Write a query that displays the number of players in each state, with FR, SO, JR, and SR players 
-- in separate columns and another column for the total number of players. 
-- Order results such that states with the most players come first.

## 7
## Write a query that shows the number of player names that start with A through M, 
## and names starting with N - Z.

-- ANSWER 1 --
SELECT short_name,
	   nationality,
  CASE WHEN nationality = 'England' Then 'YES'
	   ELSE NULL END AS 'is_from_England'
  FROM fifa_20.players_data
ORDER BY 3 DESC;

-- ANSWER 2 --
SELECT DISTINCT wage_eur
  FROM fifa_20.players_data
 ORDER BY 1
-- run this to know all the unique numbers to help you make wage range

SELECT short_name,
		CASE WHEN wage_eur <  10000 THEN 'BELOW 10000'
					WHEN wage_eur >= 10000 AND wage_eur <= 50000 THEN 'BETWEEN 10.000 AND 50.000'
					WHEN wage_eur >= 50001 AND wage_eur <= 100000 THEN 'BETWEEN 50.000 AND 100.000'
					WHEN wage_eur >= 100001 AND wage_eur <= 150000 THEN 'BETWEEN 100.000 AND 150.000'
					WHEN wage_eur >= 150001 AND wage_eur <= 200000 THEN 'BETWEEN 150.000 AND 200.000'
					WHEN wage_eur >= 200001 AND wage_eur <= 300000 THEN 'BETWEEN 200.000 AND 300.000'
					ELSE 'ABOVE 300.000' END AS wage_classification
	   FROM fifa_20.players_data;
-- this is just one of many ways to classify, you could divide player's wage in many ways

-- ANSWER 3 --
SELECT *,
       CASE WHEN team_jersey_number IN (1, 5, 10) THEN short_name ELSE NULL END AS 'players with number 1, 5, and 10'
  FROM fifa_20.players_data;
  
-- ANSWER 4 --
SELECT CASE WHEN league_name = 'English Premier League' THEN 'English Premier League'
            WHEN league_name = 'Spain Primera Division' THEN 'Spain Primera Division'
            WHEN league_name = 'German 1. Bundesliga' THEN 'German 1. Bundesliga'
            ELSE 'other ligue 1' END AS League_name,
            COUNT(1) AS players
  FROM fifa_20.players_data
 WHERE height_cm >= 180
GROUP BY 1
 
 SELECT CASE WHEN league_name IN ('English Premier League', 'Spain Primera Division', 'German 1. Bundesliga') THEN 'english_spain_german_league'
            ELSE 'Other' END AS 'Major Europe League',
            COUNT(1) AS players
  FROM fifa_20.players_data
 WHERE height_cm >= 180
  GROUP BY 1
  
 -- ANSWER 5 --
 SELECT CASE WHEN league_name = 'English Premier League' AND team_position IN ('RF', 'LF', 'CF', 'ST') THEN 'England'
             WHEN league_name = 'Spain Primera Division' AND team_position IN ('RF', 'LF', 'CF', 'ST') THEN 'Spain'
             ELSE 'Other' END AS Country,
             AVG(height_cm) AS AVG_FORWARD_POSITION
  FROM fifa_20.players_data
 GROUP BY 1
 
 SELECT AVG(height_cm) AS 'AVG_SPAIN_FORWARD_POSITION_HEIGHT'
 FROM fifa_20.players_data
 WHERE league_name = 'Spain Primera Division' AND team_position IN ('RF', 'LF', 'CF', 'ST')
-- this quey let you know if previous query number is right, you could check one by one, just change the parameter
 
-- ANSWER 6 --
SELECT nationality,
       COUNT(CASE WHEN team_position = 'RF' THEN 1 ELSE NULL END) AS Right_Forward_count,
       COUNT(CASE WHEN team_position = 'LF' THEN 1 ELSE NULL END) AS Left_Forward_count,
       COUNT(CASE WHEN team_position = 'CF' THEN 1 ELSE NULL END) AS Center_Forward_count,
       COUNT(CASE WHEN team_position = 'ST' THEN 1 ELSE NULL END) AS Striker_count,
       COUNT(1) AS total_players
  FROM fifa_20.players_data
 GROUP BY 1
 ORDER BY total_players DESC

-- ANSWER 7 -- 
SELECT CASE WHEN short_name < 'n' THEN 'A-M'
            WHEN short_name >= 'n' THEN 'N-Z'
            ELSE NULL END AS player_name_group,
       COUNT(1) AS players
  FROM fifa_20.players_data
 GROUP BY 1