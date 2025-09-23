CREATE DATABASE IF NOT EXISTS BienestarMentalApp;
USE BienestarMentalApp;

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
    ('Ana','ana@gmail.com'),
    ('Carlos','carlos@gmail.com'),
    ('Sofia','sofia@gmail.com'),
    ('Marcos','marcos@gmail.com'),
    ('Elena','elena@gmail.com'),
    ('David','david@gmail.com'),
    ('Laura','laura@gmail.com'),
    ('Felipe','felipe@gmail.com'),
    ('Lucia','lucia@gmail.com'),
    ('Gabriel','gabriel@gmail.com');
END;
//

CREATE PROCEDURE CrearTablaActividades()
BEGIN
    DROP TABLE IF EXISTS Actividades;
    CREATE TABLE Actividades (
        id_actividad INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL UNIQUE
    );
    INSERT INTO Actividades (nombre) VALUES
    ('Meditacion'),('Respiracion'),('Diario'),('Ejercicio ligero'),('Yoga'),
    ('Mindfulness'),('Afirmaciones'),('Musica relajante'),('Estiramientos'),('Lectura');
END;
//

CREATE PROCEDURE CrearTablaTipos()
BEGIN
    DROP TABLE IF EXISTS Tipos;
    CREATE TABLE Tipos (
        id_tipo INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL UNIQUE
    );
    INSERT INTO Tipos (nombre) VALUES
    ('Relajacion'),('Enfoque'),('Autoestima'),('Ansiedad'),('Sueño'),
    ('Energia'),('Mindfulness'),('Rutina'),('Motivacion'),('Respiracion');
END;
//

CREATE PROCEDURE CrearTablaSesiones()
BEGIN
    DROP TABLE IF EXISTS Sesiones;
    CREATE TABLE Sesiones (
        id_sesion INT AUTO_INCREMENT PRIMARY KEY,
        id_actividad INT,
        duracion INT,
        FOREIGN KEY (id_actividad) REFERENCES Actividades(id_actividad)
    );
    INSERT INTO Sesiones (id_actividad,duracion) VALUES
    (1,10),(2,5),(3,15),(4,20),(5,25),
    (6,12),(7,7),(8,30),(9,18),(10,22);
END;
//

CREATE PROCEDURE CrearTablaProgreso()
BEGIN
    DROP TABLE IF EXISTS Progreso;
    CREATE TABLE Progreso (
        id_progreso INT AUTO_INCREMENT PRIMARY KEY,
        id_actividad INT,
        nivel INT,
        FOREIGN KEY (id_actividad) REFERENCES Actividades(id_actividad)
    );
    INSERT INTO Progreso (id_actividad,nivel) VALUES
    (1,3),(2,2),(3,4),(4,5),(5,1),
    (6,2),(7,3),(8,4),(9,1),(10,5);
END;
//

CREATE PROCEDURE CrearTablaUsuariosActividades()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Actividades;
    CREATE TABLE Usuarios_Actividades (
        id_usuario INT,
        id_actividad INT,
        PRIMARY KEY(id_usuario,id_actividad),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_actividad) REFERENCES Actividades(id_actividad)
    );
    INSERT INTO Usuarios_Actividades (id_usuario,id_actividad) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaSesionesTipos()
BEGIN
    DROP TABLE IF EXISTS Sesiones_Tipos;
    CREATE TABLE Sesiones_Tipos (
        id_sesion INT,
        id_tipo INT,
        PRIMARY KEY(id_sesion,id_tipo),
        FOREIGN KEY (id_sesion) REFERENCES Sesiones(id_sesion),
        FOREIGN KEY (id_tipo) REFERENCES Tipos(id_tipo)
    );
    INSERT INTO Sesiones_Tipos (id_sesion,id_tipo) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaActividades();
CALL CrearTablaTipos();
CALL CrearTablaSesiones();
CALL CrearTablaProgreso();
CALL CrearTablaUsuariosActividades();
CALL CrearTablaSesionesTipos();

CREATE OR REPLACE VIEW Vista_UsuariosPorActividad AS
SELECT u.nombre AS usuario, a.nombre AS actividad
FROM Usuarios u
JOIN Usuarios_Actividades ua ON u.id_usuario = ua.id_usuario
JOIN Actividades a ON ua.id_actividad = a.id_actividad;

CREATE OR REPLACE VIEW Vista_SesionesPorActividad AS
SELECT a.nombre AS actividad, s.duracion
FROM Actividades a
JOIN Sesiones s ON a.id_actividad = s.id_actividad;

CREATE OR REPLACE VIEW Vista_TiposSesion AS
SELECT s.id_sesion, t.nombre AS tipo
FROM Sesiones s
JOIN Sesiones_Tipos st ON s.id_sesion = st.id_sesion
JOIN Tipos t ON st.id_tipo = t.id_tipo;

CREATE OR REPLACE VIEW Vista_ProgresoActividades AS
SELECT a.nombre AS actividad, p.nivel
FROM Progreso p
JOIN Actividades a ON p.id_actividad = a.id_actividad;

CREATE OR REPLACE VIEW Vista_UsuariosConProgreso AS
SELECT u.nombre AS usuario, p.nivel
FROM Usuarios u
JOIN Usuarios_Actividades ua ON u.id_usuario = ua.id_usuario
JOIN Progreso p ON ua.id_actividad = p.id_actividad;

SELECT * FROM Vista_UsuariosPorActividad;
SELECT * FROM Vista_SesionesPorActividad;
SELECT * FROM Vista_TiposSesion;
SELECT * FROM Vista_ProgresoActividades;
SELECT * FROM Vista_UsuariosConProgreso;
