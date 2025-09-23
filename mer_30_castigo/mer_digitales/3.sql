CREATE DATABASE IF NOT EXISTS SistemaEncuestas;
USE SistemaEncuestas;

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
    ('Maria','maria@gmail.com'),
    ('Yubelly','yube@gmail.com'),
    ('Mariana','mariana@gmail.com'),
    ('Emily','emi@gmail.com'),
    ('Danna','dann@gmail.com'),
    ('Andres','andres@gmail.com'),
    ('Manual','manual@gmail.com'),
    ('Camilo','cami@gmail.com'),
    ('Kenny','kevin@gmail.com');
END;
//

CREATE PROCEDURE CrearTablaEncuestas()
BEGIN
    DROP TABLE IF EXISTS Encuestas;
    CREATE TABLE Encuestas (
        id_encuesta INT AUTO_INCREMENT PRIMARY KEY,
        titulo VARCHAR(100) NOT NULL,
        descripcion VARCHAR(200),
        fecha_creacion DATETIME NOT NULL
    );
    INSERT INTO Encuestas (titulo,descripcion,fecha_creacion) VALUES
    ('satisfaccion servicio','encuesta sobre servicio','2025-09-18 10:00'),
    ('calidad producto','encuesta de calidad','2025-09-19 11:00'),
    ('atencion cliente','encuesta de atencion','2025-09-20 09:00'),
    ('soporte tecnico','encuesta soporte','2025-09-21 14:00'),
    ('experiencia compra','encuesta compra','2025-09-22 15:00'),
    ('pagina web','encuesta web','2025-09-23 16:00'),
    ('promociones','encuesta promociones','2025-09-24 17:00'),
    ('servicio posventa','encuesta posventa','2025-09-25 18:00'),
    ('sugerencias','encuesta sugerencias','2025-09-26 19:00'),
    ('mejoras','encuesta mejoras','2025-09-27 20:00');
END;
//

CREATE PROCEDURE CrearTablaPreguntas()
BEGIN
    DROP TABLE IF EXISTS Preguntas;
    CREATE TABLE Preguntas (
        id_pregunta INT AUTO_INCREMENT PRIMARY KEY,
        texto VARCHAR(200) NOT NULL
    );
    INSERT INTO Preguntas (texto) VALUES
    ('como califica la atencion'),
    ('que tan satisfecho esta'),
    ('recomendaria nuestro servicio'),
    ('que aspecto mejoraria'),
    ('como califica el producto'),
    ('su experiencia fue positiva'),
    ('el soporte fue rapido'),
    ('los precios son adecuados'),
    ('el sitio web es facil de usar'),
    ('volveria a comprar');
END;
//

CREATE PROCEDURE CrearTablaRespuestas()
BEGIN
    DROP TABLE IF EXISTS Respuestas;
    CREATE TABLE Respuestas (
        id_respuesta INT AUTO_INCREMENT PRIMARY KEY,
        texto VARCHAR(200) NOT NULL
    );
    INSERT INTO Respuestas (texto) VALUES
    ('excelente'),
    ('bueno'),
    ('regular'),
    ('malo'),
    ('si'),
    ('no'),
    ('quizas'),
    ('muy satisfecho'),
    ('poco satisfecho'),
    ('nada satisfecho');
END;
//

CREATE PROCEDURE CrearTablaRespuestasUsuarios()
BEGIN
    DROP TABLE IF EXISTS Respuestas_Usuarios;
    CREATE TABLE Respuestas_Usuarios (
        id_usuario INT NOT NULL,
        id_pregunta INT NOT NULL,
        id_respuesta INT NOT NULL,
        PRIMARY KEY(id_usuario,id_pregunta),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_pregunta) REFERENCES Preguntas(id_pregunta),
        FOREIGN KEY (id_respuesta) REFERENCES Respuestas(id_respuesta)
    );
    INSERT INTO Respuestas_Usuarios (id_usuario,id_pregunta,id_respuesta) VALUES
    (1,1,1),(2,2,2),(3,3,5),(4,4,4),(5,5,1),
    (6,6,8),(7,7,2),(8,8,3),(9,9,1),(10,10,2);
END;
//

CREATE PROCEDURE CrearTablaEncuestasPreguntas()
BEGIN
    DROP TABLE IF EXISTS Encuestas_Preguntas;
    CREATE TABLE Encuestas_Preguntas (
        id_encuesta INT NOT NULL,
        id_pregunta INT NOT NULL,
        PRIMARY KEY(id_encuesta,id_pregunta),
        FOREIGN KEY (id_encuesta) REFERENCES Encuestas(id_encuesta),
        FOREIGN KEY (id_pregunta) REFERENCES Preguntas(id_pregunta)
    );
    INSERT INTO Encuestas_Preguntas (id_encuesta,id_pregunta) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaUsuariosEncuestas()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Encuestas;
    CREATE TABLE Usuarios_Encuestas (
        id_usuario INT NOT NULL,
        id_encuesta INT NOT NULL,
        PRIMARY KEY(id_usuario,id_encuesta),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_encuesta) REFERENCES Encuestas(id_encuesta)
    );
    INSERT INTO Usuarios_Encuestas (id_usuario,id_encuesta) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaEncuestas();
CALL CrearTablaPreguntas();
CALL CrearTablaRespuestas();
CALL CrearTablaRespuestasUsuarios();
CALL CrearTablaEncuestasPreguntas();
CALL CrearTablaUsuariosEncuestas();

CREATE OR REPLACE VIEW Vista_RespuestasPorUsuario AS
SELECT u.nombre AS usuario, p.texto AS pregunta, r.texto AS respuesta
FROM Respuestas_Usuarios ru
JOIN Usuarios u ON ru.id_usuario = u.id_usuario
JOIN Preguntas p ON ru.id_pregunta = p.id_pregunta
JOIN Respuestas r ON ru.id_respuesta = r.id_respuesta;

CREATE OR REPLACE VIEW Vista_PreguntasPorEncuesta AS
SELECT e.titulo AS encuesta, COUNT(ep.id_pregunta) AS total_preguntas
FROM Encuestas e
LEFT JOIN Encuestas_Preguntas ep ON e.id_encuesta = ep.id_encuesta
GROUP BY e.id_encuesta;

CREATE OR REPLACE VIEW Vista_UsuariosPorEncuesta AS
SELECT e.titulo AS encuesta, COUNT(ue.id_usuario) AS total_usuarios
FROM Encuestas e
LEFT JOIN Usuarios_Encuestas ue ON e.id_encuesta = ue.id_encuesta
GROUP BY e.id_encuesta;

CREATE OR REPLACE VIEW Vista_EncuestasRealizadas AS
SELECT u.nombre AS usuario, e.titulo AS encuesta
FROM Usuarios u
JOIN Usuarios_Encuestas ue ON u.id_usuario = ue.id_usuario
JOIN Encuestas e ON ue.id_encuesta = e.id_encuesta;

CREATE OR REPLACE VIEW Vista_TotalRespuestasPorEncuesta AS
SELECT e.titulo AS encuesta, COUNT(ru.id_respuesta) AS total_respuestas
FROM Encuestas e
JOIN Encuestas_Preguntas ep ON e.id_encuesta = ep.id_encuesta
JOIN Respuestas_Usuarios ru ON ep.id_pregunta = ru.id_pregunta
GROUP BY e.id_encuesta;

SELECT * FROM Vista_RespuestasPorUsuario;
SELECT * FROM Vista_PreguntasPorEncuesta;
SELECT * FROM Vista_UsuariosPorEncuesta;
SELECT * FROM Vista_EncuestasRealizadas;
SELECT * FROM Vista_TotalRespuestasPorEncuesta;