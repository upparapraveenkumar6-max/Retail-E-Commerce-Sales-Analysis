# Retail E-Commerce Sales Analysis

A SQL analytics project built with **MySQL** to explore retail e-commerce data and answer business questions about customers, orders, products, sales, and revenue.

## Project Overview

This project demonstrates how SQL can turn raw e-commerce tables into useful business insights. It includes data inspection, record counts, aggregations, joins, filtering, date analysis, and window functions.

## Objectives

- Understand the structure and size of the dataset.
- Analyze order volume and order status.
- Explore customer demographics and purchasing behavior.
- Identify high-value customers and popular products.
- Compare revenue across cities, genders, and months.
- Practice advanced SQL techniques, including CTEs and window functions.

## Tools & Technologies

- **Database:** MySQL 8
- **Query language:** SQL
- **SQL concepts:** `SELECT`, `WHERE`, `GROUP BY`, `ORDER BY`, `HAVING`, aggregate functions, joins, subqueries, CTEs, date functions, and window functions (`ROW_NUMBER`, `RANK`, `DENSE_RANK`, `LAG`).

## Dataset Tables

The SQL script uses these tables:

| Table | Purpose |
|---|---|
| `customers` | Customer details, including name, city, state, age, signup date, and gender |
| `orders` | Order records, including customer, date, total amount, and status |
| `order_items` | Products and quantities included in each order, with unit price |
| `products` | Product details, including product name, category, and price |
| `locations` | Location-related data included in the dataset |

## Business Questions Covered

### Beginner — Counts and summaries

1. What is the total number of orders?
2. How many unique customers placed orders?
3. What is the average order value?
4. What is the average order value rounded to two decimal places?
5. How many orders are there for each order status?
6. How many customers are in each gender group?
7. What are the five most expensive products?
8. What are the minimum, maximum, and average product prices?

### Intermediate — Grouping and joins

9. How many products are listed in each category?
10. Which 10 customers have spent the most?
11. Which customers have placed the most orders?
12. What is the total revenue by customer gender?
13. Which cities generate the most order revenue?
14. What is the average order value for each order status?
15. How many units of each product were ordered?
16. Which products generated the most item-level sales value?
17. What is the total item quantity in each order?
18. Which orders contain more than three units in total?
19. Which customers have never placed an order?
20. How many orders were placed by customers in each city?

### Advanced — Conditions, dates, and window functions

21. Which customers have spent more than 10,000 in total?
22. What are the first and latest order dates for each customer?
23. How many orders were placed in each month?
24. Which month had the highest total order revenue?
25. How can customers be ranked by their total spending?
26. How can each customer's orders be numbered chronologically?
27. What is the revenue difference between each month and the previous month?
28. What percentage of all orders does each status represent?
29. Which products are in the top three by item sales within each category?
30. What is each customer's share of total revenue?

## How to Run

1. Install and open MySQL Server / MySQL Workbench.
2. Open `Ecommerce_Project_Analysis.sql`.
3. Check the database name and select the correct schema.
4. Run the setup and table-inspection statements as appropriate for your database.
5. Run the analysis queries individually or section by section.

> **Important:** The script begins with `USE cosmetics_ecommerce;` and includes a `RENAME TABLE` statement to rename several source tables. If you have already renamed those tables, do not run that rename statement again. Update the database name in the script if your schema has a different name.

## Date Handling

The analysis queries parse `order_date` using `STR_TO_DATE(order_date, '%d-%m-%Y')`, which assumes dates are stored as text in `DD-MM-YYYY` format. If your source data uses a different format or a native `DATE` column, adjust the date expressions accordingly.

## Repository Structure

```text
Retail-E-Commerce-Sales-Analysis/
├── README.md
└── Ecommerce_Project_Analysis.sql
```

## Skills Demonstrated

- Data exploration and validation
- Aggregations and grouped summaries
- Inner and left joins
- Filtering grouped results with `HAVING`
- Subqueries and common table expressions (CTEs)
- Date parsing and monthly trend analysis
- Customer ranking and chronological sequencing
- Revenue comparisons using `LAG`
- Product ranking within categories

## Project Notes

- The analysis focuses on the columns and tables referenced in the SQL script.
- Revenue calculated from `orders.total_amount` may differ from item-level sales calculated as `order_items.quantity * order_items.unit_price`, depending on the dataset and how order totals were recorded.
- Query 3 and Query 4 both calculate average order value; Query 4 formats the result to two decimal places.

---

**Project:** Retail E-Commerce Sales Analysis  
**Database:** MySQL  
**Focus:** SQL-based retail and e-commerce analytics
