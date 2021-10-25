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

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.material_tarea') and type = 'U')
	DROP TABLE LOS_GEDEDES.material_tarea

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.material') and type = 'U')
	DROP TABLE LOS_GEDEDES.material

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.tarea_orden') and type = 'U')
	DROP TABLE LOS_GEDEDES.tarea_orden

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.tarea') and type = 'U')
	DROP TABLE LOS_GEDEDES.tarea

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.mecanico') and type = 'U')
	DROP TABLE LOS_GEDEDES.mecanico

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.taller') and type = 'U')
	DROP TABLE LOS_GEDEDES.taller

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.Orden_Trabajo') and type = 'U')
	DROP TABLE LOS_GEDEDES.Orden_Trabajo

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.Estado') and type = 'U')
	DROP TABLE LOS_GEDEDES.Estado

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.Paquete_viaje') and type = 'U')
	DROP TABLE LOS_GEDEDES.Paquete_viaje

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.Tipo_paquete') and type = 'U')
	DROP TABLE LOS_GEDEDES.Tipo_paquete

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

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.Modelo') and type = 'U')
	DROP TABLE LOS_GEDEDES.Modelo

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.Marca') and type = 'U')
	DROP TABLE LOS_GEDEDES.Marca
		

------------ CREACION DE TABLAS ----------------

CREATE TABLE LOS_GEDEDES.Marca(
codigo		INT IDENTITY(1,1),
nombre		NVARCHAR(255),
PRIMARY KEY (codigo)
);

CREATE TABLE LOS_GEDEDES.Modelo(
codigo			INT IDENTITY(1,1),
modelo			NVARCHAR(255),
velocidadMaxima 	INT,
capacidadTanque 	INT,
capacidadCarga		INT,
codigoMarca		INT,
PRIMARY KEY (codigo),
FOREIGN KEY (codigoMarca) REFERENCES LOS_GEDEDES.Marca	
);

CREATE TABLE LOS_GEDEDES.Camion(
patente		NVARCHAR(255),
nroChasis	NVARCHAR(255),
nroMotor	NVARCHAR(255),
fechaAlta	DATETIME2(3),
codigoMarca	INT,
PRIMARY KEY (patente),
FOREIGN KEY (codigoMarca) REFERENCES LOS_GEDEDES.Marca
);


CREATE TABLE LOS_GEDEDES.Chofer(
nroLegajo	INT,
nombre		NVARCHAR(255),
apellido	NVARCHAR(255),
dni		DECIMAL(18,0),
direccion	NVARCHAR(255),
telefono	INT,
mail		NVARCHAR(255),
fecha_nac	DATETIME2(3),
costo_hora	INT,
PRIMARY KEY (nroLegajo)
);


CREATE TABLE LOS_GEDEDES.Ciudad(
codigoCiudad	INT IDENTITY(1,1),
nombre		NVARCHAR(255)
PRIMARY KEY (codigoCiudad)
);


CREATE TABLE LOS_GEDEDES.Recorrido(
nroRecorrido	INT IDENTITY(1,1),
precioRecorrido	DECIMAL(18,2),
ciudadOrigen	INT,
ciudadDestino	INT,
recorridoKM	INT,
PRIMARY KEY (nroRecorrido),
FOREIGN KEY (ciudadOrigen) REFERENCES LOS_GEDEDES.Ciudad,
FOREIGN KEY (ciudadDestino) REFERENCES LOS_GEDEDES.Ciudad
);

CREATE TABLE LOS_GEDEDES.Viaje(
nroViaje	INT IDENTITY(1,1),
patenteCamion	NVARCHAR(255),
choferLegajo	INT,
recorrido	INT,
precioRecorrido INT,
fechaInicio	DATETIME2(7),
fechaFin	DATETIME2(3),
naftaConsumida	DECIMAL(18,2),
PRIMARY KEY (nroViaje),
FOREIGN KEY (patenteCamion) REFERENCES LOS_GEDEDES.Camion,
FOREIGN KEY (choferLegajo) REFERENCES LOS_GEDEDES.Chofer,
FOREIGN KEY (recorrido) REFERENCES LOS_GEDEDES.Recorrido,
CHECK(fechaInicio < fechaFin)
);

CREATE TABLE LOS_GEDEDES.Tipo_Paquete(
nroPaquete INT IDENTITY (1,1),
tipo		NVARCHAR(255),
largoMax	DECIMAL(18,2),
precioBase	DECIMAL(18,2),
pesoMax		DECIMAL(18,2),
altoMax		DECIMAL(18,2),
PRIMARY KEY (nroPaquete),
)

CREATE TABLE LOS_GEDEDES.Paquete_viaje(
id			INT IDENTITY (1,1),
cantidad		INT,
precioFinalPaquete	DECIMAL (18,2),
nroViaje		INT,
nroPaquete		INT,
PRIMARY KEY (id),
FOREIGN KEY (nroViaje) REFERENCES LOS_GEDEDES.Viaje,
FOREIGN KEY (nroPaquete) REFERENCES LOS_GEDEDES.Tipo_Paquete,
)

CREATE TABLE LOS_GEDEDES.Estado(
codigo		INT IDENTITY(1,1),
descripcion 	NVARCHAR(255),
PRIMARY KEY (codigo)
);


CREATE TABLE LOS_GEDEDES.Orden_Trabajo(
nroOrden		INT IDENTITY(1,1),
patenteCamion		NVARCHAR(255),
estado			INT,
fechaCarga		NVARCHAR(255),
PRIMARY KEY (nroOrden),
FOREIGN KEY (patenteCamion) REFERENCES LOS_GEDEDES.Camion,
FOREIGN KEY (estado) REFERENCES LOS_GEDEDES.Estado
);


CREATE TABLE LOS_GEDEDES.taller(
id		INT IDENTITY(1,1),
nombre		NVARCHAR(255),
direccion	NVARCHAR(255),
telefono	DECIMAL(18,0),
mail		NVARCHAR(255),
codCiudad	INT,
PRIMARY KEY (id),
FOREIGN KEY (codCiudad) REFERENCES LOS_GEDEDES.ciudad
)
 
CREATE TABLE LOS_GEDEDES.mecanico(
nroLegajo	INT,
nombre		NVARCHAR(255),
apellido	NVARCHAR(255),
dni		DECIMAL(18,0),
direccion	NVARCHAR(255),
telefono	INT,
mail		NVARCHAR(255),
fecha_nac	DATETIME2(3),
costo_hora	INT,
idTaller	INT,
PRIMARY KEY (nroLegajo),
FOREIGN KEY	(idTaller) REFERENCES LOS_GEDEDES.taller
)


CREATE TABLE LOS_GEDEDES.tarea(
codigo			INT,
descripcion		NVARCHAR(255),
tiempoEstimado		INT,
tipo			NVARCHAR(255),
PRIMARY KEY (codigo)
)


CREATE TABLE LOS_GEDEDES.tarea_orden(
idTareaOrden INT IDENTITY (1,1),
nroOrden			INT,
codTarea			INT,
legajoMecanico			INT,
fechaInicioPlanificada		DATETIME2(3),
fechaInicio			DATETIME2(3),
fechaFin			DATETIME2(3),
PRIMARY KEY (idTareaOrden,nroOrden, codTarea),
FOREIGN KEY (nroOrden) REFERENCES LOS_GEDEDES.Orden_Trabajo,
FOREIGN KEY (codTarea) REFERENCES LOS_GEDEDES.tarea,
FOREIGN KEY (legajoMecanico) REFERENCES LOS_GEDEDES.mecanico,
CHECK(fechaInicioPlanificada < fechaFin AND fechaInicio < fechaFin)
)


CREATE TABLE LOS_GEDEDES.material(
codigo			NVARCHAR(100),
descripcion		NVARCHAR(255),
precio			DECIMAL(18,0),
PRIMARY KEY (codigo)
)


CREATE TABLE LOS_GEDEDES.material_tarea(
codTarea		INT,
codMaterial		NVARCHAR(100),
cantidad		INT,
PRIMARY KEY (codMaterial, codTarea),
FOREIGN KEY (codMaterial) REFERENCES LOS_GEDEDES.material,
FOREIGN KEY (codTarea) REFERENCES LOS_GEDEDES.tarea
)

---------------------------- PROCEDURES DE MIGRACION --------------------------

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


-- PROCEDURE RECORRIDO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarTablaRecorrido')
	DROP PROCEDURE LOS_GEDEDES.cargarTablaRecorrido
GO

CREATE PROCEDURE LOS_GEDEDES.cargarTablaRecorrido
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			INSERT INTO LOS_GEDEDES.Recorrido (precioRecorrido, ciudadOrigen, ciudadDestino, recorridoKM)
			SELECT DISTINCT RECORRIDO_PRECIO, origen.codigoCiudad , destino.codigoCiudad, RECORRIDO_KM
			FROM gd_esquema.Maestra gd JOIN LOS_GEDEDES.Ciudad origen ON(origen.nombre = RECORRIDO_CIUDAD_ORIGEN)
						   JOIN LOS_GEDEDES.Ciudad destino ON(destino.nombre = RECORRIDO_CIUDAD_DESTINO)

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la tabla Recorrido';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO


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
			WHERE ORDEN_TRABAJO_ESTADO IS NOT NULL

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

-- PROCEDURE MATERIAL --

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarTablaMaterial')
	DROP PROCEDURE LOS_GEDEDES.cargarTablaMaterial
GO

CREATE PROCEDURE LOS_GEDEDES.cargarTablaMaterial
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			
			INSERT INTO LOS_GEDEDES.material (codigo, descripcion, precio)
			SELECT DISTINCT MATERIAL_COD, MATERIAL_DESCRIPCION, MATERIAL_PRECIO
			FROM gd_esquema.Maestra
			WHERE MATERIAL_COD IS NOT NULL
		
		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la tabla Material';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO

-- PROCEDURE MATERIAL_TAREA --

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarTablaMaterialTarea')
	DROP PROCEDURE LOS_GEDEDES.cargarTablaMaterialTarea
GO

CREATE PROCEDURE LOS_GEDEDES.cargarTablaMaterialTarea
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			
			INSERT INTO LOS_GEDEDES.material_tarea (codTarea, codMaterial, cantidad)
			SELECT DISTINCT TAREA_CODIGO, MATERIAL_COD, COUNT(MATERIAL_COD)
			FROM gd_esquema.Maestra
			WHERE TAREA_CODIGO IS NOT NULL AND MATERIAL_COD IS NOT NULL
			GROUP BY TAREA_CODIGO, MATERIAL_COD
			ORDER BY TAREA_CODIGO, MATERIAL_COD
		
		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la tabla Material_tarea';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO

-- PROCEDURE TAREA --

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarTablaTarea')
	DROP PROCEDURE LOS_GEDEDES.cargarTablaTarea
GO

CREATE PROCEDURE LOS_GEDEDES.cargarTablaTarea
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			
			INSERT INTO LOS_GEDEDES.tarea (codigo, descripcion, tiempoEstimado, tipo)
			SELECT DISTINCT TAREA_CODIGO, TAREA_DESCRIPCION, TAREA_TIEMPO_ESTIMADO, TIPO_TAREA
			FROM gd_esquema.Maestra
			WHERE TAREA_CODIGO IS NOT NULL
		
		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la tabla Tarea';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO

-- PROCEDURE TALLER --

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarTablaTaller')
	DROP PROCEDURE LOS_GEDEDES.cargarTablaTaller
GO

CREATE PROCEDURE LOS_GEDEDES.cargarTablaTaller
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			
			INSERT INTO LOS_GEDEDES.taller (nombre, direccion, mail, telefono, codCiudad)
			SELECT DISTINCT TALLER_NOMBRE, TALLER_DIRECCION, TALLER_MAIL, TALLER_TELEFONO, c.codigoCiudad
			FROM gd_esquema.Maestra m JOIN Ciudad c ON(m.TALLER_CIUDAD = c.nombre)
			WHERE TALLER_NOMBRE IS NOT NULL
		
		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la tabla Taller';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO

-- PROCEDURE MECANICO --

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarTablaMecanico')
	DROP PROCEDURE LOS_GEDEDES.cargarTablaMecanico
GO

CREATE PROCEDURE LOS_GEDEDES.cargarTablaMecanico
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			
			INSERT INTO LOS_GEDEDES.mecanico 
			SELECT DISTINCT MECANICO_NRO_LEGAJO, MECANICO_NOMBRE, MECANICO_APELLIDO, MECANICO_DNI, 
					MECANICO_DIRECCION, MECANICO_TELEFONO, MECANICO_MAIL, MECANICO_FECHA_NAC, 
					MECANICO_COSTO_HORA, t.id 
			FROM gd_esquema.Maestra LEFT JOIN taller t ON (TALLER_NOMBRE = t.nombre)
			WHERE MECANICO_NRO_LEGAJO IS NOT NULL
		
		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la tabla Mecanico';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO


-- PROCEDURE MARCA --

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarTablaMarca')
	DROP PROCEDURE LOS_GEDEDES.cargarTablaMarca
GO

CREATE PROCEDURE LOS_GEDEDES.cargarTablaMarca
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			INSERT INTO LOS_GEDEDES.Marca (nombre)
			SELECT DISTINCT MARCA_CAMION_MARCA
			FROM gd_esquema.Maestra gd 

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la tabla Marca';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO

-- PROCEDURE MODELO --

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarTablaModelo')
	DROP PROCEDURE LOS_GEDEDES.cargarTablaModelo
GO

CREATE PROCEDURE LOS_GEDEDES.cargarTablaModelo
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			INSERT INTO LOS_GEDEDES.Modelo (modelo, velocidadMaxima, capacidadTanque, capacidadCarga, codigoMarca)
			SELECT DISTINCT MODELO_CAMION, MODELO_VELOCIDAD_MAX, MODELO_CAPACIDAD_TANQUE, MODELO_CAPACIDAD_CARGA, m.codigo
			FROM gd_esquema.Maestra gd JOIN LOS_GEDEDES.Marca m ON(m.nombre = MARCA_CAMION_MARCA)

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la tabla Modelo';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO

-- PROCEDURE TIPO PAQUETE --

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarTablaTipoPaquete')
    DROP PROCEDURE LOS_GEDEDES.cargarTablaTipoPaquete
GO

CREATE PROCEDURE LOS_GEDEDES.cargarTablaTipoPaquete
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION

            INSERT INTO LOS_GEDEDES.Tipo_Paquete (tipo, largoMax, precioBase, pesoMax, altoMax)
            SELECT DISTINCT PAQUETE_DESCRIPCION, PAQUETE_LARGO_MAX, PAQUETE_PRECIO, PAQUETE_PESO_MAX, PAQUETE_ALTO_MAX
            FROM gd_esquema.Maestra 
			WHERE PAQUETE_DESCRIPCION IS NOT NULL

        COMMIT TRANSACTION
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION;
        DECLARE @errorDescripcion VARCHAR(255)
        SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la tabla Tipo Pquete';
        THROW 50000, @errorDescripcion, 1
    END CATCH
END
GO

-- PROCEDURE CAMION --

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarTablaCamion')
	DROP PROCEDURE LOS_GEDEDES.cargarTablaCamion
GO

CREATE PROCEDURE LOS_GEDEDES.cargarTablaCamion
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			INSERT INTO LOS_GEDEDES.Camion (patente, nroChasis, nroMotor, fechaAlta, codigoMarca)
			SELECT DISTINCT CAMION_PATENTE, CAMION_NRO_CHASIS, CAMION_NRO_MOTOR, CAMION_FECHA_ALTA, m.codigo
			FROM gd_esquema.Maestra gd JOIN LOS_GEDEDES.Marca m ON (m.nombre = MARCA_CAMION_MARCA) 

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
            SELECT DISTINCT CAMION_PATENTE, e.codigo, ORDEN_TRABAJO_FECHA
            FROM gd_esquema.Maestra m JOIN LOS_GEDEDES.Estado e ON (ORDEN_TRABAJO_ESTADO = e.descripcion)
			WHERE CAMION_PATENTE IS NOT NULL 
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


-- PROCEDURE TAREA_ORDEN --


IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarTablaTareaOrden')
	DROP PROCEDURE LOS_GEDEDES.cargarTablaTareaOrden
GO

CREATE PROCEDURE LOS_GEDEDES.cargarTablaTareaOrden
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			
			--SELECT * FROM LOS_GEDEDES.Orden_Trabajo

			INSERT INTO LOS_GEDEDES.tarea_orden (nroOrden, codTarea, legajoMecanico, 
				fechaInicioPlanificada, fechaInicio, fechaFin)
			SELECT DISTINCT o.nroOrden, TAREA_CODIGO, MECANICO_NRO_LEGAJO, 
				TAREA_FECHA_INICIO_PLANIFICADO, TAREA_FECHA_INICIO, TAREA_FECHA_FIN
			FROM gd_esquema.Maestra m JOIN LOS_GEDEDES.Orden_Trabajo o ON 
				(o.patenteCamion = m.CAMION_PATENTE AND o.fechaCarga = m.ORDEN_TRABAJO_FECHA)
			WHERE TAREA_CODIGO IS NOT NULL
		
		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la tabla Tarea_orden';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO


-- PROCEDURE CHOFER --

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarTablaChofer')
    DROP PROCEDURE LOS_GEDEDES.cargarTablaChofer
GO

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarTablaChofer')
    DROP PROCEDURE LOS_GEDEDES.cargarTablaChofer
GO

CREATE PROCEDURE LOS_GEDEDES.cargarTablaChofer
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
            INSERT INTO LOS_GEDEDES.Chofer (nroLegajo,nombre,apellido,dni,direccion,telefono,mail,fecha_nac,costo_hora)
            SELECT DISTINCT CHOFER_NRO_LEGAJO, CHOFER_NOMBRE, CHOFER_APELLIDO, CHOFER_DNI, CHOFER_DIRECCION, CHOFER_TELEFONO,
			CHOFER_MAIL, CHOFER_FECHA_NAC, CHOFER_COSTO_HORA 
            FROM gd_esquema.Maestra 
	    WHERE CHOFER_NRO_LEGAJO IS NOT NULL
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


-- PROCEDURE VIAJE --

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarTablaViaje')
	DROP PROCEDURE LOS_GEDEDES.cargarTablaViaje
GO

CREATE PROCEDURE LOS_GEDEDES.cargarTablaViaje
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			INSERT INTO LOS_GEDEDES.Viaje (patenteCamion, choferLegajo, recorrido, precioRecorrido, fechaInicio, fechaFin, naftaConsumida)
			SELECT DISTINCT CAMION_PATENTE, CHOFER_NRO_LEGAJO, nroRecorrido, precioRecorrido, VIAJE_FECHA_INICIO, VIAJE_FECHA_FIN, VIAJE_CONSUMO_COMBUSTIBLE
			FROM gd_esquema.Maestra gd JOIN LOS_GEDEDES.Recorrido r ON( gd.RECORRIDO_PRECIO = r.precioRecorrido AND gd.RECORRIDO_KM = r.recorridoKM)

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la tabla Viaje';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO


-- EXECUTES --

EXEC LOS_GEDEDES.cargarTablaChofer
EXEC LOS_GEDEDES.cargarTablaCiudad
EXEC LOS_GEDEDES.cargarTablaRecorrido
EXEC LOS_GEDEDES.cargarTablaMarca
EXEC LOS_GEDEDES.cargarTablaModelo
EXEC LOS_GEDEDES.cargarTablaTipoPaquete
EXEC LOS_GEDEDES.cargarTablaEstado
EXEC LOS_GEDEDES.cargarTablaMaterial
EXEC LOS_GEDEDES.cargarTablaTarea
EXEC LOS_GEDEDES.cargarTablaMaterialTarea
EXEC LOS_GEDEDES.cargarTablaTaller
EXEC LOS_GEDEDES.cargarTablaMecanico
EXEC LOS_GEDEDES.cargarTablaCamion
EXEC LOS_GEDEDES.cargarTablaOrdenTrabajo
EXEC LOS_GEDEDES.cargarTablaTareaOrden
EXEC LOS_GEDEDES.cargarTablaViaje
/*EXEC LOS_GEDEDES.cargarTablaPaqueteViaje*/


/*
SELECT * FROM LOS_GEDEDES.taller
SELECT * FROM LOS_GEDEDES.mecanico
SELECT * FROM LOS_GEDEDES.tarea
SELECT * FROM LOS_GEDEDES.material
SELECT * FROM LOS_GEDEDES.material_tarea
*/

/*
Orden de creacion/insert de las tablas:
1.Ciudad
2.Estado
3.Material
4.Tipo_Tarea
5.Marca
6.Modelo
7.Tipo_Paquete
8.Material_Tarea
9.Tarea
10.Taller
11.Mecanico
12.Camion
13.Orden_Trabajo
14.Tarea_Orden
15.Recorrido
16.Chofer
17.Viaje
18.Paquete_Viaje
Del 1 al 7 son intercambiables


Posible orden para eliminar las tablas:
material_tarea, material, tarea_orden, tarea, mecanico, taller, orden_trabajo, estado, 
paquete_viaje, tipo_paquete, viaje, recorrido, ciudad, chofer, camion, modelo, marca

*/
