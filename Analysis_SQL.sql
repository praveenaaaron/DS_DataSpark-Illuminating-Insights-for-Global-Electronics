
use CUSTOMER_SALE_EDA;
select * from CUSTOMER_DETAILS;
select * from EXCHANGE_DETAILS;
select * from PRODUCT_DETAILS;
select * from SALES_DETAILS;
select * from STORE_DETAILS;


describe  SALES_DETAILS;
describe  CUSTOMER_DETAILS;

-- change dtypes to date --
-- customer table
update CUSTOMER_DETAILS set Birthday = str_to_date(Birthday,"%m/%d/%Y");
alter table CUSTOMER_DETAILS modify column Birthday DATE;


-- sales table
update SALES_DETAILS set Order_Date = str_to_date(Order_Date,"%m/%d/%Y");
alter table SALES_DETAILS modify column Order_Date DATE;

-- stores table
describe  STORE_DETAILS;
update STORE_DETAILS set Open_Date = str_to_date(Open_Date,"%m/%d/%Y");
alter table STORE_DETAILS modify column Open_Date DATE;

-- exchange rate table
update EXCHANGE_DETAILS set Date = str_to_date(Date,"%Y-%m-%d");
alter table EXCHANGE_DETAILS modify column Date DATE;


update STORE_DETAILS set Open_Date = str_to_date(Open_Date,"%m/%d/%Y");
alter table STORE_DETAILS modify column Open_Date DATE;

-- queries to get insights from 5 tables

-- 1.overall female count
select count(Gender) as Female_count from CUSTOMER_DETAILS 
where Gender="Female";

-- 2.overall male count
select count(Gender) as Male_count from CUSTOMER_DETAILS 
where Gender="Male";

-- 3.count of customers in country wise
select sd.Country,count(distinct c.CustomerKey)  as customer_count 
from SALES_DETAILS c join STORE_DETAILS sd on c.StoreKey=sd.StoreKey
group by sd.Country order by customer_count desc;

-- 4.overall count of customers
select count(distinct s.CustomerKey)  as customer_count 
from SALES_DETAILS s;

-- 5.count of stores in country wise
select Country,count(StoreKey) from STORE_DETAILS
group by Country order by count(StoreKey) desc;

-- 5.store wise sales
select s.StoreKey,sd.Country,sum(Unit_Price_USD*s.Quantity) as total_sales_amount from PRODUCT_DETAILS pd
join sales_details s on pd.ProductKey=s.ProductKey 
join STORE_DETAILS sd on s.StoreKey=sd.StoreKey group by s.StoreKey,sd.Country;

-- 6.overall selling amount
select sum(Unit_Price_USD*sd.Quantity) as total_sales_amount from PRODUCT_DETAILS pd
join SALES_DETAILS sd on pd.ProductKey=sd.ProductKey ;

-- 7. brand count
select Brand ,count(Brand) as brand_count from PRODUCT_DETAILS group by  Brand;

-- 8.cp and sp diffenecnce and profit
select Unit_price_USD,Unit_Cost_USD,round((Unit_price_USD-Unit_Cost_USD),2) as diff,
round(((Unit_price_USD-Unit_Cost_USD)/Unit_Cost_USD)*100,2) as profit_percent
from PRODUCT_DETAILS;

-- 9. brand wise selling amount
select Brand,round(sum(Unit_price_USD*sd.Quantity),2) as sales_amount
from PRODUCT_DETAILS pd join SALES_DETAILS sd on pd.ProductKey=sd.ProductKey group by Brand;

-- 10.Subcategory wise selling amount
select Subcategory,count(Subcategory) from PRODUCT_DETAILS group by Subcategory;


select Subcategory ,round(sum(Unit_price_USD*sd.Quantity),2) as TOTAL_SALES_AMOUNT
from PRODUCT_DETAILS pd join sales_details sd on pd.ProductKey=sd.ProductKey
 group by Subcategory order by TOTAL_SALES_AMOUNT desc;
 
 
 -- 11.country overall wise sales
select s.Country,sum(pd.Unit_price_USD*sd.Quantity) as total_sales from PRODUCT_DETAILS pd
join SALES_DETAILS sd on pd.ProductKey=sd.ProductKey 
join STORE_DETAILS s on sd.StoreKey=s.StoreKey group by s.Country ;


select s.Country,count(DISTINCT s.StoreKey),sum(pd.Unit_price_USD*sd.Quantity) as total_sales from PRODUCT_DETAILS pd
join SALES_DETAILS sd on pd.ProductKey=sd.ProductKey 
join STORE_DETAILS s on sd.StoreKey=s.StoreKey group by s.Country ;

-- 12.year wise brand sales
select year(Order_Date),pd.Brand,round(SUM(Unit_price_USD*sd.Quantity),2) as year_sales FROM SALES_DETAILS sd
join PRODUCT_DETAILS pd on sd.ProductKey=pd.ProductKey group by year(Order_Date),pd.Brand;

-- 13.overall sales with quatity
select Brand,sum(Unit_Price_USD*sd.Quantity) as sp,sum(Unit_Cost_USD*sd.Quantity) as cp,
(SUM(Unit_Price_USD*sd.Quantity) - SUM(Unit_Cost_USD*sd.Quantity)) / SUM(Unit_Cost_USD*sd.Quantity) * 100 as profit 
from PRODUCT_DETAILS pd join SALES_DETAILS sd on sd.ProductKey=pd.ProductKey
group by Brand;

-- 14.month wise sales with quatity
select month(Order_Date),sum(Unit_Price_USD*sd.Quantity) as sp_month from SALES_DETAILS
 sd join PRODUCT_DETAILS pd on sd.ProductKey=pd.ProductKey
group by month(Order_Date);

-- 15.month and year wise sales with quatity
select month(Order_Date),year(Order_Date),Brand,sum(Unit_Price_USD*sd.Quantity) as sp_month from SALES_DETAILS
 sd join PRODUCT_DETAILS pd on sd.ProductKey=pd.ProductKey
group by month(Order_Date),year(Order_Date),Brand;
 
 --  16.year wise sales
select year(Order_Date),sum(Unit_Price_USD*sd.Quantity) as sp_month from SALES_DETAILS
 sd join PRODUCT_DETAILS pd on sd.ProductKey=pd.ProductKey
group by year(Order_Date);

-- 17.comparing current_month and previous_month
select YEAR(Order_Date),month(Order_Date) ,round(sum(Unit_Price_USD*sd.Quantity),2) as sales, LAG(sum(Unit_Price_USD*sd.Quantity))
OVER(order by YEAR(Order_Date), month(Order_Date)) AS Previous_Month_Sales from SALES_DETAILS sd join PRODUCT_DETAILS pd 
on sd.ProductKey=pd.ProductKey GROUP BY 
    YEAR(Order_Date), month(Order_Date);
    
    
-- 18.comparing current_year and previous_year sales
select YEAR(Order_Date) as year ,round(sum(Unit_Price_USD*sd.Quantity),2) as sales, LAG(sum(Unit_Price_USD*sd.Quantity))
OVER(order by YEAR(Order_Date)) AS Previous_Year_Sales from SALES_DETAILS sd join PRODUCT_DETAILS pd 
on sd.ProductKey=pd.ProductKey GROUP BY 
    YEAR(Order_Date);
 
 
 -- 19.month wise profit
select YEAR(Order_Date) as year,month(Order_Date) as month,(SUM(Unit_Price_USD*sd.Quantity) - SUM(Unit_Cost_USD*sd.Quantity)) as sales, 
LAG(sum(Unit_Price_USD*sd.Quantity) - SUM(Unit_Cost_USD*sd.Quantity))
OVER(order by YEAR(Order_Date), month(Order_Date)) AS Previous_Month_Sales,
round(((SUM(Unit_Price_USD*sd.Quantity) - SUM(Unit_Cost_USD*sd.Quantity))-
LAG(sum(Unit_Price_USD*sd.Quantity) - SUM(Unit_Cost_USD*sd.Quantity))
OVER(order by YEAR(Order_Date), month(Order_Date)))/LAG(sum(Unit_Price_USD*sd.Quantity) - SUM(Unit_Cost_USD*sd.Quantity))
OVER(order by YEAR(Order_Date), month(Order_Date))*100,2) as profit_percent
from SALES_DETAILS sd join PRODUCT_DETAILS pd 
on sd.ProductKey=pd.ProductKey GROUP BY 
    YEAR(Order_Date), month(Order_Date);
    
-- 20.year wise profit   
select YEAR(Order_Date) as Year ,(SUM(Unit_Price_USD*sd.Quantity) - SUM(Unit_Cost_USD*sd.Quantity)) as sales, 
LAG(sum(Unit_Price_USD*sd.Quantity) - SUM(Unit_Cost_USD*sd.Quantity))
OVER(order by YEAR(Order_Date)) AS Previous_year_Sales,
round(((SUM(Unit_Price_USD*sd.Quantity) - SUM(Unit_Cost_USD*sd.Quantity))-
LAG(sum(Unit_Price_USD*sd.Quantity) - SUM(Unit_Cost_USD*sd.Quantity))
OVER(order by YEAR(Order_Date)))/LAG(sum(Unit_Price_USD*sd.Quantity) - SUM(Unit_Cost_USD*sd.Quantity))
OVER(order by YEAR(Order_Date))*100,2) as profit_percent
from SALES_DETAILS sd join PRODUCT_DETAILS pd 
on sd.ProductKey=pd.ProductKey GROUP BY 
    YEAR(Order_Date);
 