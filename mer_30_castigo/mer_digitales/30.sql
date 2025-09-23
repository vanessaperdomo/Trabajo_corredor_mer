CREATE DATABASE IF NOT EXISTS PlanificacionApp;
USE PlanificacionApp;

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
    ('Luis','luis@gmail.com'),
    ('Paula','paula@gmail.com'),
    ('Diego','diego@gmail.com'),
    ('Andres','andres@gmail.com'),
    ('Valeria','valeria@gmail.com'),
    ('Jorge','jorge@gmail.com'),
    ('Natalia','natalia@gmail.com'),
    ('Ricardo','ricardo@gmail.com'),
    ('Monica','monica@gmail.com'),
    ('Camila','camila@gmail.com');
END;
//

CREATE PROCEDURE CrearTablaMetodos()
BEGIN
    DROP TABLE IF EXISTS Metodos;
    CREATE TABLE Metodos (
        id_metodo INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL UNIQUE
    );
    INSERT INTO Metodos (nombre) VALUES
    ('Condon'),('Pastilla'),('DIU'),('Implante'),('Inyeccion'),
    ('Anillo'),('Parche'),('Calendario'),('Lactancia'),('Esterilizacion');
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
    ('Hormonales'),('No hormonales'),('Permanentes'),
    ('Naturales'),('Emergencia'),('Barrera'),
    ('Combinados'),('Largo plazo'),('Corto plazo'),('Masculinos');
END;
//

CREATE PROCEDURE CrearTablaConsultas()
BEGIN
    DROP TABLE IF EXISTS Consultas;
    CREATE TABLE Consultas (
        id_consulta INT AUTO_INCREMENT PRIMARY KEY,
        id_usuario INT,
        fecha DATE,
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
    );
    INSERT INTO Consultas (id_usuario,fecha) VALUES
    (1,'2025-01-10'),(2,'2025-01-15'),(3,'2025-02-01'),
    (4,'2025-02-20'),(5,'2025-03-05'),(6,'2025-03-10'),
    (7,'2025-04-01'),(8,'2025-04-15'),(9,'2025-05-01'),(10,'2025-05-20');
END;
//

CREATE PROCEDURE CrearTablaEfectividad()
BEGIN
    DROP TABLE IF EXISTS Efectividad;
    CREATE TABLE Efectividad (
        id_metodo INT,
        porcentaje INT,
        PRIMARY KEY (id_metodo),
        FOREIGN KEY (id_metodo) REFERENCES Metodos(id_metodo)
    );
    INSERT INTO Efectividad (id_metodo,porcentaje) VALUES
    (1,85),(2,91),(3,99),(4,99),(5,94),
    (6,93),(7,91),(8,76),(9,98),(10,100);
END;
//

CREATE PROCEDURE CrearTablaUsuariosMetodos()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Metodos;
    CREATE TABLE Usuarios_Metodos (
        id_usuario INT,
        id_metodo INT,
        PRIMARY KEY(id_usuario,id_metodo),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_metodo) REFERENCES Metodos(id_metodo)
    );
    INSERT INTO Usuarios_Metodos (id_usuario,id_metodo) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaMetodosTipos()
BEGIN
    DROP TABLE IF EXISTS Metodos_Tipos;
    CREATE TABLE Metodos_Tipos (
        id_metodo INT,
        id_tipo INT,
        PRIMARY KEY(id_metodo,id_tipo),
        FOREIGN KEY (id_metodo) REFERENCES Metodos(id_metodo),
        FOREIGN KEY (id_tipo) REFERENCES Tipos(id_tipo)
    );
    INSERT INTO Metodos_Tipos (id_metodo,id_tipo) VALUES
    (1,6),(2,1),(3,2),(4,1),(5,1),
    (6,1),(7,1),(8,4),(9,4),(10,3);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaMetodos();
CALL CrearTablaTipos();
CALL CrearTablaConsultas();
CALL CrearTablaEfectividad();
CALL CrearTablaUsuariosMetodos();
CALL CrearTablaMetodosTipos();

CREATE OR REPLACE VIEW Vista_UsuariosPorMetodo AS
SELECT u.nombre AS usuario, m.nombre AS metodo
FROM Usuarios u
JOIN Usuarios_Metodos um ON u.id_usuario = um.id_usuario
JOIN Metodos m ON um.id_metodo = m.id_metodo;

CREATE OR REPLACE VIEW Vista_MetodosPorTipo AS
SELECT t.nombre AS tipo, COUNT(mt.id_metodo) AS total
FROM Tipos t
LEFT JOIN Metodos_Tipos mt ON t.id_tipo = mt.id_tipo
GROUP BY t.id_tipo;

CREATE OR REPLACE VIEW Vista_EfectividadMetodos AS
SELECT m.nombre AS metodo, e.porcentaje
FROM Metodos m
JOIN Efectividad e ON m.id_metodo = e.id_metodo;

CREATE OR REPLACE VIEW Vista_ConsultasUsuarios AS
SELECT u.nombre AS usuario, c.fecha
FROM Consultas c
JOIN Usuarios u ON c.id_usuario = u.id_usuario;

CREATE OR REPLACE VIEW Vista_UsuariosConTipos AS
SELECT u.nombre AS usuario, t.nombre AS tipo
FROM Usuarios u
JOIN Usuarios_Metodos um ON u.id_usuario = um.id_usuario
JOIN Metodos_Tipos mt ON um.id_metodo = mt.id_metodo
JOIN Tipos t ON mt.id_tipo = t.id_tipo;

SELECT * FROM Vista_UsuariosPorMetodo;
SELECT * FROM Vista_MetodosPorTipo;
SELECT * FROM Vista_EfectividadMetodos;
SELECT * FROM Vista_ConsultasUsuarios;
SELECT * FROM Vista_UsuariosConTipos;
