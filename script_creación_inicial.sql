IF not exists (select * from sys.schemas where name = 'LOS_GEDEDES')
BEGIN
	exec ('CREATE SCHEMA LOS_GEDEDES')
END
GO

/*Me fijo si existe el esquema en la tabla del sistema si no existe lo creo.
--------------------------------------------------------------------------
Me fijo primero si existe el elemento en la tabla, si la tabla ya existe la dropea para despues poder correr el create.  (ANTES DE CADA CREADO IRIA)
IF EXISTS (select * from sys.objects where object_id = OBJECT_ID(N'[NOMBRE_ESQUEMA_TP].TABLA') and type = 'U')
	DROP TABLE [NOMBRE_ESQUEMA_TP].TABLA
	GO
-- CREACION DE TABLAS 
-- CREACION DE INDICES
-- CREACION DE VISTAS
-- CREACION DE FUNCIONES
-- CREACION DE SP
-- CREACION DE TRIGGERS
-- LLENADO DE TABLAS / EXEC DE SP (UNO POR TABLA)
-- CREACION DE INDICES
GO
TENER EN CUENTA
	1. DEPENDENCIAS 
	2. PERFORMANCE (TIEMPO MAXIMO DE LA CREACION 5 MINUTOS)
		-CUANDO CREAR LOS INDICES
		-CURSORES
	3. TAMAÑO DE LAS TRANSACCIONES (Mantenerlas lo mas chicas posibles. COMMITEAR CUANDO SE LLENA LA TABLA PARA TENER UN CONTROL EN CASO DE TENER QUE ROLLBACKEAR)
	4. FORMATO FECHA/HORA --*/
  
  
------------- DROP TABLAS -----------------------

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.Tarea_Orden') and type = 'U')
	DROP TABLE LOS_GEDEDES.Tarea_Orden

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.Orden_Trabajo') and type = 'U')
	DROP TABLE LOS_GEDEDES.Orden_Trabajo

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.Estado') and type = 'U')
	DROP TABLE LOS_GEDEDES.Estado

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.Viaje') and type = 'U')
	DROP TABLE LOS_GEDEDES.Viaje

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.Recorrido') and type = 'U')
	DROP TABLE LOS_GEDEDES.Recorrido
	
IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.Ciudad') and type = 'U')
	DROP TABLE LOS_GEDEDES.Ciudad

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.Chofer') and type = 'U')
	DROP TABLE LOS_GEDEDES.Chofer

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.Camion') and type = 'U')
	DROP TABLE LOS_GEDEDES.Camion

------------ CREACION DE TABLAS ----------------

CREATE TABLE LOS_GEDEDES.Camion(
patente NVARCHAR(255),
nroChasis NVARCHAR(255),
nroMotor NVARCHAR(255),
fechaAlta DATETIME2(3),
--codigoMarca INT,
PRIMARY KEY (patente),
--FOREIGN KEY (codigoMarca) REFERENCES LOS_GEDEDES.Marca
);


CREATE TABLE LOS_GEDEDES.Chofer(
nroLegajo INT,
nombre NVARCHAR(255),
apellido NVARCHAR(255),
dni DECIMAL(18,0),
direccion NVARCHAR(255),
telefono INT,
mail NVARCHAR(255),
fecha_nac INT,
costo_hora INT,
PRIMARY KEY (nroLegajo)
);


CREATE TABLE LOS_GEDEDES.Ciudad(
codigoCiudad INT IDENTITY(1,1),
nombre NVARCHAR(255)
PRIMARY KEY (codigoCiudad)
);


CREATE TABLE LOS_GEDEDES.Recorrido(
nroRecorrido INT IDENTITY(1,1),
precioRecorrido DECIMAL(18,2),
ciudadOrigen INT,
ciudadDestino INT,
recorridoKM INT,
PRIMARY KEY (nroRecorrido),
FOREIGN KEY (ciudadOrigen) REFERENCES LOS_GEDEDES.Ciudad,
FOREIGN KEY (ciudadDestino) REFERENCES LOS_GEDEDES.Ciudad
);

CREATE TABLE LOS_GEDEDES.Viaje(
nroViaje INT IDENTITY(1,1),
patenteCamion NVARCHAR(255),
choferLegajo INT,
recorrido INT,
precioRecorrido INT,
fechaInicio DATETIME2(7),
fechaFin DATETIME2(3),
naftaConsumida decimal(18,2),
PRIMARY KEY (nroViaje),
FOREIGN KEY (patenteCamion) REFERENCES LOS_GEDEDES.Camion,
FOREIGN KEY (choferLegajo) REFERENCES LOS_GEDEDES.Chofer,
FOREIGN KEY (recorrido) REFERENCES LOS_GEDEDES.Recorrido,
CHECK(fechaInicio < fechaFin)
);


CREATE TABLE LOS_GEDEDES.Estado(
	codigo INT IDENTITY(1,1),
	descripcion NVARCHAR(255),
	PRIMARY KEY (codigo)
);


CREATE TABLE LOS_GEDEDES.Orden_Trabajo(
	nroOrden INT IDENTITY(1,1),
	patenteCamion NVARCHAR(255),
	estado INT,
	fechaCarga NVARCHAR(255),/*Yo lo hubiera puesto como un DATETIME2 pero la columna era varchar*/
	PRIMARY KEY (nroOrden),
	FOREIGN KEY (patenteCamion) REFERENCES LOS_GEDEDES.Camion,
	FOREIGN KEY (estado) REFERENCES LOS_GEDEDES.Estado
);


CREATE TABLE LOS_GEDEDES.Tarea_Orden(
	nroOrden INT,
	nroTarea INT,
	legajoMecanico INT,
	fechaInicioPlani DATETIME2(3),
	fechaInicioReal DATETIME2(3),/*Esta se supone que es null?*/
	fechaFin DATETIME2(3),
	PRIMARY KEY (nroOrden, nroTarea),
	FOREIGN KEY (nroOrden) REFERENCES LOS_GEDEDES.Orden_Trabajo,
	--FOREIGN KEY (nroTarea) REFERENCES LOS_GEDEDES.Tarea, /*Esta esta comentada porque no esta la tabla tarea*/
	--FOREIGN KEY (legajoMecanico) REFERENCES LOS_GEDEDES.Mecanico, /*Esta esta comentada porque no esta la tabla mecanico*/
	CHECK(fechaInicioPlani < fechaFin AND fechaInicioReal < fechaFin)
);

---------------------------- PROCEDURES DE MIGRACION --------------------------

-- PROCEDURE CHOFER --

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarTablaChofer')
    DROP PROCEDURE LOS_GEDEDES.cargarTablaChofer
GO

/*
CREATE PROCEDURE LOS_GEDEDES.cargarTablaChofer
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION

            INSERT INTO LOS_GEDEDES.Chofer (nroLegajo,nombre,apellido,dni,direccion,telefono,mail,fecha_nac,costo_hora)
            SELECT DISTINCT CHOFER_NRO_LEGAJO, CHOFER_NOMBRE, CHOFER_APELLIDO, CHOFER_DNI, CHOFER_DIRECCION, CHOFER_TELEFONO, CHOFER_MAIL, CHOFER_FECHA_NAC, CHOFER_COSTO_HORA 
            FROM gd_esquema.Maestra 

        COMMIT TRANSACTION
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @errorDescripcion VARCHAR(255)
        SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la tabla Chofer';
        THROW 50000, @errorDescripcion, 1
    END CATCH
END
GO

-- PROCEDURE ORDEN TRABAJO --

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarTablaOrdenTrabajo')
    DROP PROCEDURE LOS_GEDEDES.cargarTablaOrdenTrabajo
GO

CREATE PROCEDURE LOS_GEDEDES.cargarTablaOrdenTrabajo
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION

            INSERT INTO LOS_GEDEDES.Orden_Trabajo (patenteCamion,estado,fechaCarga)
            SELECT DISTINCT CAMION_PATENTE, ORDEN_TRABAJO_ESTADO ORDEN_TRABAJO_FECHA
            FROM gd_esquema.Maestra 

        COMMIT TRANSACTION
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @errorDescripcion VARCHAR(255)
        SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la tabla Orden trabajo';
        THROW 50000, @errorDescripcion, 1
    END CATCH
END
GO 
--*/


-- PROCEDURE ESTADO --

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarTablaEstado')
    DROP PROCEDURE LOS_GEDEDES.cargarTablaEstado
GO

CREATE PROCEDURE LOS_GEDEDES.cargarTablaEstado
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION

            INSERT INTO LOS_GEDEDES.Estado (descripcion)
            SELECT DISTINCT ORDEN_TRABAJO_ESTADO
            FROM gd_esquema.Maestra 

        COMMIT TRANSACTION
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @errorDescripcion VARCHAR(255)
        SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la tabla Orden trabajo';
        THROW 50000, @errorDescripcion, 1
    END CATCH
END
GO

-- PROCEDURE TAREA ORDEN --
/*
IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarTablaTareaOrden')
    DROP PROCEDURE LOS_GEDEDES.cargarTablaTareaOrden
CREATE PROCEDURE LOS_GEDEDES.cargarTablaTareaOrden
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            INSERT INTO LOS_GEDEDES.TareaOrden ()
            SELECT DISTINCT 
            FROM gd_esquema.Maestra 
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @errorDescripcion VARCHAR(255)
        SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la tabla Tarea Orden';
        THROW 50000, @errorDescripcion, 1
    END CATCH
END
*/

/*No se bien como hacer la tabla intermedia, aparte que me falta lña tabla de tareas*/


-- PROCEDURE CAMION --

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarTablaCamion')
	DROP PROCEDURE LOS_GEDEDES.cargarTablaCamion
GO

CREATE PROCEDURE LOS_GEDEDES.cargarTablaCamion
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

		/*	INSERT INTO LOS_GEDEDES.Camion (patente, nroChasis, nroMotor, fechaAlta, codigoMarca)
			SELECT CAMION_PATENTE, CAMION_NRO_CHASIS, CAMION_NRO_MOTOR, CAMION_FECHA_ALTA, m.codigoMarca    -PARA CUANDO ESTE LA MARCA
			FROM gd_esquema.Maestra JOIN LOS_GEDEDES.Marca m ON( m.nombre = MARCA_CAMION_MARCA) --*/

			INSERT INTO LOS_GEDEDES.Camion (patente, nroChasis, nroMotor, fechaAlta)
			SELECT DISTINCT CAMION_PATENTE, CAMION_NRO_CHASIS, CAMION_NRO_MOTOR, CAMION_FECHA_ALTA
			FROM gd_esquema.Maestra 

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la tabla Camion';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO


-- PROCEDURE CIUDAD --

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarTablaCiudad')
	DROP PROCEDURE LOS_GEDEDES.cargarTablaCiudad
GO

CREATE PROCEDURE LOS_GEDEDES.cargarTablaCiudad
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			INSERT INTO LOS_GEDEDES.Ciudad (nombre)
			SELECT DISTINCT RECORRIDO_CIUDAD_ORIGEN
			FROM gd_esquema.Maestra 
			UNION
			SELECT DISTINCT RECORRIDO_CIUDAD_DESTINO
			FROM gd_esquema.Maestra
			ORDER BY 1 DESC

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la tabla Ciudad';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO


-- EXECUTES --

--EXEC LOS_GEDEDES.cargarTablaChofer
--EXEC LOS_GEDEDES.cargarTablaOrdenTrabajo
EXEC LOS_GEDEDES.cargarTablaEstado
EXEC LOS_GEDEDES.cargarTablaCamion
EXEC LOS_GEDEDES.cargarTablaCiudad


