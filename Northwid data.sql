--26
SELECT * FROM Customers c INNER JOIN Orders o
ON c.CustomerID = o.CustomerID

--27
SELECT * FROM Customers c LEFT JOIN Orders o
ON c.CustomerID = o.CustomerID

--28
SELECT * FROM Customers c RIGHT JOIN Orders o
ON c.CustomerID = o.CustomerID