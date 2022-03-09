use master
go

drop database if exists EstacionMontañaSQL
go

create database EstacionMontañaSQL
go

use EstacionMontañaSQL
go


CREATE TABLE abono 
    (
     id_abono INTEGER NOT NULL , 
     tipo_abono VARCHAR (50) NOT NULL , 
     precio MONEY NOT NULL , 
     fecha_expedicion DATE , 
     taquilla_id_taquilla INTEGER NOT NULL , 
     taquilla_id_personal INTEGER NOT NULL 
    )
GO

ALTER TABLE abono ADD CONSTRAINT abono_PK PRIMARY KEY CLUSTERED (id_abono)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE actividad 
    (
     id_actividad INTEGER NOT NULL , 
     tipo_actividad VARCHAR (100) NOT NULL , 
     horario_inicio VARCHAR (50) NOT NULL , 
     duracion_actividad VARCHAR NOT NULL , 
     sitio_realizamiento VARCHAR (100) , 
     monitor_personal_estacion_id_personal INTEGER NOT NULL 
    )
GO

ALTER TABLE actividad ADD CONSTRAINT actividad_PK PRIMARY KEY CLUSTERED (id_actividad, monitor_personal_estacion_id_personal)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE alquiler 
    (
     id_alquiler INTEGER NOT NULL , 
     fecha_hora_recogida VARCHAR (100) NOT NULL , 
     fecha_hora_entrega VARCHAR (100) NOT NULL , 
     datos_cliente_dni_cliente VARCHAR (9) NOT NULL , 
     material_id_material INTEGER NOT NULL 
    )
GO

ALTER TABLE alquiler ADD CONSTRAINT alquiler_PK PRIMARY KEY CLUSTERED (id_alquiler, material_id_material)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE datos_cliente 
    (
     dni_cliente VARCHAR (9) NOT NULL 
    )
GO

ALTER TABLE datos_cliente ADD CONSTRAINT datos_cliente_PK PRIMARY KEY CLUSTERED (dni_cliente)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE estacion 
    (
     id_estacion INTEGER NOT NULL , 
     numero_pistas INTEGER NOT NULL , 
     kms_totales_pista INTEGER NOT NULL , 
     nombre_estacion VARCHAR (50) , 
     logo VARBINARY(MAX) , 
     parte_diario_id_parte INTEGER NOT NULL 
    )
GO

ALTER TABLE estacion ADD CONSTRAINT estacion_PK PRIMARY KEY CLUSTERED (id_estacion)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE factura 
    (
     id_factura INTEGER NOT NULL , 
     total MONEY NOT NULL , 
     penalizacion BIT NOT NULL , 
     tipo_motivo_penalizacion VARCHAR (200) NOT NULL , 
     cargo_adicional MONEY , 
     alquiler_id_alquiler INTEGER NOT NULL , 
     alquiler_material_id_material INTEGER NOT NULL 
    )
GO

ALTER TABLE factura ADD CONSTRAINT factura_PK PRIMARY KEY CLUSTERED (id_factura, alquiler_id_alquiler, alquiler_material_id_material)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE gerente 
    (
     personal_estacion_id_personal INTEGER NOT NULL 
    )
GO

ALTER TABLE gerente ADD CONSTRAINT gerente_PK PRIMARY KEY CLUSTERED (personal_estacion_id_personal)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE mantenimiento 
    (
     area_trabajo VARCHAR (100) , 
     especialidad VARCHAR (100) , 
     personal_estacion_id_personal INTEGER NOT NULL 
    )
GO

ALTER TABLE mantenimiento ADD CONSTRAINT mantenimiento_PK PRIMARY KEY CLUSTERED (personal_estacion_id_personal)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE material 
    (
     id_material INTEGER NOT NULL , 
     modalidad VARCHAR (100) NOT NULL , 
     precio MONEY NOT NULL , 
     tipo_material VARCHAR (100) NOT NULL , 
     marca VARCHAR (50) NOT NULL , 
     tienda_id_personal INTEGER NOT NULL 
    )
GO

ALTER TABLE material ADD CONSTRAINT material_PK PRIMARY KEY CLUSTERED (id_material)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE monitor 
    (
     modalidad VARCHAR (100) NOT NULL , 
     personal_estacion_id_personal INTEGER NOT NULL 
    )
GO

ALTER TABLE monitor ADD CONSTRAINT monitor_PK PRIMARY KEY CLUSTERED (personal_estacion_id_personal)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE parte_diario 
    (
     id_parte INTEGER NOT NULL , 
     fecha_parte DATE NOT NULL , 
     estado_estacion VARCHAR (30) NOT NULL , 
     kms_esquiables INTEGER NOT NULL , 
     pistas_abiertas INTEGER NOT NULL , 
     remontes_abiertos INTEGER NOT NULL , 
     calidad_nieve VARCHAR (30) NOT NULL , 
     espesor VARCHAR (30) , 
     prevision_meteorologica VARCHAR (100) 
    )
GO

ALTER TABLE parte_diario ADD CONSTRAINT parte_diario_PK PRIMARY KEY CLUSTERED (id_parte)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE personal_estacion 
    (
     id_personal INTEGER NOT NULL , 
     nombre_empleado VARCHAR (50) , 
     primer_apellido VARCHAR (50) NOT NULL , 
     segundo_apellido VARCHAR (50) NOT NULL , 
     fecha_nacimiento DATE NOT NULL , 
     telefono INTEGER NOT NULL , 
     estacion_id_estacion INTEGER NOT NULL 
    )
GO

ALTER TABLE personal_estacion ADD CONSTRAINT personal_estacion_PK PRIMARY KEY CLUSTERED (id_personal)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE pista 
    (
     id_pista INTEGER NOT NULL , 
     estado_pista VARCHAR (30) NOT NULL , 
     nombre_pista VARCHAR (50) , 
     longitud VARCHAR (30) NOT NULL , 
     dificultad VARCHAR (30) NOT NULL , 
     zona VARCHAR (50) , 
     mapa_pistas VARBINARY(MAX) , 
     estacion_id_estacion INTEGER NOT NULL 
    )
GO

ALTER TABLE pista ADD CONSTRAINT pista_PK PRIMARY KEY CLUSTERED (id_pista)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE taquilla 
    (
     id_taquilla INTEGER NOT NULL , 
     horario_atencion VARCHAR (100) NOT NULL , 
     personal_estacion_id_personal INTEGER NOT NULL 
    )
GO

ALTER TABLE taquilla ADD CONSTRAINT taquilla_PK PRIMARY KEY CLUSTERED (id_taquilla, personal_estacion_id_personal)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

CREATE TABLE tienda 
    (
     personal_estacion_id_personal INTEGER NOT NULL 
    )
GO

ALTER TABLE tienda ADD CONSTRAINT tienda_PK PRIMARY KEY CLUSTERED (personal_estacion_id_personal)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO

ALTER TABLE abono 
    ADD CONSTRAINT abono_taquilla_FK FOREIGN KEY 
    ( 
     taquilla_id_taquilla, 
     taquilla_id_personal
    ) 
    REFERENCES taquilla 
    ( 
     id_taquilla , 
     personal_estacion_id_personal 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE actividad 
    ADD CONSTRAINT actividad_monitor_FK FOREIGN KEY 
    ( 
     monitor_personal_estacion_id_personal
    ) 
    REFERENCES monitor 
    ( 
     personal_estacion_id_personal 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE alquiler 
    ADD CONSTRAINT alquiler_datos_cliente_FK FOREIGN KEY 
    ( 
     datos_cliente_dni_cliente
    ) 
    REFERENCES datos_cliente 
    ( 
     dni_cliente 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE alquiler 
    ADD CONSTRAINT alquiler_material_FK FOREIGN KEY 
    ( 
     material_id_material
    ) 
    REFERENCES material 
    ( 
     id_material 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE estacion 
    ADD CONSTRAINT estacion_parte_diario_FK FOREIGN KEY 
    ( 
     parte_diario_id_parte
    ) 
    REFERENCES parte_diario 
    ( 
     id_parte 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE factura 
    ADD CONSTRAINT factura_alquiler_FK FOREIGN KEY 
    ( 
     alquiler_id_alquiler, 
     alquiler_material_id_material
    ) 
    REFERENCES alquiler 
    ( 
     id_alquiler , 
     material_id_material 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE gerente 
    ADD CONSTRAINT gerente_personal_estacion_FK FOREIGN KEY 
    ( 
     personal_estacion_id_personal
    ) 
    REFERENCES personal_estacion 
    ( 
     id_personal 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE mantenimiento 
    ADD CONSTRAINT mantenimiento_personal_estacion_FK FOREIGN KEY 
    ( 
     personal_estacion_id_personal
    ) 
    REFERENCES personal_estacion 
    ( 
     id_personal 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE material 
    ADD CONSTRAINT material_tienda_FK FOREIGN KEY 
    ( 
     tienda_id_personal
    ) 
    REFERENCES tienda 
    ( 
     personal_estacion_id_personal 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE monitor 
    ADD CONSTRAINT monitor_personal_estacion_FK FOREIGN KEY 
    ( 
     personal_estacion_id_personal
    ) 
    REFERENCES personal_estacion 
    ( 
     id_personal 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE personal_estacion 
    ADD CONSTRAINT personal_estacion_estacion_FK FOREIGN KEY 
    ( 
     estacion_id_estacion
    ) 
    REFERENCES estacion 
    ( 
     id_estacion 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE pista 
    ADD CONSTRAINT pista_estacion_FK FOREIGN KEY 
    ( 
     estacion_id_estacion
    ) 
    REFERENCES estacion 
    ( 
     id_estacion 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE taquilla 
    ADD CONSTRAINT taquilla_personal_estacion_FK FOREIGN KEY 
    ( 
     personal_estacion_id_personal
    ) 
    REFERENCES personal_estacion 
    ( 
     id_personal 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO

ALTER TABLE tienda 
    ADD CONSTRAINT tienda_personal_estacion_FK FOREIGN KEY 
    ( 
     personal_estacion_id_personal
    ) 
    REFERENCES personal_estacion 
    ( 
     id_personal 
    ) 
    ON DELETE NO ACTION 
    ON UPDATE NO ACTION 
GO


