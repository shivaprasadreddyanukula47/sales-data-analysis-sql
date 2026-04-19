use sales_dataset;
select * from orders1;
select * from customers;
select * from products;

-- 1.What is the total number of orders? 
select count(order_id) as total_orders from orders1;

-- 2.What is the total number of distinct products sold? 

select count(distinct product_id) as total_number_products from orders1;

-- 3.What is the total revenue generated?

select sum(total_sales ) as total_revenue from orders1;

-- 4.What is the month-wise total sales? 
select date_format(order_date,'%Y-%m') month_wise, sum(total_sales) as total_sales from
orders1 group by date_format(order_date,'%Y-%m');

-- 5.What is the year-wise total sales? 

select year(order_date) as year_wise ,sum(total_sales) as total_sales from orders1
group by year(order_date);

-- 6.Which month recorded the highest sales? 
select date_format(order_date,'%Y-%m') AS month_wise,sum(total_sales) as highest_sales 
from orders1
group by  month_wise
order by highest_sales desc
limit 1;
-- 7. What are the total sales in the last 3 months? 
select  sum(total_sales) as total_sales_in_3_months from orders1
where order_date>=current_date - interval 3 month;

-- 8.Calculate day-over-day sales and identify the difference from the previous day

select date_format(order_date,'%Y-%m-%d') as order_date,total_sales,lag(total_sales) over(order by order_date asc) as previous_sales,
total_sales-lag(total_sales) over(order by order_date asc) as diff_sales
from orders1;

-- 9.Compare current month sales with previous month sales 
select month_wise,total_sales,lag(total_sales) over(order by month_wise asc) as previous_sales, 
total_sales - lag(total_sales) over(order by month_wise asc) as diff_sales from
(select date_format(order_date,'%Y-%m') as month_wise,sum(total_sales) as total_sales from orders1
group by month_wise)t;

-- 10.Which product generated the highest revenue? 

select p.product as product_name ,sum(o.total_sales) as highest_revenue from orders1 o 
join products p on o.product_id = p.product_id
group by product_name
order by highest_revenue desc
limit 1;
-- 11.Which product generated the lowest revenue? 
select p.product as product_name ,sum(o.total_sales) as highest_revenue from orders1 o 
join products p on o.product_id = p.product_id
group by product_name
order by highest_revenue asc
limit 1;

-- 12.What is the total sales for each product? 
select p.product as product ,sum(o.total_sales) as total_sales from orders1 o
join products p on o.product_id = p.product_id
group by p.product;

-- 13.What is the average sales per product? 
select p.product as product ,round(avg(o.total_sales),0) as avg_sales from orders1 o
join products p on o.product_id = p.product_id
group by p.product;

-- 14 Identify the top 3 products by revenue 
select p.product_id, p.product as product ,sum(o.total_sales) as top_3_sales from orders1 o
join products p on o.product_id = p.product_id
group by p.product_id,p.product 
order by top_3_sales desc
limit 3;

-- OR using window function...
select product_id,product,total_revenue from(
select p.product_id as product_id,p.product as product ,sum(o.total_sales) as total_revenue,
dense_rank()over(order by sum(o.total_sales) desc) as rnk from orders1 o
join products p on o.product_id = p.product_id 
group by p.product_id,p.product)t
 where rnk<=3;

-- 15 Identify the bottom 3 products by revenue 

select p.product_id, p.product as product ,sum(o.total_sales) as lowest_sales from orders1 o
join products p on o.product_id = p.product_id
group by p.product_id,p.product 
order by lowest_sales asc
limit 3;

-- 16.Which product has the highest quantity sold? 

select p.product as product ,p.product_id,sum(o.quantity) as highest_quantity from orders1 o
join products p on o.product_id = p.product_id 
group by p.product_id,p.product
order by highest_quantity desc
limit 1;

-- 17.Which product has the highest price? 
select p.product as product ,p.product_id,max(o.price) as highest_price,o.quantity from orders1 o
join products p on o.product_id = p.product_id 
group by p.product_id,p.product,o.quantity
order by highest_price desc
limit 1;

-- 18. What is the total sales per customer?
select   customer_id,sum(total_sales) as total_sales from orders1
GROUP BY customer_id;

-- 19.What is the average total sales per customer?
select customer_id,round(avg(total_sales),0)as avg_sales from orders1
group by customer_id;

-- 20  what is average sales across customers
SELECT ROUND(AVG(total_sales), 0) AS avg_sales_per_customer
FROM (
    SELECT customer_id,
           SUM(total_sales) AS total_sales
    FROM orders1
    GROUP BY customer_id
) t;

-- 21 How many orders has each customer placed?
select customer_id, count(  distinct order_id) as orders from orders1
group by customer_id;

 -- 22 Identify the top 5 customers by total revenue
 
 select customer_id,total_sales as total_revenue
 from(
 select customer_id,sum(total_sales) as total_sales,rank() over(order by sum(total_sales) desc) as rnk
 from orders1
 group by customer_id
 )t 
 where rnk<=5;
 --  OR
 select customer_id,sum(total_sales) total_revenue from orders1
 group by customer_id
 order by total_revenue desc
 limit 5;
 
 -- 23 What is the total revenue generated by each city?
 
 SELECT CITY ,SUM(TOTAL_SALES) AS TOTAL_REVENUE FROM ORDERS1
 GROUP BY CITY;
 
 -- 24.What is the total number of orders per city?
select city , count(distinct order_id) as total_number_orders from orders1
group by city;

-- 25 Which region generated the highest revenue?
select region, sum(total_sales) as highest_revenue from orders1
group by region 
order by highest_revenue desc
limit 1;
-- or window function

select region,highest_revenue from ( select region ,sum(total_sales) as highest_revenue ,
row_number()over(order by sum(total_sales) desc) as rnk from orders1
group by region
) t where rnk =1;
  

-- 26.What is the product-wise and region-wise total sales?

select p.product as product ,o.region as region_wise,sum(o.total_sales) as total_sales from orders1 o
join products p on o.product_id = p.product_id
group by p.product,o.region;

-- 27 Which payment method generated the highest revenue?
select payment_method , sum(total_sales) as highest_sales from orders1
group by payment_method 
order by highest_sales desc
limit 1;

-- 28 What is the total sales per payment method?
select payment_method ,sum(total_sales) as total_Sales from orders1
group by payment_method;

-- 29.Show customer name and their total sales

select c.customer_name as customer_name,sum(o.total_sales) as total_sales from orders1 o
join customers c on o.customer_id = c.customer_id
group by c.customer_name;

-- 30 Find customer name, product name, and total sales?
select a.customer_id,a.customer_name as customer_name,b.product as product_name,sum(o.total_sales) as total_sales from orders1 o
join customers a on o.customer_id = a.customer_id 
join products b on o.product_id = b.product_id
group by a.customer_id,a.customer_name,b.product
order by a.customer_name ,total_sales desc;

-- 31. List top 5 customers along with their total revenue

select c.customer_id,c.customer_name as customer_name ,sum(o.total_sales) as total_sales from orders1 o
join customers c on o.customer_id = c.customer_id 
group by c.customer_id,c.customer_name 
order by total_sales desc
limit 5;

-- 32. Show region-wise sales with product names
select o.region as region ,p.product as product ,sum(o.total_sales)as total_sales from orders1 o
join products p on o.product_id = p.product_id
group by o.region,p.product
order by total_sales desc;

-- 33.Find which customer purchased which product the most
select c.customer_name as customer ,p.product as product ,sum(o.quantity) as total_quantity from orders1 o
join customers c on o.customer_id = c.customer_id 
join products p on o.product_id = p.product_id
group by c.customer_name ,p.product
order by total_quantity desc 
limit 1;
-- 34. Display customer name, order date, and sales
select c.customer_name as customer_name,o.order_date as order_date, o.total_sales as total_sales from orders1 o
join customers c on o.customer_id = c.customer_id;

-- 35. Show product performance across different regions

SELECT p.product AS product,
       o.region AS region,
       SUM(o.quantity) AS total_quantity
FROM orders1 o
JOIN products p 
    ON o.product_id = p.product_id
GROUP BY p.product, o.region;

-- 36. Find total sales per customer and per product combination

select c.customer_id as customer_id ,c.customer_name as customer_name,p.product as product,
sum(o.total_sales) as total_sales from orders1 o
join customers c on o.customer_id = c.customer_id 
join products p on o.product_id = p.product_id 
group by c.customer_id,c.customer_name,p.product;

-- 37. Identify customers who made purchases in multiple regions

select customer_id ,count(distinct region) as number_regions
 from orders1
 group by customer_id 
 having number_regions > 1;
 -- 38. Rank products based on total sales
select product,total_sales,rnk from (
select p.product as product,sum(o.total_sales) as total_sales,
dense_rank() over(order by sum(o.total_sales) desc) as rnk from orders1 o
   join products p on o.product_id = p.product_id
    group by p.product )t;

-- 39. Find top 3 products in each region
SELECT region, product, total_sales
FROM (
    SELECT o.region,
           p.product,
           SUM(o.total_sales) AS total_sales,
           RANK() OVER (PARTITION BY o.region 
                        ORDER BY SUM(o.total_sales) DESC) AS rnk
    FROM orders1 o
    JOIN products p 
        ON o.product_id = p.product_id
    GROUP BY o.region, p.product
) t
WHERE rnk <= 3;

-- 40. Calculate running total of sales by date
 SELECT order_date,
       total_sales,
       SUM(total_sales) OVER (ORDER BY order_date) AS running_sales
FROM orders1;
 
 -- 41 Find month-over-month growth percentage

 select month_wise,total_sales,lag(total_sales) over(order by month_wise) as pre_sales,
 concat(ROUND((total_sales - LAG(total_sales) OVER (ORDER BY month_wise)) 
       / LAG(total_sales) OVER (ORDER BY month_wise) * 100, 2
       ), '%') AS mom_growth_percentage from
 (select month(order_date) as month_wise,sum(total_sales) as total_sales
 from orders1
 group by month(order_date))t;
 
  -- 42.Identify repeat customers?
  select customer_id,count(*) from orders1
  group by customer_id 
  having count(*)>1;
  
  
-- 43 .Find customers who never used a specific payment method

select customer_name from customers where customer_id not in
                ( select customer_id from orders1 
                          where customer_id ="UPI"
                                                  );
                                                  
                                                  
                                                  
