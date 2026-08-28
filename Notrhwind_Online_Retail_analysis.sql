--1
SELECT AVG(DATEDIFF(DAY, RequiredDate, ShippedDate)) Ort_Gecikme
FROM Orders
WHERE DATEDIFF(DAY, RequiredDate, ShippedDate) > 0
--2
SELECT AVG(DATEDIFF(DAY, RequiredDate, ShippedDate)) Ort_Erken
FROM Orders
WHERE DATEDIFF(DAY, RequiredDate, ShippedDate) < 0
--3
SELECT  Customer_ID, SUM(Quantity*Price) Monetary
FROM retail_II
GROUP BY Customer_ID
--4
SELECT Customer_ID, MAX(InvoiceDate) Son_Alisveris,
DATEDIFF(DAY, MAX(InvoiceDate), '20111230') Recency
FROM retail_II
GROUP BY Customer_ID
--5
SELECT * FROM
(SELECT Country, [Description], SUM(Quantity) Adet,
ROW_NUMBER() OVER (PARTITION BY Country ORDER BY SUM(Quantity) DESC) AS rn
 FROM retail_II
 GROUP BY Country, [Description]) T1
 WHERE rn = 1

 --6
CREATE TABLE RFM_FSE (
    CustomerID VARCHAR(20),
LastInvoiceDate DATETIME,
FirstInvoiceDate DATETIME,
Recency INT,
Frequency INT,
Monetary INT,
Tenure INT,
Basket_Size FLOAT,
Recency_Scale INT,
Frequency_Scale INT,
Segment VARCHAR(50)
)

INSERT INTO RFM_FSE(CustomerID)
SELECT DISTINCT Customer_ID FROM onlineretaildb.dbo.retail_II

UPDATE RFM_FSE SET LastInvoiceDate = 
(
    SELECT MAX(InvoiceDate)
    FROM onlineretaildb.dbo.retail_II r
    WHERE r.Customer_ID = RFM_FSE.CustomerID
)

UPDATE RFM_FSE SET FirstInvoiceDate = 
(
    SELECT MIN(InvoiceDate)
    FROM onlineretaildb.dbo.retail_II r
    WHERE r.Customer_ID = RFM_FSE.CustomerID
) 

UPDATE RFM_FSE SET Recency = DATEDIFF(DAY, LastInvoiceDate, '20120101')

UPDATE RFM_FSE SET Tenure = DATEDIFF(DAY, FirstInvoiceDate, '20120101')

UPDATE RFM_FSE SET Frequency = 
(
    SELECT COUNT(DISTINCT Invoice)
    FROM onlineretaildb.dbo.retail_II r
    WHERE r.Customer_ID = RFM_FSE.CustomerID
)
UPDATE RFM_FSE SET Monetary = 
(
    SELECT SUM(Quantity*Price)
    FROM onlineretaildb.dbo.retail_II r
    WHERE r.Customer_ID = RFM_FSE.CustomerID
)

UPDATE RFM_FSE SET Basket_Size = (Monetary / Frequency) FROM RFM_FSE

UPDATE RFM_FSE SET Frequency_Scale = 
(
    SELECT rank
    FROM
    (
        SELECT CustomerID, Frequency, NTILE(5) OVER(ORDER BY Frequency) rank
        FROM RFM_FSE
        ) T1
    WHERE CustomerID = RFM_FSE.CustomerID )

UPDATE RFM_FSE SET Recency_Scale = 
(
    SELECT rank
    FROM
    (
        SELECT CustomerID, Recency, NTILE(5) OVER(ORDER BY Recency) rank
        FROM RFM_FSE
        ) T1
    WHERE CustomerID = RFM_FSE.CustomerID )
SELECT * FROM RFM_FSE

UPDATE RFM_OR SET Segment = 'Hibernating'
WHERE Recency_Scale LIKE '[1-2]' AND Frequency_Scale LIKE '[1-2]'


UPDATE RFM_FSE SET Segment = 'At_Risk'
WHERE Recency_Scale LIKE '[1-2]' AND Frequency_Scale LIKE '[3-4]'
UPDATE RFM_FSE SET Segment ='Cant_Loose' 
WHERE Recency_Scale LIKE  '[1-2]' AND Frequency_Scale LIKE '[5]'  
UPDATE RFM_FSE SET Segment ='About_to_Sleep' 
WHERE Recency_Scale LIKE  '[3]' AND Frequency_Scale LIKE '[1-2]'  
UPDATE RFM_FSE SET Segment ='Need_Attention' 
WHERE Recency_Scale LIKE  '[3]' AND Frequency_Scale LIKE '[3]' 
UPDATE RFM_FSE SET Segment ='Loyal_Customers' 
WHERE Recency_Scale LIKE  '[3-4]' AND Frequency_Scale LIKE '[4-5]' 
UPDATE RFM_FSE SET Segment ='Promising' 
WHERE Recency_Scale LIKE  '[4]' AND Frequency_Scale LIKE '[1]' 
UPDATE RFM_FSE SET Segment ='New_Customers' 
WHERE Recency_Scale LIKE  '[5]' AND Frequency_Scale LIKE '[1]' 
UPDATE RFM_FSE SET Segment ='Potential_Loyalists' 
WHERE Recency_Scale LIKE  '[4-5]' AND Frequency_Scale LIKE '[2-3]' 
UPDATE RFM_FSE SET Segment ='Champions' 
WHERE Recency_Scale LIKE  '[5]' AND Frequency_Scale LIKE '[4-5]'

SELECT * FROM RFM_FSE
