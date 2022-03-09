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
drop database if exists EstacionMontañaContenida
go

create database EstacionMontañaContenida
containment=partial
go

use EstacionMontañaContenida
go

--creamos el usuario Iñaki
create user iñaki
	with password='Abcd1234.',
	default_schema=dbo
go

--lo añadimos al rol db_owner
exec sp_addrolemember 'db_owner', 'iñaki'
go

alter role db_owner
add member iñaki
go

--le damos el permiso de conexión

grant connect to iñaki
go


--se crea una db con iñaki

create table [dbo].[TablaContenida](
	[Codigo] [nchar](10) null,
	[Nombre] [nchar](10) null
) on [primary]
go


