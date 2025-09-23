CREATE DATABASE IF NOT EXISTS ClimaApp;
USE ClimaApp;

DELIMITER //

CREATE PROCEDURE CrearTablaUsuarios()
BEGIN
    DROP TABLE IF EXISTS Usuarios;
    CREATE TABLE Usuarios (
        id_usuario INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE
    );
    INSERT INTO Usuarios (nombre,email) VALUES
    ('Carlos','carlos@gmail.com'),
    ('Laura','laura@gmail.com'),
    ('Sebastian','sebastian@gmail.com'),
    ('Ana','ana@gmail.com'),
    ('Martin','martin@gmail.com'),
    ('Elena','elena@gmail.com'),
    ('Fernando','fernando@gmail.com'),
    ('Claudia','claudia@gmail.com'),
    ('Julian','julian@gmail.com'),
    ('Sofia','sofia@gmail.com');
END;
//

CREATE PROCEDURE CrearTablaCiudades()
BEGIN
    DROP TABLE IF EXISTS Ciudades;
    CREATE TABLE Ciudades (
        id_ciudad INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL
    );
    INSERT INTO Ciudades (nombre) VALUES
    ('Bogota'),('Medellin'),('Lima'),('Quito'),('Buenos Aires'),
    ('Santiago'),('Montevideo'),('Asuncion'),('La Paz'),('Caracas');
END;
//

CREATE PROCEDURE CrearTablaCondiciones()
BEGIN
    DROP TABLE IF EXISTS Condiciones;
    CREATE TABLE Condiciones (
        id_condicion INT AUTO_INCREMENT PRIMARY KEY,
        descripcion VARCHAR(100) NOT NULL
    );
    INSERT INTO Condiciones (descripcion) VALUES
    ('Soleado'),('Nublado'),('Lluvia ligera'),('Lluvia fuerte'),
    ('Tormenta'),('Niebla'),('Viento fuerte'),('Nevando'),
    ('Granizo'),('Despejado');
END;
//

CREATE PROCEDURE CrearTablaReportes()
BEGIN
    DROP TABLE IF EXISTS Reportes;
    CREATE TABLE Reportes (
        id_reporte INT AUTO_INCREMENT PRIMARY KEY,
        temperatura DECIMAL(4,1),
        id_ciudad INT,
        FOREIGN KEY (id_ciudad) REFERENCES Ciudades(id_ciudad)
    );
    INSERT INTO Reportes (temperatura,id_ciudad) VALUES
    (20.5,1),(18.0,2),(25.3,3),(16.7,4),(22.0,5),
    (19.5,6),(21.4,7),(24.8,8),(17.9,9),(26.1,10);
END;
//

CREATE PROCEDURE CrearTablaAlertas()
BEGIN
    DROP TABLE IF EXISTS Alertas;
    CREATE TABLE Alertas (
        id_alerta INT AUTO_INCREMENT PRIMARY KEY,
        id_condicion INT,
        mensaje VARCHAR(150),
        FOREIGN KEY (id_condicion) REFERENCES Condiciones(id_condicion)
    );
    INSERT INTO Alertas (id_condicion,mensaje) VALUES
    (4,'Posibilidad de inundaciones'),
    (5,'Precaucion por tormentas electricas'),
    (7,'Alerta por vientos fuertes'),
    (9,'Advertencia de granizo'),
    (3,'Lluvias dispersas en la tarde'),
    (6,'Baja visibilidad por niebla'),
    (8,'Riesgo de nieve en carreteras'),
    (2,'Cielo mayormente nublado'),
    (1,'Condiciones ideales para salir'),
    (10,'Clima despejado sin novedad');
END;
//

CREATE PROCEDURE CrearTablaUsuariosCiudades()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Ciudades;
    CREATE TABLE Usuarios_Ciudades (
        id_usuario INT,
        id_ciudad INT,
        PRIMARY KEY(id_usuario,id_ciudad),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_ciudad) REFERENCES Ciudades(id_ciudad)
    );
    INSERT INTO Usuarios_Ciudades (id_usuario,id_ciudad) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaReportesCondiciones()
BEGIN
    DROP TABLE IF EXISTS Reportes_Condiciones;
    CREATE TABLE Reportes_Condiciones (
        id_reporte INT,
        id_condicion INT,
        PRIMARY KEY(id_reporte,id_condicion),
        FOREIGN KEY (id_reporte) REFERENCES Reportes(id_reporte),
        FOREIGN KEY (id_condicion) REFERENCES Condiciones(id_condicion)
    );
    INSERT INTO Reportes_Condiciones (id_reporte,id_condicion) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaCiudades();
CALL CrearTablaCondiciones();
CALL CrearTablaReportes();
CALL CrearTablaAlertas();
CALL CrearTablaUsuariosCiudades();
CALL CrearTablaReportesCondiciones();

CREATE OR REPLACE VIEW Vista_UsuariosPorCiudad AS
SELECT u.nombre AS usuario, c.nombre AS ciudad
FROM Usuarios u
JOIN Usuarios_Ciudades uc ON u.id_usuario = uc.id_usuario
JOIN Ciudades c ON uc.id_ciudad = c.id_ciudad;

CREATE OR REPLACE VIEW Vista_ReportesPorCiudad AS
SELECT c.nombre AS ciudad, r.temperatura
FROM Ciudades c
JOIN Reportes r ON c.id_ciudad = r.id_ciudad;

CREATE OR REPLACE VIEW Vista_CondicionesPorReporte AS
SELECT r.id_reporte, co.descripcion
FROM Reportes r
JOIN Reportes_Condiciones rc ON r.id_reporte = rc.id_reporte
JOIN Condiciones co ON rc.id_condicion = co.id_condicion;

CREATE OR REPLACE VIEW Vista_AlertasPorCondicion AS
SELECT co.descripcion AS condicion, a.mensaje
FROM Alertas a
JOIN Condiciones co ON a.id_condicion = co.id_condicion;

CREATE OR REPLACE VIEW Vista_UsuariosConAlertas AS
SELECT u.nombre AS usuario, a.mensaje
FROM Usuarios u
JOIN Usuarios_Ciudades uc ON u.id_usuario = uc.id_usuario
JOIN Reportes r ON uc.id_ciudad = r.id_ciudad
JOIN Reportes_Condiciones rc ON r.id_reporte = rc.id_reporte
JOIN Alertas a ON rc.id_condicion = a.id_condicion;

SELECT * FROM Vista_UsuariosPorCiudad;
SELECT * FROM Vista_ReportesPorCiudad;
SELECT * FROM Vista_CondicionesPorReporte;
SELECT * FROM Vista_AlertasPorCondicion;
SELECT * FROM Vista_UsuariosConAlertas;
