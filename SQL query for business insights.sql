USE guvi_project2;

#query 1 : Total sales revenue by product category:
SELECT Category, SUM(Quantity * `Selling Price in $`) AS Total_Revenue
FROM sales_table
JOIN product_table ON sales_table.ProductKey = product_table.ProductKey
GROUP BY Category;


#query2: Best-selling products by quantity:
SELECT product_name, SUM(Quantity) AS Total_Quantity_Sold
FROM sales_table
JOIN product_table ON sales_table.ProductKey = product_table.ProductKey
GROUP BY product_name
ORDER BY Total_Quantity_Sold DESC
LIMIT 10;

#query3: Average profit margin per product category:
SELECT Category, AVG(`Profi Margin in $`) AS Avg_Profit_Margin
FROM sales_table
JOIN product_table ON sales_table.ProductKey = product_table.ProductKey
GROUP BY Category;

#query4: Customer demographics:
SELECT Gender, AVG(Age) AS Avg_Age, COUNT(*) AS Customer_Count
FROM customer_table
GROUP BY Gender;

#query5: Top customers by total spending:
SELECT s.CustomerKey, SUM(s.Quantity * p.`Selling Price in $`) AS Total_Spending
FROM sales_table s
JOIN customer_table c ON s.CustomerKey = c.CustomerKey
JOIN product_table p ON s.ProductKey = p.ProductKey  -- Join product_table to get Selling Price
GROUP BY s.CustomerKey
ORDER BY Total_Spending DESC
LIMIT 10;


#query6: Most Profitable Products
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

#query 7: Average store size by country:
SELECT Country, AVG(`Square Meters`) AS Avg_Store_Size
FROM store_table
GROUP BY Country;

#query 8:  Most Popular Products:
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

#query 9 :  Seasonal patterns in sales:
SELECT p.product_name, (SUM(s.Quantity * p.`Selling Price in $`) - SUM(s.Quantity * p.`Cost Price in $`)) / SUM(s.Quantity * p.`Selling Price in $`) AS Profit_Margin_Percentage
FROM sales_table s
JOIN product_table p ON s.ProductKey = p.ProductKey
GROUP BY p.product_name
ORDER BY Profit_Margin_Percentage DESC;

#query 10 : Customer Distribution by Continent:

SELECT 
    c.Continent, 
    COUNT(c.CustomerKey) AS Number_of_Customers
FROM 
    customer_table c
GROUP BY 
    c.Continent
ORDER BY 
    Number_of_Customers DESC;









