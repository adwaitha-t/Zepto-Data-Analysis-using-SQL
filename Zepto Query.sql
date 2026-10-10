-- Data Exploration

-- Count of Rows
SELECT COUNT(*) FROM zepto_v2

-- Sample Data

SELECT TOP 10* 
FROM zepto_v2

--null values

SELECT * FROM zepto_v2
WHERE name is NULL
OR
category is NULL
OR 
mrp is NULL
OR
discountPercent is NULL
OR
discountedSellingPrice is NULL
or
availableQuantity is NULL
or
weightInGms is null
or
outOfStock is null
or
quantity is null

-- Different product Categories

SELECT DISTINCT category
from zepto_v2
order by Category;

ALTER TABLE zepto_v2
ADD id INT IDENTITY(1,1);

--products in stocks vs out of stock
select outOfStock, COUNT(id)
from zepto_v2
group by outOfStock

--product names present multiple times
select name, count(id) as "Number of SKUs"
from zepto_v2
group by name
having count(id) > 1
order by count(id) desc

-- Data Cleaning
-- Products with price = 0

select * from zepto_v2
where mrp=0 or discountedSellingPrice=0

delete from zepto_v2
where mrp =0

--convert paise to rupees
update zepto_v2
set mrp = mrp /100,
discountedsellingprice = discountedSellingPrice /100;

--data analysis

--Q1. Find the top 10 best value products based on the discount percentage.
SELECT DISTINCT TOP 10
    name,
    mrp,
    discountpercent
FROM zepto_v2
ORDER BY discountpercent DESC;

--Q2.What are the products with hight mrp but out of stock:
select distinct top 10 (name), mrp
from zepto_v2
where outOfStock = 1 
order by mrp desc;

-- Q3. Calculate Estimated Revenue for each category

select category,
sum(discountedsellingprice * availablequantity) as total_revenue
from 
zepto_v2
group by Category
order by total_revenue;

--Q4. Find all products where MRP is great than 500 and discount is less than 10.
select distinct name, mrp, discountPercent
from zepto_v2
where mrp > 5 and discountPercent < 10
order by mrp desc, discountPercent desc;

--Q5. Identify the top 5 categories offering the highest average discount percentage

select top 5 category,
round(avg(discountpercent),2) as avg_discount
from zepto_v2
group by Category
order by avg_discount desc;

--Q6. Find the price per gram for products above 100g and sort by best value

select distinct name,weightingms, discountedsellingprice,
round(discountedsellingprice/weightingms,2) as price_per_gram
from zepto_v2
where weightInGms >= 100
order by price_per_gram;

--Q7. Group the products into categories like low, medium, bulk

select distinct name, weightingms,
case when weightingms < 1000 then 'low'
when weightingms < 5000 then 'medium'
else 'bulk'
end as weight_category
from zepto_v2;

--Q8. What is the total inventory weight per category


SELECT
    category,
    SUM(CAST(weightInGms AS BIGINT) * availablequantity) AS total_weight
FROM zepto_v2
GROUP BY category
ORDER BY total_weight DESC;


