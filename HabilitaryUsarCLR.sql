use Northwind
go

--habilitar las opciones avanzadas
exec sp_configure 'show advanced option','1'
go
Reconfigure
go
--habilitar el clr
exec sp_configure 'clr enabled','1'
go
Reconfigure
go
--crear el ensamblado
Create assembly StoredProceduresAsm from 
'D:\vhcardenas\Documents\Visual Studio 2015\Projects\EjemploCLR\EjemploCLR\bin\Debug\EjemploCLR.dll'
with permission_set=SAFE
go
---Creando el procedimiento que llama al CLR
Create procedure GetVersion as External Name
StoredProceduresAsm.StoredProcedures.StoreProcedures
go

--Creando la funcion que llama al CLR
Create function Iva(@monto float)
returns float
external name StoredProceduresAsm.StoredProcedures.MontoConIva
go
---Ejecutar el procedimimento
Exec GetVersion
---Ejecutar la funcion
Select productname, unitprice, dbo.Iva(unitprice) as MontoConIva from Products


