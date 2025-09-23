CREATE DATABASE IF NOT EXISTS AppCompraEntradasCine;
USE AppCompraEntradasCine;

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
    ('Diego','diego@gmail.com'),
    ('Valentina','valentina@gmail.com'),
    ('Andres','andres@gmail.com'),
    ('Camila','camila@gmail.com'),
    ('Mateo','mateo@gmail.com'),
    ('Isabella','isabella@gmail.com'),
    ('Felipe','felipe@gmail.com'),
    ('Daniela','daniela@gmail.com'),
    ('Julian','julian@gmail.com'),
    ('Sara','sara@gmail.com');
END;
//

CREATE PROCEDURE CrearTablaPeliculas()
BEGIN
    DROP TABLE IF EXISTS Peliculas;
    CREATE TABLE Peliculas (
        id_pelicula INT AUTO_INCREMENT PRIMARY KEY,
        titulo VARCHAR(100) NOT NULL,
        duracion INT NOT NULL
    );
    INSERT INTO Peliculas (titulo,duracion) VALUES
    ('Accion Total',120),
    ('Comedia Noche',90),
    ('Drama Urbano',110),
    ('Terror Oscuro',100),
    ('Aventura Extrema',130),
    ('Romance Azul',95),
    ('Fantasia Lunar',125),
    ('Documental Mar',85),
    ('Ciencia Futura',105),
    ('Animacion Sol',80);
END;
//

CREATE PROCEDURE CrearTablaSalas()
BEGIN
    DROP TABLE IF EXISTS Salas;
    CREATE TABLE Salas (
        id_sala INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL,
        capacidad INT NOT NULL
    );
    INSERT INTO Salas (nombre,capacidad) VALUES
    ('Sala 1',50),('Sala 2',60),
    ('Sala 3',70),('Sala 4',55),
    ('Sala 5',65),('Sala 6',75),
    ('Sala 7',80),('Sala 8',60),
    ('Sala 9',50),('Sala 10',40);
END;
//

CREATE PROCEDURE CrearTablaFunciones()
BEGIN
    DROP TABLE IF EXISTS Funciones;
    CREATE TABLE Funciones (
        id_funcion INT AUTO_INCREMENT PRIMARY KEY,
        id_pelicula INT NOT NULL,
        id_sala INT NOT NULL,
        fecha_hora DATETIME NOT NULL,
        FOREIGN KEY (id_pelicula) REFERENCES Peliculas(id_pelicula),
        FOREIGN KEY (id_sala) REFERENCES Salas(id_sala)
    );
    INSERT INTO Funciones (id_pelicula,id_sala,fecha_hora) VALUES
    (1,1,'2025-09-20 18:00'),(2,2,'2025-09-20 20:00'),
    (3,3,'2025-09-21 17:00'),(4,4,'2025-09-21 19:00'),
    (5,5,'2025-09-22 18:30'),(6,6,'2025-09-22 21:00'),
    (7,7,'2025-09-23 16:00'),(8,8,'2025-09-23 18:00'),
    (9,9,'2025-09-24 20:00'),(10,10,'2025-09-24 21:30');
END;
//

CREATE PROCEDURE CrearTablaEntradas()
BEGIN
    DROP TABLE IF EXISTS Entradas;
    CREATE TABLE Entradas (
        id_entrada INT AUTO_INCREMENT PRIMARY KEY,
        id_funcion INT NOT NULL,
        asiento VARCHAR(10) NOT NULL,
        FOREIGN KEY (id_funcion) REFERENCES Funciones(id_funcion)
    );
    INSERT INTO Entradas (id_funcion,asiento) VALUES
    (1,'A1'),(2,'B2'),(3,'C3'),(4,'D4'),(5,'E5'),
    (6,'F6'),(7,'G7'),(8,'H8'),(9,'I9'),(10,'J10');
END;
//

CREATE PROCEDURE CrearTablaUsuariosFunciones()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Funciones;
    CREATE TABLE Usuarios_Funciones (
        id_usuario INT NOT NULL,
        id_funcion INT NOT NULL,
        PRIMARY KEY(id_usuario,id_funcion),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_funcion) REFERENCES Funciones(id_funcion)
    );
    INSERT INTO Usuarios_Funciones (id_usuario,id_funcion) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaFuncionesEntradas()
BEGIN
    DROP TABLE IF EXISTS Funciones_Entradas;
    CREATE TABLE Funciones_Entradas (
        id_funcion INT NOT NULL,
        id_entrada INT NOT NULL,
        PRIMARY KEY(id_funcion,id_entrada),
        FOREIGN KEY (id_funcion) REFERENCES Funciones(id_funcion),
        FOREIGN KEY (id_entrada) REFERENCES Entradas(id_entrada)
    );
    INSERT INTO Funciones_Entradas (id_funcion,id_entrada) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaPeliculas();
CALL CrearTablaSalas();
CALL CrearTablaFunciones();
CALL CrearTablaEntradas();
CALL CrearTablaUsuariosFunciones();
CALL CrearTablaFuncionesEntradas();

CREATE OR REPLACE VIEW Vista_UsuariosPorFuncion AS
SELECT u.nombre AS usuario, p.titulo AS pelicula, f.fecha_hora
FROM Usuarios u
JOIN Usuarios_Funciones uf ON u.id_usuario = uf.id_usuario
JOIN Funciones f ON uf.id_funcion = f.id_funcion
JOIN Peliculas p ON f.id_pelicula = p.id_pelicula;

CREATE OR REPLACE VIEW Vista_EntradasPorFuncion AS
SELECT f.id_funcion, COUNT(fe.id_entrada) AS total_entradas
FROM Funciones f
LEFT JOIN Funciones_Entradas fe ON f.id_funcion = fe.id_funcion
GROUP BY f.id_funcion;

CREATE OR REPLACE VIEW Vista_EntradasPorPelicula AS
SELECT p.titulo, COUNT(e.id_entrada) AS total
FROM Peliculas p
LEFT JOIN Funciones f ON p.id_pelicula = f.id_pelicula
LEFT JOIN Entradas e ON f.id_funcion = e.id_funcion
GROUP BY p.id_pelicula;

CREATE OR REPLACE VIEW Vista_FuncionesPorSala AS
SELECT s.nombre AS sala, COUNT(f.id_funcion) AS total_funciones
FROM Salas s
LEFT JOIN Funciones f ON s.id_sala = f.id_sala
GROUP BY s.id_sala;

CREATE OR REPLACE VIEW Vista_UsuariosConEntradas AS
SELECT u.nombre AS usuario, e.asiento, p.titulo
FROM Usuarios u
JOIN Usuarios_Funciones uf ON u.id_usuario = uf.id_usuario
JOIN Funciones f ON uf.id_funcion = f.id_funcion
JOIN Peliculas p ON f.id_pelicula = p.id_pelicula
JOIN Funciones_Entradas fe ON f.id_funcion = fe.id_funcion
JOIN Entradas e ON fe.id_entrada = e.id_entrada;

SELECT * FROM Vista_UsuariosPorFuncion;
SELECT * FROM Vista_EntradasPorFuncion;
SELECT * FROM Vista_EntradasPorPelicula;
SELECT * FROM Vista_FuncionesPorSala;
SELECT * FROM Vista_UsuariosConEntradas;