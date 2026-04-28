-- The sales territory we will be analyzing is the NorthEast region. 
-- Regional Director: Michael Jarvis,State:New Jersey,Sales Manager: Miami Vue

/* 1.) What is total revenue overall for sales in the assigned territory, plus the start date and end date
that tell you what period the data covers?*/

-- Total revenues online and store sales : using seperate queries and adding together +'
select 
(SELECT sum(Sale_Amount)
from store_sales
where Store_ID in (SELECT StoreId FROM store_locations
where state like "New Jersey")) +
(select sum(SalesTotal)
from online_sales
where ShiptoState like "New Jersey") as total_revenue;
  -- Total Revenue '7400979.24'
  
-- finding starting and ending dates
-- store sales dates
select min(Transaction_Date)as start_date,max(Transaction_Date) as end_date
from store_sales;
-- start_date, end_date
-- '2022-01-01', '2025-12-31'

-- online sales dates
select min(date) as start_date,max(date) as end_date
from online_sales
where ShiptoState like "New Jersey";
-- start_date	end_date
-- 2022-02-02	2025-12-31

-- region territy results for total revenue and start,end dates
-- Total Revenue: 7400979.24'
-- start date  2022-01-01
-- end date 2025-12-31

/* 2.) What is the month by month revenue breakdown for the sales territory?*/


select month,sum(revenue)
from(
-- Online sales monthly revenue
SELECT date_format(date,'%Y-%m') as month,sum(SalesTotal) as revenue
FROM online_sales
where ShiptoState = "New Jersey"
group by month 

-- Do not use union reason it deleted duplicate values and we dont want that so union all is best option.

UNION ALL

-- store sales monthly revenue
select date_format(transaction_Date,'%Y-%m') as month,sum(Sale_Amount) as revenue
from store_sales
JOIN store_locations
on store_sales.Store_ID = store_locations.StoreId
where store_locations.State like "New Jersey"
group by month
) as combined
group by month
order by month;

/* 3.) Provide a comparison of total revenue for the specific sales territory and the region it belongs to.*/
select 
(SELECT sum(Sale_Amount)
from store_sales
where Store_ID in (SELECT StoreId FROM store_locations
where state like "New Jersey")) +
(select sum(SalesTotal)
from online_sales
where ShiptoState like "New Jersey") as total_revenue;
  -- Total Revenue '7400979.24' jersey area
  
   -- using join to get total revenue for states in region

 select sum(Sale_Amount) as revenue
 from store_sales as s
join store_locations as sl
on s.Store_ID = sl.StoreId
where sl.State in ('Maryland','Massachusetts','Maine');
 --  ''19062121.11' TOTAL

-- used subqueries to find total revenue for the north east region
SELECT  sum(SalesTotal)
FROM online_sales
where ShiptoState in (SELECT state
FROM management
where Region like "Northeast");
-- '8609433.67' TOTAL




/*4.) What is the number of transactions per month and average transaction size by product category
for the sales territory?*/
-- online sales transaction counts,avg trasanction size
select date_format(os.date,'%Y-%m')as month ,Category,count(SalesTotal) as transaction_counts,avg(os.SalesTotal) as avg_transaction_size
from online_sales as os
join products as p
on os.ProdNum = p.ProdNum 
join inventory_categories as ic
on ic.Categoryid = p.Categoryid
where ShiptoState like "New Jersey"
group by month,Category;

-- store sales transaction counts,avg transaction size
select date_format(transaction_Date,'%Y-%m')as month,Category,count(*) as trans_count,avg(ss.Sale_Amount) as avg_trans_size
from store_sales as ss
join products as p
on ss.Prod_Num = p.ProdNum
join inventory_categories as ic
on ic.Categoryid = p.Categoryid
-- used subquuey in order to find storeid related to my state territory
where ss.Store_ID in (SELECT StoreId
FROM store_locations
where state like "New Jersey")
group by month,Category;



/*5.) Can you provide a ranking of in-store sales performance by each store in the sales territory, or a
ranking of online sales performance by state within an online sales territory?*/
 select Store_ID,sum(Sale_Amount) as total_amount,
 CASE
 when sum(Sale_Amount)  <= 207725.00 then "Poor performance"
 when sum(Sale_Amount)  BETWEEN 207725.00 AND  415450.00 then "Medium Performance"
 else "GREAT PERFORMANCE"
 END AS PERFORMANCE_RANKING
 
 from store_sales
 WHERE Store_ID in(SELECT StoreId
FROM store_locations
where state like "New Jersey")
group by Store_ID
order by total_amount desc;

 

/*6.) What is your recommendation for where to focus sales attention in the next quarter?
*/