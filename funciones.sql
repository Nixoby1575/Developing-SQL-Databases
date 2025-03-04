Use NORTHWIND
go
---CREACION DE UNA FUNCION ESCALAR
CREATE FUNCTION IVA(@MONTO MONEY)
RETURNS MONEY
AS
BEGIN
DECLARE @IMPUESTO MONEY
SET @IMPUESTO=@MONTO * 0.12
RETURN(@IMPUESTO)
END
GO
--USANDO LA FUNCION ESCALAR
SELECT PRODUCTNAME, UNITPRICE, DBO.IVA(UNITPRICE) AS IVA
FROM Products
GO
--BORRANDO LA FUNCION ESCALAR
DROP FUNCTION DBO.IVA
GO
--CREANDO LA FUNCION COMISION
CREATE FUNCTION COMISION (@MONTO MONEY)
RETURNS MONEY
AS
BEGIN
DECLARE @RESULTADO MONEY
IF @MONTO >=250
	BEGIN 
	SET @RESULTADO= @MONTO * 0.10
	END
ELSE
	BEGIN
	SET @RESULTADO= @MONTO 
	END
RETURN(@RESULTADO)
END
GO


--MODIFICANDO LA FUNCION COMISION
ALTER FUNCTION COMISION (@MONTO MONEY)
RETURNS MONEY
AS
BEGIN
DECLARE @RESULTADO MONEY
IF @MONTO >=250
	BEGIN 
	SET @RESULTADO= @MONTO * 0.10
	END
ELSE
	BEGIN
	SET @RESULTADO= 0 
	END
RETURN(@RESULTADO)
END
GO
--USANDO LA FUNCION COMISION
SELECT ORDERID, PRODUCTID, UNITPRICE, QUANTITY
, UNITPRICE * QUANTITY AS PARCIAL, DBO.COMISION(UNITPRICE * QUANTITY) AS COMISION
FROM [Order Details]
GO
--CREAR UNA FUNCION CON VALORES DE TABLA DE MULTIPLES INSTRUCCIONES
CREATE FUNCTION FN_LISTAPAISES (@PAIS VARCHAR(160))
RETURNS @CLIENTE TABLE (CUSTOMERID VARCHAR(5)
, COMPANYNAME VARCHAR(160), CONTACTNAME VARCHAR(160), COUNTRY VARCHAR(160))
AS
BEGIN
INSERT @CLIENTE SELECT CUSTOMERID, COMPANYNAME, CONTACTNAME, COUNTRY FROM
CUSTOMERS WHERE COUNTRY=@PAIS
RETURN
END
GO
--USANDO LA FUNCION
SELECT * FROM FN_LISTAPAISES('ARGENTINA')
GO
---FUNCION CON VALORES DE TABLA EN LINEA
CREATE FUNCTION FN_ORDENESFECHA (@FECHAINICIAL DATE, @FECHAFINAL DATE)
RETURNS TABLE
AS
RETURN(
SELECT O.ORDERID, O.ORDERDATE, P.PRODUCTID, D.UNITPRICE, D.QUANTITY,
D.UNITPRICE * D.QUANTITY AS PARCIAL
FROM ORDERS AS O INNER JOIN [Order Details] AS D ON O.OrderID=D.OrderID
INNER JOIN Products AS P ON P.ProductID=D.ProductID
WHERE O.ORDERDATE BETWEEN @FECHAINICIAL AND @FECHAFINAL
)
GO
--USANDO LA FUNCION
SELECT * FROM FN_ORDENESFECHA('1998-01-01','1998-12-31')
GO
