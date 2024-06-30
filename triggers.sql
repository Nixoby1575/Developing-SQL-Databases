/*
Triggers
Dos tipos de trigger: After   e  instead of
-After ocurren luego de una acción de Insert, update, delete
-Instead off  Cancela la accion desencadenadora y puede realizar otra acción.
*/
Use Northwind
go
--Crear una tabla a
Create table HistorialEliminación
(codigo int identity(1,1) primary key
,fecha date
,accion varchar(100)
, usuario varchar(100)
)
go
--Registrar la eliminación de dato en la tabla customers y cargarla a HistorialElimimnacion
Create trigger Tr_insert_client
on customers for Delete
as
Begin
Insert into HistorialEliminación (fecha, accion, usuario ) values (getdate()
, 'Se elimino un cliente ', user)
End
--Eliminar un cliente para probar el registro en HistorialEliminacion
DELETE FROM customers WHERE customerid='PARIS'
go
-- Consultar tabla de HistorialEliminación
select * from HistorialEliminación

-- crear una tabla a partir de los datos de customers
select *
into deletecustomers
from customers
--- eliminar los datos a deletecustomers
delete deletecustomers
-- Consultar para asegurarse de que esté vacía
Select * from deletecustomers
go

--- crear un trigger usando la tabla deleted
CREATE TRIGGER TR_borradocliente
on customers
after delete
as
INSERT INTO deletecustomers Select * from deleted
go
/*
Inspeccionar las tablas products y [order details] para revisar que las dos cuentan con el campo Unitprice,
vamos a crear un trigger que al insertar un dato en [order details] se actualice el precio tomandolo
de products
*/
Select * from [Order Details]
select * from products
go
--Creando el trigger
Create trigger Tr_actualizar_precio
on [order details] for insert
as
Begin
Update d set d.UnitPrice=p.UnitPrice
from [order details] d inner join products p on d.productid=p.productid
inner join inserted i on i.OrderID=d.OrderID and i.ProductID=d.ProductID
End
-----Insertar un dato
Insert into [order details] (orderid, productid, quantity, discount)
values (10248, 2, 10, 0)
-----Verificar que el trigger ponga el precio que no enviamos en el insert
Select * from [Order Details] where orderid=10248 and productid=2
go
/*
Ahora vamos a actualizar las unidades en existencia basado sobre el ingreso, eliminación
o modificación de datos en la tabla [order details]
*/

-----------Trigger de insercion que quita del inventario
Create trigger Tr_actualizar_stock
on [order details] for insert
as
Begin
Update p set 
p.UnitsInStock=p.UnitsInStock - i.Quantity
from inserted i inner join products p 
on i.productid=p.productid
End
go
-----------Trigger de eliminación que regresa a inventario
Create trigger Tr_regresar_stock
on [order details] for delete
as
Begin
Update p set 
p.UnitsInStock=p.UnitsInStock + d.Quantity
from deleted d inner join products p 
on d.productid=p.productid
End
go
-----------Trigger de actualizacion
Create trigger Tr_update_stock
on [order details] for update
as
Begin
Update p set 
p.UnitsInStock=p.UnitsInStock + d.Quantity
from deleted d inner join products p 
on d.productid=p.productid
Update p set 
p.UnitsInStock=p.UnitsInStock - i.Quantity
from inserted i inner join products p 
on i.productid=p.productid
End

-----Insertar un dato
Insert into [order details] (orderid, productid, quantity, discount)
values (10248, 32, 4, 0)
  -- Consultamos el stock del producto con el id 32
  Select * from products where ProductID=32
  -- Actualizar un registro
UPDATE [Order Details] SET Quantity=8 WHERE ORDERID=10248 AND PRODUCTID=32
-----Verificar que el trigger ponga el precio que no enviamos en el insert
Select * from [Order Details] where orderid=10248 AND PRODUCTID=32
  
------ TRIGGER INSTEAD OF
-- Creación de la Vista CATALOGO
CREATE VIEW CATALOGO
WITH SCHEMABINDING
AS
SELECT COMPANYNAME, CONTACTNAME, CONTACTTITLE, COUNTRY
, 'CUSTOMERS' AS [TYPE] FROM DBO.CUSTOMERS
UNION
SELECT COMPANYNAME, CONTACTNAME, CONTACTTITLE, COUNTRY
, 'SUPPLIER' AS [TYPE] FROM DBO.SUPPLIERS
GO
-- Selección desde la Vista CATALOGO
SELECT * FROM CATALOGO
--Creación del Trigger INSERT_CATALOGO
CREATE TRIGGER INSERT_CATALOGO
ON [CATALOGO]
INSTEAD OF INSERT
AS
INSERT CUSTOMERS (CUSTOMERID, COMPANYNAME, CONTACTNAME, CONTACTTITLE, COUNTRY)
SELECT SUBSTRING (COMPANYNAME, 1, 5), COMPANYNAME, CONTACTNAME, CONTACTTITLE, COUNTRY FROM INSERTED
WHERE TYPE= 'CUSTOMERS'
INSERT SUPPLIERS (COMPANYNAME, CONTACTNAME, CONTACTTITLE, COUNTRY)
SELECT COMPANYNAME, CONTACTNAME, CONTACTTITLE, COUNTRY FROM INSERTED
WHERE TYPE= 'SUPPLIERS'
GO
-- Inserción de Datos en la Vista CATALOGO
INSERT INTO [CATALOGO] (COMPANYNAME, CONTACTNAME, CONTACTTITLE, COUNTRY, TYPE)
VALUES ('VISOAL', 'VICTOR CARDENAS', 'ING. ', 'GUATEMALA', 'SUPPLIERS')
-- Verificación de Datos en las Tablas Subyacentes
SELECT * FROM SUPPLIERS
SELECT * FROM CUSTOMERS

-- TRIGGERS DDL
CREATE TRIGGER PROTEGER
ON DATABASE
FOR DROP_TABLE, ALTER_TABLE
AS
PRINT 'USTED NO PUEDE ELIMINAR O MODIFICAR UNA TABLA, CONSULTE A SU ADMINISTRADOR'
ROLLBACK
GO
  -- Probar el Trigger
DROP TABLE deletecustomers
