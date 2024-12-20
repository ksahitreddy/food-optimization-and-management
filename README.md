# Food Optimization and Management System
This project uses a MySQL server to store an example McDonalds restaurant data such as dishes, ingredients used and sales. Flask is used for making the website, which communicates with the MySQL server to fetch data and perform queries on the database. Gemini API is use for maknig predictions on the sales that can be made in a future by considering the previous sales data and teh ratings for each dish. 

## Instructions
First clone the github repository and then run the following commands in your terminal.

## Download the MySQL database into your MySQL
```bash
msql -u your_username -p < mysqldumpfile.sql
```
## Run the code
```bash
python app.py
```
