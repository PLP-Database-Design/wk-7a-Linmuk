-- Query to convert the ProductDetail table into 1NF by normalizing the Products column.
SELECT OrderID, CustomerName, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', n.n), ',', -1)) AS Product
FROM ProductDetail
JOIN (SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5) n 
    ON CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= n.n - 1
ORDER BY OrderID, n.n;

-- Create a new Customer table to store customer information separately.
CREATE TABLE Customer (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Insert unique order and customer information into the Customer table.
INSERT INTO Customer (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName FROM OrderDetails;

-- Modify OrderDetails table to remove the CustomerName column.
CREATE TABLE OrderDetails2 (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Customer(OrderID)
);

-- Insert data into the normalized OrderDetails2 table.
INSERT INTO OrderDetails2 (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity FROM OrderDetails;
