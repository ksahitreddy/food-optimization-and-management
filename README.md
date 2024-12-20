# Food Optimization and Management System
This project uses a MySQL server to store an example McDonalds restaurant data such as dishes, ingredients used and sales. Flask is used for making the website, which communicates with the MySQL server to fetch data and perform queries on the database. Gemini API is use for maknig predictions on the sales that can be made in a future by considering the previous sales data and teh ratings for each dish. 

## Instructions
First clone the github repository and then run the following commands in your terminal.

## Download the MySQL database into your MySQL
Before running the command, create an empty database with <your_database_name> in MySQL. Then in terminal run the command.
```bash
mysql -u your_username -p your_database_name < mysqldumpfile.sql
```
## Run the code
Before running the code, edit the MySQL configuration in [app.py](./app.py) according to your settings.
```bash
python app.py
```
