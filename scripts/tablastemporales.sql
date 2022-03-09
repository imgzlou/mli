--se crea la base de datos a la que se le añade la tabla de historico
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

use EstacionMontañaSQLTEST
go
drop table if exists material
go
create table material
	(   id_material int Primary Key Clustered, --must have primary key defined.
		modalidad  varchar(100) not null,
		precio money not null,
		tipo_material varchar(100),
		marca varchar(50),
	SysStartTime datetime2 generated always as row start not null,  
	SysEndTime datetime2 generated always as row end not null,  
	period for System_time (SysStartTime,SysEndTime) ) 
	with (System_Versioning = ON (History_Table = dbo.material_historico)
	) 
go

select * from material
go
select * from dbo.material_historico
go

--metemos datos 

insert into material ([id_material],[modalidad],[precio],[tipo_material],[marca])
values ( 1, 'Esqui',325, 'Par de esqui', 'Rossignol'),
		( 2, 'Snow',400, 'Tabla snow', 'Burton'),
		( 3, 'Nieve',50, 'Casco proteccion', 'TSG'),
		( 4, 'Esqui',150, 'Botas esqui', 'Rossignol'),
		( 5, 'Snow',150, 'Botas snow', 'Burton'),
		( 6, 'Esqui',40, 'Palos esqui', 'Rossignol')
go

--vemos los datos
select * from material
go

--en la tabla de historico no hay nada ya que no se han hecho cambios
select * from dbo.material_historico
go

--hacemos cambios, el precio los esquís id=1 de 325 pasa a ser de 300 
update material
	set precio = 300
	where id_material = 1
GO

--vemos que ahora está el precio nuevo
select * from material
go

--y esta tabla guarda el precio antiguo
select * from dbo.material_historico
go

--el precio de la tabla de snow(id=2) de 400 pasa a ser de 325
update material
	set precio = 325
	where id_material = 2
GO

--vemos que ahora está el precio nuevo
select * from material
go

--y esta tabla guarda el precio antiguo
select * from dbo.material_historico
go

--quitamos de la venta el casco (id=3)
delete from material
where id_material=3
go


--vemos que el caso ya no esta en catalogo
select * from material
go

--y vemos que el delete tambien se registra en la tabla de historico
select * from dbo.material_historico
go

--insertamos un nuevo modelo de casco

insert into material ([id_material],[modalidad],[precio],[tipo_material],[marca])
values ( 7, 'Nieve',70, 'Casco proteccion', 'Bell')
go

--vemos el casco nuevo en el catalogo
select * from material
go

--y vemos que el insert no se refleja en el historico
select * from dbo.material_historico
go

--con este select vemos todas las operaciones de la tabla:
select * 
from material
for system_time all 
go

--ver el estado de la tabla en un punto del tiempo
select * 
from material
for system_time as of '2022-03-06 17:26:36.4724596' 
go

--ver el historico de cambios hechos en un rango de fechas
select * 
from material
for system_time from '2022-03-06 17:26:36.4724596' to '2022-03-06 17:43:56.1905360' 
go


-- Between es similar al anterior pero toma referencia el SysStartTime
select * 
from material
for system_time between '2022-03-06 17:43:56.1905360' and '2022-03-06 17:26:36.4724596'
GO

-- Con for system_time conained in vemos los registros que se han introducido entre dos horas:
--en este caso entre las 17:26:00 y las 17:27:00
select * 
from material
for system_time contained in ('2022-03-06 17:26:00.0000000','2022-03-06 17:27:00.0000000')
GO



SELECT * FROM [dbo].[reserva_plaza]
GO


SELECT * FROM [dbo].[reserva_plaza_historico]
GO






