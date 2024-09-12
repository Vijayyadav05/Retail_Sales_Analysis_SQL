create database if not exists Retail_sales;
use Retail_sales;
create table sales_analysis(
transactions_id	int,
sale_date date,	
sale_time time,	
customer_id	int,
gender	varchar(10),
age	int,
category varchar(20),
quantiy	int,
price_per_unit float,
cogs float,	
total_sale float);

select * from sales_analysis;

select count(*) from sales_analysis;

# set transactions_id as Primary key

alter table sales_analysis add primary key (transactions_id);

Describe sales_analysis;

----------- Data Cleaning ----------

-- Checking for the Null values in are Data 

Select * from sales_analysis
where 
	transactions_id is null
    or
    sale_date is null
    or
    sale_time is null
    or
    customer_id is null
    or
    gender is null
    or
    age is null
    or
    category is null
    or
    quantiy is null
    or
    price_per_unit is null
    or
    cogs is null
    or
    total_sale is null;
    
-- Checking for Duplicates records in Dataset
    
with duplicates_cte as (
select *, row_number() over(partition by transactions_id,customer_id) as rw_numbers
from sales_analysis)
select * from duplicates_cte 
where rw_numbers >1;

-------- Data Exploration ----------

-- How many sales we have?
select count(*) from sales_analysis;

-- How many Unique customers we have in are records?
select count(Distinct customer_id) from sales_analysis;
-- How many category we have?
select distinct category from sales_analysis;

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05 
select * from sales_analysis 
where sale_date ='2022-11-05';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold
-- is more than 4 in the month of Nov-2022
select * from sales_analysis
where category = 'Clothing'
    and 
    Date_Format(sale_date, '%Y-%m') = '2022-11'
    and
    quantiy >= 4;
select * from sales_analysis;
-- Write a SQL query to calculate the total sales (total_sale) for each category
select category, sum(total_sale) as 'Total Sales' from sales_analysis 
group by category;
-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) as 'Avg age' from sales_analysis
 where category ='Beauty';

-- Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from sales_analysis
where total_sale > 1000;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select gender,category,count(transactions_id) as 'Number of Transactions' from sales_analysis
group by gender,category order by category;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
with monthly_sales as (
select YEAR(sale_date)as year,MONTH(sale_date) as month,Avg(Total_sale) as avg_monthly_sales
from sales_analysis
GROUP BY YEAR(sale_date), MONTH(sale_date)),
ranked_sales as (
select year,month,avg_monthly_sales,
ROW_NUMBER() OVER (PARTITION BY year ORDER BY avg_monthly_sales DESC) AS rank_in_year
FROM monthly_sales)
select year,month,round(avg_monthly_sales,2) FROM ranked_sales
WHERE rank_in_year = 1 ORDER BY year, month;

-- Write a SQL query to find the top 5 customers based on the highest total sales. 
select customer_id as Customers,sum(total_sale) as 'Total Sales' from sales_analysis
group by customer_id order by 2  desc limit 5;

-- Write a SQL query to find the number of unique customers who purchased items from each category.
select count(distinct customer_id) as 'Unique Customers', category from sales_analysis
group by category; 

-- Write a SQL query to create each shift and number of orders
-- (Example Morning <12, Afternoon Between 12 & 17, Evening >17)
select * from sales_analysis;
select  case when hour(sale_time) < 12 then 'Morning'
		       when hour(sale_time) between 12 and 17 then 'Afternoon'
               else 'Evening' end as Shift, count(*) as 'Number of Orders'
from sales_analysis group by Shift order by 2 desc;

-----------------------  END OF PROJECT --------------------------

