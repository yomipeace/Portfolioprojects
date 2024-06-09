CREATE DATABASE IF NOT EXISTS WalmartSales; 

CREATE TABLE IF NOT EXISTS Sales(
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

SHOW COLUMNS FROM sales;

SELECT * FROM walmartsales.sales;

-- --------------------------------------------------------------------------------------------
-- ---------------------------Feature Enginerring ---------------------------------------------

-- ----- TIME_OF_DAY --------
SELECT 
	time,
    (CASE
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening"
    END
    ) as time_of_date
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales SET time_of_day = 
	(CASE
		WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
		ELSE "Evening"
    END);
    
    
-- ------ day_name ------

SELECT 
	date,
    DAYNAME(date) as day_name
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales SET day_name = DAYNAME(date);


-- ------- month_name ------

SELECT 
	date,
    MONTHNAME(date) as day_name
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales SET month_name = MONTHNAME(date);
-- --------------------------------------------------------------------------------------------

-- --------------------------------------------------------------------------------------------
-- ------------------------------ general questions for EDA -----------------------------------

-- How many unique cities does the data have?
SELECT 
    DISTINCT city
FROM sales;

-- In which cities are the branches located?
SELECT
	DISTINCT city,
    branch
FROM sales
ORDER BY branch;

-- --------------------------------------------------------------------------------------------
-- ------------------------------ product questions for EDA -----------------------------------

-- How many unique product lines does the data have?
SELECT
	COUNT(DISTINCT product_line)
FROM sales;


-- What is the most common payment method?
SELECT
	payment,
    COUNT(payment) as payment_cnt
FROM sales
GROUP BY payment
ORDER BY payment_cnt DESC;


-- What is the most selling product line?
SELECT
	product_line,
    COUNT(product_line) as product_cnt
FROM sales
GROUP BY product_line
ORDER BY product_cnt DESC;


-- What is the total revenue by month?
SELECT
	month_name,
    SUM(total) as total_rev
FROM sales
GROUP BY month_name
ORDER BY total_rev DESC;


-- What month had the largest COGS?
SELECT
	month_name as months,
    SUM(cogs) as cogs_sum
FROM sales
GROUP BY months
ORDER BY cogs_sum DESC;


-- What product line had the largest revenue?
SELECT
	product_line,
    SUM(total) as revenue
FROM sales
GROUP BY product_line
ORDER BY revenue DESC;


-- What is the city with the largest revenue?
SELECT
	city,
    branch,
    SUM(total) as revenue
FROM sales
GROUP BY city, branch
ORDER BY revenue DESC;


-- What product line had the largest VAT (Value Added Tax)?   -> AVG of PCT for comparing proportions
SELECT 
	product_line,
    AVG(tax_pct) as avg_VAT
FROM sales
GROUP BY product_line
ORDER BY avg_VAT DESC;


-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales


-- Which branch sold more products than average product sold?
SELECT
	branch,
    SUM(quantity) as qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);


-- What is the most common product line by gender?
SELECT
	gender,
    product_line,
    count(gender) as cnt_gender
FROM sales
GROUP BY gender, product_line
ORDER BY cnt_gender DESC;


-- What is the average rating of each product line?
SELECT
	product_line,
    ROUND(AVG(rating),2) as avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;


-- --------------------------------------------------------------------------------------
-- ---------------------------------- Sales Questions -----------------------------------
 
-- Number of sales made in each time of the day per weekday

SELECT 
  day_name,
  time_of_day,
  COUNT(*) AS number_of_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY day_name, time_of_day
ORDER BY number_of_sales;
-- ----------or?! -----------
SELECT day_name, time_of_day, COUNT(*) AS number_of_sales
FROM sales
WHERE day_name = "Saturday"
GROUP BY day_name, time_of_day
UNION ALL
SELECT day_name, time_of_day, COUNT(*) AS number_of_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY day_name, time_of_day
UNION ALL
SELECT day_name, time_of_day, COUNT(*) AS number_of_sales
FROM sales
WHERE day_name = "Monday"
GROUP BY day_name, time_of_day
UNION ALL
SELECT day_name, time_of_day, COUNT(*) AS number_of_sales
FROM sales
WHERE day_name = "Tuesday"
GROUP BY day_name, time_of_day
UNION ALL
SELECT day_name, time_of_day, COUNT(*) AS number_of_sales
FROM sales
WHERE day_name = "Wednesday"
GROUP BY day_name, time_of_day
UNION ALL
SELECT day_name, time_of_day, COUNT(*) AS number_of_sales
FROM sales
WHERE day_name = "Thursday"
GROUP BY day_name, time_of_day
UNION ALL 
SELECT day_name, time_of_day, COUNT(*) AS number_of_sales
FROM sales
WHERE day_name = "Friday"
GROUP BY day_name, time_of_day
ORDER BY day_name, time_of_day;


-- Which of the customer types brings the most revenue?
SELECT
	customer_type,
    SUM(total) as revenue
FROM sales
GROUP BY customer_type
ORDER BY revenue DESC;


-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT
	city,
    AVG(tax_pct) as largest_VAT
FROM sales
GROUP BY city
ORDER BY largest_VAT DESC;


-- Which customer type pays the most in VAT?
SELECT
	customer_type,
    AVG(tax_pct) as largest_VAT
FROM sales
GROUP BY customer_type
ORDER BY largest_VAT DESC;


-- -----------------------------------------------------------------------------
-- -----------------------Customer questtions ----------------------------------

-- How many unique customer types does the data have?    -> 2 types: Member, Normal  
SELECT DISTINCT customer_type
FROM sales;

-- How many unique payment methods does the data have?    -> 3 methods: credit, Ewallet, Cash
SELECT DISTINCT payment
FROM sales;

-- What is the most common customer type?   -> Member customers
SELECT 
	customer_type,
    COUNT(customer_type) as cust_cnt
FROM sales
GROUP BY customer_type
ORDER BY cust_cnt DESC;

-- Which customer type buys the most?   -> Normal type
SELECT 
	customer_type,
    COUNT(*) as cust_cnt
FROM sales
GROUP BY customer_type;


-- What is the gender of most of the customers?
SELECT 
	gender,
    COUNT(*) as cnt
FROM sales
GROUP BY gender
ORDER BY cnt DESC;

-- What is the gender distribution per branch?
SELECT 
	branch,
    gender,
    COUNT(*) as cnt
FROM sales
GROUP BY branch, gender
ORDER BY branch ASC;

-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
    AVG(rating) as rating_avg
FROM sales
GROUP BY time_of_day
ORDER BY rating_avg DESC;


-- Which time of the day do customers give most ratings per branch?
SELECT
	branch,
    time_of_day,
    AVG(rating) as rating_avg
FROM sales
GROUP BY branch,time_of_day
ORDER BY branch ASC, rating_avg DESC;


-- Which day of the week has the best avg ratings?
SELECT
	day_name,
    AVG(rating) as rating_avg
FROM sales
GROUP BY day_name
ORDER BY rating_avg DESC;


-- Which day of the week has the best average ratings per branch?
SELECT
	branch,
    day_name,
    AVG(rating) as rating_avg
FROM sales
GROUP BY branch, day_name
ORDER BY branch ASC,rating_avg DESC;
