
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