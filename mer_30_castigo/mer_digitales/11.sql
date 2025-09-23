CREATE DATABASE IF NOT EXISTS AplicacionLectura;
USE AplicacionLectura;

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
    ('Juan','juan@gmail.com'),
    ('Maria','maria@gmail.com'),
    ('Carlos','carlos@gmail.com'),
    ('Laura','laura@gmail.com'),
    ('Pedro','pedro@gmail.com'),
    ('Sofia','sofia@gmail.com'),
    ('Miguel','miguel@gmail.com'),
    ('Elena','elena@gmail.com'),
    ('Kevin','kevin@gmail.com');
END;
//

CREATE PROCEDURE CrearTablaLibros()
BEGIN
    DROP TABLE IF EXISTS Libros;
    CREATE TABLE Libros (
        id_libro INT AUTO_INCREMENT PRIMARY KEY,
        titulo VARCHAR(100) NOT NULL,
        autor VARCHAR(100) NOT NULL
    );
    INSERT INTO Libros (titulo,autor) VALUES
    ('Cien Anos de Soledad','Gabriel Garcia Marquez'),
    ('1984','George Orwell'),
    ('Don Quijote','Miguel de Cervantes'),
    ('El Principito','Antoine de Saint-Exupery'),
    ('La Odisea','Homero'),
    ('Moby Dick','Herman Melville'),
    ('Hamlet','William Shakespeare'),
    ('Orgullo y Prejuicio','Jane Austen'),
    ('Crimen y Castigo','Fiodor Dostoievski'),
    ('Rayuela','Julio Cortazar');
END;
//

CREATE PROCEDURE CrearTablaGeneros()
BEGIN
    DROP TABLE IF EXISTS Generos;
    CREATE TABLE Generos (
        id_genero INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL UNIQUE
    );
    INSERT INTO Generos (nombre) VALUES
    ('Ficcion'),('Clasico'),('Ciencia Ficcion'),('Fantasia'),('Drama'),
    ('Romance'),('Misterio'),('Historia'),('Biografia'),('Aventura');
END;
//

CREATE PROCEDURE CrearTablaFavoritos()
BEGIN
    DROP TABLE IF EXISTS Favoritos;
    CREATE TABLE Favoritos (
        id_favorito INT AUTO_INCREMENT PRIMARY KEY,
        id_usuario INT NOT NULL,
        id_libro INT NOT NULL,
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_libro) REFERENCES Libros(id_libro)
    );
    INSERT INTO Favoritos (id_usuario,id_libro) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaUsuariosGeneros()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Generos;
    CREATE TABLE Usuarios_Generos (
        id_usuario INT NOT NULL,
        id_genero INT NOT NULL,
        PRIMARY KEY(id_usuario,id_genero),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_genero) REFERENCES Generos(id_genero)
    );
    INSERT INTO Usuarios_Generos (id_usuario,id_genero) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaResenas()
BEGIN
    DROP TABLE IF EXISTS Resenas;
    CREATE TABLE Resenas (
        id_resena INT AUTO_INCREMENT PRIMARY KEY,
        id_libro INT NOT NULL,
        comentario VARCHAR(200),
        FOREIGN KEY (id_libro) REFERENCES Libros(id_libro)
    );
    INSERT INTO Resenas (id_libro,comentario) VALUES
    (1,'Excelente libro'),
    (2,'Muy interesante'),
    (3,'Clasico imperdible'),
    (4,'Inspirador'),
    (5,'Historia epica'),
    (6,'Aventura intensa'),
    (7,'Gran obra teatral'),
    (8,'Romance encantador'),
    (9,'Profundo y reflexivo'),
    (10,'Narrativa innovadora');
END;
//

CREATE PROCEDURE CrearTablaLecturas()
BEGIN
    DROP TABLE IF EXISTS Lecturas;
    CREATE TABLE Lecturas (
        id_lectura INT AUTO_INCREMENT PRIMARY KEY,
        id_usuario INT NOT NULL,
        id_libro INT NOT NULL,
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_libro) REFERENCES Libros(id_libro)
    );
    INSERT INTO Lecturas (id_usuario,id_libro) VALUES
    (1,2),(2,3),(3,4),(4,5),(5,6),
    (6,7),(7,8),(8,9),(9,10),(10,1);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaLibros();
CALL CrearTablaGeneros();
CALL CrearTablaFavoritos();
CALL CrearTablaUsuariosGeneros();
CALL CrearTablaResenas();
CALL CrearTablaLecturas();

CREATE OR REPLACE VIEW Vista_LibrosPorUsuario AS
SELECT u.nombre AS usuario, l.titulo
FROM Lecturas le
JOIN Usuarios u ON le.id_usuario = u.id_usuario
JOIN Libros l ON le.id_libro = l.id_libro;

CREATE OR REPLACE VIEW Vista_GenerosPorUsuario AS
SELECT u.nombre AS usuario, g.nombre AS genero
FROM Usuarios_Generos ug
JOIN Usuarios u ON ug.id_usuario = u.id_usuario
JOIN Generos g ON ug.id_genero = g.id_genero;

CREATE OR REPLACE VIEW Vista_Favoritos AS
SELECT u.nombre AS usuario, l.titulo AS libro
FROM Favoritos f
JOIN Usuarios u ON f.id_usuario = u.id_usuario
JOIN Libros l ON f.id_libro = l.id_libro;

CREATE OR REPLACE VIEW Vista_ResenasPorLibro AS
SELECT l.titulo AS libro, r.comentario
FROM Resenas r
JOIN Libros l ON r.id_libro = l.id_libro;

CREATE OR REPLACE VIEW Vista_LecturasTotales AS
SELECT u.nombre AS usuario, COUNT(le.id_libro) AS total
FROM Lecturas le
JOIN Usuarios u ON le.id_usuario = u.id_usuario
GROUP BY u.id_usuario;

SELECT * FROM Vista_LibrosPorUsuario;
SELECT * FROM Vista_GenerosPorUsuario;
SELECT * FROM Vista_Favoritos;
SELECT * FROM Vista_ResenasPorLibro;
SELECT * FROM Vista_LecturasTotales;
