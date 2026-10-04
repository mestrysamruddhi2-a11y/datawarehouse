CREATE DATABASE SalesWarehouse;
USE SalesWarehouse;
CREATE TABLE Product_Dim (
    ProductKey INT PRIMARY KEY AUTO_INCREMENT,
    ProductID INT,
    ProductName VARCHAR(50),
    Category VARCHAR(50)
);

INSERT INTO Product_Dim (ProductID, ProductName, Category)
SELECT ProductID, ProductName, Category
FROM Samruddhi.Product;

SELECT * FROM Product_Dim;

CREATE TABLE Region_Dim (
    RegionKey INT PRIMARY KEY AUTO_INCREMENT,
    RegionID INT,
    RegionName VARCHAR(50),
    City VARCHAR(50)
);

INSERT INTO Region_Dim (RegionID, RegionName, City)
SELECT RegionID, RegionName, City
FROM Samruddhi.Region;

CREATE TABLE Time_Dim (
    TimeKey INT PRIMARY KEY AUTO_INCREMENT,
    SaleDate DATE,
    SaleMonth INT,
    SaleYear INT
);

INSERT INTO Time_Dim (SaleDate, SaleMonth, SaleYear)
SELECT DISTINCT
    SaleDate,
    MONTH(SaleDate),
    YEAR(SaleDate)
FROM Samruddhi.Sales;

CREATE TABLE Sales_Fact (
    SalesKey INT PRIMARY KEY AUTO_INCREMENT,
    ProductKey INT,
    RegionKey INT,
    TimeKey INT,
    Quantity INT,
    SalesAmount DECIMAL(10,2),

    FOREIGN KEY (ProductKey) REFERENCES Product_Dim(ProductKey),
    FOREIGN KEY (RegionKey) REFERENCES Region_Dim(RegionKey),
    FOREIGN KEY (TimeKey) REFERENCES Time_Dim(TimeKey)
);

INSERT INTO Sales_Fact
(ProductKey, RegionKey, TimeKey, Quantity, SalesAmount)

SELECT
    p.ProductKey,
    r.RegionKey,
    t.TimeKey,
    s.Quantity,
    s.SalesAmount

FROM Samruddhi.Sales s

JOIN Product_Dim p
    ON s.ProductID = p.ProductID

JOIN Region_Dim r
    ON s.RegionID = r.RegionID

JOIN Time_Dim t
    ON s.SaleDate = t.SaleDate;

SELECT * FROM Sales_Fact;
