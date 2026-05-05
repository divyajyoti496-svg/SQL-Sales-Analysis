-- =====================================
-- SQL SALES ANALYSIS (BASIC DATASET)
-- =====================================

-- 1. Total Revenue
SELECT 'Total Revenue' AS metric, ROUND(SUM(Sales),2) AS value FROM sales;

-- 2. Total Profit
SELECT 'Total Profit' AS metric, ROUND(SUM(Profit),2) AS value FROM sales;

-- 3. Average Profit per Transaction
SELECT 'Average Profit per Order' AS metric, ROUND(AVG(Profit), 2) AS value FROM sales;

-- 4. Total Quantity Sold
SELECT SUM(Quantity) AS total_quantity FROM sales;

-- 5. Discount Impact on Profit
SELECT 
   Discount AS discount_rate,
    ROUND(AVG(Profit), 2) AS avg_profit
FROM sales
GROUP BY Discount
ORDER BY avg_profit DESC;

-- 6. Top 5 Highest Sales Transactions
SELECT Sales, Profit
FROM sales
ORDER BY Sales DESC
LIMIT 5;

-- 7. Loss-making Transactions
SELECT COUNT(*) AS loss_transactions
FROM sales
WHERE Profit < 0;

-- 8. High Discount vs Profit Loss
SELECT 
    Discount AS discount_rate,
    COUNT(*) AS total_orders,
    ROUND(AVG(Profit), 2) AS avg_profit
FROM sales
GROUP BY Discount
ORDER BY Discount DESC;

-- 9. Profit Classification
SELECT 
    CASE 
        WHEN Profit < 0 THEN 'Loss'
        WHEN Profit BETWEEN 0 AND 50 THEN 'Low Profit'
        ELSE 'High Profit'
    END AS profit_category,
    COUNT(*) AS total_orders
FROM sales
GROUP BY profit_category;

-- 9.1 Profit Margin %
SELECT 
    ROUND((SUM(Profit) * 100.0 / SUM(Sales)), 2) AS profit_margin_percent
FROM sales;

-- 9.2 Loss Rate %
SELECT 
    ROUND(
        (SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
        2
    ) AS loss_transaction_percent
FROM sales;

-- 10. Discount Buckets Analysis
SELECT 
    CASE 
        WHEN Discount <= 0.2 THEN 'Low Discount'
        WHEN Discount <= 0.5 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS discount_bucket,
    COUNT(*) AS total_orders,
    ROUND(AVG(Profit),2) AS avg_profit
FROM sales
GROUP BY discount_bucket;

-- 11. Loss Transaction Percentage (KPI)
SELECT 
    ROUND(
        (SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) * 100.0) / COUNT(*),
        2
    ) AS loss_transaction_percent
FROM sales;

-- Insight: Higher discounts lead to negative profitability
-- Query 5: Top 10 Customers by Profit using RANK()
SELECT
    customer_name,
    ROUND(SUM(profit), 2) AS total_profit,
    RANK() OVER (ORDER BY SUM(profit) DESC) AS profit_rank
FROM superstore
GROUP BY customer_name
ORDER BY profit_rank
LIMIT 10;


-- Query 6: Month-over-Month Revenue Trend using LAG()
SELECT
    order_month,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(LAG(total_revenue) OVER (ORDER BY order_month), 2) AS prev_month_revenue,
    ROUND(total_revenue - LAG(total_revenue) OVER (ORDER BY order_month), 2) AS revenue_change
FROM (
    SELECT
        STRFTIME('%Y-%m', order_date) AS order_month,
        SUM(sales) AS total_revenue
    FROM superstore
    GROUP BY order_month
) monthly_sales
ORDER BY order_month;


-- Query 7: Profit by Sub-Category ranked within each Category
SELECT
    category,
    sub_category,
    ROUND(SUM(profit), 2) AS total_profit,
    RANK() OVER (PARTITION BY category ORDER BY SUM(profit) DESC) AS rank_in_category
FROM superstore
GROUP BY category, sub_category
ORDER BY category, rank_in_category;