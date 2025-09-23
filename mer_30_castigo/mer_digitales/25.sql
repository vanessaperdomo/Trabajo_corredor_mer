CREATE DATABASE IF NOT EXISTS ServiciosApp;
USE ServiciosApp;

DELIMITER //

CREATE PROCEDURE CrearTablaUsuarios()
BEGIN
    DROP TABLE IF EXISTS Usuarios;
    CREATE TABLE Usuarios (
        id_usuario INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100),
        email VARCHAR(100)
    );
    INSERT INTO Usuarios (nombre, email) VALUES
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

CREATE PROCEDURE CrearTablaCategorias()
BEGIN
    DROP TABLE IF EXISTS Categorias;
    CREATE TABLE Categorias (
        id_categoria INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50)
    );
    INSERT INTO Categorias (nombre) VALUES
    ('Abogados'),('Contadores'),('Disenadores'),
    ('Marketing'),('Programadores'),('Consultores'),
    ('Traductores'),('Tutores'),('Arquitectos'),
    ('Ingenieros');
END;
//

CREATE PROCEDURE CrearTablaServicios()
BEGIN
    DROP TABLE IF EXISTS Servicios;
    CREATE TABLE Servicios (
        id_servicio INT AUTO_INCREMENT PRIMARY KEY,
        titulo VARCHAR(100),
        precio DECIMAL(10,2)
    );
    INSERT INTO Servicios (titulo, precio) VALUES
    ('Asesoria legal', 100.00),
    ('Declaracion de renta', 80.00),
    ('Diseno de logo', 120.00),
    ('Campana publicitaria', 200.00),
    ('Desarrollo web', 300.00),
    ('Consultoria empresarial', 150.00),
    ('Traduccion de documentos', 90.00),
    ('Clases particulares', 50.00),
    ('Plano de casa', 250.00),
    ('Revision estructural', 180.00);
END;
//

CREATE PROCEDURE CrearTablaResenas()
BEGIN
    DROP TABLE IF EXISTS Resenas;
    CREATE TABLE Resenas (
        id_resena INT AUTO_INCREMENT PRIMARY KEY,
        id_servicio INT,
        texto VARCHAR(100)
    );
    INSERT INTO Resenas (id_servicio, texto) VALUES
    (1,'Muy profesional'),
    (2,'Rapido y claro'),
    (3,'Excelente diseno'),
    (4,'Buena estrategia'),
    (5,'Codigo limpio'),
    (6,'Buen analisis'),
    (7,'Traduccion precisa'),
    (8,'Explica bien'),
    (9,'Trabajo detallado'),
    (10,'Muy tecnico');
END;
//

CREATE PROCEDURE CrearTablaUsuariosCategorias()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Categorias;
    CREATE TABLE Usuarios_Categorias (
        id_usuario INT,
        id_categoria INT,
        PRIMARY KEY(id_usuario, id_categoria),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
    );
    INSERT INTO Usuarios_Categorias (id_usuario, id_categoria) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaServiciosCategorias()
BEGIN
    DROP TABLE IF EXISTS Servicios_Categorias;
    CREATE TABLE Servicios_Categorias (
        id_servicio INT,
        id_categoria INT,
        PRIMARY KEY(id_servicio, id_categoria),
        FOREIGN KEY (id_servicio) REFERENCES Servicios(id_servicio),
        FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
    );
    INSERT INTO Servicios_Categorias (id_servicio, id_categoria) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaProfesionales()
BEGIN
    DROP TABLE IF EXISTS Profesionales;
    CREATE TABLE Profesionales (
        id_profesional INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100),
        profesion VARCHAR(50)
    );
    INSERT INTO Profesionales (nombre, profesion) VALUES
    ('Carlos','Abogado'),
    ('Andrea','Contadora'),
    ('Julian','Disenador'),
    ('Laura','Marketer'),
    ('Sofia','Programadora'),
    ('Martin','Consultor'),
    ('Luisa','Traductora'),
    ('Fernando','Tutor'),
    ('Elena','Arquitecta'),
    ('Bruno','Ingeniero');
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaCategorias();
CALL CrearTablaServicios();
CALL CrearTablaResenas();
CALL CrearTablaUsuariosCategorias();
CALL CrearTablaServiciosCategorias();
CALL CrearTablaProfesionales();

CREATE OR REPLACE VIEW Vista_ServiciosPorUsuario AS
SELECT u.nombre AS usuario, s.titulo
FROM Servicios s
JOIN Usuarios_Categorias uc ON s.id_servicio = uc.id_usuario
JOIN Usuarios u ON uc.id_usuario = u.id_usuario;

CREATE OR REPLACE VIEW Vista_ServiciosPorCategoria AS
SELECT c.nombre AS categoria, COUNT(sc.id_servicio) AS total
FROM Categorias c
LEFT JOIN Servicios_Categorias sc ON c.id_categoria = sc.id_categoria
GROUP BY c.id_categoria;

CREATE OR REPLACE VIEW Vista_ResenasPorServicio AS
SELECT s.titulo AS servicio, COUNT(r.id_resena) AS total
FROM Servicios s
LEFT JOIN Resenas r ON s.id_servicio = r.id_servicio
GROUP BY s.id_servicio;

CREATE OR REPLACE VIEW Vista_UsuariosConCategorias AS
SELECT u.nombre AS usuario, c.nombre AS categoria
FROM Usuarios u
JOIN Usuarios_Categorias uc ON u.id_usuario = uc.id_usuario
JOIN Categorias c ON uc.id_categoria = c.id_categoria;

CREATE OR REPLACE VIEW Vista_ProfesionalesDisponibles AS
SELECT p.nombre AS profesional, p.profesion
FROM Profesionales p;

SELECT * FROM Vista_ServiciosPorUsuario;
SELECT * FROM Vista_ServiciosPorCategoria;
SELECT * FROM Vista_ResenasPorServicio;
SELECT * FROM Vista_UsuariosConCategorias;
SELECT * FROM Vista_ProfesionalesDisponibles;
