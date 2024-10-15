PROJECT REPORT

EDA code:
import pandas as pd
from datetime import datetime
from sqlalchemy import create_engine
df = pd.read_csv("C:/Users/chels/Downloads/Customers.csv", encoding='ISO-8859-1')
print(df.shape)
df_clean = df.dropna()
print(df_clean.shape)
df_og = df_clean.drop_duplicates()
print(df_og.shape)
df_best = df_og.drop(columns=['Zip Code', 'State Code'])
print(df_best.shape)
df_best['Birthday'] = pd.to_datetime(df_best['Birthday'])
today = pd.to_datetime(datetime.today().strftime('%Y-%m-%d'))
df_best['Age'] = today.year - df_best['Birthday'].dt.year
df_best['Age'] -= (today.month < df_best['Birthday'].dt.month) | \
                  ((today.month == df_best['Birthday'].dt.month) & (today.day < df_best['Birthday'].dt.day))
df_best['Age'] = df_best['Age'] - df_best['Age'].astype(bool).astype(int)
df_cbest = df_best.drop(columns=['Birthday'])
df_cbest
df = pd.read_csv("C:/Users/chels/Downloads/Products.csv")
df.dropna().drop_duplicates()
df['Cost Price in $'] = df['Unit Cost USD'].str.replace('$', '')
df['Cost Price in $'] = df['Cost Price in $'].str.replace(',', '').str.strip().astype(float)
df['Selling Price in $'] = df['Unit Price USD'].str.replace('$', '')
df['Selling Price in $'] = df['Selling Price in $'].str.replace(',', '').str.strip().astype(float)
df["Profi Margin in $"] = df["Selling Price in $"]- df["Cost Price in $"]
df_pbest = df.drop(columns=["Unit Cost USD","Unit Price USD","Color"])
df_pbest.head()
df = pd.read_csv("C:/Users/chels/Downloads/Sales.csv")
df_sbest= df.drop_duplicates()
df_sbest['Order Date'] = pd.to_datetime(df_sbest['Order Date'])
df_sbest['Order years'] = df_sbest['Order Date'].dt.year
df_sbest = pd.merge(df_sbest, df_pbest[['ProductKey', 'Profi Margin in $']], on='ProductKey', how='left')
df_sbest['Total Profit'] = df_sbest['Quantity'] * df_sbest['Profi Margin in $']
df_sbest.head(10)
df = pd.read_csv("C:/Users/chels/Downloads/Stores.csv")
df_stbest = df.dropna().drop_duplicates()
df_stbest
import mysql.connector
connection = mysql.connector.connect(
    host='localhost',        
    user='root',    
    password=*********', 
    database='Guvi_project2' 
)
cursor = connection.cursor()
engine = create_engine("mysql+mysqlconnector://root:********@localhost/Guvi_project2")
df_cbest.to_sql(name='customer_table', con=engine, if_exists='replace', index=False)
df_pbest.to_sql(name='product_table', con=engine, if_exists='replace', index=False)
df_sbest.to_sql(name='sales_table', con=engine, if_exists='replace', index=False)
df_stbest.to_sql(name='store_table', con=engine, if_exists='replace', index=False)
df_cbest.to_excel('customer_file.xlsx', index=False)
df_sbest.to_excel('sales_table.xlsx', index=False)
df_pbest.to_excel('product_table.xlsx',index=False)
df_stbest.to_excel('store_table.xlsx',index=False


Power BI:
Customer analysis:
•	We have a stacked bar graph which gives us the number of customers at a particular age also differentiates male and female. This helps us in produces and sale products targeting the age groups and the gender.

•	In the card we can look in too the number of customers we have 

•	Donate chart is used to differentiate gender therefore companies can have products targeting the genders

•	From clustered bar chart we can clearly understand customers centric categories and increases or decrease the production accordingly.

•	Map visual shows the customer from different zone gives us the insight to increase the production on the respective region or export to the respective region in-advance to manage the demand supply.
Sales analysis:
•	The line chart gives us the insight about amount profit made on a year and we can analyse the pattern and plan the cash flow into the company respectively.

•	We have 2 cards first card represents the overall profit made by the company and second card represents the overall sales.

•	The bar chart gives the number of products sold on yearly bases which helps in increase or decrease the production.

•	The scattered plot shows the sum of quantity by each sub category to analyse the sales contribution sub category wise also the size of the dot represents the sum of profit made by the sub category.

Product analysis:
•	The heatmap shows where the category stands according to their profit margin.

•	The slider is used to analyse other visuals other except heatmap by category.

•	The first table show the most sold product name and it’s sum of quantity sold varies according to the slider.

•	The second table show the least sold product name and it’s sum of quantity sold varies according to the slider.

•	The scattered plot shows the sum of quantity by each sub category to analyse the sales contribution sub category wise also the size of the dot represents the sum of profit made by the sub category.

•	The card displays the sum of total profit.
Store analysis:
•	There are two slicer one has the list of countries and another has continents.

•	There are two cards first card shows the total no of stores second card shows total profit of the store and varies according to the slicer.

•	The table show the list of store’s key and place also it’s open date and varies according to slicer

•	The scattered plot shows the relation between the area of the store and the sales of the store.

•	The map chart shows the visual representation of store in the their region and the dot size indicates the profit made by the store



SQL QURIES:

query 1 : Total sales revenue by product category:
SELECT Category, SUM(Quantity * `Selling Price in $`) AS Total_Revenue
FROM sales_table
JOIN product_table ON sales_table.ProductKey = product_table.ProductKey
GROUP BY Category;

query2: Best-selling products by quantity:
SELECT product_name, SUM(Quantity) AS Total_Quantity_Sold
FROM sales_table
JOIN product_table ON sales_table.ProductKey = product_table.ProductKey
GROUP BY product_name
ORDER BY Total_Quantity_Sold DESC
LIMIT 10;

query3: Average profit margin per product category:
SELECT Category, AVG(`Profi Margin in $`) AS Avg_Profit_Margin
FROM sales_table
JOIN product_table ON sales_table.ProductKey = product_table.ProductKey
GROUP BY Category;

query4: Customer demographics:
SELECT Gender, AVG(Age) AS Avg_Age, COUNT(*) AS Customer_Count
FROM customer_table
GROUP BY Gender;

query5: Top customers by total spending:
SELECT s.CustomerKey, SUM(s.Quantity * p.`Selling Price in $`) AS Total_Spending
FROM sales_table s
JOIN customer_table c ON s.CustomerKey = c.CustomerKey
JOIN product_table p ON s.ProductKey = p.ProductKey  -- Join product_table to get Selling Price
GROUP BY s.CustomerKey
ORDER BY Total_Spending DESC
LIMIT 10;


query6: Most Profitable Products
SELECT 
    pt.product_name, 
    SUM(pt.`Profi Margin in $` * st.Quantity) AS Total_Profit
FROM 
    sales_table st
JOIN 
    product_table pt ON st.ProductKey = pt.ProductKey
GROUP BY 
    pt.product_name
ORDER BY 
    Total_Profit DESC
LIMIT 10;

query 7: Average store size by country:
SELECT Country, AVG(`Square Meters`) AS Avg_Store_Size
FROM store_table
GROUP BY Country;*/

query 8:  Most Popular Products:
SELECT 
    pt.product_name, 
    SUM(st.Quantity) AS Total_Units_Sold
FROM 
    sales_table st
JOIN 
    product_table pt ON st.ProductKey = pt.ProductKey
GROUP BY 
    pt.product_name
ORDER BY 
    Total_Units_Sold DESC;

query 9 :  Seasonal patterns in sales:
SELECT p.product_name, (SUM(s.Quantity * p.`Selling Price in $`) - SUM(s.Quantity * p.`Cost Price in $`)) / SUM(s.Quantity * p.`Selling Price in $`) AS Profit_Margin_Percentage
FROM sales_table s
JOIN product_table p ON s.ProductKey = p.ProductKey
GROUP BY p.product_name
ORDER BY Profit_Margin_Percentage DESC;

query 10 : Customer Distribution by Continent:

SELECT 
    c.Continent, 
    COUNT(c.CustomerKey) AS Number_of_Customers
FROM 
    customer_table c
GROUP BY 
    c.Continent
ORDER BY 
    Number_of_Customers DESC;












