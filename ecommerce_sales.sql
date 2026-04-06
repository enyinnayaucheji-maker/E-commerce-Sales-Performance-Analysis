
SELECT *
FROM `alien-device-410108.ecommerce.ecommerce_sales`
LIMIT 20

SELECT 
  TRIM(`Customer ID`) AS customer_id,
  TRIM(Gender) AS gender,
  CAST(Age AS INT64) AS age,
  TRIM(Region) AS region,
  DATE(`Order Date`) AS order_date,
  TRIM(`Product Name`) AS product_name,
  TRIM(Category) AS category,
  CAST(`Unit Price` AS NUMERIC) AS unit_price,
  CAST(Quantity AS INT64) AS quantity,
  CAST(`Total Price` AS NUMERIC) AS total_price,
  CAST(`Shipping Fee` AS NUMERIC) AS shipping_fee,
  TRIM(`Shipping Status`) AS shipping_status
FROM `alien-device-410108.ecommerce.ecommerce_sales`

SELECT *
FROM `alien-device-410108.ecommerce.ecommerce_sales`
WHERE TRIM(`Customer ID`) IS NOT NULL
LIMIT 20

CREATE OR REPLACE TABLE `alien-device-410108.ecommerce.ecommerce_sales_clean` AS
SELECT DISTINCT
  TRIM(`Customer ID`) AS customer_id,
  TRIM(Gender) AS gender,
  SAFE_CAST(Age AS INT64) AS age,
  TRIM(Region) AS region,
  DATE(`Order Date`) AS order_date,
  TRIM(`Product Name`) AS product_name,
  TRIM(Category) AS category,
  SAFE_CAST(`Unit Price` AS NUMERIC) AS unit_price,
  SAFE_CAST(Quantity AS INT64) AS quantity,
  SAFE_CAST(`Total Price` AS NUMERIC) AS total_price,
  SAFE_CAST(`Shipping Fee` AS NUMERIC) AS shipping_fee,
  TRIM(`Shipping Status`) AS shipping_status
FROM `alien-device-410108.ecommerce.ecommerce_sales`
WHERE TRIM(`Customer ID`) IS NOT NULL;

SELECT *
FROM `alien-device-410108.ecommerce.ecommerce_sales_clean`
LIMIT 20

-- total revenue & total quantity
SELECT
  SUM(total_price) AS total_revenue,
  SUM(quantity) AS total_units_sold
FROM `alien-device-410108.ecommerce.ecommerce_sales_clean`

-- Revenue by category
SELECT
category,
SUM(total_price) AS revenue
FROM `alien-device-410108.ecommerce.ecommerce_sales_clean`
GROUP BY category
ORDER BY revenue DESC

-- revenue by region
SELECT
  region,
  SUM(total_price) AS revenue
FROM `alien-device-410108.ecommerce.ecommerce_sales_clean`
GROUP BY region
ORDER BY revenue DESC

-- montly sales trend
SELECT
  DATE_TRUNC(order_date, MONTH) AS month,
  SUM(total_price) AS revenue
FROM `alien-device-410108.ecommerce.ecommerce_sales_clean`
WHERE order_date IS NOT NULL
GROUP BY month
ORDER BY month

-- top 10 prducts
SELECT
  product_name,
  SUM(total_price) AS revenue
FROM `alien-device-410108.ecommerce.ecommerce_sales_clean`
GROUP BY product_name
ORDER BY revenue DESC
LIMIT 10

SELECT
  customer_id,
  SUM(total_price) AS total_spent
FROM `alien-device-410108.ecommerce.ecommerce_sales_clean`
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10

SELECT
  shipping_status,
  COUNT(*) AS number_of_orders
FROM `alien-device-410108.ecommerce.ecommerce_sales_clean`
GROUP BY shipping_status
ORDER BY number_of_orders DESC