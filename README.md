# CRM Sales Opportunities Analysis
 
A full analytics pipeline tracking a CRM's sales pipeline from Oct 2016 to Dec 2017: **Excel** for data cleaning, **MySQL** for analysis, and **Power BI** for a 5-page interactive dashboard.
 
---
 
## 📌 Project Overview
 
This project analyzes **7,375 sales opportunities** handled by **35 sales agents** across **3 regional offices** (Central, East, West), covering **85 accounts** and **7 products**. Unlike a single-tool project, this one deliberately moves through three stages, each doing a different job:
 
1. **Excel** — cleaned and staged the four source tables (`sales_team`, `sales_pipeline`, `Products`, `Account`) before anything else touched them
2. **MySQL Workbench** — built the schema, loaded the cleaned data, and ran the full analysis (account, product, sales, and team performance)
3. **Power BI** — turned the SQL analysis into a 5-page interactive dashboard (Overview, Account Analysis, Product Analysis, Sales Analysis, Sales Team Analysis)
## 🎯 Business Problem
 
Sales leadership needs to know which accounts, products, and regions actually drive revenue, which agents convert deals fastest and most often, and whether deals are closing near list price — and they need it in a form (a live dashboard) that doesn't require someone to run a SQL query every time a question comes up.
 
## 📊 Project Objectives
 
- Clean and consolidate four related tables into an analysis-ready dataset
- Answer the core CRM questions in SQL: revenue, win rate, top accounts, top products, agent and regional performance
- Rebuild those same answers as a filterable, presentation-ready Power BI dashboard
- Catch and document any inconsistency between the SQL analysis and the dashboard before presenting either as final
 
## 🛠️ Tools & Technologies
 
- **Microsoft Excel** — cleaning and staging 4 source tables before loading
- **MySQL Workbench** — schema design, `LOAD DATA INFILE`, joins, conditional aggregation (win rate, discount %), the authoritative source of every number in this README
- **Power BI** — data modeling, 5-page dashboard, slicers (Sector, Series, Regional Office), KPI cards, trend and comparison visuals
---
 
## 📈 Key Findings (from the SQL Analysis — the authoritative source)
 
- **$10.0M in closed revenue** across **7,375 total deals**, with **4,238 won** — overall win rate **63.15%**
- **Kan-code ($341,455), Konex ($269,245), and Condax ($206,410)** are the top three accounts by revenue
- **Retail (17 accounts)** is the largest client sector, followed by Medical and Technology (12 each)
- **GTX Pro is the top product** ($3.51M revenue, 1,258 deals sold), and the **GTX series dominates overall** ($7.34M, about 73% of all product revenue)
- Deals close within about **±1.5% of list price** across every product — pricing discipline is strong
- **June and March are the strongest months**, both by volume (531 deals each) and win rate (over 82%)
- **West leads regionally** in revenue ($3.57M) and win rate (63.9%), narrowly ahead of Central and East
- **Hayden Neloms has the best individual win rate (70.4%)**; the agent gap (70.4% vs. 55.0%) is far wider than the regional gap (63.9% vs. 62.6%)
*(Full detail on each of these is in the CRM Sales Opportunities SQL write-up.)*
 
---
 
## 📊 Power BI Dashboard Walkthrough
 
### 1. CRM Overview
**Goal:** A single-page snapshot of the whole pipeline for anyone who doesn't need to dig into detail.
**Visuals:** KPI cards (Revenue, Deals, Sold, Win Rate %, Accounts, Products), a monthly revenue trend line, and a deal-stage donut (Won/Lost/Engaging/Prospecting).
**What it shows:** Win Rate % (63.15%) and Accounts (85) match the SQL analysis exactly. The deal-stage donut shows **Won at 57.46%** — this is a *different* win-rate calculation than the 63.15% KPI card next to it: the card measures Won ÷ (Won + Lost) only, while the donut measures Won ÷ *all* deals, including still-open Engaging and Prospecting ones. Both are valid, but worth labeling clearly so a viewer doesn't assume they conflict.
 
### 2. Account Analysis
**Goal:** Break down the client base by sector, region, and account size.
**Visuals:** Win rate by account, total deals by account, accounts by sector, accounts by region, and a "Top Ten Biggest Accounts" table.
**What it shows:** **Retail is the largest sector (17 accounts)**, and accounts split fairly evenly by region — **Central 84 (34.85%), West 79 (32.78%), East 78 (32.37%)**. **Rangreen leads on win rate (75%)**, and **Hottechi handles the most total deals (409)**. The Top Ten Accounts table matches the SQL account data exactly (e.g., Kan-code: 34,288 employees, $11,698 revenue).
 
### 3. Product Analysis
**Goal:** Understand product-level performance — pricing, discounting, revenue, and monthly sales patterns.
**Visuals:** Average deal time by product, most expensive product, average discount % by product, series revenue, product revenue and win rate, and product sales by month.
**What it shows:** **GTK 500 is the most expensive product ($26,768)**, and **GTX is the dominant series by revenue share**. Discounting stays close to zero across every product, consistent with the SQL finding. **June and March are the top months for units sold**, matching the SQL analysis exactly in relative terms.
 
### 4. Sales Analysis
**Goal:** Track where revenue actually comes from — over time, by region, and by account.
**Visuals:** Monthly revenue, regional office revenue (donut), product revenue (declining line), and top 10 accounts by revenue.
**What it shows:** **West leads regional revenue (35.67% share)**, narrowly ahead of East (33.44%) and Central (30.89%) — the same ranking as the SQL analysis. **Kan-code is the top account by revenue**, consistent throughout every page of the report.
 
### 5. Sales Team Analysis
**Goal:** Compare agents and regions directly on revenue, deal volume, and win rate.
**Visuals:** Agents by region, a "Best Region" performance table, a "Best Sales Agent" table, and account revenue.
**What it shows:** **East and West each have 12 agents, Central has 11** — matching the SQL analysis exactly. Regional win rates rank **West (63.94%) > East (63.02%) > Central (62.56%)**, the same order and nearly the same values as the SQL analysis. The agent table shown appears to be sorted alphabetically rather than by performance, so the true top performer (Hayden Neloms, 70.4% win rate, confirmed via SQL) isn't visible in this particular screenshot — worth re-sorting this table by Win Rate before presenting it, so the dashboard actually highlights its best agent.
 
---
 
| Metric | SQL Analysis (Source of Truth) | Power BI Dashboard | Ratio |
|---|---|---|---|
| Total Revenue | $10.0M | $20M | 2.00x |
| Total Deals | 7,375 | ~15K | 2.03x |
| Deals Sold (Won) | 4,238 | ~8K | 1.89x |
| GTX Pro Revenue | $3.51M | $7,021K | 2.00x |
| Kan-code Revenue | $341,455 | $683K | 2.00x |
| Konex Revenue | $269,245 | $538K | 2.00x |
| June Deals Sold | 531 | 1,062 | 2.00x |
| West Region Revenue | $3.57M | $7,137,294 | 2.00x |
 
**Likely cause:** a fan-out (many-to-many) relationship in the Power BI data model — most likely between the sales pipeline fact table and one of the dimension tables (Sales Team or Account), where each transaction row is being matched more than once during the join, doubling every `SUM()`-based measure while leaving every ratio-based measure (which divides two doubled numbers) unaffected. This matches a real bug already present in the SQL load script itself: `CRMEQaccounts.csv` and `CRMEQsales_team.csv` are both loaded into the same `CREMQsales_team` table, which — if replicated in how the Power BI model was built — would create exactly this kind of duplicate-key relationship.
 
**Why this matters for a defense:** the SQL analysis and the dashboard tell the *same relative story* (same rankings, same percentages, same top performers), but the dashboard's absolute numbers should not be quoted as final until this relationship is fixed in the Power BI model — likely by checking for a duplicate or non-unique key on the Sales Team or Account relationship and setting it to a single-direction, one-to-many filter.
 
---
 
## 💡 Business Insights
 
1. **The SQL analysis is the reliable source for absolute figures**; the dashboard is reliable for rankings, trends, and percentages, but its totals need the relationship fix above before being quoted externally.
2. **Revenue and win rate are concentrated**, not evenly spread: a handful of accounts (Kan-code, Konex, Condax) and one product line (GTX) drive a disproportionate share of both, consistent across every page of the dashboard.
3. **Regional performance is close and consistent** across both the SQL analysis and the dashboard — West edges out East and Central on both revenue and win rate, but the gap between regions is small compared to the much larger gap between individual agents.
4. **The dashboard's own agent table isn't currently sorted to show its best performer** — a small fix (sort by Win Rate) would make the Sales Team Analysis page immediately answer its own central question.
---
 
## 📸 Dashboard
 
![CRM Overview](images/CRM_overview_Dashboard.png)
![CRM Account Analysis](images/CRM_Account_analysis_Dashboard.png)
![CRM Product Analysis](images/CRM_Product_analysis_dashboard.png)
![CRM Sales Analysis](images/CRM_Sales_Analysis.png)
![CRM Sales Team Analysis](images/CRM_sales_Team_analysis_Dashboard.png)
 
## 📚 Skills Demonstrated
 
- End-to-end pipeline design across three tools (Excel → SQL → Power BI)
- Relational schema design and multi-table joins in MySQL
- Conditional aggregation for win-rate, discount, and revenue analysis
- Power BI data modeling and multi-page interactive dashboard design
- **Cross-tool validation** — catching a real data-model duplication bug by comparing dashboard output against the underlying SQL analysis, rather than presenting either in isolation
## 👤 Author
 
**Shodunke Feranmi**
  [GitHub](https://github.com/Shodunke-Feranmi)
