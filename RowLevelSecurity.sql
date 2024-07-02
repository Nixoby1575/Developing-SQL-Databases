CREATE database TestRowLevel
go
Use TestRowLevel
go
--Creacion de tabla
Create table dbo.Ordenes
(
Codigo_Cliente int,
Nombre_Producto varchar(100),
Fecha datetime,
Cantidad int,
ProcesadoPor Varchar(10)
)           
go
 -- ingreso de datos de ejemplo
Insert into dbo.Ordenes 
values(101,'Monitores','2016-11-08 00:34:51:090',100,'SOFIA')
Insert into dbo.Ordenes 
values(102,'Teclados CORP','2016-01-08 19:44:51:090',700,'SOFIA')
Insert into dbo.Ordenes 
values(103,'Memoria RAM','2015-19-08 19:44:51:090',1500,'SOFIA')
Insert into dbo.Ordenes 
values(102,'Disco Duro','2014-19-08 19:44:51:090',1099,'CLAUDIA')
Insert into dbo.Ordenes 
values(101,'Web Cam','2014-08-04 19:44:51:090',5600,'CLAUDIA')
Insert into dbo.Ordenes 
values(103,'Ratones','2015-08-10 19:44:51:090',498,'HUGO')
Insert into dbo.Ordenes 
values(102,'Cable HDMI','2015-17-04 19:44:51:090',999,'HUGO')
Insert into dbo.Ordenes 
values(101,'Cable VGA','2015-21-08 19:44:51:090',543,'VICTOR')
Insert into dbo.Ordenes 
values(103,'Conectores RJ45','2015-08-06 19:44:51:090',876,'VICTOR')
Insert into dbo.Ordenes 
values(102,'Memory Stick','2015-26-08 19:44:51:090',665,'VICTOR')
go
--Creacion de la funcion de predicado que filtra que ordenes
--fueron realizadas por cada usuario
-- Filtro será aplicada durante la ejecución de la consulta

Create Function dbo.fn_SeguridadOrdenes (@ProcesadoPor sysname)
returns table with Schemabinding
as
return select 1 as [fn_SeguridadOrdenes_result]
from 
dbo.Ordenes
where @ProcesadoPor = user_name()  
go
--Creacion de la politica de seguridad al crearla
--aplicará la limitación de acceso a los usuarios
Create security Policy fn_seguridad
add Filter Predicate
dbo.fn_SeguridadOrdenes(ProcesadoPor)
on dbo.Ordenes
go
--creacion de usuarios para prueba
Create user VICTOR without login;
Create user HUGO without login;
Create user CLAUDIA without login;
Create user SOFIA without login;
--asignacion de permisos a los usuarios de prueba
GRANT SELECT ON dbo.Ordenes to CLAUDIA;
GRANT SELECT ON dbo.Ordenes to SOFIA;
GRANT SELECT ON dbo.Ordenes to HUGO;
GRANT SELECT ON dbo.Ordenes to VICTOR;

Execute ('SELECT * FROM DBO.ORDENES') as user='SOFIA';
go
