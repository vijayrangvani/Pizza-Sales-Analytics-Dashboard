-- A. KPI 

-- 1. Total Revenue:

select Round(sum(total_price),2) as [Total Revenue]
from pizza_sales;

-- 2. Average Order Value

select sum(total_price)/count(distinct order_id) as [Average Order Value]
from pizza_sales;

-- 3. Total Pizzas Sold

select sum(quantity) AS  [Total Pizzas Sold]
from pizza_sales;

-- 4. Total Orders

select count(distinct order_id) as [Total Orders]
from pizza_sales;

-- 5. Average Pizzas Per Order

select 
		cast(
				cast(sum(quantity) as decimal(10,2))/
				cast(count(distinct order_id) as decimal(10,2))
				as decimal(10,2)
			  ) 
		as [Average Pizzas Per Order]
from pizza_sales;

-- B. Daily Trend for Total Orders
 select 
		datename(WEEKDAY,order_date) as [Order Day],
		count(distinct order_id) as [Total Orders]
 from pizza_sales
 group by datename(WEEKDAY,order_date);

 -- C. Hourly Trend for Orders

select 
		datepart(HH,order_time) as [Order Hours],
		count(distinct order_id) as [Total Orders]
from pizza_sales
group by datepart(HH,order_time)
order by [Order Hours];

-- D. % of Sales by Pizza Category

select 
		pizza_category,
		round(sum(total_price),2) as total_revenue,
		concat(cast(sum(total_price)*100/(select sum(total_price) from pizza_sales) as decimal(10,2)),'%') as PCT
from pizza_sales
group by pizza_category;

-- E. % of Sales by Pizza Size

select 
		pizza_size,
		round(sum(total_price),2) as [Sales],
	    concat(cast(sum(total_price)*100 /(select sum(total_price) from pizza_sales) as decimal(10,2)),'%') as PCT
from pizza_sales
group by pizza_size
order by PCT desc;

-- F. Total Pizzas Sold by Pizza Category

select 
		pizza_category,
		sum(quantity) as [Total Pizzas Sold]
from pizza_sales
group by pizza_category
order by  [Total Pizzas Sold] desc;

-- G. Top 5 Best Sellers by Total Pizzas Sold

with top_pizza as(
select 
		pizza_name,
		sum(quantity) as [Total Pizza Sold],
		ROW_NUMBER() over(order by sum(quantity) desc) as rnk
from pizza_sales
group by pizza_name)
select pizza_name,[Total Pizza Sold]
from top_pizza
where rnk <=5;

-- H. Bottom 5 Best Sellers by Total Pizzas Sold

select top(5)
		pizza_name,
		sum(quantity) as [Total Pizza Sold]
from pizza_sales
group by pizza_name
order by [Total Pizza Sold];
