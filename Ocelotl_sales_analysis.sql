-- The sales territory we will be analyzing is the NorthEast region. 
-- Regional Director: Michael Jarvis,State:New Jersey,Sales Manager: Miami Vue

/* 1.) What is total revenue overall for sales in the assigned territory, plus the start date and end date
that tell you what period the data covers?*/

-- Total store sales
-- '5175417.99'
select sum(Sale_Amount) -- agg function to get total of sales amount
from store_sales -- from table store_sales
where Store_ID in (SELECT StoreId FROM store_locations 
where state like "New Jersey"); -- use subquery to give me all the store id in new jersey territory

-- finding starting and ending dates
-- store sales dates
select min(Transaction_Date)as start_date,max(Transaction_Date) as end_date -- agg to give me smallest and largest dates
from store_sales;

-- start_date, end_date
-- '2022-01-01', '2025-12-31'


/* 2.) What is the month by month revenue breakdown for the sales territory?*/

-- store sales monthly revenue
select date_format(transaction_Date,'%Y-%m') as month,sum(Sale_Amount) as revenue -- select month,day and sum total of sale amount
from store_sales -- table store_sales
JOIN store_locations -- join store locations table
on store_sales.Store_ID = store_locations.StoreId -- matching columns
where store_locations.State like "New Jersey" -- filter to use where  in store location table with state new jersey to be able to get 
group by month
order by month;

/* 3.) Provide a comparison of total revenue for the specific sales territory and the region it belongs to.*/
  
   -- using join to get total revenue for states in region for store_sales

 select sl.state,sum(Sale_Amount) as revenue
 from store_sales as s
join store_locations as sl
on s.Store_ID = sl.StoreId
where sl.State in ('Maryland','Massachusetts','Maine','New Jersey')
group by sl.state
order by revenue desc;
 --  '19062121.11' TOTAL
 -- 'Maryland', '11451615.09'
-- 'Massachusetts', '5733256.27'
--  'Maine', '1877249.75'
-- 'New Jersey', '5175417.99'  #3


/*4.) What is the number of transactions per month and average transaction size by product category
for the sales territory?*/

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
group by month,Category
-- reason I included order by is to see what products we arent as strong in for avg transaction size,
-- in order to focus on those product/categories.
order by avg_trans_size asc;

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

-- FOCUS ON STORE_ID: 837

 
/*6.) What is your recommendation for where to focus sales attention in the next quarter?
-- By the data it shows we are 3rd in our region when it come to total revenue My recommendation is to focus on books,art supplies .While viewing the data and 
investigating  on certain categories, 
We've discovered those categories are doing poorly throught the year in transaction count and average transaction size . We should introduce a certain deal,bogo,promotion
 for these products to have them in higher demand when customers visit.2ND focus will be store_id 837 based off question 5 that we worked in it shows store 837 performance
 is very low compared to the rest of the store in our territory.