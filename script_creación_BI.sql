------------- FUNCIONES AUXILIARES --------------

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.rangoEtario_fx') and type = 'FN')
	DROP FUNCTION LOS_GEDEDES.rangoEtario_fx

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.cuatrimestre_fx') and type = 'FN')
	DROP FUNCTION LOS_GEDEDES.cuatrimestre_fx
	
IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.asignarTiempo_fx') and type = 'FN')
	DROP FUNCTION LOS_GEDEDES.asignarTiempo_fx


GO
CREATE FUNCTION LOS_GEDEDES.rangoEtario_fx(@fecha_nac DATETIME2(3))
RETURNS NVARCHAR(15)
AS
BEGIN
	DECLARE @rango NVARCHAR(15)
	DECLARE @edad INT

	SELECT @edad = FLOOR(
		(cast(convert(varchar(8),getdate(),112) as int) -
		cast(convert(varchar(8),@fecha_nac,112) as int) ) / 10000
		)

	SELECT @rango = CASE 
		WHEN @edad >= 18 AND @edad <= 30 THEN '18 - 30'
		WHEN @edad > 30 AND @edad <= 50 THEN '30 - 50'
		ELSE '50+'
		END

	RETURN @rango
END
GO

CREATE FUNCTION LOS_GEDEDES.cuatrimestre_fx(@fecha DATETIME2(3))
RETURNS INT
AS BEGIN
	DECLARE @cuatrimestre INT
	DECLARE @numeroMes INT

	SELECT @numeroMes = MONTH(@fecha)

	SELECT @cuatrimestre = CASE
		WHEN @numeroMes >= 1 AND @numeroMes <= 4 THEN 1
		WHEN @numeroMes > 4 AND @numeroMes <= 8 THEN 2 
		WHEN @numeroMes > 8 AND @numeroMes <= 12 THEN 3 
		END
	
	RETURN @cuatrimestre
END
GO

GO
CREATE FUNCTION LOS_GEDEDES.asignarTiempo_fx(@fechaInicio DATETIME2(7))
RETURNS INT
AS
BEGIN
	DECLARE @pkTiempo INT

	SELECT @pkTiempo = (SELECT idTiempo FROM LOS_GEDEDES.BI_dimension_tiempo
	WHERE anio = YEAR(@fechaInicio)
	AND mes = MONTH(@fechaInicio))

	RETURN @pkTiempo
END
GO

------------- DROP TABLAS -----------------------

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.BI_viaje') and type = 'U')
	DROP TABLE LOS_GEDEDES.BI_viaje

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.BI_reparacion') and type = 'U')
	DROP TABLE LOS_GEDEDES.BI_reparacion
  
IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.BI_dimension_camion') and type = 'U')
	DROP TABLE LOS_GEDEDES.BI_dimension_camion
  
IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.BI_dimension_tiempo') and type = 'U')
	DROP TABLE LOS_GEDEDES.BI_dimension_tiempo
  
IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.BI_dimension_recorrido') and type = 'U')
	DROP TABLE LOS_GEDEDES.BI_dimension_recorrido

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.BI_dimension_tarea') and type = 'U')
	DROP TABLE LOS_GEDEDES.BI_dimension_tarea

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.BI_dimension_material') and type = 'U')
	DROP TABLE LOS_GEDEDES.BI_dimension_material

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.BI_dimension_mecanico') and type = 'U')
	DROP TABLE LOS_GEDEDES.BI_dimension_mecanico

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.BI_dimension_chofer') and type = 'U')
	DROP TABLE LOS_GEDEDES.BI_dimension_chofer

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.BI_dimension_OT') and type = 'U')
	DROP TABLE LOS_GEDEDES.BI_dimension_OT
 
IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.BI_dimension_marca') and type = 'U')
	DROP TABLE LOS_GEDEDES.BI_dimension_marca

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.BI_dimension_modelo') and type = 'U')
	DROP TABLE LOS_GEDEDES.BI_dimension_modelo

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.BI_dimension_paquete') and type = 'U')
	DROP TABLE LOS_GEDEDES.BI_dimension_paquete
	
IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.BI_dimension_taller') and type = 'U')
	DROP TABLE LOS_GEDEDES.BI_dimension_taller
  
------------ CREACION DE TABLAS ----------------

CREATE TABLE LOS_GEDEDES.BI_dimension_chofer(
nroLegajo		INT,
nombre			NVARCHAR(255),
apellido		NVARCHAR(255),
dni				DECIMAL(18,0),
direccion		NVARCHAR(255),
telefono		INT,
mail			NVARCHAR(255),
fecha_nac		DATETIME2(3),
costo_hora		INT,
rangoEtario 	NVARCHAR(15),
PRIMARY KEY (nroLegajo)
);

/*
CREATE TABLE LOS_GEDEDES.BI_dimension_OT(
nroOrden		INT, 
estado			NVARCHAR(255),
fechaCarga		NVARCHAR(255), Quiza con la dimension tiempo no sea necesario este campo
PRIMARY KEY (nroOrden)
);
*/

CREATE TABLE LOS_GEDEDES.BI_dimension_camion(
patente		NVARCHAR(255),
nroChasis	NVARCHAR(255),
nroMotor	NVARCHAR(255),
fechaAlta	DATETIME2(3),
PRIMARY KEY (patente)
);

CREATE TABLE LOS_GEDEDES.BI_dimension_tiempo(
idTiempo		INT IDENTITY(1,1),
anio			INT,
mes				INT,
cuatrimestre	INT,
PRIMARY KEY (idTiempo)
);

CREATE TABLE LOS_GEDEDES.BI_dimension_recorrido(
nroRecorrido	INT,
precioRecorrido	DECIMAL(18,2),
ciudadOrigen	NVARCHAR(255), 
ciudadDestino	NVARCHAR(255),
recorridoKM		INT,
PRIMARY KEY (nroRecorrido)
);

CREATE TABLE LOS_GEDEDES.BI_dimension_tarea(
codigo			INT,
descripcion		NVARCHAR(255),
tipo			NVARCHAR(255),
fechaInicio		DATETIME2(3),
fechaFin		DATETIME2(3),
PRIMARY KEY (codigo)
)

CREATE TABLE LOS_GEDEDES.BI_dimension_material(
codigo			NVARCHAR(100),
descripcion		NVARCHAR(255),
precioBase		DECIMAL(18,0),
cantidad		INT,
PRIMARY KEY (codigo)
)

CREATE TABLE LOS_GEDEDES.BI_dimension_mecanico(
nroLegajo	INT,
nombre		NVARCHAR(255),
apellido	NVARCHAR(255),
dni			DECIMAL(18,0),
direccion	NVARCHAR(255),
telefono	INT,
mail		NVARCHAR(255),
rangoEtario	NVARCHAR(15), 
costo_hora	INT,
PRIMARY KEY (nroLegajo),
)

CREATE TABLE LOS_GEDEDES.BI_dimension_marca(
codigo	INT,
nombre	NVARCHAR(255),
PRIMARY KEY (codigo),
)

CREATE TABLE LOS_GEDEDES.BI_dimension_modelo(
codigo	INT,
modelo	NVARCHAR(255),
velocidadMaxima DECIMAL(18,2),
capacidadCarga DECIMAL(18,2),
capacidadTanque DECIMAL(18,2),
PRIMARY KEY (codigo),
)

CREATE TABLE LOS_GEDEDES.BI_dimension_paquete(
id					INT IDENTITY (1,1),
nroPaquete			INT,
tipo				NVARCHAR(8),
largoMax			DECIMAL(18,2),
pesoMax				DECIMAL(18,2),
altoMax				DECIMAL(18,2),
precioBase			DECIMAL(18,2),
cantidad			INT,
precioFinalPaquete	DECIMAL(18,2),
PRIMARY KEY (id),
)

CREATE TABLE LOS_GEDEDES.BI_dimension_taller(
id			INT,
nombre		NVARCHAR(255),
direccion	NVARCHAR(255),
telefono	DECIMAL(18,0),
mail		NVARCHAR(255),
ciudad		NVARCHAR(255),
PRIMARY KEY (id)
)

CREATE TABLE LOS_GEDEDES.BI_viaje(
choferLegajo 		INT,
patenteCamion		NVARCHAR(255),
recorrido			INT,
tiempo 				INT,
nroPaquete 			INT,
precioRecorrido		INT,
naftaConsumida		DECIMAL(18,2),
PRIMARY KEY (choferLegajo, patenteCamion, recorrido, tiempo, nroPaquete),
FOREIGN KEY (nroPaquete) REFERENCES LOS_GEDEDES.BI_dimension_paquete,
FOREIGN KEY (patenteCamion) REFERENCES LOS_GEDEDES.BI_dimension_camion,
FOREIGN KEY (choferLegajo) REFERENCES LOS_GEDEDES.BI_dimension_chofer,
FOREIGN KEY (recorrido) REFERENCES LOS_GEDEDES.BI_dimension_recorrido,
FOREIGN KEY (tiempo) REFERENCES LOS_GEDEDES.BI_dimension_tiempo
);

CREATE TABLE LOS_GEDEDES.BI_reparacion(
patenteCamion		NVARCHAR(255),
codigoMarca			INT,
codigoModelo		INT,
mecanicoLegajo 		INT,
codigoTarea			INT,
codigoMaterial 		NVARCHAR(100),
--nroOrdenTrabajo 	INT,
tiempo 				INT,
idTaller			INT,
PRIMARY KEY(patenteCamion, codigoMarca, codigoModelo, choferLegajo, codigoTarea,
codigoMaterial, /*nroOrdenTrabajo,*/ tiempo, idTaller),
FOREIGN KEY (patenteCamion) REFERENCES LOS_GEDEDES.BI_dimension_camion,
FOREIGN KEY (codigoMarca) REFERENCES LOS_GEDEDES.BI_dimension_marca,
FOREIGN KEY (codigoModelo) REFERENCES LOS_GEDEDES.BI_dimension_modelo,
FOREIGN KEY (choferLegajo) REFERENCES LOS_GEDEDES.BI_dimension_mecanico,
FOREIGN KEY (codigoTarea) REFERENCES LOS_GEDEDES.BI_dimension_tarea,
FOREIGN KEY (codigoMaterial) REFERENCES LOS_GEDEDES.BI_dimension_material,
--FOREIGN KEY (nroOrdenTrabajo) REFERENCES LOS_GEDEDES.BI_dimension_OT,
FOREIGN KEY (tiempo) REFERENCES LOS_GEDEDES.BI_dimension_tiempo,
FOREIGN KEY (idTaller) REFERENCES LOS_GEDEDES.BI_dimension_taller
);

----------LLENADO DE LAS DIMENSIONES Y TABLA DE HECHOS-------------

INSERT INTO LOS_GEDEDES.BI_dimension_chofer (nroLegajo,nombre,apellido,dni,direccion,telefono,mail,fecha_nac,costo_hora, rangoEtario)
SELECT c.nroLegajo, c.nombre, c.apellido, c.dni, c.direccion, c.telefono, c.mail, c.fecha_nac, c.costo_hora, LOS_GEDEDES.rangoEtario_fx(c.fecha_nac)
FROM LOS_GEDEDES.Chofer c

INSERT INTO LOS_GEDEDES.BI_dimension_marca (codigo, nombre) 
SELECT codigo, nombre
FROM LOS_GEDEDES.Marca

INSERT INTO LOS_GEDEDES.BI_dimension_modelo (codigo, modelo, velocidadMaxima, capacidadTanque, capacidadCarga)
SELECT codigo, modelo, velocidadMaxima, capacidadTanque, capacidadCarga
FROM LOS_GEDEDES.Modelo

INSERT INTO LOS_GEDEDES.BI_dimension_paquete (nroPaquete, tipo, largoMax, precioBase, pesoMax, altoMax, precioFinalPaquete, cantidad)
SELECT tp.nroPaquete, tp.tipo, tp.largoMax, tp.precioBase, tp.pesoMax, tp.altoMax, pv.precioFinalPaquete, pv.cantidad
FROM LOS_GEDEDES.Paquete_viaje pv 
JOIN LOS_GEDEDES.Tipo_Paquete tp ON (pv.nroPaquete = tp.nroPaquete)

--SANTI INICIO	
INSERT INTO LOS_GEDEDES.BI_dimension_taller
	(id, nombre, direccion, telefono, mail, ciudad)
SELECT  t.id, t.nombre, t.direccion, t.telefono, t.mail, ci.nombre 
FROM LOS_GEDEDES.taller t
	JOIN LOS_GEDEDES.Ciudad ci ON (ci.codigoCiudad = t.codCiudad)

INSERT INTO LOS_GEDEDES.BI_dimension_mecanico
	(nroLegajo, nombre, apellido, dni, direccion, telefono, mail, rangoEtario, costo_hora)
SELECT  t.id, t.nombre, t.direccion, t.telefono, t.mail, ci.nombre 
FROM LOS_GEDEDES.mecanico m
	JOIN LOS_GEDEDES.Ciudad ci ON (ci.codigoCiudad = t.codCiudad)

--SANTI FIN


--PROCEDURE DIMENSION CAMION--

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarDimensionCamion')
	DROP PROCEDURE LOS_GEDEDES.cargarDimensionCamion
GO

CREATE PROCEDURE LOS_GEDEDES.cargarDimensionCamion
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			
			INSERT INTO LOS_GEDEDES.BI_dimension_camion (patente, nroChasis, nroMotor, fechaAlta)
			SELECT patente, nroChasis, nroMotor, fechaAlta
			FROM LOS_GEDEDES.Camion
		
		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la dimension Camion';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO

--PROCEDURE DIMENSION TIEMPO--

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarDimensionTiempo')
	DROP PROCEDURE LOS_GEDEDES.cargarDimensionTiempo
GO

CREATE PROCEDURE LOS_GEDEDES.cargarDimensionTiempo
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			
		INSERT INTO LOS_GEDEDES.BI_dimension_tiempo (anio, mes, cuatrimestre)
		SELECT DISTINCT YEAR(fechaInicio), MONTH(fechaInicio), LOS_GEDEDES.cuatrimestre_fx(fechaInicio) FROM LOS_GEDEDES.tarea_orden
		UNION 
		SELECT DISTINCT YEAR(fechaInicio), MONTH(fechaInicio), LOS_GEDEDES.cuatrimestre_fx(fechaInicio) FROM LOS_GEDEDES.Viaje

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la dimension Tiempo';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO

--PROCEDURE DIMENSION RECORRIDO--

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarDimensionRecorrido')
	DROP PROCEDURE LOS_GEDEDES.cargarDimensionRecorrido
GO

CREATE PROCEDURE LOS_GEDEDES.cargarDimensionRecorrido
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			
		INSERT INTO LOS_GEDEDES.BI_dimension_recorrido(nroRecorrido, precioRecorrido, ciudadOrigen, ciudadDestino, recorridoKM)
		SELECT nroRecorrido, precioRecorrido, c1.nombre, c2.nombre, recorridoKM
		FROM LOS_GEDEDES.Recorrido r JOIN LOS_GEDEDES.Ciudad c1 ON(c1.codigoCiudad = r.ciudadOrigen)
									 JOIN LOS_GEDEDES.Ciudad c2 ON(c2.codigoCiudad = r.ciudadDestino)

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la dimension Recorrido';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO

--PROCEDURE DIMENSION CHOFER--

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarDimensionChofer')
	DROP PROCEDURE LOS_GEDEDES.cargarDimensionChofer
GO

CREATE PROCEDURE LOS_GEDEDES.cargarDimensionChofer
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			INSERT INTO LOS_GEDEDES.BI_dimension_chofer (nroLegajo,nombre,apellido,dni,direccion,telefono,mail,fecha_nac,costo_hora, rangoEtario)
			SELECT c.nroLegajo, c.nombre, c.apellido, c.dni, c.direccion, c.telefono, c.mail, c.fecha_nac, c.costo_hora, LOS_GEDEDES.rangoEtario_fx(c.fecha_nac)
			FROM LOS_GEDEDES.Chofer c

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la dimension chofer';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO

--PROCEDURE FACT TABLE VIAJE--

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarFactTableViaje')
	DROP PROCEDURE LOS_GEDEDES.cargarFactTableViaje
GO

CREATE PROCEDURE LOS_GEDEDES.cargarFactTableViaje
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

        /*Como las dimensiones se cargan en base a nuestras tablas, directamente saco los datos de las FK de nuestras tablas, no hace falta que joinee por 
        la dimension que necesito, si total estas dimensiones tienen de PK las PK originales */
			
		INSERT INTO LOS_GEDEDES.BI_viaje (choferLegajo, patenteCamion, recorrido, tiempo, nroPaquete, precioRecorrido, naftaConsumida)
		SELECT choferLegajo, patenteCamion, recorrido, LOS_GEDEDES.asignarTiempo_fx(fechaInicio), pv.id, precioRecorrido, naftaConsumida
		FROM LOS_GEDEDES.Viaje v JOIN LOS_GEDEDES.Paquete_viaje pv ON(pv.nroViaje = v.nroViaje)

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la fact table Viaje';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO

-- PROCEDURE FACT TABLE REPARACION --

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarFactTableReparacion')
	DROP PROCEDURE LOS_GEDEDES.cargarFactTableReparacion
GO

CREATE PROCEDURE LOS_GEDEDES.cargarFactTableReparacion
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			/*Directamente cargo todas las PK de las dimensiones porque basicamente no tengo que hacer nada mas que eso,
			no hace falta hacer un join*/

			INSERT INTO LOS_GEDEDES.BI_reparacion (patenteCamion, codigoMarca, codigoModelo, choferLegajo, codigoTarea,
			codigoMaterial, tiempo, idTaller)
			SELECT c.patente, mar.codigo, mod.codigo, mec.nroLegajo, tar.codigo, mat.codigo, tiem.idTiempo, tall.id
			FROM LOS_GEDEDES.BI_dimension_camion c, LOS_GEDEDES.BI_dimension_marca mar, LOS_GEDEDES.BI_dimension_modelo mod,
			LOS_GEDEDES.BI_dimension_mecanico mec, LOS_GEDEDES.BI_dimension_tarea tar, LOS_GEDEDES.BI_dimension_material mat,
			LOS_GEDEDES.BI_dimension_tiempo tiem, LOS_GEDEDES.BI_dimension_taller tall --No se si esta bien

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la tabla de hechos de reparacion';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO

-------EXEC DE LOS PROCEDURES--------

EXEC LOS_GEDEDES.cargarDimensionChofer
EXEC LOS_GEDES.cargarFactTableReparacion
EXEC LOS_GEDEDES.cargarDimensionRecorrido
EXEC LOS_GEDEDES.cargarDimensionTiempo
EXEC LOS_GEDEDES.cargarDimensionCamion
EXEC LOS_GEDEDES.cargarFactTableViaje

