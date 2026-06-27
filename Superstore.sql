-- ============================================================
-- Retail Business Performance & Profitability Analysis
-- Dataset: Sample - Superstore
-- ============================================================

-- ================================
-- 1. DATA EXPLORATION & CLEANING
-- ================================

-- Preview the data
SELECT * FROM "Sample - Superstore" LIMIT 10;

-- Check total row count
SELECT COUNT(*) AS Total_Rows FROM "Sample - Superstore";

-- Check for null values in key columns
SELECT 
  SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS Null_Sales,
  SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS Null_Profit,
  SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) AS Null_Category,
  SUM(CASE WHEN "Sub-Category" IS NULL THEN 1 ELSE 0 END) AS Null_SubCategory,
  SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS Null_Region
FROM "Sample - Superstore";

-- Check for duplicate line items (same order + product appearing more than once)
SELECT "Order ID", "Product ID", COUNT(*) AS Cnt
FROM "Sample - Superstore"
GROUP BY "Order ID", "Product ID"
HAVING COUNT(*) > 1;

-- Create a cleaned table (drops exact duplicates + rows missing core numeric fields)
-- Use this table for every query below
CREATE TABLE superstore_clean AS
SELECT DISTINCT * FROM "Sample - Superstore"
WHERE Sales IS NOT NULL AND Profit IS NOT NULL;

-- ================================
-- 2. PROFIT MARGIN ANALYSIS
-- ================================

-- Profit margin by Category
SELECT Category,
       ROUND(SUM(Sales), 2) AS Total_Sales,
       ROUND(SUM(Profit), 2) AS Total_Profit,
       ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS Profit_Margin_Pct
FROM superstore_clean
GROUP BY Category
ORDER BY Profit_Margin_Pct DESC;

-- Profit margin by Sub-Category (loss-makers float to top)
SELECT "Sub-Category",
       ROUND(SUM(Sales), 2) AS Total_Sales,
       ROUND(SUM(Profit), 2) AS Total_Profit,
       ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS Profit_Margin_Pct
FROM superstore_clean
GROUP BY "Sub-Category"
ORDER BY Profit_Margin_Pct ASC;

-- Top 5 most profitable sub-categories
SELECT "Sub-Category", ROUND(SUM(Profit), 2) AS Total_Profit
FROM superstore_clean
GROUP BY "Sub-Category"
ORDER BY Total_Profit DESC
LIMIT 5;

-- Bottom 5 loss-making sub-categories
SELECT "Sub-Category", ROUND(SUM(Profit), 2) AS Total_Profit
FROM superstore_clean
GROUP BY "Sub-Category"
ORDER BY Total_Profit ASC
LIMIT 5;

-- ================================
-- 3. REGIONAL ANALYSIS
-- ================================

-- Profit and sales by Region
SELECT Region,
       ROUND(SUM(Sales), 2) AS Total_Sales,
       ROUND(SUM(Profit), 2) AS Total_Profit,
       ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS Profit_Margin_Pct
FROM superstore_clean
GROUP BY Region
ORDER BY Total_Profit DESC;

-- Region + Category drill-down
SELECT Region, Category,
       ROUND(SUM(Sales), 2) AS Total_Sales,
       ROUND(SUM(Profit), 2) AS Total_Profit
FROM superstore_clean
GROUP BY Region, Category
ORDER BY Region, Total_Profit DESC;

-- ================================
-- 4. DISCOUNT IMPACT ANALYSIS
-- ================================

-- Average discount vs total profit by Category
SELECT Category,
       ROUND(AVG(Discount), 3) AS Avg_Discount,
       ROUND(SUM(Profit), 2) AS Total_Profit
FROM superstore_clean
GROUP BY Category;

-- Discount bands vs average profit (shows the tipping point where discounts erase profit)
SELECT 
  CASE 
    WHEN Discount = 0 THEN '0%'
    WHEN Discount <= 0.2 THEN '1-20%'
    WHEN Discount <= 0.4 THEN '21-40%'
    ELSE '40%+'
  END AS Discount_Band,
  ROUND(AVG(Profit), 2) AS Avg_Profit,
  COUNT(*) AS Order_Count
FROM superstore_clean
GROUP BY Discount_Band
ORDER BY Discount_Band;

-- ================================
-- 5. SEASONAL / TIME-BASED ANALYSIS
-- ================================

-- Monthly sales and profit trend
SELECT strftime('%Y-%m', "Order Date") AS Order_Month,
       ROUND(SUM(Sales), 2) AS Total_Sales,
       ROUND(SUM(Profit), 2) AS Total_Profit
FROM superstore_clean
GROUP BY Order_Month
ORDER BY Order_Month;

-- Sales by quarter and category (seasonal pattern)
SELECT 
  CASE 
    WHEN CAST(strftime('%m', "Order Date") AS INTEGER) IN (1,2,3) THEN 'Q1'
    WHEN CAST(strftime('%m', "Order Date") AS INTEGER) IN (4,5,6) THEN 'Q2'
    WHEN CAST(strftime('%m', "Order Date") AS INTEGER) IN (7,8,9) THEN 'Q3'
    ELSE 'Q4'
  END AS Quarter,
  Category,
  ROUND(SUM(Sales), 2) AS Total_Sales
FROM superstore_clean
GROUP BY Quarter, Category
ORDER BY Quarter, Category;

-- ================================
-- 6. ORDER-TO-SHIP DAYS (fulfillment/inventory proxy -> feeds Python correlation step)
-- ================================

-- Row-level days-to-ship (export this for the Pandas correlation analysis)
SELECT "Order ID",
       Category,
       "Sub-Category",
       Profit,
       Sales,
       "Ship Date"
FROM superstore_clean;


-- ================================
-- 7. SHIP MODE / SEGMENT BREAKDOWN (supporting insights)
-- ================================

SELECT "Ship Mode",
       ROUND(SUM(Profit), 2) AS Total_Profit,
       ROUND(AVG(Discount), 3) AS Avg_Discount
FROM superstore_clean
GROUP BY "Ship Mode";

SELECT Segment,
       ROUND(SUM(Sales), 2) AS Total_Sales,
       ROUND(SUM(Profit), 2) AS Total_Profit
FROM superstore_clean
GROUP BY Segment
ORDER BY Total_Profit DESC;
