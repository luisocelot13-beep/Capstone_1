-- SELECT, Filtering & Sorting--

/*1. Create a list of all transactions that took place on January 15, 2024, sorted by sale amount from
highest to lowest.*/
SELECT * 
FROM store_sales
where Transaction_Date = '2024-01-15'
order by Sale_Amount desc;


/*2. Which transactions had a sale amount greater than $500? Display the transaction date, store ID,
product number, and sale amount.*/
select Transaction_Date,Store_ID,Prod_Num,Sale_Amount
from store_sales
where Sale_Amount > 500;

/*3. Find all products whose product number begins with the prefix 105250. What category do they
belong to*/

select Categoryid
from products
where ProdNum like '105250%';

-- Aggregation--

/*4. What is the total sales revenue across all transactions? What is the average transaction amount?*/
 select sum(Sale_Amount) as total_sale ,avg(Sale_Amount) as avg_sale
 from store_sales;

/*5. How many transactions were recorded for each product category? Which category has the most
transactions?*/

select Prod_Num,count(*)
from store_sales
group by Prod_Num 
order by count(*) desc;

/*6. Which store generated the highest total revenue? Which generated the lowest?*/

select Store_ID,sum(Sale_Amount) as revenue
from store_sales
group by Store_ID 
order by revenue asc
limit 1;
-- highest total

select Store_ID,sum(Sale_Amount) as revenue
from store_sales
group by Store_ID 
order by revenue desc
limit 1;
-- lowest total


/*7. What is the total revenue for each category, sorted from highest to lowest?*/

select Prod_Num,sum(Sale_Amount) as revenue
from store_sales
group by Prod_Num 
order by revenue desc;

/*8. Which stores had total revenue above $50,000? (Hint: you'll need HAVING.)*/

select Store_ID,sum(Sale_Amount) as revenue
from store_sales
group by Store_ID 
having revenue > 50000;

--     Joins -----

/*9. Find all sales records where the category is either "Textbooks" or "Technology & Accessories."*/

select ic.Category,sum(Sale_Amount)
from store_sales as ss
join products as p
on ss.Prod_Num = p.ProdNum
join inventory_categories as ic
on p.Categoryid = ic.Categoryid
where ic.Category like "Textbooks" or 'Technology & Accessories'
group by ic.Category;

/*10. List all transactions where the sale amount was between $100 and $200, and the category was
"Textbooks."*/

select *
from store_sales as ss
join products as p
on ss.Prod_Num = p.ProdNum
join inventory_categories as ic
on p.Categoryid = ic.Categoryid
where ss.Sale_Amount between 100 and 200
and ic.Category like 'Textbooks';

/*11. Write a query that displays each store's total sales along with the city and state where that store is
located.*/

select ss.Store_ID,sl.State,sl.StoreLocation,sum(Sale_Amount) as revenue
from store_sales as ss
join store_locations as sl
on ss.Store_ID = sl.StoreId
group by ss.Store_ID;

/*12. For each sale, display the transaction date, sale amount, city, state, and the name of the store
manager responsible for that state.*/
select ss.Transaction_Date,ss.Sale_Amount,sl.State,sl.StoreLocation,m.SalesManager
from store_sales as ss
join store_locations as sl
on ss.Store_ID = sl.StoreId
join management as m
on sl.State = m.State;

/*13. Write a query that shows total sales by region. Which region generates the most revenue?*/

select m.Region,sum(ss.Sale_Amount) as revenue
from store_locations as sl
join store_sales as ss
on sl.StoreId = ss.Store_ID
join management as m
on sl.State = m.State
group by m.Region
order by revenue desc
limit 1;

/*14. For states that have a preferred shipper listed in Shipper_List, show the total sales alongside the
preferred shipper and volume discount.*/

select sl.id,sum(ss.Sale_Amount),sl.PreferredShipper,sl.VolumeDiscount
from store_sales as ss
join shipper_list as sl
on ss.id = sl.id
where sl.id between 1 and 29
group by sl.id;

/*15. Are there any states with sales data that do not appear in Shipper_List?*/
-- all states with sales data are present in the shipper list.

select distinct sl.state	
from store_sales as ss
join store_locations as sl
on ss.Store_ID	= sl.StoreId
left join shipper_list as sh
on sl.state = sh.ShiptoState
where sh.ShiptoState is null;

/*16. Display total revenue by regional director*/

select m.RegionalDirector,sum(Sale_Amount) as revenue
from store_sales as ss
join store_locations as sl
on ss.Store_ID = sl.StoreId
join management as m
on sl.State = m.State
group by m.RegionalDirector;

-- Subqueries
/*17. Using a subquery, find all transactions from stores located in Texas.*/
select *
from store_sales
where Store_ID in (select Store_ID from store_locations
where state like 'Texas');

/*18. Which stores had total sales above the average store revenue? (Hint: use a subquery to calculate the
average first.)*/

select Store_ID,sum(Sale_Amount)
from store_sales
group by Store_ID
having sum(Sale_Amount) >
(select avg(Sale_Amount)
from store_sales);

/*19. Find the top 5 highest-grossing stores, then use that result to look up their city and state from
Store_Locations.*/
SELECT sl.StoreId, sl.StoreLocation, sl.State
FROM store_locations sl
JOIN (
  SELECT Store_ID
  FROM store_sales
  GROUP BY Store_ID
  ORDER BY SUM(Sale_Amount) DESC
  LIMIT 5
) AS top5
  ON sl.StoreId = top5.Store_ID;


/*20. Write a query using a subquery to find all sales records from stores managed by the Northeast
region's store managers.*/
select *
from store_sales as ss
join store_locations as sl
on  ss.Store_ID = sl.StoreId
where sl.state in 

(SELECT state
FROM sample_sales.management
where region like 'Northeast')