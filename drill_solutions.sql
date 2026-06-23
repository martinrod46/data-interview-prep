================================================================
SQL DRILL SET — SOLUTIONS
================================================================
Compatible with SQLite, Postgres, MySQL (minor syntax notes
included where engines differ).

----------------------------------------------------------------
PROBLEM 1 — Completed orders with customer name
----------------------------------------------------------------
SELECT o.order_id, c.name, o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
ORDER BY o.order_date ASC;

----------------------------------------------------------------
PROBLEM 2 — Customers with more than 2 completed orders
----------------------------------------------------------------
SELECT c.name, COUNT(*) AS completed_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.customer_id, c.name
HAVING COUNT(*) > 2
ORDER BY completed_orders DESC;

Common mistake: using WHERE COUNT(*) > 2 instead of HAVING.
WHERE filters rows before aggregation; HAVING filters after.

----------------------------------------------------------------
PROBLEM 3 — Order total value
----------------------------------------------------------------
SELECT o.order_id,
       SUM(oi.quantity * oi.unit_price) AS total_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.status = 'completed'
GROUP BY o.order_id
ORDER BY total_value DESC;

----------------------------------------------------------------
PROBLEM 4 — Rank customers by total spend
----------------------------------------------------------------
SELECT name, total_spend,
       RANK() OVER (ORDER BY total_spend DESC) AS spend_rank
FROM (
    SELECT c.customer_id, c.name,
           SUM(oi.quantity * oi.unit_price) AS total_spend
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY c.customer_id, c.name
) spend_summary
ORDER BY spend_rank;

Note: RANK() leaves gaps on ties (1,2,2,4). DENSE_RANK() doesn't
(1,2,2,3). Know which one an interviewer wants — if unsure, ask.

----------------------------------------------------------------
PROBLEM 5 — Monthly revenue + running total
----------------------------------------------------------------
SELECT month, monthly_revenue,
       SUM(monthly_revenue) OVER (ORDER BY month) AS running_total
FROM (
    SELECT strftime('%Y-%m', o.order_date) AS month,
           SUM(oi.quantity * oi.unit_price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY month
) monthly
ORDER BY month;

-- Postgres/MySQL note: replace strftime('%Y-%m', order_date)
-- with DATE_TRUNC('month', order_date) (Postgres) or
-- DATE_FORMAT(order_date, '%Y-%m') (MySQL).

----------------------------------------------------------------
PROBLEM 6 — Customers with no completed orders
----------------------------------------------------------------
SELECT c.name
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id AND o.status = 'completed'
WHERE o.order_id IS NULL;

Key idea: put the status filter in the JOIN condition, not in a
WHERE clause after the LEFT JOIN — filtering in WHERE would
silently turn it back into an inner join and break the logic.

----------------------------------------------------------------
PROBLEM 7 — Month-over-month % change
----------------------------------------------------------------
SELECT month, monthly_revenue,
       LAG(monthly_revenue) OVER (ORDER BY month) AS prev_month_revenue,
       ROUND(
         (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY month))
         * 100.0 / LAG(monthly_revenue) OVER (ORDER BY month), 1
       ) AS pct_change
FROM (
    SELECT strftime('%Y-%m', o.order_date) AS month,
           SUM(oi.quantity * oi.unit_price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY month
) monthly
ORDER BY month;

----------------------------------------------------------------
PROBLEM 8 — Revenue and order count by category
----------------------------------------------------------------
SELECT p.category,
       SUM(oi.quantity * oi.unit_price) AS category_revenue,
       COUNT(DISTINCT oi.order_id) AS distinct_orders
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY p.category
ORDER BY category_revenue DESC;

----------------------------------------------------------------
PROBLEM 9 — Second-highest spender (tie-safe)
----------------------------------------------------------------
SELECT name, total_spend, spend_rank
FROM (
    SELECT c.name,
           SUM(oi.quantity * oi.unit_price) AS total_spend,
           DENSE_RANK() OVER (
             ORDER BY SUM(oi.quantity * oi.unit_price) DESC
           ) AS spend_rank
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.status = 'completed'
    GROUP BY c.customer_id, c.name
) ranked
WHERE spend_rank = 2;

----------------------------------------------------------------
PROBLEM 10 — Retained across Oct -> Nov 2023
----------------------------------------------------------------
SELECT oct.customer_id
FROM (
    SELECT DISTINCT customer_id FROM orders
    WHERE status = 'completed'
      AND strftime('%Y-%m', order_date) = '2023-10'
) oct
JOIN (
    SELECT DISTINCT customer_id FROM orders
    WHERE status = 'completed'
      AND strftime('%Y-%m', order_date) = '2023-11'
) nov
ON oct.customer_id = nov.customer_id;

================================================================
SELF-SCORING GUIDE
================================================================
For each problem, rate yourself honestly:
  - SOLID: wrote it correctly within 3 min, no major hesitation
  - SHAKY: got there but slow, or needed 2+ tries
  - STUCK: couldn't produce a working query

Any "STUCK" problems are your real priority list — redo those
specific patterns 2-3 more times over the next two days rather
than moving on to new material.
================================================================
