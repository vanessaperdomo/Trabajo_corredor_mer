USE SistemaControlAccesos;

-- Este indice practicamente sirve para buscar por nombre de puerta
CREATE INDEX nombre_puerta ON Puertas(nombre);

-- Este indice es practicamente para evitar el duplicado de emails
CREATE UNIQUE INDEX email_usuarios ON Usuarios(email);

-- Este indice sirve para filtrar por tipo de acceso
CREATE INDEX tipo_acceso ON Accesos(tipo);

-- agregar indice por fecha usando alter table
ALTER TABLE Accesos
ADD INDEX fecha_acceso (fecha);

-- agregar indice por ubicacion usando alter table
ALTER TABLE Puertas
ADD INDEX ubicacion_puerta (ubicacion);




