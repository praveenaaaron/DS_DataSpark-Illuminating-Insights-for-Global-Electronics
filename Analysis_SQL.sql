
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
