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

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.BI_fuera_de_servicio') and type = 'U')
	DROP TABLE LOS_GEDEDES.BI_fuera_de_servicio
 
IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.BI_tarea_por_modelo') and type = 'U')
	DROP TABLE LOS_GEDEDES.BI_tarea_por_modelo

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.BI_ganancia_por_camion') and type = 'U')
	DROP TABLE LOS_GEDEDES.BI_ganancia_por_camion

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

------------ DROP VIEWS ------------------------

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.v_MaterialesMasUsadosPorTaller') and type = 'V')
	DROP VIEW LOS_GEDEDES.v_MaterialesMasUsadosPorTaller

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.v_CostoPromedioPorRangoEtario') and type = 'V')
	DROP VIEW LOS_GEDEDES.v_costoPromedioPorRangoEtario

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.v_FacturacionPorRecorridoPorCuatrimestre') and type = 'V')
	DROP VIEW LOS_GEDEDES.v_FacturacionPorRecorridoPorCuatrimestre

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.v_GananciaPorCamion') and type = 'V')
	DROP VIEW LOS_GEDEDES.v_GananciaPorCamion

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.v_CostoDeMantenimiento') and type = 'V')
	DROP VIEW LOS_GEDEDES.v_CostoDeMantenimiento

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.v_DesvioEstandarCostoTareaxTaller') and type = 'V')
	DROP VIEW LOS_GEDEDES.v_DesvioEstandarCostoTareaxTaller

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.v_tareasMasRealizadasPorModelo') and type = 'V')
	DROP VIEW LOS_GEDEDES.v_tareasMasRealizadasPorModelo

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.v_FueraDeServicioCamionPorCuatrimestre') and type = 'V')
	DROP VIEW LOS_GEDEDES.v_FueraDeServicioCamionPorCuatrimestre
  
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


CREATE TABLE LOS_GEDEDES.BI_dimension_OT(
nroOrden		INT, 
estado			NVARCHAR(255),
duracion		INT, --Quiza con la dimension tiempo no sea necesario este campo
PRIMARY KEY (nroOrden)
);


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
duracion  INT
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
id					INT,
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
duracion            INT,
costoViaje			DECIMAL(18,2),
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
nroOrdenTrabajo 	INT,
tiempo 				INT,
idTaller			INT,
PRIMARY KEY(patenteCamion, codigoMarca, codigoModelo, mecanicoLegajo, codigoTarea,
codigoMaterial, nroOrdenTrabajo, tiempo, idTaller),
FOREIGN KEY (patenteCamion) REFERENCES LOS_GEDEDES.BI_dimension_camion,
FOREIGN KEY (codigoMarca) REFERENCES LOS_GEDEDES.BI_dimension_marca,
FOREIGN KEY (codigoModelo) REFERENCES LOS_GEDEDES.BI_dimension_modelo,
FOREIGN KEY (mecanicoLegajo) REFERENCES LOS_GEDEDES.BI_dimension_mecanico,
FOREIGN KEY (codigoTarea) REFERENCES LOS_GEDEDES.BI_dimension_tarea,
FOREIGN KEY (codigoMaterial) REFERENCES LOS_GEDEDES.BI_dimension_material,
FOREIGN KEY (nroOrdenTrabajo) REFERENCES LOS_GEDEDES.BI_dimension_OT,
FOREIGN KEY (tiempo) REFERENCES LOS_GEDEDES.BI_dimension_tiempo,
FOREIGN KEY (idTaller) REFERENCES LOS_GEDEDES.BI_dimension_taller
);


CREATE TABLE LOS_GEDEDES.BI_fuera_de_servicio(
patenteCamion		NVARCHAR(255),
nroOrdenTrabajo 	INT,
tiempo 				INT,
PRIMARY KEY(patenteCamion, nroOrdenTrabajo, tiempo),
FOREIGN KEY (patenteCamion) REFERENCES LOS_GEDEDES.BI_dimension_camion,
FOREIGN KEY (nroOrdenTrabajo) REFERENCES LOS_GEDEDES.BI_dimension_OT,
FOREIGN KEY (tiempo) REFERENCES LOS_GEDEDES.BI_dimension_tiempo
);

CREATE TABLE LOS_GEDEDES.BI_tarea_por_modelo(
codigoModelo	INT,
codigoTarea		INT,
cantidad		INT,  -- Cuantas veces se hizo una tarea
PRIMARY KEY(codigoModelo, codigoTarea),
FOREIGN KEY (codigoModelo) REFERENCES LOS_GEDEDES.BI_dimension_modelo,
FOREIGN KEY (codigoTarea) REFERENCES LOS_GEDEDES.BI_dimension_tarea
);

----------LLENADO DE LAS DIMENSIONES Y TABLA DE HECHOS-------------

--PROCEDURE DIMENSION OT--

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarDimensionOT')
	DROP PROCEDURE LOS_GEDEDES.cargarDimensionOT
GO

CREATE PROCEDURE LOS_GEDEDES.cargarDimensionOT
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			
			INSERT INTO LOS_GEDEDES.BI_dimension_OT(nroOrden, estado, duracion)
			SELECT ot.nroOrden, e.descripcion, DATEDIFF(DAY, MIN(t_o.fechaInicio), MAX(t_o.fechaFin))
			FROM LOS_GEDEDES.Orden_Trabajo ot 
				JOIN LOS_GEDEDES.Estado e ON (ot.estado = e.codigo)
				JOIN LOS_GEDEDES.tarea_orden t_o ON (t_o.nroOrden = ot.nroOrden)
			GROUP BY ot.nroOrden, e.descripcion

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la dimension OT';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO


--PROCEDURE DIMENSION TALLER--

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarDimensionTaller')
	DROP PROCEDURE LOS_GEDEDES.cargarDimensionTaller
GO

CREATE PROCEDURE LOS_GEDEDES.cargarDimensionTaller
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			
			INSERT INTO LOS_GEDEDES.BI_dimension_taller
				(id, nombre, direccion, telefono, mail, ciudad)
			SELECT  t.id, t.nombre, t.direccion, t.telefono, t.mail, ci.nombre 
			FROM LOS_GEDEDES.taller t
				JOIN LOS_GEDEDES.Ciudad ci ON (ci.codigoCiudad = t.codCiudad)
		
		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la dimension Taller';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO

--PROCEDURE DIMENSION MECANICO--

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarDimensionMecanico')
	DROP PROCEDURE LOS_GEDEDES.cargarDimensionMecanico
GO

CREATE PROCEDURE LOS_GEDEDES.cargarDimensionMecanico
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			
			INSERT INTO LOS_GEDEDES.BI_dimension_mecanico
				(nroLegajo, nombre, apellido, dni, direccion, telefono, mail, rangoEtario, costo_hora)
			SELECT m.nroLegajo, m.nombre, m.apellido, m.dni, m.direccion, m.telefono, m.mail,
				LOS_GEDEDES.rangoEtario_fx(m.fecha_nac), m.costo_hora
			FROM LOS_GEDEDES.mecanico m
		
		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la dimension Mecanico';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO

--PROCEDURE DIMENSION MATERIAL--

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarDimensionMaterial')
	DROP PROCEDURE LOS_GEDEDES.cargarDimensionMaterial
GO

CREATE PROCEDURE LOS_GEDEDES.cargarDimensionMaterial
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			
			INSERT INTO LOS_GEDEDES.BI_dimension_material (codigo, descripcion, precioBase, cantidad)
			SELECT DISTINCT m.codigo, m.descripcion, m.precio, mt.cantidad 
			FROM LOS_GEDEDES.material m 
				JOIN LOS_GEDEDES.material_tarea mt ON (m.codigo = mt.codMaterial)
		
		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la dimension Material';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO

--PROCEDURE DIMENSION TAREA--

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarDimensionTarea')
	DROP PROCEDURE LOS_GEDEDES.cargarDimensionTarea
GO

CREATE PROCEDURE LOS_GEDEDES.cargarDimensionTarea
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
			
			INSERT INTO LOS_GEDEDES.BI_dimension_tarea (codigo, descripcion, tipo, duracion)
			SELECT t.codigo, t.descripcion, t.tipo, t.tiempoEstimado
			FROM LOS_GEDEDES.tarea t
		
		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la dimension Tarea';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO

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

--PROCEDURE DIMENSION MARCA--

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarDimensionMarca')
	DROP PROCEDURE LOS_GEDEDES.cargarDimensionMarca
GO

CREATE PROCEDURE LOS_GEDEDES.cargarDimensionMarca
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			INSERT INTO LOS_GEDEDES.BI_dimension_marca (codigo, nombre) 
			SELECT codigo, nombre
			FROM LOS_GEDEDES.Marca

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la dimension marca';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO

--PROCEDURE DIMENSION MODELO--

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarDimensionModelo')
	DROP PROCEDURE LOS_GEDEDES.cargarDimensionModelo
GO

CREATE PROCEDURE LOS_GEDEDES.cargarDimensionModelo
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			INSERT INTO LOS_GEDEDES.BI_dimension_modelo (codigo, modelo, velocidadMaxima, capacidadTanque, capacidadCarga)
			SELECT codigo, modelo, velocidadMaxima, capacidadTanque, capacidadCarga
			FROM LOS_GEDEDES.Modelo

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la dimension modelo';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO

--PROCEDURE DIMENSION PAQUETE--

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarDimensionPaquete')
	DROP PROCEDURE LOS_GEDEDES.cargarDimensionPaquete
GO

CREATE PROCEDURE LOS_GEDEDES.cargarDimensionPaquete
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			INSERT INTO LOS_GEDEDES.BI_dimension_paquete (id , nroPaquete, tipo, largoMax, precioBase, pesoMax, altoMax, precioFinalPaquete, cantidad)
			SELECT  pv.id ,tp.nroPaquete, tp.tipo, tp.largoMax, tp.precioBase, tp.pesoMax, tp.altoMax, pv.precioFinalPaquete, pv.cantidad
			FROM LOS_GEDEDES.Paquete_viaje pv 
			JOIN LOS_GEDEDES.Tipo_Paquete tp ON (pv.nroPaquete = tp.nroPaquete)

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la dimension paquete';
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
			
		INSERT INTO LOS_GEDEDES.BI_viaje (choferLegajo, patenteCamion, recorrido, tiempo, nroPaquete, precioRecorrido, naftaConsumida, duracion, costoViaje)
		SELECT DISTINCT choferLegajo, patenteCamion, recorrido, LOS_GEDEDES.asignarTiempo_fx(fechaInicio), pv.id, precioRecorrido, naftaConsumida, DATEDIFF(DAY, v.fechaInicio, v.fechaFin), 
		ch.costo_hora * DATEDIFF(DAY, v.fechaInicio, v.fechaFin) * 8
		FROM LOS_GEDEDES.Viaje v JOIN LOS_GEDEDES.Paquete_viaje pv ON(pv.nroViaje = v.nroViaje)
		                         JOIN LOS_GEDEDES.BI_dimension_chofer ch ON(ch.nroLegajo = v.choferLegajo)

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

			INSERT INTO LOS_GEDEDES.BI_reparacion (patenteCamion, codigoMarca, codigoModelo, mecanicoLegajo, 
			codigoTarea, codigoMaterial, nroOrdenTrabajo, tiempo, idTaller)
			SELECT DISTINCT c.patente, mar.codigo, mo.codigo, m.nroLegajo, ta.codigo, ma.codigo,
			o_t.nroOrden, dt.idTiempo, t.id
			FROM LOS_GEDEDES.Orden_Trabajo o_t
    			JOIN LOS_GEDEDES.BI_dimension_tiempo dt ON (YEAR(o_t.fechaCarga) = dt.anio AND 
       				 MONTH(o_t.fechaCarga) = dt.mes  )
    			JOIN LOS_GEDEDES.Camion c ON (c.patente = o_t.patenteCamion)
    			JOIN LOS_GEDEDES.Marca mar ON (mar.codigo = c.codigoMarca)
    			JOIN LOS_GEDEDES.Modelo mo ON (mo.codigoMarca = mar.codigo)
    			JOIN LOS_GEDEDES.tarea_orden t_o ON (t_o.nroOrden = o_t.nroOrden)
    			JOIN LOS_GEDEDES.mecanico m  ON (m.nroLegajo = t_o.legajoMecanico)
    			JOIN LOS_GEDEDES.taller t ON (m.idTaller = t.id)
    			JOIN LOS_GEDEDES.Ciudad ci ON (ci.codigoCiudad = t.codCiudad)
    			JOIN LOS_GEDEDES.tarea ta ON (ta.codigo = t_o.codTarea)
    			JOIN LOS_GEDEDES.material_tarea m_t ON (m_t.codTarea = ta.codigo)
    			JOIN LOS_GEDEDES.material ma ON (ma.codigo = m_t.codMaterial)

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


-- PROCEDURE FACT TABLE FUERA DE SERVICIO --

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarFactTableFueraDeServicio')
	DROP PROCEDURE LOS_GEDEDES.cargarFactTableFueraDeServicio
GO

CREATE PROCEDURE LOS_GEDEDES.cargarFactTableFueraDeServicio
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			INSERT INTO LOS_GEDEDES.BI_fuera_de_servicio (patenteCamion, nroOrdenTrabajo, tiempo)
			SELECT DISTINCT c.patente, o_t.nroOrden, dt.idTiempo
			FROM LOS_GEDEDES.Orden_Trabajo o_t
    			JOIN LOS_GEDEDES.BI_dimension_tiempo dt ON (YEAR(o_t.fechaCarga) = dt.anio AND 
       				 MONTH(o_t.fechaCarga) = dt.mes  )
    			JOIN LOS_GEDEDES.Camion c ON (c.patente = o_t.patenteCamion)
    			JOIN LOS_GEDEDES.tarea_orden t_o ON (t_o.nroOrden = o_t.nroOrden)
				--ORDER BY c.patente, o_t.nroOrden, dt.idTiempo

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la tabla de hechos de reparacion2';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO

-- PROCEDURE FACT TABLE TAREA POR MODELO --

IF EXISTS (SELECT * FROM sys.objects WHERE name = 'cargarFactTableTareaPorModelo')
	DROP PROCEDURE LOS_GEDEDES.cargarFactTableTareaPorModelo
GO

CREATE PROCEDURE LOS_GEDEDES.cargarFactTableTareaPorModelo
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			INSERT INTO LOS_GEDEDES.BI_tarea_por_modelo(codigoModelo, codigoTarea, cantidad)
			SELECT mo.codigo, t_o.codTarea, COUNT(t_o.codTarea)
			FROM LOS_GEDEDES.Orden_Trabajo o_t
    			JOIN LOS_GEDEDES.Camion c ON (c.patente = o_t.patenteCamion)
    			JOIN LOS_GEDEDES.Marca mar ON (mar.codigo = c.codigoMarca)
    			JOIN LOS_GEDEDES.Modelo mo ON (mo.codigoMarca = mar.codigo)
    			JOIN LOS_GEDEDES.tarea_orden t_o ON (t_o.nroOrden = o_t.nroOrden)
			GROUP BY mo.codigo, t_o.codTarea
			ORDER BY mo.codigo, t_o.codTarea

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;
		DECLARE @errorDescripcion VARCHAR(255)
		SELECT @errorDescripcion = ERROR_MESSAGE() + ' Error en el insert de la tabla de hechos de tarea por modelo';
        THROW 50000, @errorDescripcion, 1
	END CATCH
END
GO


-------EXEC DE LOS PROCEDURES--------

EXEC LOS_GEDEDES.cargarDimensionChofer
EXEC LOS_GEDEDES.cargarDimensionRecorrido
EXEC LOS_GEDEDES.cargarDimensionTiempo
EXEC LOS_GEDEDES.cargarDimensionCamion
EXEC LOS_GEDEDES.cargarDimensionMarca
EXEC LOS_GEDEDES.cargarDimensionModelo
EXEC LOS_GEDEDES.cargarDimensionPaquete
EXEC LOS_GEDEDES.cargarDimensionOT
EXEC LOS_GEDEDES.cargarDimensionMaterial
EXEC LOS_GEDEDES.cargarDimensionMecanico
EXEC LOS_GEDEDES.cargarDimensionTaller
EXEC LOS_GEDEDES.cargarDimensionTarea
EXEC LOS_GEDEDES.cargarFactTableViaje
EXEC LOS_GEDEDES.cargarFactTableReparacion
EXEC LOS_GEDEDES.cargarFactTableFueraDeServicio
EXEC LOS_GEDEDES.cargarFactTableTareaPorModelo
GO


-- VISTA 1--

CREATE VIEW LOS_GEDEDES.v_FueraDeServicioCamionPorCuatrimestre (patenteCamion, cuatrimestre, tiempoFueraDeServicio)
AS
SELECT ftr.patenteCamion, t.cuatrimestre, MAX(ot.duracion)
FROM LOS_GEDEDES.BI_fuera_de_servicio ftr
	JOIN LOS_GEDEDES.BI_dimension_OT ot ON (ftr.nroOrdenTrabajo = ot.nroOrden)
	JOIN LOS_GEDEDES.BI_dimension_tiempo t ON (ftr.tiempo = t.idTiempo)
GROUP BY ftr.patenteCamion, t.cuatrimestre
GO

-- VISTA 2--
CREATE VIEW LOS_GEDEDES.v_CostoDeMantenimiento (patenteCamion, idTaller, cuatrimestre, Costo_Mantenimiento)
AS
	SELECT patenteCamion, idTaller, t.cuatrimestre, SUM(m.precioBase*m.cantidad) + SUM(me.costo_hora*ta.duracion*8)
		FROM LOS_GEDEDES.BI_reparacion
			JOIN LOS_GEDEDES.BI_dimension_tiempo t ON tiempo = t.idTiempo
			JOIN LOS_GEDEDES.BI_dimension_material m ON codigoMaterial = m.codigo 
			JOIN LOS_GEDEDES.BI_dimension_mecanico me ON mecanicoLegajo = me.nroLegajo 
			JOIN LOS_GEDEDES.BI_dimension_tarea ta ON codigoTarea = ta.codigo
	GROUP BY patenteCamion, idTaller, t.cuatrimestre
GO


-- VISTA 3--
CREATE VIEW LOS_GEDEDES.v_DesvioEstandarCostoTareaxTaller (idTaller, codigoTarea, desvioPromedioCosto)
AS
	SELECT R.idTaller, R.codigoTarea, STDEV(TABLA_AUX.COSTO_TAREA)
		FROM LOS_GEDEDES.BI_reparacion R
			JOIN (SELECT codigoMaterial, idTaller, mecanicoLegajo, codigoTarea, SUM(m.precioBase*m.cantidad) + SUM(me.costo_hora*ta.duracion*8) COSTO_TAREA 
					FROM LOS_GEDEDES.BI_reparacion
					JOIN LOS_GEDEDES.BI_dimension_material m ON codigoMaterial = m.codigo 
					JOIN LOS_GEDEDES.BI_dimension_mecanico me ON mecanicoLegajo = me.nroLegajo
					JOIN LOS_GEDEDES.BI_dimension_tarea ta ON codigoTarea = ta.codigo
					GROUP BY idTaller, codigoTarea, codigoMaterial, mecanicoLegajo
					) TABLA_AUX ON R.codigoMaterial = TABLA_AUX.codigoMaterial AND R.mecanicoLegajo = TABLA_AUX.mecanicoLegajo AND R.codigoTarea = TABLA_AUX.codigoTarea 
	GROUP BY R.idTaller, R.codigoTarea
GO


--VISTA 4--

CREATE VIEW LOS_GEDEDES.v_tareasMasRealizadasPorModelo (modelo, codTarea, cantidad)
AS
SELECT m.modelo, tm.codigoTarea, cantidad
FROM LOS_GEDEDES.BI_tarea_por_modelo tm
	JOIN LOS_GEDEDES.BI_dimension_modelo m ON (m.codigo = tm.codigoModelo)
WHERE tm.codigoTarea IN (
	SELECT TOP 5 tm1.codigoTarea
	FROM LOS_GEDEDES.BI_tarea_por_modelo tm1
	WHERE tm1.codigoModelo = tm.codigoModelo
	ORDER BY tm1.cantidad DESC)
GROUP BY m.modelo, tm.codigoTarea, cantidad
GO

-- VISTA 5

CREATE VIEW LOS_GEDEDES.v_MaterialesMasUsadosPorTaller (nroTaller, codMaterial, cantidad)
AS
SELECT r.idTaller , r.codigoMaterial, m.cantidad 
FROM LOS_GEDEDES.BI_reparacion r JOIN LOS_GEDEDES.BI_dimension_tarea t ON r.codigoTarea = t.codigo
								 JOIN LOS_GEDEDES.BI_dimension_material m ON r.codigoMaterial = m.codigo
WHERE r.codigoMaterial IN (
	SELECT taux.cod
	FROM(SELECT DISTINCT TOP 10 r2.codigoMaterial cod,m2.cantidad cant
		FROM LOS_GEDEDES.BI_reparacion r2 JOIN LOS_GEDEDES.BI_dimension_material m2 ON r2.codigoMaterial = m2.codigo
		WHERE r2.idTaller = r.idTaller
		ORDER BY m2.cantidad DESC) taux)
GROUP BY r.idTaller, r.codigoMaterial, m.cantidad
GO

-- VISTA 6

CREATE VIEW LOS_GEDEDES.v_FacturacionPorRecorridoPorCuatrimestre (facturacionTotal, recorrido, cuatrimestre)
AS
SELECT SUM(p.precioFinalPaquete), fv.recorrido, t.cuatrimestre
FROM LOS_GEDEDES.BI_viaje fv JOIN LOS_GEDEDES.BI_dimension_tiempo t ON(fv.tiempo = t.idTiempo)
							 JOIN LOS_GEDEDES.BI_dimension_paquete p ON(fv.nroPaquete = p.id)
GROUP BY fv.recorrido, t.cuatrimestre
GO

-- VISTA 7 

CREATE VIEW LOS_GEDEDES.v_CostoPromedioPorRangoEtario (rangoEtario, promedio)
AS
SELECT c.rangoEtario , (SUM(c.costo_hora)/COUNT(v.choferLegajo)) 
FROM LOS_GEDEDES.BI_viaje v JOIN LOS_GEDEDES.BI_dimension_chofer c ON v.choferLegajo = c.nroLegajo
GROUP BY c.rangoEtario
GO

-- VISTA 8

CREATE VIEW LOS_GEDEDES.v_GananciaPorCamion (patenteCamion, ganancia)
AS
SELECT v.patenteCamion, SUM(p.precioFinalPaquete) + v.costoViaje + SUM(m.precioBase*m.cantidad) + SUM(me.costo_hora*ta.duracion*8)
FROM LOS_GEDEDES.BI_viaje v JOIN LOS_GEDEDES.BI_reparacion r ON(v.patenteCamion = r.patenteCamion)
                            JOIN LOS_GEDEDES.BI_dimension_paquete p ON(v.nroPaquete = p.id)
							JOIN LOS_GEDEDES.BI_dimension_material m ON (r.codigoMaterial = m.codigo) 
							JOIN LOS_GEDEDES.BI_dimension_mecanico me ON (r.mecanicoLegajo = me.nroLegajo)
							JOIN LOS_GEDEDES.BI_dimension_tarea ta ON (r.codigoTarea = ta.codigo)
GROUP BY v.patenteCamion, v.costoViaje
GO
