use master
go

exec sp_configure filestream_access_level, 2
reconfigure
go

drop database if exists EstacionMontañaSQLTEST
go

--Se crea la carpeta 'C:\EMSQLFiletable'

create database EstacionMontañaSQLTEST
on primary 
(
	name = EMSQLFiletable_data,
	filename = 'C:\EMSQLFiletable\EMSQLFiletableDATA.mdf'
),
filegroup FileSteamFG contains filestream --(se guarda como ndf)
(
	name = EstacionMontañaSQLTEST,
	filename = 'C:\EMSQLFiletable\EMSQL_Container' 
)
log on
(
	name = ManzanedaFiletable_Log,
	filename = 'C:\EMSQLFiletable\EMSQL_Log.ldf'
)
with filestream
(
	non_transacted_access = full,
	directory_name = 'EMSQLContainer'
);
go

--consultar opciones de filetable:
-------------------------
-- METADATA

-- Check the Filestream Options
SELECT DB_NAME(database_id),
non_transacted_access,
non_transacted_access_desc
FROM sys.database_filestream_options;
GO
----------------
-- Another version
SELECT DB_NAME(database_id) as DatabaseName, non_transacted_access, non_transacted_access_desc 
FROM sys.database_filestream_options
where DB_NAME(database_id)='EstacionMontañaSQLTEST';
GO

--We can have the following options for non-transacted access.

--OFF: Non-transactional access to FileTables is not allowed
--Read Only– Non-transactional access to FileTables is allowed for the read-only purpose
--Full– Non-transactional access to FileTables is allowed for both reading and writing
--Specify a directory for the SQL Server FILETABLE. We need to specify directory without directory path. This directory acts as a root path in FILETABLE hierarchy. 
--We will explore more in a further section of this article

--create filetable table

use EstacionMontañaSQLTEST
go

create table EMSQL_Docs
as filetable
with
(
	FileTable_Directory = 'EMSQLContainer',
	Filetable_Collate_Filename = database_default
);
go

-- See FileTableTb in OBJECT EXPLORER

-- Now you can select data using a regular select table.

select * from EMSQL_Docs
go

--o bien, para que no nos salgan todos los datos filtramos por campos:

select  [stream_id],[name]
from [EstacionMontañaSQLTEST].[dbo].[EMSQL_Docs]
go


