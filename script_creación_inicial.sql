CREATE TABLE LOS_GEDEDES.Camion(
patente NVARCHAR(255),
nroChasis NVARCHAR(255),
fechaAlta DATETIME2(3),
marca NVARCHAR(255),
modelo NVARCHAR(255),
velocidadMaxima INT,
capacidadTanque INT,
capacidadCarga INT,
PRIMARY KEY (patente),
);

CREATE TABLE LOS_GEDEDES.Recorrido(
nroRecorrido INT,
precioRecorrido DECIMAL(18,2),
ciudadOrigen NVARCHAR(255),
ciudadDestino NVARCHAR(255),
recorridoKM INT,
PRIMARY KEY (nroRecorrido),
);


CREATE TABLE LOS_GEDEDES.Viaje(
nroViaje INT IDENTITY(1,1),
camionID NVARCHAR(255),
choferID INT,
recorrido INT,
precioRecorrido INT,
fechaInicio DATETIME2(7),
fechaFin DATETIME2(3),
naftaConsumida decimal(18,2),
PRIMARY KEY (nroViaje),
FOREIGN KEY (camionID) REFERENCES LOS_GEDEDES.Camion,
FOREIGN KEY (choferID) REFERENCES LOS_GEDEDES.Persona,
FOREIGN KEY (recorrido) REFERENCES LOS_GEDEDES.Recorrido,
CHECK(fechaInicio < fechaFin)
);

