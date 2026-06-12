CREATE DATABASE toysgroup;
CREATE TABLE category (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL
);
CREATE TABLE region (
    RegionID INT PRIMARY KEY,
    RegionName VARCHAR(100) NOT NULL
);
CREATE TABLE country (
    CountryID INT PRIMARY KEY,
    CountryName VARCHAR(100) NOT NULL,
    RegionID INT NOT NULL,
    FOREIGN KEY (RegionID) REFERENCES region(RegionID)
);

CREATE TABLE product (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    CategoryID INT NOT NULL,
    FOREIGN KEY (CategoryID) REFERENCES category(CategoryID)
);

CREATE TABLE sales (
    SalesID INT PRIMARY KEY,
    DocumentCode VARCHAR(50) NOT NULL,
    SalesDate DATE NOT NULL,
    ProductID INT NOT NULL,
    CountryID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES product(ProductID),
    FOREIGN KEY (CountryID) REFERENCES country(CountryID)
);
INSERT INTO category (CategoryID, CategoryName) VALUES
(1, 'Bikes'),
(2, 'Clothing'),
(3, 'Accessories');

INSERT INTO region (RegionID, RegionName) VALUES
(1, 'WestEurope'),
(2, 'SouthEurope'),
(3, 'NorthAmerica');

INSERT INTO country (CountryID, CountryName, RegionID) VALUES
(1, 'France', 1),
(2, 'Germany', 1),
(3, 'Italy', 2),
(4, 'Greece', 2),
(5, 'United States', 3);

INSERT INTO product (ProductID, ProductName, CategoryID) VALUES
(101, 'Bikes-100', 1),
(102, 'Bikes-200', 1),
(103, 'Bike Gloves M', 2),
(104, 'Bike Gloves L', 2),
(105, 'Helmet Pro', 3),
(106, 'Water Bottle', 3);

INSERT INTO sales (SalesID, DocumentCode, SalesDate, ProductID, CountryID, Quantity, UnitPrice) VALUES
(1, 'DOC001', '2024-01-15', 101, 1, 10, 500.00),
(2, 'DOC002', '2024-03-10', 102, 2, 8, 650.00),
(3, 'DOC003', '2024-06-05', 103, 3, 20, 25.00),
(4, 'DOC004', '2024-09-18', 105, 4, 12, 80.00),
(5, 'DOC005', '2025-02-11', 101, 3, 6, 520.00),
(6, 'DOC006', '2025-04-22', 104, 1, 15, 30.00),
(7, 'DOC007', '2025-07-09', 103, 5, 18, 27.00),
(8, 'DOC008', '2025-10-01', 105, 2, 9, 82.00);


SELECT CategoryID, count(*)
FROM category
group by CategoryID
having count(*)>1;
SELECT CountryID, count(*)
FROM country
group by CountryID
having count(*)>1;
SELECT ProductID, count(*)
FROM product
group by ProductID
having count(*)>1;
SELECT RegionID, count(*)
FROM region
group by RegionID
having count(*)>1;
SELECT SalesID, count(*)
FROM sales
group by SalesID
having count(*)>1;
SELECT s.DocumentCode, s.SalesDate,p.ProductName,c.CategoryName,co.CountryName,r.RegionName,
 IF(s.SalesDate < CURDATE() - INTERVAL 180 DAY, 'True', 'False') as over180days
FROM sales AS s
JOIN product AS p ON s.ProductID = p.ProductID
JOIN category AS c ON p.CategoryID = c.CategoryID
JOIN country AS co ON s.CountryID = co.CountryID
JOIN region AS r ON co.RegionID = r.RegionID;
SELECT s.ProductID, SUM(s.Quantity) as TotalSold
FROM sales s
WHERE YEAR(s.SalesDate) = (
    SELECT MAX(YEAR(SalesDate))
    FROM sales
)
GROUP BY s.ProductID
HAVING SUM(s.Quantity) > (
    SELECT AVG(TotalSold)
    FROM (
        SELECT
            ProductID,
            SUM(Quantity) AS TotalSold
        FROM sales
        WHERE YEAR(SalesDate) = (
            SELECT MAX(YEAR(SalesDate))
            FROM sales
        )
        GROUP BY ProductID
    ) AS x);
SELECT co.CountryName, year(s.SalesDate) as Anno, SUM(s.Quantity*s.UnitPrice) as fattutot
FROM sales as s 
JOIN country as co
ON s.CountryID=co.CountryID
GROUP BY co.CountryName,Anno
ORDER BY fattutot,Anno DESC ;
SELECT c.CategoryName, SUM(s.Quantity) AS TotalSold
FROM sales as s
JOIN product as p ON s.ProductID = p.ProductID
JOIN category as c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY TotalSold DESC
LIMIT 1;
SELECT p.ProductID, p.ProductName
from product as p 
LEFT JOIN sales as s 
ON p.ProductID=s.ProductID
WHERE s.ProductID IS NULL;
SELECT
    p.ProductID,
    p.ProductName
FROM product as p
WHERE NOT EXISTS 
(SELECT 1
FROM sales as s
WHERE s.ProductID = p.ProductID);
CREATE VIEW viewproductinfo AS
SELECT p.ProductID, p.ProductName, c.CategoryName
FROM product as p
JOIN category as c
ON p.CategoryID = c.CategoryID;
CREATE VIEW view_geoinfo AS
SELECT co.CountryID, co.CountryName, r.RegionName
FROM country as co
JOIN region as r
ON co.RegionID = r.RegionID;

