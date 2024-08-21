# Walmart_sales_data_analysis
This repository contains a SQL script that performs various data analysis tasks on a sales dataset. The script is designed to extract insights from the data, including:
- Sales by city and branch
- Product line sales and revenue
- Customer type and payment method analysis
- Time of day and day of week sales patterns
- Rating and review analysis
- Dataset

The script assumes a table named sales with the following columns:
* invoice_id: unique identifier for each sale
* branch: branch location of the sale
* city: city where the sale was made
* customer_type: type of customer (e.g. individual, business)
* gender: gender of the customer
* product_line: product line sold
* unit_price: price of each unit sold
* quantity: quantity sold
* tax_pct: tax percentage applied to the sale
* total: total revenue from the sale
* date: date of the sale
* time: time of the sale
* payment: payment method used
* cogs: cost of goods sold
* gross_margin_pct: gross margin percentage
* gross_income: gross income from the sale
* rating: customer rating (1-5)

Queries
The query is written in SQL and is executed in a database management system PostgreSQL. The script performs the following tasks:
- Data cleaning: adds new columns for time of day and day of week
- Sales analysis: calculates total revenue by month, product line, and city
- Customer analysis: analyzes customer type, payment method, and rating patterns
- Time analysis: analyzes sales patterns by time of day and day of week
