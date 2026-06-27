# Retail Business Performance & Profitability Analysis

Analysis of the Sample Superstore dataset to identify profit-draining product categories, test whether order fulfillment speed affects profitability, and uncover the real driver behind margin erosion — using SQL, Python, and Power BI.

<img width="903" height="509" alt="Superstore Dashboard SS" src="https://github.com/user-attachments/assets/4378b357-5f23-4f12-a381-f32f9241f495" />

## Objective

Retail sales volume can look healthy while profit quietly erodes underneath it. This project analyzes 9,994 Superstore orders (2014–2017) to answer:
- Which product categories and sub-categories drain profit despite strong sales?
- Does slower order fulfillment (days to ship) correlate with lower profit?
- How much does discounting actually cost the business?

## Tools Used

| Tool | Purpose |
|---|---|
| **SQL (SQLite / DB Browser)** | Data cleaning, profit margin by category/sub-category/region, discount-band aggregation |
| **Python (Pandas, Seaborn, Matplotlib)** | Date parsing, days-to-ship calculation, correlation analysis with profit |
| **Power BI Desktop** | Interactive dashboard — KPI cards, profitability charts, regional treemap, quarterly trend, discount-band analysis |
| **Tableau Public** | Cross-tool validation of findings |

## Key Findings

- **Tables and Bookcases are consistently loss-making** sub-categories despite solid sales volume.
- **Fulfillment speed has near-zero correlation with profit** (checked overall and by category) — shipping delays are not the cause of margin loss.
- **Discounting is the real profit killer.** Orders with 0–20% discount stay strongly profitable; profit turns negative above 21%, with the steepest losses at 40%+ discount.
- **Seasonality compounds the discount problem:** Q4 sales are ~4x Q1, but profit only ~2x — heavier holiday discounting eats into margin growth exactly when volume peaks.

## Recommendation

Cap discounts at 20% for Furniture sub-categories — particularly Tables and Bookcases — to recover profitability without sacrificing sales volume.

## Repository Contents

| File | Description |
|---|---|
| `Sample - Superstore.csv` | Raw dataset |
| `superstore_clean.csv` | Cleaned export used for Python analysis |
| `Superstore.sql` | All SQL queries — cleaning, profit margin, regional, discount-band analysis |
| `Superstore Query.pdf` | SQL queries exported as PDF |
| `superstore.ipynb` | Python notebook — date parsing and days-to-ship vs. profit correlation |
| `Superstore Dashboard.pbix` | Power BI dashboard file |
| `Superstore Dashboard SS.png` | Dashboard screenshot |
| `Retail_Profitability_Report.pdf` | 1–2 page project report (Introduction, Abstract, Tools, Steps, Conclusion) |

## Author

**Mohammad Sadique**
Data Analyst Intern, Elevate Labs
[LinkedIn](https://linkedin.com/in/mohammad-sadique-1028ba2a1) · [GitHub](https://github.com/Sadique-Osman)
