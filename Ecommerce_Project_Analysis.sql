USE cosmetics_ecommerce;

-- Rename tables to shorter names
RENAME TABLE
    cosmetics_orders TO orders,
    cosmetics_order_items TO order_items,
    cosmetics_products TO products,
    cosmetics_locations TO locations;
    
-- Step 1: Check renamed tables
SHOW TABLES;

-- Step 2: View sample records

SELECT * FROM customers LIMIT 10;

SELECT * FROM orders LIMIT 10;

SELECT * FROM order_items LIMIT 10;

SELECT * FROM products LIMIT 10;

SELECT * FROM locations LIMIT 10;

-- Step 3: Count records

SELECT COUNT(*) AS total_customers FROM customers;

SELECT COUNT(*) AS total_orders FROM orders;

SELECT COUNT(*) AS total_order_items FROM order_items;

SELECT COUNT(*) AS total_products FROM products;

SELECT COUNT(*) AS total_locations FROM locations;

-- Questions
-- Beginner --> Counts and summaries
-- 1: Total number of orders
SELECT COUNT(*) AS total_orders
FROM orders;


--  2: Count unique customers who placed orders
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM orders;


--  3: Calculate average order value
SELECT AVG(total_amount) AS average_order_value
FROM orders;

-- 4 : What is the average order value?
SELECT ROUND(AVG(total_amount), 2) AS average_order_value
FROM orders;

-- 5 : How many orders are there for each order status?
select status,count(status) as order_count from orders
group by status
order by order_count desc;

-- 6 : How many customers are there in each gender group?
select gender,count(*) as total_count from customers
group by gender
order by total_count desc;

-- 7 : What are the five most expensive products?
select product_name,price from products
order by price desc
limit 5;

-- 8 : What are the minimum, maximum, and average product prices?
SELECT MIN(price) AS minimum_price,
       MAX(price) AS maximum_price,
       ROUND(AVG(price), 2) AS average_price
FROM products;

-- Intermediate --> Grouping and joins

-- 9 : How many products are listed in each category?
select category,count(*) as total_products
from products
group by category
order by total_products desc;

-- 10 : Which 10 customers have spent the most?
select c.customer_id,c.customer_name as name,sum(o.total_amount) as amount
from customers c join orders o
on c.customer_id=o.customer_id
group by c.customer_name,c.customer_id
order by amount desc
limit 10;

-- 11 : Which customers have placed the most orders?
SELECT c.customer_id, c.customer_name,
       COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY order_count DESC
LIMIT 10;

-- 12 : What is the total revenue by customer gender?
select c.gender,sum(o.total_amount) as revenue from customers c 
join orders o on c.customer_id=o.customer_id
group by c.gender
order by revenue desc;

-- 13 : Which cities generate the most order revenue?
select c.city,sum(o.total_amount) as city_revenue from customers c
join orders o on c.customer_id=o.customer_id
group by c.city
order by city_revenue desc;

-- 14 : What is the average order value for each status?
select status,round(avg(total_amount), 2) as avg_value from orders
group by status
order by avg_value desc;

-- 15 : How many units of each product were ordered?
select p.product_id,p.product_name,sum(oi.quantity) as total_quantity from products p
join order_items oi on p.product_id=oi.product_id
group by p.product_id,p.product_name
order by total_quantity desc;

-- 16 : Which products generated the most item-level sales value?
select p.product_id,p.product_name,
sum(oi.quantity*oi.unit_price) as sales_value
from products p join order_items oi on
p.product_id=oi.product_id
group by p.product_id,p.product_name
order by sales_value desc;

-- 17 : What is the total item quantity in each order?
SELECT order_id, SUM(quantity) AS total_items
FROM order_items
GROUP BY order_id
ORDER BY total_items DESC;

-- 18 : Which orders contain more than three units in total?
select order_id,sum(quantity) as total_quantity
 from order_items 
 group by order_id
 having sum(quantity)>3
 order by total_quantity desc;
 
 -- 19 : Which customers have never placed an order?
 SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;

-- 20 : How many orders were placed by each customer city?
SELECT c.city, COUNT(o.order_id) AS order_count
FROM customers c
JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.city
ORDER BY order_count DESC;

-- Advanced --> Conditions, dates, and window functions

-- 21 : Which customers have spent more than 10,000 in total?
select c.customer_id,c.customer_name,sum(o.total_amount) as total_spent
from customers c join orders o on c.customer_id=o.customer_id
group by c.customer_id,c.customer_name
having sum(o.total_amount)>10000
order by total_spent desc;

-- 22 : What are the first and latest order dates for each customer?
SELECT customer_id,
       MIN(STR_TO_DATE(order_date, '%d-%m-%Y')) AS first_order_date,
       MAX(STR_TO_DATE(order_date, '%d-%m-%Y')) AS latest_order_date
FROM orders
GROUP BY customer_id;

-- 23 : How many orders were placed in each month?
SELECT DATE_FORMAT(STR_TO_DATE(order_date, '%d-%m-%Y'), '%Y-%m') AS order_month,
       COUNT(*) AS order_count
FROM orders
GROUP BY order_month
ORDER BY order_month;

-- 24 : Which month had the highest total order revenue?
SELECT DATE_FORMAT(STR_TO_DATE(order_date, '%d-%m-%Y'), '%Y-%m') AS order_month,
       SUM(total_amount) AS monthly_revenue
FROM orders
GROUP BY order_month
ORDER BY monthly_revenue DESC
LIMIT 1;

-- 25 : Rank customers by their total spending.
select customer_id,customer_name,amount_spent,
rank() over (order by amount_spent desc) as rnk from
(select c.customer_id,c.customer_name,sum(o.total_amount) as amount_spent
from customers c join orders o on c.customer_id=o.customer_id
group by c.customer_id,c.customer_name
order by amount_spent desc) as total_spending
order by rnk;

-- 26 : Show each customer's orders in chronological order.
SELECT customer_id, order_id, order_date,
       ROW_NUMBER() OVER (
           PARTITION BY customer_id
           ORDER BY STR_TO_DATE(order_date, '%d-%m-%Y')
       ) AS order_sequence
FROM orders;

-- 27 : What is the revenue difference between each month and the previous month?
WITH monthly_revenue AS (
    SELECT DATE_FORMAT(STR_TO_DATE(order_date, '%d-%m-%Y'), '%Y-%m') AS order_month,
           SUM(total_amount) AS revenue
    FROM orders
    GROUP BY order_month
), revenue_comparison AS (
    SELECT order_month, revenue,
           LAG(revenue) OVER (ORDER BY order_month) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT order_month, revenue, previous_month_revenue,
       revenue - previous_month_revenue AS revenue_difference
FROM revenue_comparison
ORDER BY order_month;

-- 28 : What percentage of all orders does each status represent?
select status,count(total_amount) as amount,
round(count(total_amount)/(select count(*) from orders) * 100, 2) as per
from orders
group by status
order by per desc;


-- 29 : Which products are in the top three by item sales within each category?
with b as (select category,product_name,revenue,
dense_rank() over (partition by category order by revenue desc) as rnk from 
(select p.category,p.product_name,
sum(oi.quantity*oi.unit_price) as revenue
from products p join order_items oi
on p.product_id=oi.product_id
group by p.category,p.product_name
order by revenue) as a)

select category,product_name,revenue,rnk from b
where rnk<=3
order by category;

-- 30 : What is each customer's share of total revenue?
WITH customer_revenue AS (
    SELECT c.customer_id, c.customer_name,
           SUM(o.total_amount) AS revenue
    FROM customers c
    JOIN orders o ON o.customer_id = c.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT customer_id, customer_name, revenue,
       ROUND(revenue * 100.0 / (SELECT SUM(total_amount) FROM orders), 2) AS revenue_share_percent
FROM customer_revenue
ORDER BY revenue DESC;