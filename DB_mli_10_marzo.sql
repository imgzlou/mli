use master
go

drop database if exists DB_mli_10_marzo
go

create database DB_mli_10_marzo
go

use DB_mli_10_marzo
go

--##########################################################################################################
--Generar Tabla usando como base la Tabla AdventureWorks2017/2019.Sales.SalesOrderHeader con el nombre iniciales_fecha (ej. Table_cmm_10_marzo)
--Table_mli_10_marzo

drop table if exists Table_mli_10_marzo
go

select * 
into Table_mli_10_marzo
from [AdventureWorks2017].[Sales].[SalesOrderHeader]
go

select * from Table_mli_10_marzo
go

--Crear PARTICIÓN con campo orderdate. Demostrar Funcionamiento. 
--Realizar las operaciones : SPLIT - TRUNCATE (por ejemplo, la Partición final)

--split/truncate

alter database DB_mli_10_marzo add filegroup archivo
go
alter database DB_mli_10_marzo add filegroup Part_2011
go
alter database DB_mli_10_marzo add filegroup Part_2012
go
alter database DB_mli_10_marzo add filegroup Part_2013
go
alter database DB_mli_10_marzo add filegroup Part_2014
go

alter database DB_mli_10_marzo
add file (
	name = 'archivo',
	filename = 'C:\mli_10_marzo\archivo.ndf',
	size = 100mb,
	maxsize = 100mb,
	filegrowth = 2mb
	)
to filegroup archivo
go

alter database DB_mli_10_marzo
add file (
	name = 'Part_2011',
	filename = 'C:\mli_10_marzo\Part_2011.ndf',
	size = 100mb,
	maxsize = 100mb,
	filegrowth = 2mb
	)
to filegroup Part_2011
go

alter database DB_mli_10_marzo
add file (
	name = 'Part_2012',
	filename = 'C:\mli_10_marzo\Part_2012.ndf',
	size = 100mb,
	maxsize = 100mb,
	filegrowth = 2mb
	)
to filegroup Part_2012
go

alter database DB_mli_10_marzo
add file (
	name = 'Part_2013',
	filename = 'C:\mli_10_marzo\Part_2013.ndf',
	size = 100mb,
	maxsize = 100mb,
	filegrowth = 2mb
	)
to filegroup Part_2013
go

alter database DB_mli_10_marzo
add file (
	name = 'Part_2014',
	filename = 'C:\mli_10_marzo\Part_2014.ndf',
	size = 100mb,
	maxsize = 100mb,
	filegrowth = 2mb
	)
to filegroup Part_2014
go

select * from sys.filegroups
go

--name	data_space_id	type	type_desc	is_default	is_system	filegroup_guid	log_filegroup_id	is_read_only	is_autogrow_all_files
--PRIMARY	1	FG	ROWS_FILEGROUP	1	0	NULL	NULL	0	0
--archivo	2	FG	ROWS_FILEGROUP	0	0	88606742-A245-46A5-8406-41AE78377BFD	NULL	0	0
--Part_2011	3	FG	ROWS_FILEGROUP	0	0	D71656EE-0386-4A5F-A05D-C0F327A26BBE	NULL	0	0
--Part_2012	4	FG	ROWS_FILEGROUP	0	0	C61D7B15-DA96-4508-9709-9D9540002C47	NULL	0	0
--Part_2013	5	FG	ROWS_FILEGROUP	0	0	A81AF688-E33D-4395-B0F7-9F750D848684	NULL	0	0


--partition function para 2011, 2012 y 2013
create partition function partfn_mli_10_marzo (datetime)
as range right
for values ('2011-01-01','2012-01-01','2013-01-01')
go


--partition scheme
create partition scheme partsch_mli_10_marzo
as partition partfn_mli_10_marzo
to (archivo, Part_2011, Part_2012, Part_2013, Part_2014)
go

create clustered index part_id
on Table_mli_10_marzo
(
	SalesOrderID asc
)
on partsch_mli_10_marzo(OrderDate)
go

select name, create_date, value from sys.partition_functions f
inner join sys.partition_range_values rv
on f.function_id=rv.function_id
where f.name = 'partfn_mli_10_marzo'
go
		
--name	create_date	value
--partfn_mli_10_marzo	2022-03-10 18:41:38.567	2011-01-01 00:00:00.000
--partfn_mli_10_marzo	2022-03-10 18:41:38.567	2012-01-01 00:00:00.000
--partfn_mli_10_marzo	2022-03-10 18:41:38.567	2013-01-01 00:00:00.000

select p.partition_number, p.rows from sys.partitions p
inner join sys.tables t
on p.object_id=t.object_id and t.name = 'Table_mli_10_marzo'
GO

--partition_number	rows
--1	0
--2	1607
--3	3915
--4	25943

--SPLIT - TRUNCATE


--SPLIT
alter partition function partfn_mli_10_marzo()
split range ('2014-01-01')
go

select name, create_date, value from sys.partition_functions f
inner join sys.partition_range_values rv
on f.function_id=rv.function_id
where f.name = 'partfn_mli_10_marzo'
go
--name	create_date	value
--partfn_mli_10_marzo	2022-03-10 19:00:00.420	2011-01-01 00:00:00.000
--partfn_mli_10_marzo	2022-03-10 19:00:00.420	2012-01-01 00:00:00.000
--partfn_mli_10_marzo	2022-03-10 19:00:00.420	2013-01-01 00:00:00.000
--partfn_mli_10_marzo	2022-03-10 19:00:00.420	2014-01-01 00:00:00.000


select p.partition_number, p.rows from sys.partitions p
inner join sys.tables t
on p.object_id=t.object_id and t.name = 'Table_mli_10_marzo'
GO
--partition_number	rows
--1	0
--2	1607
--3	3915
--4	14182
--5	11761

--TRUNCATE

truncate table Table_mli_10_marzo
	with (partitions(5))
go


select p.partition_number, p.rows from sys.partitions p
inner join sys.tables t
on p.object_id=t.object_id and t.name = 'Table_mli_10_marzo'
GO

--partition_number	rows
--1	0
--2	1607
--3	3915
--4	14182
--5	0    <-----vemos que se han borrado los registros



--##########################################################################################################
-- PROCEDIMIENTO ALMACENADO

--Añadimos campos NOMBRE USUARIO y PASSWORD  a la Tabla iniciales_fecha (ej. Table_cmm_16_marzo)

--Creamos una VISTA de la Tabla iniciales_fecha con nombre view_iniciales_fecha (ej. View_cmm_16_marzo)

--Dado Nombreusuario y PASSWORD como parámetros de entrada.

--Si puedes acceder actualiza un campo (cualquiera) sino puedes acceder mensaje de ACCESO PROHIBIDO

select * from Table_mli_10_marzo
go

--añadimos campos nombre y usuario

alter table Table_mli_10_marzo
add nombre_usuario varchar (20)
go

alter table Table_mli_10_marzo
add password varchar (20)
go

select * from Table_mli_10_marzo
go

update Table_mli_10_marzo
set nombre_usuario = 'paco', password ='Abcd1234.'
where SalesOrderID = 43660
go



--vista:

drop view if exists view_mli_10_marzo
go
create view view_mli_10_marzo
as
select *
from Table_mli_10_marzo
where OrderDate > 2011-01-01
go

select * from view_mli_10_marzo
go



--procedimiento almacenado: 

create or alter proc sp_mli_10_marzo
	@nombre_usuario varchar(20),
	@password varchar(20)
as
	if exists
	(select * from Table_mli_10_marzo
	where nombre_usuario=@nombre_usuario and password=@password)
	begin 
		update Table_mli_10_marzo
		set password = 'Abcd1234.'
		where nombre_usuario=@nombre_usuario
	end
else
	begin
		print 'Acceso prohibido'
	end
go

--probamos a entrar con la contraseña
execute sp_mli_10_marzo 'paco','Abcd1234.'
go

--
--(1 row affected)

--Completion time: 2022-03-10T20:29:02.7771144+01:00


--probamos con la contraseña erronea:
execute sp_mli_10_marzo 'paco','Abcd'
go

--Acceso prohibido

--Completion time: 2022-03-10T20:29:23.2470291+01:00

--##########################################################################################################
----  Queremos mantener información sobre la evolución de los Departamentos de nuestra empresa a lo largo del tiempo.

--		Estructura de la tabla Departamento:

--		DeptID,  DeptName, DepCreado , NumEmpleados


--	Crear TABLA TEMPORAL (VERSIÓN DEL SISTEMA) y demostrar funcionamiento con un par de consultas diferentes (usando Operadores).

drop database if exists tmp_mli_10_marzo
go
create database tmp_mli_10_marzo
on primary (name = 'DB_mli_10_marzo',
filename = 'C:\mli_10_marzo\DB_mli_10_marzo_fijo.mdf',
size = 15360KB, maxsize = unlimited, filegrowth = 0)
log on (name = 'DB_mli_10_marzo_log.ldf',
filename = 'C:\mli_10_marzo\DB_mli_10_marzo_log.ldf',
size = 10176KB, maxsize = 2048GB, filegrowth = 10%)
go

		--Estructura de la tabla Departamento:

		--DeptID,  DeptName, DepCreado , NumEmpleados

use tmp_mli_10_marzo
go
create table departamento_mli_10_marzo(
DeptID int Primary Key Clustered,
DeptName varchar(50),
DepCreado varchar(50),
NumEmpleados int,
SysStartTime datetime2 generated always as row start not null,
SysEndTime datetime2 generated always as row end not null,
period for System_time (SysStartTime,SysEndTime) )
with (System_Versioning = ON (History_Table = dbo.historico_departamento_mli_10_marzo)
)
go

--insertamos datos en la tabla
insert into departamento_mli_10_marzo (DeptID, DeptName, DepCreado, NumEmpleados)
values (1, 'RRHH', 'RRHH', 3),
		(2, 'Contabilidad', 'Contabilidad', 5),
		(3, 'Informatica', 'Informatica', 4),
		(4, 'Ventas', 'Ventas', 7)
go

select * from departamento_mli_10_marzo
go

--DeptID	DeptName	DepCreado	NumEmpleados	SysStartTime	SysEndTime
--1	RRHH	RRHH	3	2022-03-10 18:50:34.6240012	9999-12-31 23:59:59.9999999
--2	Contabilidad	Contabilidad	5	2022-03-10 18:50:34.6240012	9999-12-31 23:59:59.9999999
--3	Informatica	Informatica	4	2022-03-10 18:50:34.6240012	9999-12-31 23:59:59.9999999
--4	Ventas	Ventas	7	2022-03-10 18:50:34.6240012	9999-12-31 23:59:59.9999999

--al insertar no se actualiza nada de la tabla del histórico ya que no supone un cambio que se pueda registrar
select * from dbo.historico_departamento_mli_10_marzo
go

--DeptID	DeptName	DepCreado	NumEmpleados	SysStartTime	SysEndTime

--modificamos la columna NumEmpleados de RRHH
update departamento_mli_10_marzo
	set NumEmpleados = 2
	where DeptID = 1
go

--consultamos la tabla original para ver el cambio:
select * from departamento_mli_10_marzo
go

--DeptID	DeptName		DepCreado			NumEmpleados	SysStartTime	SysEndTime
--1			RRHH				RRHH			2				2022-03-10 18:53:25.4140271	9999-12-31 23:59:59.9999999
--2			Contabilidad		Contabilidad	5				2022-03-10 18:50:34.6240012	9999-12-31 23:59:59.9999999
--3			Informatica			Informatica		4				2022-03-10 18:50:34.6240012	9999-12-31 23:59:59.9999999
--4			Ventas				Ventas			7				2022-03-10 18:50:34.6240012	9999-12-31 23:59:59.9999999

--ahora consultamos la tabla del historico:
select * from dbo.historico_departamento_mli_10_marzo
go

--y podemos ver que se ha registrado la modificacion apareciendo en la tabla el valor antiguo
--DeptID	DeptName	DepCreado	NumEmpleados	SysStartTime	SysEndTime
--1			RRHH		RRHH		3				2022-03-10 18:50:34.6240012	2022-03-10 18:53:25.4140271

--lo mismo con un truncate
--se borra el departamento de contabilidad:
delete from departamento_mli_10_marzo
where DeptID = 2
go

--vemos que ya no está en la tabla original:
select * from departamento_mli_10_marzo
go
--DeptID		DeptName	DepCreado		NumEmpleados	SysStartTime	SysEndTime
--1				RRHH		RRHH			2				2022-03-10 18:53:25.4140271	9999-12-31 23:59:59.9999999
--3				Informatica	Informatica		4				2022-03-10 18:50:34.6240012	9999-12-31 23:59:59.9999999
--4				Ventas		Ventas			7				2022-03-10 18:50:34.6240012	9999-12-31 23:59:59.9999999

--y vemos que se registra en la tabla de historico:
select * from dbo.historico_departamento_mli_10_marzo
go
--DeptID		DeptName		DepCreado		NumEmpleados	SysStartTime	SysEndTime
--1				RRHH			RRHH			3				2022-03-10 18:50:34.6240012	2022-03-10 18:53:25.4140271
--2				Contabilidad	Contabilidad	5				2022-03-10 18:50:34.6240012	2022-03-10 18:57:12.8751244
