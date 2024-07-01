Use Northwind
go
---Xml.query
declare @mydoc xml
set @mydoc='
<root>
<productdescription productid="1" productname="rood bike">
	<Features>
		<warranty>1 año de garantia para partes</warranty>
		<maintenance>3 años de mantenimiento</maintenance>
	</Features>
</productdescription>
<productdescription productid="2" productname="Mountain bike">
	<Features>
		<warranty>5 año de garantia para partes</warranty>
		<maintenance>2 años de mantenimiento</maintenance>
	</Features>
</productdescription>
</root>
'
Select @mydoc.query('(/root/productdescription/Features/maintenance)[2]')

---XML.value
declare @mydoc xml
set @mydoc='<root>
<productdescription productid="1" productname="rood bike">
	<Features>
		<warranty>1 año de garantia para partes</warranty>
		<maintenance>3 años de mantenimiento</maintenance>
	</Features>
</productdescription>
<productdescription productid="2" productname="Mountain bike">
	<Features>
		<warranty>5 año de garantia para partes</warranty>
		<maintenance>2 años de mantenimiento</maintenance>
	</Features>
</productdescription>
</root>'
declare @bike varchar(100)
set @bike= @mydoc.value('(/root/productdescription/@productname)[2]', 'varchar(100)')
Select @bike
GO

--Creando una columna de tipo Xml en la tabla Orders (probablemente exista del ejercicio anterior)
USE Northwind
GO
ALTER TABLE ORDERS
ADD Details	XML

--Actualizando los datos de la columna Details
Update o set o.details=(Select d1.OrderId, d1.ProductID
						, d1.UnitPrice, d1.Quantity,d1.Discount
						from [Order Details] as d1 
						where o.orderid=d1.OrderID for xml auto
						) from orders as o inner join [order details] as d
						on o.orderid=d.orderid
---XML.Nodes
declare @mydoc xml
set @mydoc=(Select Details from orders where orderid=10248)
Select 
OrderId= T.Item.value ('@OrderId','bigint'),
ProductId= T.Item.value ('@ProductID','bigint'),
Unitprice= T.Item.value ('@UnitPrice','money'),
Quantity= T.Item.value ('@Quantity','bigint'),
Discount= T.Item.value ('@Discount','real')
from @mydoc.nodes('d1') as T(Item)
go


--Usando OpenXML
Declare @mydoc xml, @i int
Set @mydoc = '<root>
<person LastName="White" FirstName="Johnson"/>
<person LastName="Green" FirstName="Marjorie"/>
<person LastName="Carson" FirstName="Cheryl"/>
</root>'
Exec sp_xml_preparedocument @i output, @mydoc
Select * from OPENXML(@i, '/root/person') with (LastName nvarchar(50),
                                                FirstName nvarchar(50))










Select * from orders












