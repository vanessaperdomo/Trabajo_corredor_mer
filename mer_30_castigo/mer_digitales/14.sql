CREATE DATABASE IF NOT EXISTS VotacionProyectosApp;
USE VotacionProyectosApp;

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
    ('Gabriel','gabriel@gmail.com'),
    ('Paula','paula@gmail.com'),
    ('Hector','hector@gmail.com'),
    ('Natalia','natalia@gmail.com'),
    ('Oscar','oscar@gmail.com'),
    ('Mariana','mariana@gmail.com'),
    ('Felipe','felipe@gmail.com'),
    ('Claudia','claudia@gmail.com'),
    ('Ricardo','ricardo@gmail.com'),
    ('Emma','emma@gmail.com');
END;
//

CREATE PROCEDURE CrearTablaComunidades()
BEGIN
    DROP TABLE IF EXISTS Comunidades;
    CREATE TABLE Comunidades (
        id_comunidad INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL UNIQUE
    );
    INSERT INTO Comunidades (nombre) VALUES
    ('Universidad'),('Empresa'),('Barrio'),('Colegio'),('Fundacion'),
    ('Institucion'),('Club'),('Asociacion'),('Escuela'),('Grupo');
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
    ('Tecnologia'),('Medio Ambiente'),('Educacion'),('Salud'),('Cultura'),
    ('Deporte'),('Innovacion'),('Arte'),('Comunidad'),('Infraestructura');
END;
//

CREATE PROCEDURE CrearTablaProyectos()
BEGIN
    DROP TABLE IF EXISTS Proyectos;
    CREATE TABLE Proyectos (
        id_proyecto INT AUTO_INCREMENT PRIMARY KEY,
        titulo VARCHAR(100) NOT NULL,
        descripcion VARCHAR(200),
        fecha_creacion DATETIME NOT NULL
    );
    INSERT INTO Proyectos (titulo,descripcion,fecha_creacion) VALUES
    ('Sistema de reciclaje','Implementacion','2025-09-20 10:00'),
    ('Tutorias','Plataforma','2025-09-16 17:00'),
    ('Huerta','Cultivo','2025-09-18 09:00'),
    ('Robotica','Innovacion','2025-09-17 15:00'),
    ('Salud','Charlas','2025-09-16 19:00'),
    ('Biblioteca','Libros online','2025-09-21 12:00'),
    ('Festival','Evento','2025-09-16 20:00'),
    ('Cancha','Deporte','2025-09-22 18:00'),
    ('Arte','Exposiciones','2025-09-19 16:00'),
    ('Limpieza','Barrio','2025-09-23 14:00');
END;
//

CREATE PROCEDURE CrearTablaVotos()
BEGIN
    DROP TABLE IF EXISTS Votos;
    CREATE TABLE Votos (
        id_voto INT AUTO_INCREMENT PRIMARY KEY,
        id_proyecto INT NOT NULL,
        valor TINYINT(1) DEFAULT 1,
        FOREIGN KEY (id_proyecto) REFERENCES Proyectos(id_proyecto)
    );
    INSERT INTO Votos (id_proyecto,valor) VALUES
    (1,1),(2,1),(3,1),(4,1),(5,1),
    (6,1),(7,1),(8,1),(9,1),(10,1);
END;
//

CREATE PROCEDURE CrearTablaUsuariosComunidades()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Comunidades;
    CREATE TABLE Usuarios_Comunidades (
        id_usuario INT NOT NULL,
        id_comunidad INT NOT NULL,
        PRIMARY KEY(id_usuario,id_comunidad),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_comunidad) REFERENCES Comunidades(id_comunidad)
    );
    INSERT INTO Usuarios_Comunidades (id_usuario,id_comunidad) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,7),(9,8),(10,9);
END;
//

CREATE PROCEDURE CrearTablaProyectosCategorias()
BEGIN
    DROP TABLE IF EXISTS Proyectos_Categorias;
    CREATE TABLE Proyectos_Categorias (
        id_proyecto INT NOT NULL,
        id_categoria INT NOT NULL,
        PRIMARY KEY(id_proyecto,id_categoria),
        FOREIGN KEY (id_proyecto) REFERENCES Proyectos(id_proyecto),
        FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
    );
    INSERT INTO Proyectos_Categorias (id_proyecto,id_categoria) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaComunidades();
CALL CrearTablaCategorias();
CALL CrearTablaProyectos();
CALL CrearTablaVotos();
CALL CrearTablaUsuariosComunidades();
CALL CrearTablaProyectosCategorias();

CREATE OR REPLACE VIEW Vista_ProyectosPorUsuario AS
SELECT u.nombre AS usuario, p.titulo, p.fecha_creacion
FROM Proyectos p
JOIN Usuarios_Comunidades uc ON uc.id_usuario = p.id_proyecto
JOIN Usuarios u ON uc.id_usuario = u.id_usuario;

CREATE OR REPLACE VIEW Vista_ProyectosPorComunidad AS
SELECT c.nombre AS comunidad, COUNT(uc.id_usuario) AS total
FROM Comunidades c
LEFT JOIN Usuarios_Comunidades uc ON c.id_comunidad = uc.id_comunidad
GROUP BY c.id_comunidad;

CREATE OR REPLACE VIEW Vista_ProyectosPorCategoria AS
SELECT cat.nombre AS categoria, COUNT(pc.id_proyecto) AS total
FROM Categorias cat
LEFT JOIN Proyectos_Categorias pc ON cat.id_categoria = pc.id_categoria
GROUP BY cat.id_categoria;

CREATE OR REPLACE VIEW Vista_VotosTotales AS
SELECT p.titulo AS proyecto, COUNT(v.id_voto) AS total_votos
FROM Votos v
JOIN Proyectos p ON v.id_proyecto = p.id_proyecto
GROUP BY p.id_proyecto;

CREATE OR REPLACE VIEW Vista_UsuariosConComunidades AS
SELECT u.nombre AS usuario, c.nombre AS comunidad
FROM Usuarios u
JOIN Usuarios_Comunidades uc ON u.id_usuario = uc.id_usuario
JOIN Comunidades c ON uc.id_comunidad = c.id_comunidad;

SELECT * FROM Vista_ProyectosPorUsuario;
SELECT * FROM Vista_ProyectosPorComunidad;
SELECT * FROM Vista_ProyectosPorCategoria;
SELECT * FROM Vista_VotosTotales;
SELECT * FROM Vista_UsuariosConComunidades;