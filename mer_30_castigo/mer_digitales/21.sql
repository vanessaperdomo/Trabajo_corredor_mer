CREATE DATABASE IF NOT EXISTS MeditacionApp;
USE MeditacionApp;

DELIMITER //

CREATE PROCEDURE CrearTablaUsuarios()
BEGIN
    DROP TABLE IF EXISTS Usuarios;
    CREATE TABLE Usuarios (
        id_usuario INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE
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
        nombre VARCHAR(50) NOT NULL UNIQUE
    );
    INSERT INTO Categorias (nombre) VALUES
    ('Mindfulness'),('Respiracion'),('Relajacion'),
    ('Gratitud'),('Compasion'),('Sueno'),('Atencion Plena'),
    ('Estres'),('Enfoque'),('Cuerpo');
END;
//

CREATE PROCEDURE CrearTablaTecnicas()
BEGIN
    DROP TABLE IF EXISTS Tecnicas;
    CREATE TABLE Tecnicas (
        id_tecnica INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL UNIQUE
    );
    INSERT INTO Tecnicas (nombre) VALUES
    ('Respiracion Profunda'),('Visualizacion'),
    ('Body Scan'),('Mantras'),('Silencio'),('Movimiento Lento'),
    ('Contar Respiraciones'),('Conciencia del cuerpo'),
    ('Aceptacion'),('Intencion Positiva');
END;
//

CREATE PROCEDURE CrearTablaSesiones()
BEGIN
    DROP TABLE IF EXISTS Sesiones;
    CREATE TABLE Sesiones (
        id_sesion INT AUTO_INCREMENT PRIMARY KEY,
        titulo VARCHAR(100) NOT NULL,
        descripcion VARCHAR(200),
        duracion_min INT NOT NULL
    );
    INSERT INTO Sesiones (titulo, descripcion, duracion_min) VALUES
    ('Respira y calma','Sesion guiada para relajarte',10),
    ('Cuerpo y mente','Enfoque en el cuerpo',15),
    ('Agradecimiento diario','Meditacion de gratitud',12),
    ('Compasion interior','Desarrolla empatia',20),
    ('Relajacion nocturna','Ideal antes de dormir',18),
    ('Enfocate','Mejora tu concentracion',14),
    ('Desconexion','Reduce el estres',16),
    ('Momento presente','Practica de atencion plena',10),
    ('Pausa mental','Mini descanso guiado',8),
    ('Visualiza tu dia','Prepara tu mente',13);
END;
//

CREATE PROCEDURE CrearTablaComentarios()
BEGIN
    DROP TABLE IF EXISTS Comentarios;
    CREATE TABLE Comentarios (
        id_comentario INT AUTO_INCREMENT PRIMARY KEY,
        id_sesion INT NOT NULL,
        texto VARCHAR(200) NOT NULL,
        FOREIGN KEY (id_sesion) REFERENCES Sesiones(id_sesion)
    );
    INSERT INTO Comentarios (id_sesion, texto) VALUES
    (1,'Muy relajante'),(2,'Me ayudo mucho'),
    (3,'Excelente forma de empezar el dia'),(4,'Muy emotiva'),
    (5,'Me dormi rapido'),(6,'Ayuda con enfoque'),
    (7,'Siento menos tension'),(8,'Me conecto al presente'),
    (9,'Pausa necesaria'),(10,'Motivadora');
END;
//

CREATE PROCEDURE CrearTablaUsuariosCategorias()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Categorias;
    CREATE TABLE Usuarios_Categorias (
        id_usuario INT NOT NULL,
        id_categoria INT NOT NULL,
        PRIMARY KEY (id_usuario, id_categoria),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
    );
    INSERT INTO Usuarios_Categorias (id_usuario, id_categoria) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaSesionesTecnicas()
BEGIN
    DROP TABLE IF EXISTS Sesiones_Tecnicas;
    CREATE TABLE Sesiones_Tecnicas (
        id_sesion INT NOT NULL,
        id_tecnica INT NOT NULL,
        PRIMARY KEY (id_sesion, id_tecnica),
        FOREIGN KEY (id_sesion) REFERENCES Sesiones(id_sesion),
        FOREIGN KEY (id_tecnica) REFERENCES Tecnicas(id_tecnica)
    );
    INSERT INTO Sesiones_Tecnicas (id_sesion, id_tecnica) VALUES
    (1,1),(1,2),(2,3),(3,4),(4,5),
    (5,6),(6,7),(7,1),(8,8),(9,9);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaCategorias();
CALL CrearTablaTecnicas();
CALL CrearTablaSesiones();
CALL CrearTablaComentarios();
CALL CrearTablaUsuariosCategorias();
CALL CrearTablaSesionesTecnicas();

CREATE OR REPLACE VIEW Vista_SesionesPorUsuario AS
SELECT u.nombre AS usuario, s.titulo, s.duracion_min
FROM Sesiones s
JOIN Usuarios_Categorias uc ON uc.id_usuario = s.id_sesion
JOIN Usuarios u ON uc.id_usuario = u.id_usuario;

CREATE OR REPLACE VIEW Vista_UsuariosPorCategoria AS
SELECT c.nombre AS categoria, COUNT(uc.id_usuario) AS total
FROM Categorias c
LEFT JOIN Usuarios_Categorias uc ON c.id_categoria = uc.id_categoria
GROUP BY c.id_categoria;

CREATE OR REPLACE VIEW Vista_TecnicasPorSesion AS
SELECT s.titulo AS sesion, COUNT(st.id_tecnica) AS total
FROM Sesiones s
LEFT JOIN Sesiones_Tecnicas st ON s.id_sesion = st.id_sesion
GROUP BY s.id_sesion;

CREATE OR REPLACE VIEW Vista_ComentariosPorSesion AS
SELECT s.titulo, c.texto
FROM Comentarios c
JOIN Sesiones s ON c.id_sesion = s.id_sesion;

CREATE OR REPLACE VIEW Vista_UsuariosConCategorias AS
SELECT u.nombre AS usuario, c.nombre AS categoria
FROM Usuarios u
JOIN Usuarios_Categorias uc ON u.id_usuario = uc.id_usuario
JOIN Categorias c ON uc.id_categoria = c.id_categoria;

SELECT * FROM Vista_SesionesPorUsuario;
SELECT * FROM Vista_UsuariosPorCategoria;
SELECT * FROM Vista_TecnicasPorSesion;
SELECT * FROM Vista_ComentariosPorSesion;
SELECT * FROM Vista_UsuariosConCategorias;