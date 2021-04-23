go
CREATE TABLE OrderReport(
    OrderReportID INT PRIMARY KEY IDENTITY    NOT NULL,     
	OrderID    INT     NULL,     
	productID    INT     NULL,     
	customer    NVARCHAR(350)   NULL,    
	employe    NVARCHAR(200)    NULL,     
	employeProductRanking    DECIMAL(10,2)    NULL,     
	shipper    NVARCHAR(350)     NULL,     
	product    NVARCHAR(200)     NULL,     
	productUnitsVsQuantityOrderDetails    DECIMAL(8, 2)    NULL,     
	productRealItemTotal DECIMAL(10,2)   NULL,
	productDiscountItemTotal INT NULL,
	productMonetaryLoss NVARCHAR(200) NULL,
	productMonetaryLossAccumulated DECIMAL(10,2) NULL,
    fechaRegistro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP)

GO
DECLARE @id INT, @idProduct INT
DECLARE curOrder CURSOR FOR SELECT DISTINCT O.OrderID
                                   FROM dbo.Orders O
								   INNER JOIN dbo.[Order Details] D ON D.OrderID=O.OrderID
								   INNER JOIN dbo.Products P ON P.ProductID=D.ProductID

OPEN curOrder

FETCH NEXT FROM curOder INTO @id, @idProduct
WHILE @@FETCH_STATUS=0
      BEGIN
	       IF NOT EXISTS(SELECT OrderID FROM dbo.Orders WHERE OrderID=@id)
		   BEGIN
		      IF NOT EXISTS(SELECT ProductID FROM dbo.Products WHERE ProductID=@idProduct)
			  BEGIN
	       INSERT INTO dbo.OrderReport (OrderID, productID, customer, employe, employeProductRanking, shipper, product)
		   VALUES(@id, @idProduct,dbo.ufcCustomer(@id), dbo.ufcEmploye(@id) );

	       END
		       END
	  FETCH NEXT FROM curOder INTO @id, @idProduct
	  END
CLOSE curOrder
DEALLOCATE curOrder
GO

CREATE FUNCTION ufcCustomer(@orderID INT)
RETURNS VARCHAR(350)
BEGIN 
    DECLARE @customer VARCHAR (350);
    SET @customer=(SELECT CONCAT(C.CustomerID, '-',C.CompanyName,'-',C.ContactName,'-',C.Address, '-',
    C.City,'-', ISNULL(C.Region, 'Ninguno'),'-', C.Country)
    FROM Orders O
    INNER JOIN Customers C ON C.CustomerID= O.CustomerID
    WHERE O.OrderID=@orderID)
    RETURN @customer
END

GO
CREATE FUNCTION ufcEmploye (@orderID INT) 
RETURNS VARCHAR(60) 
BEGIN     
DECLARE @res VARCHAR(60);     
SET @res=(SELECT CONCAT(E.FirstName, ' ', E.LastName, '- Report to -',
ISNULL((SELECT CONCAT(E.FirstName, ' ', E.LastName) FROM Employees E WHERE E.ReportsTo=E.EmployeeID), 'nadie a cargo'))             FROM Orders O             
INNER JOIN Employees E ON E.EmployeeID=O.EmployeeID             
WHERE O.OrderID=@orderID)   
RETURN @res
END
