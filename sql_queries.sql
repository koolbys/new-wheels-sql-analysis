/*
New Wheels Business Performance Analysis
Author: Briana Salinas

This file contains SQL queries used to analyze:
- Customer distribution
- Customer satisfaction
- Manufacturer preferences
- Revenue trends
- Shipping performance
*/

-- Question 1a: Total number of customers who placed orders
SELECT
    COUNT(DISTINCT c.customer_id) AS total_customers
FROM customer_t AS c
JOIN order_t AS o 
    ON c.customer_id = o.customer_id;


-- Question 1b: Distribution of customers across states
SELECT
    state,
    COUNT(customer_id) AS total_customers
FROM customer_t
GROUP BY state
ORDER BY total_customers DESC;


-- Question 2: Top 5 vehicle makers preferred by customers
SELECT
    p.vehicle_maker,
    COUNT(DISTINCT o.customer_id) AS customer_count
FROM product_t AS p
JOIN order_t AS o 
    ON p.product_id = o.product_id
GROUP BY p.vehicle_maker
ORDER BY customer_count DESC
LIMIT 5;


-- Question 3: Most preferred vehicle maker in each state
-- Note: RANK() returns all tied top vehicle makers within each state.
SELECT
    state,
    vehicle_maker,
    customer_count
FROM (
    SELECT
        c.state,
        p.vehicle_maker,
        COUNT(DISTINCT o.customer_id) AS customer_count,
        RANK() OVER (
            PARTITION BY c.state
            ORDER BY COUNT(DISTINCT o.customer_id) DESC
        ) AS rnk
    FROM product_t AS p
    JOIN order_t AS o 
        ON p.product_id = o.product_id
    JOIN customer_t AS c 
        ON o.customer_id = c.customer_id
    GROUP BY c.state, p.vehicle_maker
) AS ranked
WHERE rnk = 1
ORDER BY state;
