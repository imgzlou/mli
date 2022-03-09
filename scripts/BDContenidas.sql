use master
go

--preparamos el entorno:

--se activan las opciones avanzadas
exec sp_configure 'show advanced options',1
go

--actualizamos
reconfigure
go

--activamos la caracteristica
exec sp_configure 'contained database authentication',1
go

--actualizamos
reconfigure
go

--creamos BD contenida
drop database if exists EstacionMonta�aContenida
go

create database EstacionMonta�aContenida
containment=partial
go

use EstacionMonta�aContenida
go

--creamos el usuario I�aki
create user i�aki
	with password='Abcd1234.',
	default_schema=dbo
go

--lo a�adimos al rol db_owner
exec sp_addrolemember 'db_owner', 'i�aki'
go

alter role db_owner
add member i�aki
go

--le damos el permiso de conexi�n

grant connect to i�aki
go


--se crea una db con i�aki

create table [dbo].[TablaContenida](
	[Codigo] [nchar](10) null,
	[Nombre] [nchar](10) null
) on [primary]
go


