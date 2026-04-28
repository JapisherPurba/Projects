-- ACS-3902 Assignment 2 Part C
-- Name:Japisher Singh Purba
-- St#: 3183522
--------------------------------
SET SCHEMA 'purba_3183522_as2_c';  -- change the schema name to match your own


-- Q1
SELECT sr.salesrepnumber, sr.last, sr.first
FROM sales_rep sr
LEFT JOIN customer c ON sr.salesrepnumber = c.salesrepnumber
WHERE c.salesrepnumber IS NULL;


-- Q2

SELECT 
    sr.salesrepnumber,
    sr.last AS rep_last_name,
    sr.first AS rep_first_name,
    COUNT(DISTINCT so.order_number) AS total_orders,
    (SUM(ol.qty_ordered * ol.quoted_price), 0) AS total_revenue
FROM sales_rep sr
LEFT JOIN customer c ON sr.salesrepnumber = c.salesrepnumber
LEFT JOIN sales_order so ON c.customer_number = so.customer_number
LEFT JOIN order_line ol ON so.order_number = ol.order_number
GROUP BY sr.salesrepnumber, sr.last, sr.first
ORDER BY sr.salesrepnumber;

-- Q3

SELECT 
    c.customer_number,
    c.last AS customer_last_name,
    sr.last AS rep_last_name,
    (AVG(ol.qty_ordered * ol.quoted_price), 0) AS avg_order_value
FROM customer c
LEFT JOIN sales_rep sr ON c.salesrepnumber = sr.salesrepnumber
LEFT JOIN sales_order so ON c.customer_number = so.customer_number
LEFT JOIN order_line ol ON so.order_number = ol.order_number
GROUP BY c.customer_number, c.last, sr.last
ORDER BY avg_order_value DESC;

-- Q4
WITH avg_price AS (
    SELECT AVG(unit_price) AS avg_unit_price FROM part
)
SELECT 
    p.part_number,
    p.part_description,
    p.unit_price,
    (SUM(ol.qty_ordered), 0) AS total_quantity,
    (SUM(ol.qty_ordered * ol.quoted_price), 0) AS total_revenue
FROM part p
LEFT JOIN order_line ol ON p.part_number = ol.part_number
WHERE p.unit_price >= (SELECT avg_unit_price FROM avg_price)
GROUP BY p.part_number, p.part_description, p.unit_price
ORDER BY total_quantity DESC;

-- Q5
WITH sg_customers AS (
    SELECT DISTINCT c.customer_number
    FROM customer c
    JOIN sales_order so ON c.customer_number = so.customer_number
    JOIN order_line ol ON so.order_number = ol.order_number
    JOIN part p ON ol.part_number = p.part_number
    JOIN item_class ic ON p.item_class_id = ic.item_class_id
    WHERE ic.item_class_code = 'SG'
)
SELECT 
    c.customer_number,
    c.first AS first_name,
    c.last AS last_name,
    (SUM(ol.qty_ordered * ol.quoted_price), 0) AS total_order_value
FROM customer c
LEFT JOIN sales_order so ON c.customer_number = so.customer_number
LEFT JOIN order_line ol ON so.order_number = ol.order_number
WHERE c.customer_number IN (SELECT customer_number FROM sg_customers)
GROUP BY c.customer_number, c.first, c.last
ORDER BY c.customer_number;

-- Q6
BEGIN;

INSERT INTO sales_commision_payout (
    salesrepnumber,
    commissionrate,
    salesyear,
    salesmonthnumber,
    sales,
    commission
)
SELECT 
    sr.salesrepnumber,
    sr.commission_rate,
    2023 AS salesyear,
    9 AS salesmonthnumber,
    SUM(ol.qty_ordered * ol.quoted_price) AS total_sales,
    SUM(ol.qty_ordered * ol.quoted_price * sr.commission_rate) AS commission
FROM sales_rep sr
LEFT JOIN customer c ON sr.salesrepnumber = c.salesrepnumber
LEFT JOIN sales_order so ON c.customer_number = so.customer_number
    AND EXTRACT(YEAR FROM so.order_date) = 2023
    AND EXTRACT(MONTH FROM so.order_date) = 9
LEFT JOIN order_line ol ON so.order_number = ol.order_number
GROUP BY sr.salesrepnumber, sr.commission_rate
ON CONFLICT (salesrepnumber, salesyear, salesmonthnumber) 
DO UPDATE SET 
    commissionrate = EXCLUDED.commissionrate,
    sales = EXCLUDED.sales,
    commission = EXCLUDED.commission;

COMMIT;