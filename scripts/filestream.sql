use master
go

exec sp_configure
go

exec sp_configure filestream_access_level
go

exec sp_configure filestream_access_level, 2
reconfigure
go

drop database if exists EstacionMontañaSQLTEST
go

create database EstacionMontañaSQLTEST
go

use EstacionMontañaSQLTEST
go


alter database EstacionMontañaSQLTEST
	add filegroup EMSQLFile01
	contains filestream
go

alter database EstacionMontañaSQLTESt
	add file (
				name= 'EM_filestream',
				filename = 'C:\EMSQLFilestream'
			)
	to filegroup EMSQLFile01
go


drop table if exists estacionTEST
go

CREATE TABLE [dbo].[estacionTEST](
	id uniqueidentifier rowguidcol not null unique,
	[numero_pistas] [int] NOT NULL,
	[kms_totales_pista] [int] NOT NULL,
	[nombre_estacion] [varchar](50) NULL,
	[logo] [varbinary](max) filestream
);
go

insert into [dbo].[estacionTEST] ([id],[numero_pistas],[kms_totales_pista],[nombre_estacion],[logo])
select newid(), '25', '22', 'Manzaneda Estación de Montaña', bulkcolumn
from openrowset  ( BULK 'C:\IMGEstacionMontaña\logo.jpg',SINGLE_BLOB)  as ImageFile
go

drop table if exists pistaTEST
go

CREATE TABLE [dbo].[pistaTEST](
	id uniqueidentifier rowguidcol not null unique,
	[estado_pista] [varchar](30) NOT NULL,
	[nombre_pista] [varchar](50) NULL,
	[longitud] [varchar](30) NOT NULL,
	[dificultad] [varchar](30) NOT NULL,
	[zona] [varchar](50) NULL,
	[mapa_pistas] [varbinary](max) filestream
);
go

insert into [dbo].[pistaTEST] (id, estado_pista, nombre_pista, longitud, dificultad, zona, mapa_pistas)
select newid(), 'Abierta', 'Os Carqueixos', '400m', 'Azul', '4', bulkcolumn
from openrowset  ( BULK 'C:\IMGEstacionMontaña\mapa_pistas.jpg',SINGLE_BLOB)  as ImageFile
go

select * from estacionTEST
go

select * from pistaTEST
go


alter table estacionTEST
drop column logo
go
alter table estacionTEST
set (filestream_on="null")
go


alter table pistaTEST
drop column mapa_pistas
go
alter table pistaTEST
set (filestream_on="null")
go

alter database EstacionMontañaSQLTEST
remove file EM_filestream;
go
--Msg 5042, Level 16, State 13, Line 95
--The file 'EM_filestream' cannot be removed because it is not empty.

use master
go

alter database EstacionMontañaSQLTEST
remove file EM_filestream;
go

--The file 'EM_filestream' has been removed.

alter database EstacionMontañaSQLTEST
remove filegroup EMSQLFile01
go

--The filegroup 'EMSQLFile01' has been removed.


drop database EstacionMontañaSQLTEST
go



















