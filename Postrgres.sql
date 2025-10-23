CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS analytics;

CREATE TABLE if NOT EXISTS raw.invoices (
	 invoices_no text, -- Invoices number ( string, not numeric)
	 stock_code text, -- categorical
	 describtion text, --product describtion
	 quantity integer, --int64 in python
	 invoice_date timestamptz, --OBJECT IN python, but contains datetime
	 unit_price NUMERIC(10,2), --float in python (fixed precision)
	 customer_id integer, --is was float in python! but it's int
	 country text
	 );
GRANT USAGE ON SCHEMA analytics TO PUBLIC;
GRANT CREATE ON SCHEMA analytics TO PUBLIC;
ALTER DEFAULT PRIVILEGES IN SCHEMA analytics GRANT SELECT ON TABLES TO PUBLIC;


CREATE TABLE IF NOT EXISTS ANALYTICS.customers(
	 customer_id integer PRIMARY key,
	 country text
);
 CREATE TABLE IF NOT EXISTS ANALYTICS.products(
	description text,
	stock_code text NOT NULL PRIMARY key,
	unit_price numeric(10,2)
	
 );
 CREATE TABLE IF NOT EXISTS ANALYTICS.sales_data (
    invoices_no TEXT PRIMARY KEY,
    stock_code TEXT,
    customer_id INTEGER,
    description TEXT,
    quantity INTEGER,
    invoice_date TIMESTAMPTZ,
    unit_price NUMERIC(10,2),
    country TEXT,
    FOREIGN KEY (stock_code) REFERENCES ANALYTICS.products(stock_code),
    FOREIGN KEY (customer_id) REFERENCES ANALYTICS.customers(customer_id)
);

INSERT INTO ANALYTICS.CUSTOMERS(customer_id, country)
SELECT DISTINCT i.customer_id, i.country
FROM RAW.INVOICES i
WHERE customer_id IS NOT NULL
ON CONFLICT (customer_id) DO nothing;

INSERT INTO ANALYTICS.PRODUCTS (STOCK_CODE, description, UNIT_PRICE)
SELECT DISTINCT i.STOCK_CODE,i.DESCRIBTION ,i.UNIT_PRICE
FROM RAW.INVOICES I 
WHERE STOCK_CODE IS NOT NULL 
ON CONFLICT (stock_code) DO NOTHING;

INSERT INTO ANALYTICS.SALES_DATA (  invoices_no, stock_code ,customer_id , describtion ,quantity,invoice_date, unit_price,country)
SELECT DISTINCT i.invoices_no,
				i.stock_code ,
				i.customer_id , 
				i.describtion ,
				i.quantity,
				i.invoice_date
				, i.unit_price,
				i.country
FROM raw.INVOICES  I
WHERE invoices_no IS NOT NULL 
ON CONFLICT (invoices_no) DO NOTHING;


