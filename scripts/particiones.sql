
use master
go

drop database if exists EstacionMontañaSQLTEST
go
create database EstacionMontañaSQLTEST
	on primary (name = 'EstacionMontañaSQLTEST',
		filename = 'C:\data\EstacionMontañaSQLTEST_fijo.mdf',
		size = 15360KB, maxsize = unlimited, filegrowth = 0)
	log on (name = 'EstacionMontañaSQLTEST_log.ldf',
		filename = 'C:\data\EstacionMontañaSQLTEST_log.ldf',
		size = 10176KB, maxsize = 2048GB, filegrowth = 10%)
go

--paso los datos de la original a test
use [EstacionMontañaSQLTEST]
go

alter database EstacionMontañaSQLTEST add filegroup [EMSQL_Archivo]
go
alter database EstacionMontañaSQLTEST add filegroup [EMSQLFileGroup_2020]
go
alter database EstacionMontañaSQLTEST add filegroup [EMSQLFileGroup_2021]
go
alter database EstacionMontañaSQLTEST add filegroup [EMSQLFileGroup_2022]
go
-------------------

select * from sys.filegroups
go

--name	data_space_id	type	type_desc	is_default	is_system	filegroup_guid	log_filegroup_id	is_read_only	is_autogrow_all_files
--PRIMARY	1	FG	ROWS_FILEGROUP	1	0	NULL	NULL	0	0
--EMSQL_Archivo	2	FG	ROWS_FILEGROUP	0	0	707D635A-8163-4D73-A124-2F2709145A69	NULL	0	0
--EMSQLFileGroup_2020	3	FG	ROWS_FILEGROUP	0	0	77545DF4-DE47-4685-9106-9EEF753DDC1B	NULL	0	0
--EMSQLFileGroup_2021	4	FG	ROWS_FILEGROUP	0	0	1B939EAF-706C-4026-8FBC-A66DDA87AA85	NULL	0	0
--EMSQLFileGroup_2022	5	FG	ROWS_FILEGROUP	0	0	2F23BF8F-5A6E-418F-9872-209567A58671	NULL	0	0

--añadimos content

use EstacionMontañaSQLTEST
go

alter database EstacionMontañaSQLTEST 
add file (
	name = 'Alquiler_Archivo',
	filename = 'c:\data\Alquiler_Archivo.ndf',
	size = 100mb, 
	maxsize = 100mb,
	filegrowth = 2mb
	)
to filegroup [EMSQL_Archivo]
go

alter database EstacionMontañaSQLTEST 
add file (
	name = 'Alquiler_2020',
	filename = 'c:\data\Alquiler_2020.ndf',
	size = 5mb,
	maxsize = 100mb,
	filegrowth = 2mb
	)
to filegroup [EMSQLFileGroup_2020]
go

alter database EstacionMontañaSQLTEST 
add file (
	name = 'Alquiler_2021',
	filename = 'c:\data\Alquiler_2021.ndf',
	size = 5mb,
	maxsize = 100mb,
	filegrowth = 2mb
	)
to filegroup [EMSQLFileGroup_2021]
go

alter database EstacionMontañaSQLTEST 
add file (
	name = 'Alquiler_2022',
	filename = 'c:\data\Alquiler_2022.ndf',
	size = 5mb,
	maxsize = 100mb,
	filegrowth = 2mb
	)
to filegroup [EMSQLFileGroup_2022]
go

select * from sys.filegroups
go

--name	data_space_id	type	type_desc	is_default	is_system	filegroup_guid	log_filegroup_id	is_read_only	is_autogrow_all_files
--PRIMARY	1	FG	ROWS_FILEGROUP	1	0	NULL	NULL	0	0
--EMSQL_Archivo	2	FG	ROWS_FILEGROUP	0	0	D52C6C3D-1E77-435A-8A46-AFC8153CA2A1	NULL	0	0
--EMSQLFileGroup_2020	3	FG	ROWS_FILEGROUP	0	0	DECF1333-1CD6-4CE6-ABA6-8CAE564F924D	NULL	0	0
--EMSQLFileGroup_2021	4	FG	ROWS_FILEGROUP	0	0	E8408C0F-1D43-400A-9792-74513B22F573	NULL	0	0
--EMSQLFileGroup_2022	5	FG	ROWS_FILEGROUP	0	0	374E41B5-BD98-41C1-9E5B-091D87FC969E	NULL	0	0

select * from sys.database_files
go

--file_id	file_guid	type	type_desc	data_space_id	name	physical_name	state	state_desc	size	max_size	growth	is_media_read_only	is_read_only	is_sparse	is_percent_growth	is_name_reserved	is_persistent_log_buffer	create_lsn	drop_lsn	read_only_lsn	read_write_lsn	differential_base_lsn	differential_base_guid	differential_base_time	redo_start_lsn	redo_start_fork_guid	redo_target_lsn	redo_target_fork_guid	backup_lsn
--1	E1428E28-8399-4389-A6E6-A46C6DEA2178	0	ROWS	1	EstacionMontañaSQLTEST	C:\data\EstacionMontañaSQLTEST_fijo.mdf	0	ONLINE	1920	-1	0	0	0	0	0	0	0	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
--2	A04A924D-81BF-4186-B746-D613AFC4BF4A	1	LOG	0	EstacionMontañaSQLTEST_log.ldf	C:\data\EstacionMontañaSQLTEST_log.ldf	0	ONLINE	1272	268435456	10	0	0	0	1	0	0	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
--3	76EBA67A-0A13-49C7-9DB3-C29792B2570E	0	ROWS	2	Alquiler_Archivo	c:\data\Alquiler_Archivo.ndf	0	ONLINE	12800	12800	256	0	0	0	0	0	0	37000000033500001	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
--4	FB7DDB86-B139-4AA7-93B6-7E08E189960C	0	ROWS	3	Alquiler_2020	c:\data\Alquiler_2020.ndf	0	ONLINE	640	12800	256	0	0	0	0	0	0	37000000036300001	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
--5	91308CFA-FFB8-400A-80D0-3EECE95E8AAD	0	ROWS	4	Alquiler_2021	c:\data\Alquiler_2021.ndf	0	ONLINE	640	12800	256	0	0	0	0	0	0	37000000039100001	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL
--6	4F13CBBE-DB22-47FD-905F-3BFF121F1ED4	0	ROWS	5	Alquiler_2022	c:\data\Alquiler_2022.ndf	0	ONLINE	640	12800	256	0	0	0	0	0	0	37000000041900001	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL	NULL

--creamos schema
use EstacionMontañaSQLTEST
go
drop schema if exists EMSQLtest
go
create schema EMSQLtest
go

-- PARTITION FUNCTION
-- BOUNDARIES (LIMITES)
--creamos funcion donde vamos a establecer los rangos de fechas que queramos.
--alquiler anterior a 2020, los de 2020, y los de despues de 1-1-2021

--partition function
create partition function fn_fecha_alquiler (datetime)
as range right 
	for values ('2020-01-01','2021-01-01')
	go
go

-- PARTITION SCHEME
--los rangos establecidos se asignarán a sus filestream corresponientes
--anteriores de 2020 a archivo, los de 2020 a 2020, los de 2021 en adelante a 2021, 2022 queda vacio porque no se le asigno rango.

create partition scheme alquiler_fecha
as partition fn_fecha_alquiler
	to (EMSQL_Archivo, EMSQLFileGroup_2020, EMSQLFileGroup_2021, EMSQLFileGroup_2022)
go

--creamos la tabla indicandole el esquema de particion y que campo usará para determinar la particio a la que pertnece cada registro


drop table if exists dbo.alquiler
go

create table dbo.alquiler(
	id_alquiler int not null,
	fecha_hora_recogida datetime,
	fecha_hora_entrega datetime,
	datos_cliente_dni_cliente varchar(9)
	)
	on alquiler_fecha --partitio scheme
		(fecha_hora_recogida)--the column to apply the function within the scheme
go


--insertamos datos del 2019:

insert into dbo.alquiler
values (1, '2019-01-22 09:30:00', '2020-01-22 17:15:00', '67346546J'),
		(2, '2019-01-22 09:30:00', '2021-01-22 17:15:00', '67342346B'),
		(3, '2019-01-23 09:45:00', '2022-01-23 18:30:00', '66638746J')
go

--insertamos datos del 2020:

insert into dbo.alquiler
values (4, '2020-01-22 09:30:00', '2020-01-22 17:15:00', '67337486J'),
		(5, '2020-01-22 09:30:00', '2021-01-22 17:15:00', '67485246B'),
		(6, '2020-01-23 09:45:00', '2022-01-23 18:30:00', '66636246J')
go

--insertamos datos del 2021:

insert into dbo.alquiler
values (7, '2021-01-22 09:30:00', '2020-01-22 17:15:00', '67346546J'),
		(8, '2021-01-22 09:30:00', '2021-01-22 17:15:00', '67342346B'),
		(9, '2021-01-23 09:45:00', '2022-01-23 18:30:00', '66638746J')
go

--insertamos datos del 2022:

insert into dbo.alquiler
values (10, '2022-01-22 09:30:00', '2020-01-22 17:15:00', '67346546J'),
		(11, '2022-01-22 09:30:00', '2021-01-22 17:15:00', '67342346B'),
		(12, '2022-01-23 09:45:00', '2022-01-23 18:30:00', '66638746J')
go

--consultamos los datos

select * from dbo.alquiler
go

--metadata information

--con esta select podemos ver qué entradas están en qué particiones:
select *,$Partition.fn_fecha_alquiler(fecha_hora_recogida) AS partition
from dbo.alquiler
go

-- partition function
--con esta select podemos ver información de las particiones:
select name, create_date, value from sys.partition_functions f 
inner join sys.partition_range_values rv 
on f.function_id=rv.function_id 
where f.name = 'fn_fecha_alquiler'
go

--con esta select vemos el número de registros que hay en cada partición:
select p.partition_number, p.rows from sys.partitions p 
inner join sys.tables t 
on p.object_id=t.object_id and t.name = 'alquiler' 
GO


--ver particiones, su filegroup, registros y rangos de cada una:
DECLARE @TableName NVARCHAR(200) = N'alquiler' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] ,
p.partition_number AS [p#] ,
fg.name AS [filegroup] 
, p.rows ,
au.total_pages AS pages ,
CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison ,
rv.value ,
CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) +
SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20),
CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) +
SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS
first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id 
INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id 
INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number 
INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id 
AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO


-- PARTITIONS OPERATIONS
--Split#################################################################################################

alter partition function fn_fecha_alquiler()
split range ('2022-01-01');
go

--comprobamos que los alquileres realizados en 2022 se han colocado en la cuarta partición:
select *,$Partition.fn_fecha_alquiler(fecha_hora_recogida) AS partition
from dbo.alquiler
go

--con esta sentencia ahora podemos ver la nueva partición y nuevo rango:
DECLARE @TableName NVARCHAR(200) = N'alquiler' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] ,
p.partition_number AS [p#] ,
fg.name AS [filegroup] 
, p.rows ,
au.total_pages AS pages ,
CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison ,
rv.value ,
CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) +
SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20),
CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) +
SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS
first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id 
INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id 
INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number 
INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id 
AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

--merge########################################################################################

--Se utiliza el merge para eliminar un rango de los anteriores creados.
--Para este ejemplo vamos a eliminar el rango de 2020, una vez eliminado los datos que se situaban en dicho rango pasarán a formar parte de la partición de Archivo.

alter partition function fn_fecha_alquiler ()
merge range ('2020-01-01')
go

--comprobamos que se ha borrado el rango:
DECLARE @TableName NVARCHAR(200) = N'alquiler' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] ,
p.partition_number AS [p#] ,
fg.name AS [filegroup] 
, p.rows ,
au.total_pages AS pages ,
CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison ,
rv.value ,
CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) +
SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20),
CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) +
SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS
first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id 
INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id 
INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number 
INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id 
AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

  --una vez el filegroup está vacío lo podemos eliminar:
use master
go

alter database [EstacionMontañaSQLTEST]
remove file EMSQLFileGroup_2020
go

  --switch##################

  DECLARE @TableName NVARCHAR(200) = N'alquiler' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] ,
p.partition_number AS [p#] ,
fg.name AS [filegroup] 
, p.rows ,
au.total_pages AS pages ,
CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison ,
rv.value ,
CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) +
SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20),
CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) +
SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS
first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id 
INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id 
INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number 
INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id 
AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

  use EstacionMontañaSQLTEST
  go

 drop table if exists archivo_alquiler
 go

 create table archivo_alquiler (
	id_alquiler int not null,
	fecha_hora_recogida datetime,
	fecha_hora_entrega datetime,
	datos_cliente_dni_cliente varchar(9))
on EMSQL_Archivo
go

alter table dbo.alquiler
	switch partition 1 to archivo_alquiler
go

select * from alquiler
go

select * from archivo_alquiler
go

DECLARE @TableName NVARCHAR(200) = N'alquiler' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] ,
p.partition_number AS [p#] ,
fg.name AS [filegroup] 
, p.rows ,
au.total_pages AS pages ,
CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison ,
rv.value ,
CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) +
SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20),
CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) +
SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS
first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id 
INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id 
INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number 
INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id 
AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO

--truncate#############################################################

--con truncate vamos a borrar los registros de una tabla

truncate table alquiler
	with (partitions(3))
go

--comprobamos:

select * from alquiler
go


DECLARE @TableName NVARCHAR(200) = N'alquiler' 
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object] ,
p.partition_number AS [p#] ,
fg.name AS [filegroup] 
, p.rows ,
au.total_pages AS pages ,
CASE boundary_value_on_right WHEN 1 THEN 'less than' ELSE 'less than or equal to' END as comparison ,
rv.value ,
CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) +
SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20),
CONVERT (INT, SUBSTRING (au.first_page, 4, 1) + SUBSTRING (au.first_page, 3, 1) +
SUBSTRING (au.first_page, 2, 1) + SUBSTRING (au.first_page, 1, 1))) AS
first_page FROM sys.partitions p INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id INNER JOIN sys.objects o
ON p.object_id = o.object_id INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id 
INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id 
INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number 
INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id 
AND p.partition_number = rv.boundary_id WHERE i.index_id < 2 AND o.object_id = OBJECT_ID(@TableName);
GO








  







