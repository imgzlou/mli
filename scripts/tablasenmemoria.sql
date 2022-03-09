--tablas en memoria
use EstacionMontañaSQLTEST
go

select d.compatibility_level
	from sys.databases as d
	where d.name = db_name()
go

--compatibility_level
--150

-- Si hubiera que cambiar 

alter database current
	set compatibility_level = 150
go

-------------------------------------------------
--creamos una nueva base de datos ya que la anterior de pruebas ya contenia un filegroup tipo MEMORY_OPTIMIZED_DATA 
--y solo está permitido uno por base de datos

drop database if exists EstacionMontañaSQLTST
go
create database EstacionMontañaSQLTST
go
use EstacionMontañaSQLTST
go

--en la BD donde nos ubicamos, activamos el "memory_optimized_elevate_to_snapshot"
alter database current
	set memory_optimized_elevate_to_snapshot = on
go

--create an optimized filegroup

alter database EstacionMontañaSQLTST
	add filegroup EMSQL_mod
	contains memory_optimized_data
go

--le agregamos los contenedores
-- You need to add one or more containers to the MEMORY_OPTIMIZED_DATA filegroup
alter database EstacionMontañaSQLTST
	add file (name='EMSQL_mod1',
	filename='c:\data\EMSQL_mod1')
	to filegroup EMSQL_mod
go

--
-- Look up DB Properties FILEGROUpS

-- Create a memory-optimized table

drop table if exists estacion
go
create table estacion
(
	id_estacion int primary key nonclustered, --must have primary key non clustered defined 
	numero_pistas int not null,
	kms_totales_pista int not null,
	nombre_estacion varchar(50),
	logo varbinary(max) null
)
with
	(memory_optimized = on,
	durability = schema_and_data)
go


