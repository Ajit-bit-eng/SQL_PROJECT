use sales_project;

-- Exploratory Data Analysis

-- Total Sales by State (Top 5)

SELECT state, ROUND(SUM(total_amount), 2) AS total_sales
FROM sales
GROUP BY state
ORDER BY total_sales DESC
LIMIT 5;

-- Total Quantity Sold by Category

SELECT category, SUM(quantity) AS total_quantity_sold
FROM sales
GROUP BY category;

-- Top 5 Cities by Average Order Value

SELECT city, ROUND(AVG(total_amount), 2) AS avg_order_value
FROM sales
GROUP BY city
ORDER BY avg_order_value DESC
LIMIT 5;

-- Monthly Sales Trend Analysis

SELECT 
  DATE_FORMAT(order_date, '%Y-%m') AS order_month,
  COUNT(order_id) AS num_orders,
  round(SUM(total_amount),2) AS total_sales,
  ROUND(AVG(total_amount), 2) AS avg_order_value
FROM sales
GROUP BY order_month
ORDER BY order_month;

-- Top 10 products by total sales

SELECT 
    product,
    ROUND(SUM(total_amount), 2) AS total_sales
FROM sales
GROUP BY product
ORDER BY total_sales DESC
LIMIT 10;

-- gender based sales analysis

SELECT 
  gender,
  COUNT(*) AS num_orders,
  ROUND(SUM(total_amount), 2) AS total_sales,
  ROUND(AVG(total_amount), 2) AS avg_order_value
FROM sales
GROUP BY gender
ORDER BY total_sales DESC;

-- Most Popular Payment Method per State

SELECT state, payment_method, total_orders
FROM (
    SELECT state, payment_method, COUNT(*) AS total_orders,
           RANK() OVER (PARTITION BY state ORDER BY COUNT(*) DESC)
           AS rnk
    FROM sales
    GROUP BY state, payment_method
) AS ranked_methods
WHERE rnk = 1;

-- customer segmentation by age group

SELECT
  CASE
    WHEN customer_age BETWEEN 18 AND 25 THEN '18-25'
    WHEN customer_age BETWEEN 26 AND 35 THEN '26-35'
    WHEN customer_age BETWEEN 36 AND 45 THEN '36-45'
    WHEN customer_age BETWEEN 46 AND 60 THEN '46-60'
    ELSE '60+'
  END AS age_group,
  COUNT(*) AS num_orders,
  ROUND(SUM(total_amount), 2) AS total_sales
FROM sales
GROUP BY age_group
ORDER BY total_sales DESC;

-- Top-selling product in each state

SELECT state, product, total_sales
FROM (
    SELECT 
        state,
        product,
        ROUND(SUM(total_amount), 2) AS total_sales,
        RANK() OVER (PARTITION BY state ORDER BY SUM(total_amount) DESC) AS rnk
    FROM sales
    GROUP BY state, product
) AS ranked_products
WHERE rnk = 1;

/* Find the top 3 cities with the highest total sales in each
state. */

SELECT state, city, total_sales
FROM (
    SELECT 
        state,
        city,
        round(SUM(total_amount),2) AS total_sales,
        RANK() OVER (PARTITION BY state ORDER BY SUM(total_amount) DESC) AS city_rank
    FROM sales
    GROUP BY state, city
) AS ranked_cities
WHERE city_rank <= 3;

-- State-wise Sales Summary with Post-Aggregation Filtering 

WITH state_sales AS (
  SELECT 
    state,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(total_amount), 2) AS avg_order_value
  FROM sales
  GROUP BY state
)
SELECT *
FROM state_sales
WHERE total_orders > 50
ORDER BY avg_order_value DESC;
