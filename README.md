# snowflake_proj12_streams

This project demonstrates Snowflake Streams, a feature that allows capturing changes (inserts, updates, deletes) on tables. The exercises cover creating streams to track inserted, updated, and deleted records, loading data from S3, and querying the streams to analyze changes.

---

## TASK 1: Streams - Insert

**Objective:** Create a table, load data, and set up a stream to capture inserted records.

**Steps:**

1. Use the demo warehouse for executing all SQL commands.  
2. Create a database named `sales_db_stream`.  
3. Create a table named `sales_data` with the following columns:  
   - order_id (Integer)  
   - customer_id (Integer)  
   - customer_name (String, 100 characters)  
   - order_date (Date)  
   - product (String, 100 characters)  
   - quantity (Integer)  
   - price (Numeric)  
   - complete_address (String, 255 characters)  
4. Create an external stage named `s3_stage` using:  
   - S3 Path: `s3://snowflake-hands-on-data/sample_data_heavy_files/`  
   - AWS Access Key: `<Copy from Section - 2>`  
   - AWS Secret Key: `<Copy from Section - 2>`  
5. Load data from S3 into `sales_data` using the `COPY INTO` command.  
6. Create a stream on `sales_data` named `sales_data_stream` to track only inserted records (`APPEND_ONLY = TRUE`).  
7. Insert sample data into `sales_data` to test the stream.  
8. Query `sales_data_stream` to view records captured by the stream.  
9. Clean Up: Drop the stream, table, stage, and database.

---

## TASK 2: Update Streams in Snowflake

**Objective:** Track updates to a table using a stream.

**Steps:**

1. Use the demo warehouse for executing all SQL commands.  
2. Create a database called `sales_db_stream` and a schema `public`.  
3. Create a table `sales_data_update` with the following columns:  
   - order_id (Integer)  
   - customer_id (Integer)  
   - customer_name (String, 100 characters)  
   - order_date (Date)  
   - product (String, 100 characters)  
   - quantity (Integer)  
   - price (Numeric)  
   - complete_address (String, 255 characters)  
4. Insert sample data into `sales_data_update`.  
5. Set up an external stage using:  
   - S3 Path: `s3://snowflake-hands-on-data/sample_data_heavy_files/sales_data_sample_large.csv`  
   - AWS Access Key: `<Copy from Section - 2>`  
   - AWS Secret Key: `<Copy from Section - 2>`  
6. Create a stream `update_stream_sales` on `sales_data_update` to track row updates.  
7. Update rows in `sales_data_update` to trigger the stream capture.  
8. Query `update_stream_sales` to review the captured changes.  
9. Clean up by dropping the stream, table, stage, and database.

---

## TASK 3: Delete Stream in Snowflake

**Objective:** Track delete operations using a stream.

**Steps:**

1. Use the demo warehouse for executing all SQL commands.  
2. Create a database named `sales_db_delete` and a schema `public`.  
3. Create a table `sales_data_delete` with the following columns:  
   - order_id (Integer)  
   - customer_id (Integer)  
   - customer_name (String, 100 characters)  
   - order_date (Date)  
   - product (String, 100 characters)  
   - quantity (Integer)  
   - price (Numeric)  
   - complete_address (String, 255 characters)  
4. Create an external stage pointing to:  
   - S3 Path: `s3://snowflake-hands-on-data/sample_data_heavy_files/`  
   - AWS Access Key: `<Copy from Section - 2>`  
   - AWS Secret Key: `<Copy from Section - 2>`  
5. Load data into `sales_data_delete` from `sales_data_sample_large.csv`.  
6. Create a delete stream `delete_stream_sales` on `sales_data_delete`.  
7. Perform delete operations to remove specific rows.  
8. Query `delete_stream_sales` to verify captured changes.  
9. Clean up by dropping the stream, table, stage, and database.

---

**Real-World Relevance:**

- **Insert Streams:** Monitor new data ingestions for analytics or ETL pipelines.  
- **Update Streams:** Track data changes to maintain up-to-date dashboards or audit logs.  
- **Delete Streams:** Detect removed records to synchronize downstream systems.  
- **S3 Integration:** Enables seamless loading and tracking of cloud-based datasets.  
