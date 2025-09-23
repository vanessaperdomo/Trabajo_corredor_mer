CREATE DATABASE IF NOT EXISTS SistemaRegistroAsistencia;
USE SistemaRegistroAsistencia;

DELIMITER //

CREATE PROCEDURE CrearTablaPersonas()
BEGIN
    DROP TABLE IF EXISTS Personas;
    CREATE TABLE Personas (
        id_persona INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE
    );
    INSERT INTO Personas (nombre,email) VALUES
    ('Sofia','sofia@gmail.com'),
    ('Maria','maria@gmail.com'),
    ('David','david@gmail.com'),
    ('Laura','laura@gmail.com'),
    ('Sara','sara@gmail.com'),
    ('Diego','diego@gmail.com'),
    ('Stiven','stiven@gmail.com'),
    ('Dayana','dayana@gmail.com'),
    ('Luisa','luisa@gmail.com'),
    ('Keissy','keissy@gmail.com');
END;
//

CREATE PROCEDURE CrearTablaEventos()
BEGIN
    DROP TABLE IF EXISTS Eventos;
    CREATE TABLE Eventos (
        id_evento INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL UNIQUE
    );
    INSERT INTO Eventos (nombre) VALUES
    ('Conferencia'),
    ('Taller'),
    ('Seminario'),
    ('Reunion'),
    ('Webinar'),
    ('ClaseSQL'),
    ('CursoJava'),
    ('Presentacion'),
    ('Charla'),
    ('Capacitacion');
END;
//

CREATE PROCEDURE CrearTablaRoles()
BEGIN
    DROP TABLE IF EXISTS Roles;
    CREATE TABLE Roles (
        id_rol INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL UNIQUE
    );
    INSERT INTO Roles (nombre) VALUES
    ('Empleado'),('Estudiante'),('Invitado'),('Ponente'),('Organizador'),
    ('Voluntario'),('Supervisor'),('Docente'),('Asistente'),('Administrador');
END;
//

CREATE PROCEDURE CrearTablaSesiones()
BEGIN
    DROP TABLE IF EXISTS Sesiones;
    CREATE TABLE Sesiones (
        id_sesion INT AUTO_INCREMENT PRIMARY KEY,
        tema VARCHAR(100) NOT NULL,
        fecha_hora DATETIME NOT NULL
    );
    INSERT INTO Sesiones (tema,fecha_hora) VALUES
    ('Sesion1','2025-09-20 10:00'),
    ('Sesion2','2025-09-16 17:00'),
    ('Sesion3','2025-09-18 09:00'),
    ('Sesion4','2025-09-17 15:00'),
    ('Sesion5','2025-09-16 19:00'),
    ('Sesion6','2025-09-21 12:00'),
    ('Sesion7','2025-09-16 20:00'),
    ('Sesion8','2025-09-22 18:00'),
    ('Sesion9','2025-09-19 16:00'),
    ('Sesion10','2025-09-23 14:00');
END;
//

CREATE PROCEDURE CrearTablaAsistencias()
BEGIN
    DROP TABLE IF EXISTS Asistencias;
    CREATE TABLE Asistencias (
        id_asistencia INT AUTO_INCREMENT PRIMARY KEY,
        id_sesion INT NOT NULL,
        presente TINYINT(1) DEFAULT 0,
        FOREIGN KEY (id_sesion) REFERENCES Sesiones(id_sesion)
    );
    INSERT INTO Asistencias (id_sesion,presente) VALUES
    (1,0),(2,0),(3,0),(4,0),(5,0),
    (6,0),(7,0),(8,0),(9,0),(10,0);
END;
//

CREATE PROCEDURE CrearTablaPersonasEventos()
BEGIN
    DROP TABLE IF EXISTS Personas_Eventos;
    CREATE TABLE Personas_Eventos (
        id_persona INT NOT NULL,
        id_evento INT NOT NULL,
        PRIMARY KEY(id_persona,id_evento),
        FOREIGN KEY (id_persona) REFERENCES Personas(id_persona),
        FOREIGN KEY (id_evento) REFERENCES Eventos(id_evento)
    );
    INSERT INTO Personas_Eventos (id_persona,id_evento) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaSesionesRoles()
BEGIN
    DROP TABLE IF EXISTS Sesiones_Roles;
    CREATE TABLE Sesiones_Roles (
        id_sesion INT NOT NULL,
        id_rol INT NOT NULL,
        PRIMARY KEY(id_sesion,id_rol),
        FOREIGN KEY (id_sesion) REFERENCES Sesiones(id_sesion),
        FOREIGN KEY (id_rol) REFERENCES Roles(id_rol)
    );
    INSERT INTO Sesiones_Roles (id_sesion,id_rol) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaPersonas();
CALL CrearTablaEventos();
CALL CrearTablaRoles();
CALL CrearTablaSesiones();
CALL CrearTablaAsistencias();
CALL CrearTablaPersonasEventos();
CALL CrearTablaSesionesRoles();

CREATE OR REPLACE VIEW Vista_SesionesPorPersona AS
SELECT p.nombre AS persona, s.tema, s.fecha_hora
FROM Sesiones s
JOIN Personas_Eventos pe ON pe.id_persona = s.id_sesion
JOIN Personas p ON pe.id_persona = p.id_persona;

CREATE OR REPLACE VIEW Vista_EventosPorPersona AS
SELECT e.nombre AS evento, COUNT(pe.id_persona) AS total
FROM Eventos e
LEFT JOIN Personas_Eventos pe ON e.id_evento = pe.id_evento
GROUP BY e.id_evento;

CREATE OR REPLACE VIEW Vista_SesionesPorRol AS
SELECT r.nombre AS rol, COUNT(sr.id_sesion) AS total
FROM Roles r
LEFT JOIN Sesiones_Roles sr ON r.id_rol = sr.id_rol
GROUP BY r.id_rol;

CREATE OR REPLACE VIEW Vista_AsistenciasPendientes AS
SELECT s.tema, a.presente
FROM Asistencias a
JOIN Sesiones s ON a.id_sesion = s.id_sesion
WHERE a.presente = 0;

CREATE OR REPLACE VIEW Vista_PersonasConEventos AS
SELECT p.nombre AS persona, e.nombre AS evento
FROM Personas p
JOIN Personas_Eventos pe ON p.id_persona = pe.id_persona
JOIN Eventos e ON pe.id_evento = e.id_evento;

SELECT * FROM Vista_SesionesPorPersona;
SELECT * FROM Vista_EventosPorPersona;
SELECT * FROM Vista_SesionesPorRol;
SELECT * FROM Vista_AsistenciasPendientes;
SELECT * FROM Vista_PersonasConEventos;
