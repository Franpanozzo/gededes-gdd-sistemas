------------- DROP TABLAS -----------------------

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.BI_viaje') and type = 'U')
	DROP TABLE LOS_GEDEDES.BI_viaje
  
IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.BI_dimension_camion') and type = 'U')
	DROP TABLE LOS_GEDEDES.BI_dimension_camion
  
IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.BI_dimension_tiempo') and type = 'U')
	DROP TABLE LOS_GEDEDES.BI_dimension_tiempo
  
IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.BI_dimension_recorrido') and type = 'U')
	DROP TABLE LOS_GEDEDES.BI_dimension_recorrido

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.BI_tarea') and type = 'U')
	DROP TABLE LOS_GEDEDES.BI_tarea

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.BI_material') and type = 'U')
	DROP TABLE LOS_GEDEDES.BI_material

IF EXISTS (select * from sys.objects where object_id = OBJECT_ID('LOS_GEDEDES.BI_mecanico') and type = 'U')
	DROP TABLE LOS_GEDEDES.BI_mecanico
 
  
------------ CREACION DE TABLAS ----------------

CREATE TABLE LOS_GEDEDES.BI_viaje(
choferLegajo INT,
patenteCamion	NVARCHAR(255),
recorrido	INT,
tiempo INT,
nroPaquete INT,
precioRecorrido INT,
naftaConsumida	DECIMAL(18,2),
PRIMARY KEY (choferLegajo, patenteCamion, recorrido, tiempo, nroPaquete),
FOREIGN KEY (nroPaquete) REFERENCES LOS_GEDEDES.BI_dimension_paquete,
FOREIGN KEY (patenteCamion) REFERENCES LOS_GEDEDES.BI_dimension_camion,
FOREIGN KEY (choferLegajo) REFERENCES LOS_GEDEDES.BI_dimension_chofer,
FOREIGN KEY (recorrido) REFERENCES LOS_GEDEDES.BI_dimension_recorrido,
FOREIGN KEY (tiempo) REFERENCES LOS_GEDEDES.BI_dimension_tiempo
);

CREATE TABLE LOS_GEDEDES.BI_dimension_camion(
patente		NVARCHAR(255),
nroChasis	NVARCHAR(255),
nroMotor	NVARCHAR(255),
fechaAlta	DATETIME2(3),
PRIMARY KEY (patente)
);

CREATE TABLE LOS_GEDEDES.BI_dimension_tiempo(
idTiempo INT IDENTITY(1,1),
anio INT,
cuatrimestre INT,
PRIMARY KEY (idTiempo)
);

CREATE TABLE LOS_GEDEDES.BI_dimension_recorrido(
nroRecorrido	INT IDENTITY(1,1),
precioRecorrido	DECIMAL(18,2),
ciudadOrigen	NVARCHAR(255),   /*Desnormalizo las ciudades entendiendo que no se pueden poner FKs en la dimension*/
ciudadDestino	NVARCHAR(255),
recorridoKM		INT,
PRIMARY KEY (nroRecorrido)
);


CREATE TABLE LOS_GEDEDES.BI_tarea(
codigo			INT,
descripcion		NVARCHAR(255),
tipo			NVARCHAR(255),
fechaInicio			DATETIME2(3),
fechaFin			DATETIME2(3),
PRIMARY KEY (codigo)
)


CREATE TABLE LOS_GEDEDES.BI_material(
codigo			NVARCHAR(100),
descripcion		NVARCHAR(255),
precioBase		DECIMAL(18,0),
cantidad		INT,
PRIMARY KEY (codigo)
)


CREATE TABLE LOS_GEDEDES.BI_mecanico(
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






