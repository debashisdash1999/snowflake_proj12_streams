--  TASK 1: Streams - Insert
-- Set the warehouse to demo for executing commands
USE WAREHOUSE demo;

-- Create a new database to store sales data
CREATE OR REPLACE DATABASE sales_db_stream;

-- Define a table to hold sales data details
CREATE OR REPLACE TABLE sales_data (
    order_id INTEGER,
    customer_id INTEGER,
    customer_name STRING(100),
    order_date DATE,
    product STRING(100),
    quantity INTEGER,
    price NUMERIC,
    complete_address STRING(255)
);

-- Set up an external stage with AWS credentials to access S3 data
CREATE OR REPLACE STAGE s3_stage
URL='s3://snowflake-hands-on-data/sample_data_heavy_files/'
CREDENTIALS = (AWS_KEY_ID=888888888888 
               AWS_SECRET_KEY=888888888888
               );

-- Load data from the S3 stage into the sales_data table
COPY INTO sales_data
FROM @s3_stage/sales_data_sample_large.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

-- Create a stream to capture any new rows inserted into the sales_data table
CREATE OR REPLACE STREAM sales_data_stream
ON TABLE sales_data
APPEND_ONLY = TRUE;

-- Insert a sample record into the sales_data table for stream testing
INSERT INTO sales_data (order_id, customer_id, customer_name, order_date, product, quantity, price, complete_address)
VALUES (101, 1001, 'John Doe', '2024-10-25', 'Laptop', 1, 1200.00, '123 Elm St, Springfield');

-- Retrieve data from the stream to confirm the inserted record is tracked
SELECT * FROM sales_data_stream;

-- Drop the created stream to clear resources
DROP STREAM IF EXISTS sales_data_stream;

-- Drop the sales_data table after stream operations are complete
DROP TABLE IF EXISTS sales_data;

-- Drop the stage used for S3 data access
DROP STAGE IF EXISTS s3_stage;

-- Drop the database created for this assignment
DROP DATABASE IF EXISTS sales_db_stream;



--  TASK 2: Update Streams in Snowflake
-- Use the demo warehouse
USE WAREHOUSE demo;

-- Create a database for sales data
CREATE OR REPLACE DATABASE sales_db_stream;

-- Create a table named sales_data_update with specified columns
CREATE OR REPLACE TABLE sales_data_update (
    order_id INTEGER,
    customer_id INTEGER,
    customer_name STRING(100),
    order_date DATE,
    product STRING(100),
    quantity INTEGER,
    price NUMERIC,
    complete_address STRING(255)
);

-- Create an external stage for loading data from S3
CREATE OR REPLACE STAGE s3_stage
URL='s3://snowflake-hands-on-data/sample_data_heavy_files/'
CREDENTIALS = (AWS_KEY_ID=8888888888888 
               AWS_SECRET_KEY=88888888888888
              );

-- Load data from the external stage into the sales_data_update table
COPY INTO sales_data_update
FROM @s3_stage/sales_data_sample_large.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

-- Create a stream named update_stream_sales on the sales_data_update table
CREATE OR REPLACE STREAM update_stream_sales ON TABLE sales_data_update;

-- Update rows in the sales_data_update table to trigger the stream
UPDATE sales_data_update
SET price = price * 1.1
WHERE quantity > 100;

-- Query the update_stream_sales to see the changes captured by the stream
SELECT * FROM update_stream_sales;

-- Drop the stream, table, stage, and database to clean up
DROP STREAM IF EXISTS update_stream_sales;
DROP TABLE IF EXISTS sales_data_update;
DROP STAGE IF EXISTS s3_stage;
DROP DATABASE IF EXISTS sales_db_stream;



--  TASK 3: Delete Stream in Snowflake
-- Use the demo warehouse
USE WAREHOUSE demo;

-- Create a database for sales data
CREATE OR REPLACE DATABASE sales_db_delete;

-- Create a table named sales_data_delete with specified columns
CREATE OR REPLACE TABLE sales_data_delete (
    order_id INTEGER,
    customer_id INTEGER,
    customer_name STRING(100),
    order_date DATE,
    product STRING(100),
    quantity INTEGER,
    price NUMERIC,
    complete_address STRING(255)
);

-- Create an external stage for loading data from S3
CREATE OR REPLACE STAGE s3_stage
URL='s3://snowflake-hands-on-data/sample_data_heavy_files/'
CREDENTIALS = (AWS_KEY_ID=88888888888 
               AWS_SECRET_KEY=8888888888888
              );

-- Load data from the external stage into the sales_data_delete table
COPY INTO sales_data_delete
FROM @s3_stage/sales_data_sample_large.csv
FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1 FIELD_OPTIONALLY_ENCLOSED_BY = '"');

-- Create a delete stream named delete_stream_sales on the sales_data_delete table
CREATE OR REPLACE STREAM delete_stream_sales ON TABLE sales_data_delete;

-- Delete specific rows in the sales_data_delete table to trigger the stream
DELETE FROM sales_data_delete
WHERE quantity < 50;

-- Query the delete_stream_sales to see the changes captured by the stream
SELECT COUNT (*) FROM delete_stream_sales;

-- Drop the stream, table, stage, and database to clean up
DROP STREAM IF EXISTS delete_stream_sales;
DROP TABLE IF EXISTS sales_data_delete;
DROP STAGE IF EXISTS s3_stage;
DROP DATABASE IF EXISTS sales_db_delete;
