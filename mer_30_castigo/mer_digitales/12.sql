CREATE DATABASE IF NOT EXISTS PlataformaIdiomas;
USE PlataformaIdiomas;

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
    ('Andres','andres@gmail.com'),
    ('Valeria','valeria@gmail.com'),
    ('Sebastian','sebastian@gmail.com'),
    ('Paula','paula@gmail.com'),
    ('Mateo','mateo@gmail.com'),
    ('Isabella','isabella@gmail.com'),
    ('Daniel','daniel@gmail.com'),
    ('Mariana','mariana@gmail.com'),
    ('Esteban','esteban@gmail.com'),
    ('Gabriela','gabriela@gmail.com');
END;
//

CREATE PROCEDURE CrearTablaIdiomas()
BEGIN
    DROP TABLE IF EXISTS Idiomas;
    CREATE TABLE Idiomas (
        id_idioma INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL UNIQUE
    );
    INSERT INTO Idiomas (nombre) VALUES
    ('Ingles'),('Frances'),('Aleman'),('Italiano'),('Japones'),
    ('Mandarin'),('Portugues'),('Ruso'),('Arabe'),('Coreano');
END;
//

CREATE PROCEDURE CrearTablaNiveles()
BEGIN
    DROP TABLE IF EXISTS Niveles;
    CREATE TABLE Niveles (
        id_nivel INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL UNIQUE
    );
    INSERT INTO Niveles (nombre) VALUES
    ('Basico'),('Intermedio'),('Avanzado'),('Conversacion'),('Gramatica'),
    ('Pronunciacion'),('Lectura'),('Escritura'),('Comprension'),('Vocabulario');
END;
//

CREATE PROCEDURE CrearTablaLecciones()
BEGIN
    DROP TABLE IF EXISTS Lecciones;
    CREATE TABLE Lecciones (
        id_leccion INT AUTO_INCREMENT PRIMARY KEY,
        titulo VARCHAR(100) NOT NULL,
        descripcion VARCHAR(200)
    );
    INSERT INTO Lecciones (titulo,descripcion) VALUES
    ('Saludos basicos','Aprender saludos cotidianos'),
    ('Frases comunes','Expresiones de uso diario'),
    ('Numeros','Aprender a contar'),
    ('Colores','Nombres de colores'),
    ('Comida','Vocabulario de alimentos'),
    ('Viajes','Frases para viajar'),
    ('Trabajo','Vocabulario laboral'),
    ('Familia','Miembros de la familia'),
    ('Tiempo','Expresiones de clima'),
    ('Hobbies','Actividades recreativas');
END;
//

CREATE PROCEDURE CrearTablaProgresos()
BEGIN
    DROP TABLE IF EXISTS Progresos;
    CREATE TABLE Progresos (
        id_progreso INT AUTO_INCREMENT PRIMARY KEY,
        id_usuario INT NOT NULL,
        id_leccion INT NOT NULL,
        completado TINYINT(1) DEFAULT 0,
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_leccion) REFERENCES Lecciones(id_leccion)
    );
    INSERT INTO Progresos (id_usuario,id_leccion,completado) VALUES
    (1,1,1),(2,2,0),(3,3,1),(4,4,0),(5,5,1),
    (6,6,0),(7,7,1),(8,8,0),(9,9,1),(10,10,0);
END;
//

CREATE PROCEDURE CrearTablaUsuariosIdiomas()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Idiomas;
    CREATE TABLE Usuarios_Idiomas (
        id_usuario INT NOT NULL,
        id_idioma INT NOT NULL,
        PRIMARY KEY(id_usuario,id_idioma),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_idioma) REFERENCES Idiomas(id_idioma)
    );
    INSERT INTO Usuarios_Idiomas (id_usuario,id_idioma) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaLeccionesNiveles()
BEGIN
    DROP TABLE IF EXISTS Lecciones_Niveles;
    CREATE TABLE Lecciones_Niveles (
        id_leccion INT NOT NULL,
        id_nivel INT NOT NULL,
        PRIMARY KEY(id_leccion,id_nivel),
        FOREIGN KEY (id_leccion) REFERENCES Lecciones(id_leccion),
        FOREIGN KEY (id_nivel) REFERENCES Niveles(id_nivel)
    );
    INSERT INTO Lecciones_Niveles (id_leccion,id_nivel) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaIdiomas();
CALL CrearTablaNiveles();
CALL CrearTablaLecciones();
CALL CrearTablaProgresos();
CALL CrearTablaUsuariosIdiomas();
CALL CrearTablaLeccionesNiveles();

CREATE OR REPLACE VIEW Vista_LeccionesPorUsuario AS
SELECT u.nombre AS usuario, l.titulo, p.completado
FROM Progresos p
JOIN Usuarios u ON p.id_usuario = u.id_usuario
JOIN Lecciones l ON p.id_leccion = l.id_leccion;

CREATE OR REPLACE VIEW Vista_UsuariosPorIdioma AS
SELECT i.nombre AS idioma, COUNT(ui.id_usuario) AS total
FROM Idiomas i
LEFT JOIN Usuarios_Idiomas ui ON i.id_idioma = ui.id_idioma
GROUP BY i.id_idioma;

CREATE OR REPLACE VIEW Vista_LeccionesPorNivel AS
SELECT n.nombre AS nivel, COUNT(ln.id_leccion) AS total
FROM Niveles n
LEFT JOIN Lecciones_Niveles ln ON n.id_nivel = ln.id_nivel
GROUP BY n.id_nivel;

CREATE OR REPLACE VIEW Vista_UsuariosConIdiomas AS
SELECT u.nombre AS usuario, i.nombre AS idioma
FROM Usuarios u
JOIN Usuarios_Idiomas ui ON u.id_usuario = ui.id_usuario
JOIN Idiomas i ON ui.id_idioma = i.id_idioma;

CREATE OR REPLACE VIEW Vista_ProgresoTotal AS
SELECT u.nombre AS usuario, COUNT(p.id_leccion) AS total_lecciones,
SUM(p.completado) AS completadas
FROM Progresos p
JOIN Usuarios u ON p.id_usuario = u.id_usuario
GROUP BY u.id_usuario;

SELECT * FROM Vista_LeccionesPorUsuario;
SELECT * FROM Vista_UsuariosPorIdioma;
SELECT * FROM Vista_LeccionesPorNivel;
SELECT * FROM Vista_UsuariosConIdiomas;
SELECT * FROM Vista_ProgresoTotal;