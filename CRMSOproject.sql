-- ==================================================
-- File Name:   CRMSOproject
-- Author:      Shodunke Feranmi
-- Date:        2026-09-14
-- ==================================================
-- Description
-- CRM Sales Opportunities Dataset
-- Tracks a CRM's sales pipeline from Oct 2016 - Dec 2017
-- Contains: account , products, sales_team, sales_pipeline
-- Covers 7,375 sales opportunities handled by 35 agents across 3 regional offices
-- Deal outcomes are tracked as Won, Lost, Engaging, or Prospecting
-- ===================================================
-- Project:       CRM sales Opportunities
-- Date Period:   Oct 2016 - Dec 2017
-- Tool:          MySQL Workbench
-- ===================================================

create database CRMsalesopportunities;
use CRMsalesopportunities;

create table CRMEQaccount
(account varchar (30),
sector varchar (30),
year_established Int,
revenue int,
employees int,
office_location varchar (50),
subsidiary_of varchar (30)
);

create table CRMEQproduct
(product varchar (20),
series varchar (10),
sales_price int 
);

Create Table CRMEQsales_pipeline
(opportunity_id varchar (20),
sales_agent varchar (50),
product varchar (20),
account varchar (50),
deal_stage varchar (20),
engage_date date,
close_date date,
close_value int,
deal_duration_days int,
engage_month varchar (10),
engage_year int,
close_month varchar (10),
close_year int
);

create table CREMQsales_team
(sales_agent varchar (50),
manager varchar (50),
regional_office varchar (50)
);

SHOW VARIABLES LIKE 'secure_file_priv';
    
    LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CRMEQsales_pipeline.csv'
INTO TABLE CRMEQsales_pipeline
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    opportunity_id,
    sales_agent,
    product,
    account,
    deal_stage,
    @engage_date,
    @close_date,
    @close_value,
    @deal_duration_days,
    @engage_month,
    @engage_year,
    @close_month,
    @close_year
)
SET
    engage_date = NULLIF(@engage_date, ''),
    close_date = NULLIF(@close_date, ''),
    close_value = NULLIF(@close_value, ''),
    deal_duration_days = NULLIF(@deal_duration_days, ''),
    engage_month = NULLIF(@engage_month, ''),
    engage_year = NULLIF(@engage_year, ''),
    close_month = NULLIF(@close_month, ''),
    close_year = NULLIF(@close_year, '');
    
    select *
from CRMEQsales_pipeline
limit 5;

SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CRMEQproduct.csv'
INTO TABLE crmeqproduct
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

TRUNCATE TABLE crmeqproduct;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CRMEQaccounts.csv'
INTO TABLE CREMQsales_team
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CRMEQsales_team.csv'
INTO TABLE CREMQsales_team
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

		      -- Overview
select 
count(distinct account)                                                                           as `Accounts`,
sum(close_value)                                                                                  as `Revenue`,       
count(*)    																					  as `Total Deals`,     
count(case when deal_stage = 'Won' then 1 end)                                                    as `Total Sold`,            
ROUND(SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END)
/ SUM(CASE WHEN deal_stage in ('Won','Lost') THEN 1 ELSE 0 END) * 100
    , 2)                                                                                         as `Win Rate`,
count(distinct Product)                                                                          as `No of Products`,
round(avg(deal_duration_days))                                                                   as `AVG deal Duration`
from CRMEQsales_pipeline;

			-- Account Analysis
-- How Many Clients do we have?
select 
count(distinct account)   as Accounts
from crmeqaccount;          

-- Which Sector do we have most Of Clients
select 
distinct Sector,
count(Account)           as Account
from crmeqaccount
group by sector
order by Account desc;

-- Biggest Accounts In Revenue and Size
select account, revenue, employees
from crmeqaccount
group by account, revenue, employees
order by revenue, employees ;

-- Which Region Do we have most Of our accounts in
select t.regional_office, count(distinct p.account) as Account
from crmeqsales_pipeline p
join cremqsales_team t on p.sales_agent = t.sales_agent
group by t.regional_office
order by Account;

-- How much do we make from each Account 
select account, sum(close_value) Revenue, round(avg(close_value)) AVG_Revenue
from crmeqsales_pipeline
group by account;

-- Which Account do we sell to Most
select  distinct a.account as Account, count(p.deal_stage) as Most_Deals
from crmeqaccount a
join crmeqsales_pipeline p on a.account = p.account
group by Account
order by Most_Deals desc;

-- How long does take to convert each Account
select distinct account as Account, round(AVG(deal_duration_days)) as AVG_Duration_Day
from crmeqsales_pipeline
group by Account
order by AVG_Duration_Day;

-- Highest Account Win Rate 
select distinct account as Account, ROUND(SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END)
/ SUM(CASE WHEN deal_stage in ('Won','Lost') THEN 1 ELSE 0 END) * 100
    , 2)  as Win_Rate
from crmeqsales_pipeline
group by Account
order by Win_Rate desc;

             -- Product Analysis
-- How many Products Do we have
Select count(distinct product) as Products
from crmeqproduct;

-- Most Expensive Product 
Select product as Products, sales_price
from crmeqproduct
group by product, sales_price
order by sales_price desc;

-- Which Product made the most revenue, was sold the most and and Win rate
select product, sum(close_value) Revenue, round(avg(close_value)) AVG_Revenue, count(product) as product_count,
ROUND(SUM(CASE WHEN deal_stage = 'Won' THEN 1 ELSE 0 END)
/ SUM(CASE WHEN deal_stage in ('Won','Lost') THEN 1 ELSE 0 END) * 100
    , 2)  as Win_rate
from crmeqsales_pipeline
group by product;

-- Which Product takes the longest time to close the deal
select product, round(avg(deal_duration_days)) as AVG_deal_duration
from crmeqsales_pipeline
group by product
order by AVG_deal_duration desc;

-- Best Product series
select p.series, 
sum(sp.close_value)                         as Total_Revenue, 
round(avg(sp.close_value))                  as AVG_Revenue,
 COUNT(CASE WHEN deal_stage = 'Won' THEN 1 END) AS products_sold,
    ROUND(
        COUNT(CASE WHEN deal_stage = 'Won' THEN 1 END) 
        / COUNT(*) * 100
    , 2) AS win_rate
from crmeqproduct p
join crmeqsales_pipeline sp on p.product = sp.product
WHERE deal_stage IN ('Won', 'Lost')
group by p.series
order by Total_Revenue desc;

-- Product Monthly Analysis
-- Which month did we sell products most and win rate 
SELECT 
    close_month,
    COUNT(CASE WHEN deal_stage = 'Won' THEN 1 END) AS products_sold,
    ROUND(
        COUNT(CASE WHEN deal_stage = 'Won' THEN 1 END) 
        / COUNT(*) * 100
    , 2) AS win_rate
FROM crmeqsales_pipeline
WHERE deal_stage IN ('Won', 'Lost')
GROUP BY close_month
ORDER BY products_sold DESC;

-- compare close_value against sales_price
SELECT
    sp.product,
    pr.sales_price AS sales_price,
    ROUND(AVG(sp.close_value), 2)  AS avg_close_value,
    ROUND(AVG(sp.close_value) - pr.sales_price, 2) AS avg_diff,
    ROUND(
        (AVG(sp.close_value) - pr.sales_price) / pr.sales_price * 100
    , 2)                           AS avg_discount
FROM crmeqsales_pipeline sp
JOIN crmeqproduct pr ON sp.product = pr.product
WHERE sp.deal_stage = 'Won'
GROUP BY sp.product, pr.sales_price
ORDER BY avg_discount;          
                
  -- Best Selling Product by sector              
select
a.sector,
sp.product,
SUM(sp.close_value) AS total_revenue,
AVG(sp.close_value) AS avg_revenue,
COUNT(*) AS products_sold
FROM crmeqaccount a
JOIN crmeqsales_pipeline sp ON a.account = sp.account
WHERE sp.deal_stage = 'Won'
GROUP BY a.sector, sp.product
ORDER BY a.sector, sp.product;
                 

-- Best Products by Region
select st.regional_office, sp.product,
sum(sp.close_value) as Total_Revenue,
avg(sp.close_value) as AVG_Revenue,
COUNT(*) as  products_sold
from cremqsales_team  st		
join crmeqsales_pipeline sp on st.sales_agent = sp.sales_agent
where sp.deal_stage = 'Won'               
group by st.regional_office, sp.product
order by st.regional_office, sp.product;

                
-- Sales Analysis
select 
avg(close_value) as AVG_Revenue,
round(sum(close_value)) as Total_Revenue
from crmeqsales_pipeline;

-- Monthly sales
select 
close_month,
sum(close_value) as Total_Revenue,
round(avg(close_value)) as AVG_Revenue
From crmeqsales_pipeline
where deal_stage = 'Won'
group by close_month
order by Total_Revenue desc;

-- Regional sales 
select st.regional_office,
sum(sp.close_value) as Total_Revenue,
avg(sp.close_value) as AVG_Revenue
from cremqsales_team  st		
join crmeqsales_pipeline sp on st.sales_agent = sp.sales_agent
where sp.deal_stage = 'Won'               
group by st.regional_office
order by Total_Revenue;

-- Account Sales
select a.account,
sum(sp.close_value) as Total_Revenue,
round(avg(sp.close_value)) as AVG_Revenue
from crmeqaccount  a		
join crmeqsales_pipeline sp on a.account = sp.account
where sp.deal_stage = 'Won'               
group by a.account
order by Total_Revenue;

			-- Sales Team analysis 
-- How many Sales Agent do we have
select count(distinct sales_agent) as sales_agent
from cremqsales_team;

-- How many sales agent do we have in each region
select 
regional_office,
count(distinct sales_agent) as sales_agent
from cremqsales_team
group by regional_office;

-- Best sales Agent 
select 
st.sales_agent, 
sum(close_value) as Total_Revenue,
round(avg(close_value)) as AVG_Revenue,
count(deal_stage) as Deals,
COUNT(CASE WHEN deal_stage = 'Won' THEN 1 END) AS products_sold,
    ROUND(
        COUNT(CASE WHEN deal_stage = 'Won' THEN 1 END) 
        / COUNT(*) * 100
    , 2) AS win_rate
from cremqsales_team st
join crmeqsales_pipeline sp on st.sales_agent = sp.sales_agent
where deal_stage IN ('Won', 'Lost')
group by st.sales_agent
order by win_rate desc;

-- Best Region 
select 
st.regional_office, 
sum(close_value) as Total_Revenue,
round(avg(close_value)) as AVG_Revenue,
count(deal_stage) as deals,
COUNT(CASE WHEN deal_stage = 'Won' THEN 1 END) AS products_sold,
    ROUND(
        COUNT(CASE WHEN deal_stage = 'Won' THEN 1 END) 
        / COUNT(*) * 100
    , 2) AS win_rate
from cremqsales_team st
join crmeqsales_pipeline sp on st.sales_agent = sp.sales_agent
where deal_stage IN ('Won', 'Lost')
group by st.regional_office
order by win_rate desc;


SET SQL_SAFE_UPDATES = 0;

UPDATE crmeqsales_pipeline
SET product = 'GTX Pro'
WHERE product = 'GTXPro';




