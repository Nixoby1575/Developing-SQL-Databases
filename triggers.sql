/*
Triggers
Dos tipos de trigger: After   e  instead of
-After ocurren luego de una acci�n de Insert, update, delete
-Instead off  Cancela la accion desencadenadora y puede realizar otra acci�n.
*/
Use Northwind
go
--Crear una tabla a
Create table HistorialEliminaci�n
(codigo int identity(1,1) primary key
,fecha date
,accion varchar(100)
, usuario varchar(100)
)
go
--Registrar la eliminaci�n de dato en la tabla customers y cargarla a HistorialElimimnacion
Create trigger Tr_insert_cliente
on customers for Delete
as
Begin
Insert into HistorialEliminaci�n (fecha, accion, usuario ) values (getdate()
, 'Se elimino un cliente ', user)
End
--Eliminar un cliente para probar el registro en HistorialEliminacion
Delete from customers where customerid='PARIS'
go

/*
Inspeccionar las tablas products y [order details] para revisar que las dos cuentan con el campo Unitprice,
vamos a crear un trigger que al insertar un dato en [order details] se actualice el precio tomandolo
de products
*/
select * from products
Select * from [Order Details]
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
Select * from [Order Details] where orderid=10248
go
/*
Ahora vamos a actualizar las unidades en existencia basado sobre el ingreso, eliminaci�n
o modificaci�n de datos en la tabla [order details]
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
-----------Trigger de eliminaci�n que regresa a inventario
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
values (10248, 2, 10, 0)
-----Verificar que el trigger ponga el precio que no enviamos en el insert
Select * from [Order Details] where orderid=10248