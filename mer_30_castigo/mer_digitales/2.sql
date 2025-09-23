CREATE DATABASE IF NOT EXISTS Plataforma_Encuentros_Deportivos;
USE Plataforma_Encuentros_Deportivos;

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
    ('Ana Torres','ana@email.com'),
    ('Juan Perez','juan@email.com'),
    ('Maria Lopez','maria@email.com'),
    ('Carlos Garcia','carlos@email.com'),
    ('Laura Martinez','laura@email.com'),
    ('Pedro Gomez','pedro@email.com'),
    ('Sofia Hernandez','sofia@email.com'),
    ('Miguel Torres','miguel@email.com'),
    ('Elena Ruiz','elena@email.com'),
    ('Kevin Culma','kevin@email.com');
END;
//

CREATE PROCEDURE CrearTablaDeportes()
BEGIN
    DROP TABLE IF EXISTS Deportes;
    CREATE TABLE Deportes (
        id_deporte INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL UNIQUE
    );
    INSERT INTO Deportes (nombre) VALUES
    ('Futbol'),('Baloncesto'),('Tenis'),('Natacion'),('Voleibol'),
    ('Atletismo'),('Ciclismo'),('Boxeo'),('Golf'),('Esgrima');
END;
//

CREATE PROCEDURE CrearTablaEstadosEncuentro()
BEGIN
    DROP TABLE IF EXISTS Estados_Encuentro;
    CREATE TABLE Estados_Encuentro (
        id_estado INT AUTO_INCREMENT PRIMARY KEY,
        estado VARCHAR(50) NOT NULL UNIQUE
    );
    INSERT INTO Estados_Encuentro (estado) VALUES
    ('Programado'),('En curso'),('Finalizado'),('Cancelado'),('Suspendido'),
    ('Aplazado'),('Confirmado'),('Pendiente'),('Reprogramado'),('Archivado');
END;
//

CREATE PROCEDURE CrearTablaEncuentros()
BEGIN
    DROP TABLE IF EXISTS Encuentros;
    CREATE TABLE Encuentros (
        id_encuentro INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        descripcion VARCHAR(200),
        fecha_encuentro DATETIME NOT NULL
    );
    INSERT INTO Encuentros (nombre,descripcion,fecha_encuentro) VALUES
    ('Partido Futbol','Amistoso entre equipos locales','2025-09-20 10:00'),
    ('Torneo Baloncesto','Competencia intercolegios','2025-09-16 17:00'),
    ('Clase Tenis','Entrenamiento de principiantes','2025-09-18 09:00'),
    ('Carrera Atletismo','5K en ciudad','2025-09-17 15:00'),
    ('Competencia Natacion','Estilos combinados','2025-09-16 19:00'),
    ('Partido Voleibol','Equipos locales','2025-09-21 12:00'),
    ('Ruta Ciclismo','Circuito urbano','2025-09-16 20:00'),
    ('Torneo Boxeo','Campeonato juvenil','2025-09-22 18:00'),
    ('Partido Golf','Competencia 9 hoyos','2025-09-19 16:00'),
    ('Clase Esgrima','Practica avanzada','2025-09-23 14:00');
END;
//

CREATE PROCEDURE CrearTablaUsuariosEncuentros()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Encuentros;
    CREATE TABLE Usuarios_Encuentros (
        id_usuario INT NOT NULL,
        id_encuentro INT NOT NULL,
        PRIMARY KEY (id_usuario, id_encuentro),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_encuentro) REFERENCES Encuentros(id_encuentro)
    );
    INSERT INTO Usuarios_Encuentros (id_usuario,id_encuentro) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaEncuentrosDeportes()
BEGIN
    DROP TABLE IF EXISTS Encuentros_Deportes;
    CREATE TABLE Encuentros_Deportes (
        id_encuentro INT NOT NULL,
        id_deporte INT NOT NULL,
        PRIMARY KEY (id_encuentro, id_deporte),
        FOREIGN KEY (id_encuentro) REFERENCES Encuentros(id_encuentro),
        FOREIGN KEY (id_deporte) REFERENCES Deportes(id_deporte)
    );
    INSERT INTO Encuentros_Deportes (id_encuentro,id_deporte) VALUES
    (1,1),(2,2),(3,3),(4,6),(5,4),
    (6,5),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaEncuentrosEstados()
BEGIN
    DROP TABLE IF EXISTS Encuentros_Estados;
    CREATE TABLE Encuentros_Estados (
        id_encuentro INT NOT NULL,
        id_estado INT NOT NULL,
        PRIMARY KEY (id_encuentro, id_estado),
        FOREIGN KEY (id_encuentro) REFERENCES Encuentros(id_encuentro),
        FOREIGN KEY (id_estado) REFERENCES Estados_Encuentro(id_estado)
    );
    INSERT INTO Encuentros_Estados (id_encuentro,id_estado) VALUES
    (1,1),(2,1),(3,1),(4,1),(5,1),
    (6,1),(7,1),(8,1),(9,1),(10,1);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaDeportes();
CALL CrearTablaEstadosEncuentro();
CALL CrearTablaEncuentros();
CALL CrearTablaUsuariosEncuentros();
CALL CrearTablaEncuentrosDeportes();
CALL CrearTablaEncuentrosEstados();

CREATE OR REPLACE VIEW Vista_EncuentrosPorUsuario AS
SELECT u.nombre AS usuario, e.nombre AS encuentro, e.fecha_encuentro
FROM Encuentros e
JOIN Usuarios_Encuentros ue ON ue.id_encuentro = e.id_encuentro
JOIN Usuarios u ON ue.id_usuario = u.id_usuario;

CREATE OR REPLACE VIEW Vista_EncuentrosPorDeporte AS
SELECT d.nombre AS deporte, COUNT(ed.id_encuentro) AS total
FROM Deportes d
LEFT JOIN Encuentros_Deportes ed ON d.id_deporte = ed.id_deporte
GROUP BY d.id_deporte;

CREATE OR REPLACE VIEW Vista_EncuentrosPorEstado AS
SELECT es.estado, COUNT(ee.id_encuentro) AS total
FROM Estados_Encuentro es
LEFT JOIN Encuentros_Estados ee ON es.id_estado = ee.id_estado
GROUP BY es.id_estado;

CREATE OR REPLACE VIEW Vista_UsuariosConEncuentros AS
SELECT u.nombre AS usuario, COUNT(ue.id_encuentro) AS total_encuentros
FROM Usuarios u
LEFT JOIN Usuarios_Encuentros ue ON u.id_usuario = ue.id_usuario
GROUP BY u.id_usuario;

CREATE OR REPLACE VIEW Vista_EncuentrosDetallados AS
SELECT e.id_encuentro, u.nombre AS usuario, e.nombre AS encuentro, d.nombre AS deporte, es.estado, e.fecha_encuentro
FROM Encuentros e
JOIN Usuarios_Encuentros ue ON ue.id_encuentro = e.id_encuentro
JOIN Usuarios u ON ue.id_usuario = u.id_usuario
JOIN Encuentros_Deportes ed ON ed.id_encuentro = e.id_encuentro
JOIN Deportes d ON ed.id_deporte = d.id_deporte
JOIN Encuentros_Estados ee ON ee.id_encuentro = e.id_encuentro
JOIN Estados_Encuentro es ON ee.id_estado = es.id_estado;

SELECT * FROM Vista_EncuentrosPorUsuario;
SELECT * FROM Vista_EncuentrosPorDeporte;
SELECT * FROM Vista_EncuentrosPorEstado;
SELECT * FROM Vista_UsuariosConEncuentros;
SELECT * FROM Vista_EncuentrosDetallados;
