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
rangoEtario 	NVARCHAR(255),
--fechaViaje DATETIME2(3) 
/*Lo comento porque no se si va aca, mepa que en la tabla de bi viaje,
quiza dentro de la dimension tiempo*/
PRIMARY KEY (nroLegajo)
);

CREATE TABLE LOS_GEDEDES.BI_dimension_OT(
nroOrden		INT, /*No le pongo IDENTITY por lo que puse abajo*/
patenteCamion	NVARCHAR(255),
estado			INT,
fechaCarga		NVARCHAR(255),/*Quiza con la dimension tiempo no sea necesario este campo*/
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
cuatrimestre	INT,
PRIMARY KEY (idTiempo)
);

CREATE TABLE LOS_GEDEDES.BI_dimension_recorrido(
nroRecorrido	INT IDENTITY(1,1), 
/*Con el IDENTITY?? Yo creo que los datos que van aca son los precargados de las tablas que ya hicimos
por que lo poner identity podria generar que halla un recorrido igual pero con dos IDs diferentes*/
precioRecorrido	DECIMAL(18,2),
ciudadOrigen	NVARCHAR(255),   /*Desnormalizo las ciudades entendiendo que no se pueden poner FKs en la dimension*/
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
fecha_nac	DATETIME2(3),
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
PRIMARY KEY (codigo),
)

CREATE TABLE LOS_GEDEDES.BI_dimension_paquete(
nroPaquete			INT,
largoMax			DECIMAL(18,2),
pesoMax				DECIMAL(18,2),
altoMax				DECIMAL(18,2),
precioBase			DECIMAL(18,2),
cantidad			INT,
precioFinalPaquete	DECIMAL(18,2),
PRIMARY KEY (nroPaquete),
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
choferLegajo 		INT,
codigoTarea			INT,
codigoMaterial 		NVARCHAR(100),
nroOrdenTrabajo 	INT,
tiempo 				INT
PRIMARY KEY(patenteCamion, choferLegajo, codigoTarea,
codigoMaterial, nroOrdenTrabajo, tiempo)
FOREIGN KEY (patenteCamion) REFERENCES LOS_GEDEDES.BI_dimension_camion,
FOREIGN KEY (choferLegajo) REFERENCES LOS_GEDEDES.BI_dimension_chofer,
FOREIGN KEY (codigoTarea) REFERENCES LOS_GEDEDES.BI_dimension_tarea,
FOREIGN KEY (codigoMaterial) REFERENCES LOS_GEDEDES.BI_dimension_material,
FOREIGN KEY (nroOrdenTrabajo) REFERENCES LOS_GEDEDES.BI_dimension_OT,
FOREIGN KEY (tiempo) REFERENCES LOS_GEDEDES.BI_dimension_tiempo
);
