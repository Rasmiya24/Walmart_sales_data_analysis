CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2)
);

-- Data Cleaning
SELECT * 
FROM sales;

-- Add a new column 'time_of_day' to the 'sales' table
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20)

-- Update the 'sales' table with the 'time_of_day'
UPDATE sales
SET time_of_day = (
	CASE 
	WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
	WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
	ELSE 'Evening'
	END)

-- Extract the day of the week from the 'date' column
SELECT EXTRACT(DOW FROM date) AS day_name
FROM sales;

-- Add a new column 'day_name' to the 'sales' table
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

-- Update the 'day_name' column with the day of the week
UPDATE sales
SET day_name = TO_CHAR(date, 'DAY');

-- Extract the 'month_name' from the 'date' column
SELECT EXTRACT(MONTH FROM date) AS month_name
FROM sales;

-- Add a new column 'month_name' to the 'sales' table
ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

-- Update the 'month_name' column with the month
UPDATE sales
SET month_name = TO_CHAR(date, 'MONTH');

-----------------***********------------------

-- How many unique cities does the data have?
SELECT DISTINCT city
FROM sales;

-- In which city is each branch?
SELECT DISTINCT city, branch
FROM sales;

-- How many unique product lines does the data have?
SELECT COUNT(DISTINCT product_line)
FROM sales;

-- Which is the most common payment method?
SELECT payment, COUNT(payment) AS payment_count
FROM sales
GROUP BY payment
ORDER BY payment_count DESC;

-- Which is the most selling product line?
SELECT product_line, COUNT(product_line) AS count_pl
FROM sales
GROUP BY product_line
ORDER BY count_pl DESC;

-- What is the total revenue by month?
SELECT month_name AS month, SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- Which month had the largest COGS?
SELECT month_name AS month, SUM(cogs) AS sum_cogs
FROM sales
GROUP BY month_name
ORDER BY sum_cogs DESC;

-- Which product line had the largest revenue?
SELECT product_line, SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- Which is the city with the largest revenue?
SELECT city, branch, SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch
ORDER BY total_revenue DESC;

-- Which product line had the largest VAT?
SELECT product_line, AVG(tax_pct) AS avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;
	
-- Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT SUM(quantity) / COUNT(DISTINCT branch) FROM sales);
	
-- What is the most common product line by gender?
SELECT gender, product_line, COUNT(*) AS total_count
FROM sales
GROUP BY gender, product_line
HAVING COUNT(*) = (
  SELECT MAX(total_count)
  FROM (
    SELECT gender, product_line, COUNT(*) AS total_count
    FROM sales
    GROUP BY gender, product_line
  ) AS subquery
  WHERE gender = sales.gender
)

-- What is the average rating of each product line?
SELECT product_line, AVG(rating) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

------------------****************-------------------

-- Number of sales made in each time of the day per weekday
SELECT day_name, time_of_day, COUNT(*) as total_sales
FROM sales
GROUP BY day_name, time_of_day
ORDER BY day_name, total_sales DESC;

-- Which of the customer types brings the most revenue?
SELECT customer_type, SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- Which city has the largest tax percent/ VAT (**Value Added Tax**)?
SELECT city, AVG(tax_pct) AS avg_tax_pct
FROM sales
GROUP BY city
ORDER BY avg_tax_pct DESC
LIMIT 1;

-- Which customer type pays the most in VAT?
SELECT customer_type, SUM(total * tax_pct / 100) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax DESC;

--------------------********************----------------

-- How many unique customer types does the data have?
SELECT COUNT(DISTINCT customer_type)
FROM sales;

-- How many unique payment methods does the data have?
SELECT COUNT(DISTINCT payment)
FROM sales;

-- What is the most common customer type?
SELECT customer_type, COUNT(*) AS count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;

-- Which customer type buys the most?
SELECT customer_type, COUNT(*) AS purchase_count
FROM sales
GROUP BY customer_type
ORDER BY purchase_count DESC;

-- What is the gender of most of the customers?
SELECT gender, COUNT(*) AS gender_count
FROM sales
GROUP BY gender
ORDER BY gender_count DESC;

-- What is the gender distribution per branch?
SELECT branch, gender, COUNT(*) AS gender_count
FROM sales
GROUP BY branch, gender
ORDER BY branch, gender_count DESC;

-- Which time of the day do customers give most ratings?
SELECT time_of_day, COUNT(rating) AS num_rating
FROM sales
GROUP BY time_of_day
ORDER BY num_rating DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT s.branch, s.time_of_day, s.num_rating
FROM (
SELECT branch, time_of_day, COUNT(rating) AS num_rating
FROM sales
GROUP BY branch, time_of_day
) AS s
JOIN (
SELECT branch, MAX(num_rating) AS max_num_rating
FROM (
SELECT branch, time_of_day, COUNT(rating) AS num_rating
FROM sales
GROUP BY branch, time_of_day
  ) AS subquery
GROUP BY branch
) AS m
ON s.branch = m.branch AND s.num_rating = m.max_num_rating;

-- Which day of the week has the best avg ratings?
SELECT day_name, AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings per branch?
SELECT s.branch, s.day_name, s.avg_rating
FROM (
  SELECT branch, day_name, AVG(rating) AS avg_rating,
         RANK() OVER (PARTITION BY branch ORDER BY AVG(rating) DESC) AS rank
  FROM sales
  GROUP BY branch, day_name
) AS s
WHERE s.rank = 1;