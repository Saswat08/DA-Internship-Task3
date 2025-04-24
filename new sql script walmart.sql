-- Data base creation
create database walmart_sales_data;
use walmart_sales_data;

-- Table Creation
create table sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
    );
  ----------------------------------------------------------------------------------------------------------------------------------------   
 - ----------------------------------------------------- Altering Table------------------------------------------------------------------
    SELECT time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);
-------------------------------------------------------------------------------------------------------------------------------------

SELECT date,
DAYNAME(date) AS day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(20); 
UPDATE sales
SET day_name = DAYNAME(date);
------------------------------------------------------------------------------------------------------------------------------------------

SELECT date,
MONTHNAME(date) AS month_name
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
UPDATE sales
SET month_name = MONTHNAME(date); 
------------------------------------------------------------------------------------------------------------------------------------------
-- What are the unique cities, branch and cities in each branch?

SELECT DISTINCT city
FROM sales;

SELECT DISTINCT branch
FROM sales;

SELECT DISTINCT city, branch
FROM sales;

-- --------------------------------------------------------------------------------------------------------------------------------------
-- How many unique product lines does the data have?
SELECT DISTINCT product_line
FROM sales;


SELECT payment,
COUNT(payment) AS count
FROM sales
GROUP BY payment;

-- What is the most selling product line
SELECT product_line,
SUM(quantity) AS QTY
FROM sales
GROUP BY product_line
ORDER BY quantity DESC;

-- What is the total revenue by month
SELECT month_name,
SUM(total) AS total_revenue
FROM sales
GROUP BY month_name;

-- What month had the largest COGS?
SELECT month_name,
SUM(cogs) AS cost_of_goods_sold
FROM sales
GROUP BY month_name;

-- What product line had the largest revenue?
SELECT product_line, 
SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- What is the city with the largest revenue?
SELECT city, 
SUM(total) AS total_revenue
FROM sales
GROUP BY city
ORDER BY total_revenue DESC;

-- What product line had the largest VAT?
SELECT DISTINCT product_line, 
AVG(tax_pct) AS avg_tax_pct
FROM sales
GROUP BY product_line
ORDER BY tax_pct DESC;

-- Which branch sold more products than average product sold?
SELECT branch, 
SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- What is the most common product line by gender?
SELECT gender, product_line,
COUNT(gender) AS gender_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY COUNT(gender) DESC;

-- What is the average rating of each product line?
SELECT product_line,
ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;
-- -----------------------------------------------------------------------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday?
SELECT time_of_day,
COUNT(total) AS total_sales
FROM sales
WHERE day_name = "Monday"
GROUP BY time_of_day;

-- Which of the customer types brings the most revenue?
SELECT customer_type,
SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total DESC;

-- Which city has the largest tax/VAT percent?
SELECT customer_type,
ROUND(AVG(tax_pct),2) AS VAT
FROM sales
GROUP BY customer_type;


SELECT customer_type,
AVG(total) AS total_revenue
FROM sales
GROUP BY customer_type;

-- What is the gender of most of the customers?
SELECT gender,
COUNT(gender) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- What is the gender distribution per branch?
SELECT branch, gender,
COUNT(gender) AS gender_cnt
FROM sales
GROUP BY branch, gender;

-- Which time of the day do customers give most ratings?
SELECT time_of_day,
AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- View Query
CREATE VIEW PRODUCT_LINE_DATA AS
SELECT product_line, gender, total
FROM sales
WHERE total > 200;

SELECT * FROM PRODUCT_LINE_DATA;


