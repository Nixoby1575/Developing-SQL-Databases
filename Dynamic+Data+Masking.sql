CREATE database TestDataMasking
go
Use TestDataMasking
go
--Creacion de tabla
Create table dbo.Cliente
(
Cliente_Codigo int,
Cliente_Nombre varchar(100),
Cliente_FechaInicio datetime,
Cliente_EMail varchar(100),
Cliente_TarjetaCredito Varchar(100)
)           
go

 -- ingreso de datos de ejemplo
Insert into dbo.Cliente 
values(101,'Visoalgt','2016-08-11 00:34:51:090','YoshiTannamuri@visoalgt.com','9135-5555-8798')
Insert into dbo.Cliente 
values(102,'Cardenas Corp','2016-01-08 19:44:51:090','DanielTonini@cardenas.com','1555-9857-8709')
Insert into dbo.Cliente 
values(103,'Alfreds Futterkiste','2015-08-19 19:44:51:090','PhilipCramer@futterkiste.com','7675-3425-3433')
Insert into dbo.Cliente 
values(104,'Antonio Moreno Taquería','2014-08-19 19:44:51:090','PatriciaMcKenna@tqueria.com','5535-0297-6523')
Insert into dbo.Cliente 
values(105,'Around the Horn','2014-08-04 19:44:51:090','YoshiLatimer@araound.com','1354-2534-4534')
Insert into dbo.Cliente 
values(106,'Berglunds snabbköp','2015-08-10 19:44:51:090','chbrancar@beglunds.com','5203-4560-5455')
Insert into dbo.Cliente 
values(107,'Bs Beverages','2015-04-17 19:44:51:090','SimonCrowther@beverages','555-9482-3587')
Insert into dbo.Cliente 
values(108,'Bólido Comidas preparadasCable VGA','2015-08-21 19:44:51:090','FelipeIzquierdo@bolido.com','555-7555-4545')
Insert into dbo.Cliente 
values(109,'X enterprice','2015-08-06 19:44:51:090','CarlosGonzalez@xenterprice.com','2833-2951-4544')
Insert into dbo.Cliente 
values(110,'Chop-suey Chinese','2015-08-26 19:44:51:090','JohnSteel@chop.com','5535-1340-3453')
go
---Consultar la tabla
Select * from Cliente

-- Se mostraran los dos primeros caracteres y el ultimo caracter del nombre
ALTER TABLE dbo.Cliente ALTER COLUMN Cliente_Nombre  
    ADD MASKED WITH (FUNCTION = 'partial(2, "XXXXXXXX", 1)');

-- Todas las direcciones de correo se mostraran nXXX@XXXX.com
ALTER TABLE dbo.Cliente ALTER COLUMN Cliente_Email  
    ADD MASKED WITH (FUNCTION = 'email()');

-- Se motrara el dato de la siguiente manera nXXX-XXXX-XXXXn
ALTER TABLE dbo.Cliente ALTER COLUMN Cliente_TarjetaCredito       
    ADD MASKED WITH (FUNCTION = 'partial(1,"XXXX-XXXX-XXXXX",1)');

    -- Todas las fechas las mostrara como 1900-01-01 
ALTER TABLE dbo.Cliente ALTER COLUMN Cliente_FechaInicio 
    ADD MASKED WITH (FUNCTION = 'default()');


--creacion de usuarios para prueba
Create user VICTOR without login;

--asignacion de permisos a los usuarios de prueba
GRANT SELECT ON dbo.Cliente to VICTOR;

--Ejecución de una consulta en nombre del usuario recien creado
Execute ('SELECT * FROM DBO.Cliente') as user='VICTOR';
go

--Modificar una mascara
ALTER TABLE dbo.Cliente ALTER COLUMN Cliente_TarjetaCredito       
    ADD MASKED WITH (FUNCTION = 'partial(0,"XXXX-XXXX-XXXXX",4)');
--Consultar
Select * from dbo.Cliente

--Eliminar una Mascara
ALTER TABLE dbo.Cliente ALTER COLUMN Cliente_TarjetaCredito DROP MASKED;

Select * 
into Clientes2
from dbo.Cliente

Select * from clientes2