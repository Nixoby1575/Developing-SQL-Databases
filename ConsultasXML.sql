Use Northwind
go
---xml auto
select s.companyname, p.productname, p.unitprice
from suppliers as s inner join products as p on s.SupplierID=p.SupplierID
for xml auto
go
---xml path
select s.companyname, p.productname, p.unitprice
from suppliers as s inner join products as p on s.SupplierID=p.SupplierID
for xml path
go
---xml raw
select s.companyname, p.productname, p.unitprice
from suppliers as s inner join products as p on s.SupplierID=p.SupplierID
for xml raw
go

---xml explicit
Select 1 as Tag, null as parent, customerid as [cliente!1!customerid], 
contactname as [cliente!1], null as [orden!2!ordenid], null as [orden!2]
from customers where customerid='ALFKI'
union all
Select 2 as Tag, 1 as parent, c.customerid, c.contactname, o.orderid, o.shipaddress
from customers as c inner join orders as o on c.CustomerID=o.CustomerID
where c.CustomerID='ALFKI'
for xml explicit
go
-- Realizamos las consultas
select * from Orders
select * from [Order Details]
--agregar una columna tipo XML a la tabla orders
Alter table orders
Add Details xml
go
--Consultando las tablas orders y order details
select o.orderid, o.orderdate, d.productid, d.unitprice, d.quantity
from orders as o inner join [Order Details] as d on o.OrderID=d.OrderID
go
--Actualizando el campo details de la tabla orders con un xml con datos de order details
update o set o.details=
(select d.orderid, d.productid, d.unitprice, d.quantity,
d.discount from [Order Details] as d where o.orderid=d.orderid for xml auto)
from orders as o inner join [Order Details] as d on o.OrderID=d.OrderID
go
--Consultando la tabla ordes ya con el campo details de tipo xml actualizado.
select * from orders





















