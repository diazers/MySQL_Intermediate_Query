show variables like "secure_file_priv"  ## put all the .csv files into the path from this query 
show variables like "local_infile"  ## check if local infile has been activated or not, you need to set local_infile ON to be able import the data quickly using LOAD DATA INFILE  


CREATE TABLE companies(
						permalink VARCHAR(100),
                        name VARCHAR(100),
                        homepage_url VARCHAR(100),
                        category_code VARCHAR(100),
                        funding_total_usd INT,
                        status VARCHAR(100),
                        country_code VARCHAR(100),
                        state_code VARCHAR(100),
                        region VARCHAR(100),
                        city VARCHAR(100),
                        funding_rounds INT,
                        founded_at VARCHAR(100),
                        founded_month VARCHAR(100),
                        founded_quarter VARCHAR(100),
                        founded_year INT,
                        first_funding_at VARCHAR(100),
						last_funding_at VARCHAR(100),
                        last_milestone_at VARCHAR(100),
                        id INT
                        );

CREATE TABLE acquisitions(
						company_permalink VARCHAR(100),
                        company_name VARCHAR(100),
                        company_category_code VARCHAR(100),
                        company_country_code VARCHAR(100),
                        company_state_code VARCHAR(100),
                        company_region VARCHAR(100),
                        company_city VARCHAR(100),
                        acquirer_permalink VARCHAR(100),
                        acquirer_name VARCHAR(100),
                        acquirer_category_code VARCHAR(100),
                        acquirer_country_code VARCHAR(100),
                        acquirer_state_code VARCHAR(100),
                        acquirer_region VARCHAR(100),
                        acquirer_city VARCHAR(100),
                        acquired_at VARCHAR(100),
                        acquired_month VARCHAR(100),
						acquired_quarter VARCHAR(100),
                        acquired_year INT,
                        price_amount INT,
                        price_currency_code VARCHAR(100),
                        id INT
                        );

CREATE TABLE investments(
						 company_permalink VARCHAR(100),
						 company_name VARCHAR(100),
                         company_category_code VARCHAR(100),
                         company_country_code VARCHAR(100),
                         company_state_code VARCHAR(100),
						 company_region VARCHAR(100),
                         company_city VARCHAR(100),
                         investor_permalink VARCHAR(100),
                         investor_name VARCHAR(100),
                         investor_category_code VARCHAR(100),
                         investor_country_code VARCHAR(100),
                         investor_state_code VARCHAR(100),
                         investor_region VARCHAR(100),
                         investor_city VARCHAR(100),
                         funding_round_type VARCHAR(100),
                         funded_at VARCHAR(100),
                         funded_month VARCHAR(100),
                         funded_quarter VARCHAR(100),
                         funded_year INT,
                         raised_amount_usd INT,
                         id INT
                         );



LOAD DATA LOCAL INFILE "C:/Program Files/MySQL/MySQL Server 8.0/Uploads/crunchbase_companies.csv" INTO TABLE companies
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "C:/Program Files/MySQL/MySQL Server 8.0/Uploads/crunchbase_acquisitions.csv" INTO TABLE acquisitions
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA LOCAL INFILE "C:/Program Files/MySQL/MySQL Server 8.0/Uploads/crunchbase_investments.csv" INTO TABLE investments
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

SHOW TABLES;
DESCRIBE acquisitions;
DESCRIBE companies;
DESCRIBE investments;

SELECT * FROM crunchbase.companies;

SELECT * FROM crunchbase.acquisitions;

SELECT * FROM crunchbase.investments;

###-- JOIN --###
-- A join is a method of linking data between one (self join) or more tables based on values of the common column between the tables.
-- MySQL supports the following types of joins:
	## Inner join
	## Left join
	## Right join
	## Cross join
	## Self join

-- MySQL hasn’t supported the FULL OUTER JOIN yet

###-- INNER JOIN --###
-- The INNER JOIN matches each row in one table with every row in other tables and allows you to query rows that contain columns from both tables.
-- inner joins eliminate rows from both tables that do not satisfy the join condition set forth in the ON statement. 
-- In mathematical terms, an inner join is the intersection of the two tables.
-- you can write INNER JOIN o just JOIN
-- use aliasing to help you shorten your code

-- company_permalink in this table maps to the permalink field in tutorial.crunchbase_companies
SELECT companies.permalink AS companies_permalink,
       acquisitions.company_permalink AS acquisitions_permalink
  FROM crunchbase.companies companies
 INNER JOIN crunchbase.acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
    
-- INNER JOIN using other operators
SELECT companies.name AS companies_name,
	   companies.funding_total_usd AS companies_funding_total_usd,
       acquisitions.acquirer_name AS acquisitions_acquirer_name,
       acquisitions.price_amount AS acquisitions_price_amount
  FROM crunchbase.companies companies
  JOIN crunchbase.acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink	   
	   AND companies.funding_total_usd > acquisitions.price_amount  #Condition in ON Clause
       AND acquisitions.price_amount != 0						    #Condition in ON Clause
WHERE country_code = 'USA';
-- query of the price of companies that have been acquired by other companies 
-- which the the amount of funding_total is bigger than acquired price
-- For INNER JOIN clause, the condition in the ON clause is equivalent to the condition in the WHERE clause.      





###-- LEFT JOIN --###
SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM crunchbase.companies companies
  JOIN crunchbase.acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink;
    
SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM crunchbase.companies companies
  LEFT JOIN crunchbase.acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink;
    
    
 -- Write a query that performs an inner join between the tutorial.crunchbase_acquisitions 
 -- table and the tutorial.crunchbase_companies table, but instead of listing individual rows, 
 -- count the number of non-null rows in each table.   
SELECT COUNT(companies.permalink) AS companies_rowcount,
       COUNT(acquisitions.company_permalink) AS acquisitions_rowcount
  FROM crunchbase.companies companies
  JOIN crunchbase.acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink    

-- Modify the query above to be a LEFT JOIN. Note the difference in results.    

SELECT COUNT(companies.permalink) AS companies_rowcount,
       COUNT(acquisitions.company_permalink) AS acquisitions_rowcount
  FROM crunchbase.companies companies
  LEFT JOIN crunchbase.acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink  
    
-- Count the number of unique companies (don't double-count companies) and unique acquired companies by state. 
-- Do not include results for which there is no state data, and order by the number of acquired companies from highest to lowest.
SELECT companies.state_code,
       COUNT(DISTINCT companies.permalink) AS unique_companies,
       COUNT(DISTINCT acquisitions.company_permalink) AS unique_companies_acquired
  FROM crunchbase.companies companies
  LEFT JOIN crunchbase.acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
 WHERE companies.state_code IS NOT NULL
 GROUP BY 1
 ORDER BY 3 DESC

-- MySQL LEFT JOIN clause to find unmatched rows
-- The following example uses the LEFT JOIN to find companies who have no funding total price but have acquisitions price
SELECT companies.name AS companies_name,
	   companies.funding_total_usd AS companies_funding_total_usd,
       acquisitions.acquirer_name AS acquisitions_acquirer_name,
       acquisitions.price_amount AS acquisitions_price_amount
  FROM crunchbase.companies companies
  LEFT JOIN crunchbase.acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
 WHERE companies.funding_total_usd = 0
       AND acquisitions.price_amount != 0;
       
-- Condition in WHERE clause vs ON clause
-- See the following example
SELECT companies.name AS companies_name,
	   companies.funding_total_usd AS companies_funding_total_usd,
       acquisitions.acquirer_name AS acquisitions_acquirer_name,
       acquisitions.price_amount AS acquisitions_price_amount
  FROM crunchbase.companies companies
  LEFT JOIN crunchbase.acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
 WHERE companies.funding_total_usd = 1000000
 -- in this query, it only returns companies funding total with value of 1000000 
 -- other than that value will not be shown in the query result
 -- you will notice that the filter happens after the tables are joined.

-- In this case, the query returns all rows with 1000000 value 
-- but only the companies with the total funding 1000000 will have line items associated with it
SELECT companies.name AS companies_name,
	   companies.funding_total_usd AS companies_funding_total_usd,
       acquisitions.acquirer_name AS acquisitions_acquirer_name,
       acquisitions.price_amount AS acquisitions_price_amount
  FROM crunchbase.companies companies
  LEFT JOIN crunchbase.acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
       AND companies.funding_total_usd = 1000000
-- What's happening above is that the conditional statement AND... is evaluated before the join 
-- occurs. You can think of it as a WHERE clause that only applies to one of the tables.

-- Oher Example WHERE clause vs. ON clause
-- conditional or filtering in ON clause
SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM crunchbase.companies companies
  LEFT JOIN crunchbase.acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
   AND acquisitions.company_permalink != '/company/1000memories'
 ORDER BY 1
 
-- conditional or filtering in WHERE clause
SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM crunchbase.companies companies
  LEFT JOIN crunchbase.acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
 WHERE acquisitions.company_permalink != '/company/1000memories'
    OR acquisitions.company_permalink IS NULL
 ORDER BY 1

-- Write a query that shows a company's name, "status" (found in the Companies table), 
-- and the number of unique investors in that company. Order by the number of investors from most to fewest. 
-- Limit to only companies in the state of New York.
SELECT companies.name AS company_name,
       companies.status,
       COUNT(DISTINCT investments.investor_name) AS unqiue_investors
  FROM crunchbase.companies companies
  LEFT JOIN crunchbase.investments investments
    ON companies.permalink = investments.company_permalink
 WHERE companies.state_code = 'NY'
 GROUP BY 1,2
 ORDER BY 3 DESC

-- Write a query that lists investors based on the number of companies in 
-- which they are invested. Include a row for companies with no investor, 
-- and order from most companies to least.
SELECT CASE WHEN investments.investor_name IS NULL THEN 'No Investors'
            ELSE investments.investor_name END AS investor,
       COUNT(DISTINCT companies.permalink) AS companies_invested_in
  FROM crunchbase.companies companies
  LEFT JOIN crunchbase.investments investments
    ON companies.permalink = investments.company_permalink
 GROUP BY 1
 ORDER BY 2 DESC
 
 
-- Using comparison operators with joins
-- you can enter any type of conditional statement into the ON clause. 
-- Here's an example using > to join only investments that occurred more than 5 years after each company's founding year:
-- you can enter any type of conditional statement into the ON clause. Here's an example using > to join only investments that occurred 
-- more than 5 years after each company's founding year:
SELECT companies.permalink,
       companies.name,
       companies.status,
       COUNT(investments.investor_permalink) AS investors
  FROM crunchbase.companies companies
  LEFT JOIN crunchbase.acquisitions acquisitions
    ON companies.permalink = investments.company_permalink
   AND investments.funded_year > companies.founded_year + 5
 GROUP BY 1,2, 3

 
 
###-- RIGHT JOIN --###
-- MySQL RIGHT JOIN is similar to LEFT JOIN, except that the treatment of the joined tables is reversed.
-- they return all rows from the table in the RIGHT JOIN clause and only matching rows from the table in the FROM clause.
-- RIGHT JOIN is rarely used because you can achieve the results of a RIGHT JOIN 
-- by simply switching the two joined table names in a LEFT JOIN.

-- This query
SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM crunchbase.companies companies
  LEFT JOIN crunchbase.acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink

-- produces the same results as this query:
SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM crunchbase.acquisitions acquisitions
 RIGHT JOIN crunchbase.companies companies
    ON companies.permalink = acquisitions.company_permalink

-- another example from previos left join turn into right join    
SELECT companies.state_code,
       COUNT(DISTINCT companies.permalink) AS unique_companies,
       COUNT(DISTINCT acquisitions.company_permalink) AS acquired_companies
  FROM crunchbase.acquisitions acquisitions
 RIGHT JOIN crunchbase.companies companies
    ON companies.permalink = acquisitions.company_permalink
 WHERE companies.state_code IS NOT NULL
 GROUP BY 1
 ORDER BY 3 DESC



 
###-- SELF JOIN --###
-- To perform a self join, you must use table aliases to not repeat the same table name twice in a single query.
-- referencing a table twice or more in a query without using table aliases will cause an error.
-- you can perform SELF JOIN using INNER JOIN, LEFT KOIN, and RIGHT JOIN 
 SELECT DISTINCT japan_investments.company_name,
       japan_investments.company_permalink
  FROM crunchbase.investments japan_investments
  JOIN crunchbase.investments gb_investments
    ON japan_investments.company_name = gb_investments.company_name
   AND gb_investments.investor_country_code = 'GBR'
   AND gb_investments.funded_at > japan_investments.funded_at
 WHERE japan_investments.investor_country_code = 'JPN'
 ORDER BY 1
 -- Note how the same table can easily be referenced multiple times using different aliases
 -- in this case, japan_investments and gb_investments.
 