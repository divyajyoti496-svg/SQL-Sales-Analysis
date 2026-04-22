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
