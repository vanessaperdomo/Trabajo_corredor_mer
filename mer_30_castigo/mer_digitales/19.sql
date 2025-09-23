CREATE DATABASE IF NOT EXISTS PlataformaInvestigacion;
USE PlataformaInvestigacion;

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
    ('Laura','laura@gmail.com'),
    ('Andres','andres@gmail.com'),
    ('Camila','camila@gmail.com'),
    ('Mateo','mateo@gmail.com'),
    ('Paula','paula@gmail.com'),
    ('Daniel','daniel@gmail.com'),
    ('Isabela','isabela@gmail.com'),
    ('Felipe','felipe@gmail.com'),
    ('Valentina','valentina@gmail.com'),
    ('Jorge','jorge@gmail.com');
END;
//

CREATE PROCEDURE CrearTablaEstudios()
BEGIN
    DROP TABLE IF EXISTS Estudios;
    CREATE TABLE Estudios (
        id_estudio INT AUTO_INCREMENT PRIMARY KEY,
        titulo VARCHAR(100) NOT NULL,
        fecha_inicio DATETIME NOT NULL
    );
    INSERT INTO Estudios (titulo,fecha_inicio) VALUES
    ('Analisis de consumo','2025-09-20 10:00'),
    ('Tendencias digitales','2025-09-16 17:00'),
    ('Preferencias alimenticias','2025-09-18 09:00'),
    ('Habitos de compra','2025-09-17 15:00'),
    ('Estudio regional','2025-09-16 19:00'),
    ('Encuesta de tecnologia','2025-09-21 12:00'),
    ('Mercado juvenil','2025-09-16 20:00'),
    ('Investigacion moda','2025-09-22 18:00'),
    ('Analisis de precios','2025-09-19 16:00'),
    ('Comportamiento consumidor','2025-09-23 14:00');
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
    ('Tecnologia'),('Alimentos'),('Ropa'),('Salud'),('Educacion'),
    ('Deporte'),('Viajes'),('Entretenimiento'),('Finanzas'),('Otros');
END;
//

CREATE PROCEDURE CrearTablaEncuestas()
BEGIN
    DROP TABLE IF EXISTS Encuestas;
    CREATE TABLE Encuestas (
        id_encuesta INT AUTO_INCREMENT PRIMARY KEY,
        tema VARCHAR(100) NOT NULL,
        fecha_creacion DATETIME NOT NULL
    );
    INSERT INTO Encuestas (tema,fecha_creacion) VALUES
    ('Dispositivos','2025-09-20 11:00'),
    ('Alimentos','2025-09-16 18:00'),
    ('Moda','2025-09-18 10:00'),
    ('Salud','2025-09-17 16:00'),
    ('Educacion','2025-09-16 20:00'),
    ('Viajes','2025-09-21 13:00'),
    ('Deportes','2025-09-16 21:00'),
    ('Entretenimiento','2025-09-22 19:00'),
    ('Finanzas','2025-09-19 17:00'),
    ('Tendencias','2025-09-23 15:00');
END;
//

CREATE PROCEDURE CrearTablaRespuestas()
BEGIN
    DROP TABLE IF EXISTS Respuestas;
    CREATE TABLE Respuestas (
        id_respuesta INT AUTO_INCREMENT PRIMARY KEY,
        id_encuesta INT NOT NULL,
        respuesta_texto VARCHAR(200),
        FOREIGN KEY (id_encuesta) REFERENCES Encuestas(id_encuesta)
    );
    INSERT INTO Respuestas (id_encuesta,respuesta_texto) VALUES
    (1,'Opcion A'),(2,'Opcion B'),(3,'Opcion C'),(4,'Opcion D'),
    (5,'Opcion E'),(6,'Opcion F'),(7,'Opcion G'),(8,'Opcion H'),
    (9,'Opcion I'),(10,'Opcion J');
END;
//

CREATE PROCEDURE CrearTablaUsuariosCategorias()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Categorias;
    CREATE TABLE Usuarios_Categorias (
        id_usuario INT NOT NULL,
        id_categoria INT NOT NULL,
        PRIMARY KEY(id_usuario,id_categoria),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
    );
    INSERT INTO Usuarios_Categorias (id_usuario,id_categoria) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaEstudiosEncuestas()
BEGIN
    DROP TABLE IF EXISTS Estudios_Encuestas;
    CREATE TABLE Estudios_Encuestas (
        id_estudio INT NOT NULL,
        id_encuesta INT NOT NULL,
        PRIMARY KEY(id_estudio,id_encuesta),
        FOREIGN KEY (id_estudio) REFERENCES Estudios(id_estudio),
        FOREIGN KEY (id_encuesta) REFERENCES Encuestas(id_encuesta)
    );
    INSERT INTO Estudios_Encuestas (id_estudio,id_encuesta) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaEstudios();
CALL CrearTablaCategorias();
CALL CrearTablaEncuestas();
CALL CrearTablaRespuestas();
CALL CrearTablaUsuariosCategorias();
CALL CrearTablaEstudiosEncuestas();

CREATE OR REPLACE VIEW Vista_UsuariosCategorias AS
SELECT u.nombre AS usuario, c.nombre AS categoria
FROM Usuarios u
JOIN Usuarios_Categorias uc ON u.id_usuario = uc.id_usuario
JOIN Categorias c ON uc.id_categoria = c.id_categoria;

CREATE OR REPLACE VIEW Vista_EstudiosPorUsuario AS
SELECT u.nombre AS usuario, e.titulo AS estudio
FROM Estudios e
JOIN Estudios_Encuestas ee ON e.id_estudio = ee.id_estudio
JOIN Encuestas enq ON ee.id_encuesta = enq.id_encuesta
JOIN Usuarios_Categorias uc ON uc.id_categoria = uc.id_categoria
JOIN Usuarios u ON u.id_usuario = uc.id_usuario;

CREATE OR REPLACE VIEW Vista_EncuestasPorCategoria AS
SELECT c.nombre AS categoria, COUNT(uc.id_usuario) AS total
FROM Categorias c
LEFT JOIN Usuarios_Categorias uc ON c.id_categoria = uc.id_categoria
GROUP BY c.id_categoria;

CREATE OR REPLACE VIEW Vista_RespuestasPorEncuesta AS
SELECT enq.tema AS encuesta, COUNT(r.id_respuesta) AS total_respuestas
FROM Encuestas enq
LEFT JOIN Respuestas r ON enq.id_encuesta = r.id_encuesta
GROUP BY enq.id_encuesta;

CREATE OR REPLACE VIEW Vista_EstudiosConEncuestas AS
SELECT e.titulo AS estudio, enq.tema AS encuesta
FROM Estudios e
JOIN Estudios_Encuestas ee ON e.id_estudio = ee.id_estudio
JOIN Encuestas enq ON ee.id_encuesta = enq.id_encuesta;

SELECT * FROM Vista_UsuariosCategorias;
SELECT * FROM Vista_EstudiosPorUsuario;
SELECT * FROM Vista_EncuestasPorCategoria;
SELECT * FROM Vista_RespuestasPorEncuesta;
SELECT * FROM Vista_EstudiosConEncuestas;