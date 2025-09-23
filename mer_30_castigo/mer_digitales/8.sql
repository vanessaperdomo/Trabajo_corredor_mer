CREATE DATABASE IF NOT EXISTS AplicacionStreamingMusica;
USE AplicacionStreamingMusica;

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
    ('Jose','jose@gmail.com'),
    ('Lorena','lorena@gmail.com'),
    ('Diego','diego@gmail.com'),
    ('Camila','camila@gmail.com'),
    ('Andres','andres@gmail.com'),
    ('Valeria','valeria@gmail.com'),
    ('Jorge','jorge@gmail.com'),
    ('Natalia','natalia@gmail.com'),
    ('Ricardo','ricardo@gmail.com'),
    ('Monica','monica@gmail.com');
END;
//

CREATE PROCEDURE CrearTablaArtistas()
BEGIN
    DROP TABLE IF EXISTS Artistas;
    CREATE TABLE Artistas (
        id_artista INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL UNIQUE
    );
    INSERT INTO Artistas (nombre) VALUES
    ('Arctic Waves'),('Luna Roja'),('Electro Beat'),('Sonido Urbano'),('Jazz Fusion'),
    ('Rock Andino'),('Pop Estelar'),('Indie Norte'),('Rap Central'),('Folk Andino');
END;
//

CREATE PROCEDURE CrearTablaAlbums()
BEGIN
    DROP TABLE IF EXISTS Albums;
    CREATE TABLE Albums (
        id_album INT AUTO_INCREMENT PRIMARY KEY,
        titulo VARCHAR(100) NOT NULL,
        anio INT NOT NULL,
        id_artista INT NOT NULL,
        FOREIGN KEY (id_artista) REFERENCES Artistas(id_artista)
    );
    INSERT INTO Albums (titulo,anio,id_artista) VALUES
    ('Horizonte',2022,1),('Noches',2021,2),('Electro Live',2023,3),('Calles',2020,4),('Blue Jazz',2022,5),
    ('Montanas',2019,6),('Galaxia',2021,7),('Indie Sun',2022,8),('Rimas',2023,9),('Bosque',2020,10);
END;
//

CREATE PROCEDURE CrearTablaCanciones()
BEGIN
    DROP TABLE IF EXISTS Canciones;
    CREATE TABLE Canciones (
        id_cancion INT AUTO_INCREMENT PRIMARY KEY,
        titulo VARCHAR(100) NOT NULL,
        duracion INT NOT NULL,
        id_album INT NOT NULL,
        FOREIGN KEY (id_album) REFERENCES Albums(id_album)
    );
    INSERT INTO Canciones (titulo,duracion,id_album) VALUES
    ('Intro',180,1),
    ('Luz',200,2),
    ('BeatUp',210,3),
    ('Ciudad',190,4),
    ('Sax',220,5),
    ('Cumbre',205,6),
    ('Estrella',215,7),
    ('Indie Love',230,8),
    ('Flow',240,9),
    ('Raiz',195,10);
END;
//

CREATE PROCEDURE CrearTablaListas()
BEGIN
    DROP TABLE IF EXISTS Listas;
    CREATE TABLE Listas (
        id_lista INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        id_usuario INT NOT NULL,
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario)
    );
    INSERT INTO Listas (nombre,id_usuario) VALUES
    ('Favoritas',1),('Workout',2),('Relax',3),('Fiesta',4),('Viaje',5),
    ('Estudio',6),('PopHits',7),('RockMix',8),('Chill',9),('Top10',10);
END;
//

CREATE PROCEDURE CrearTablaListaCanciones()
BEGIN
    DROP TABLE IF EXISTS Lista_Canciones;
    CREATE TABLE Lista_Canciones (
        id_lista INT NOT NULL,
        id_cancion INT NOT NULL,
        PRIMARY KEY (id_lista,id_cancion),
        FOREIGN KEY (id_lista) REFERENCES Listas(id_lista),
        FOREIGN KEY (id_cancion) REFERENCES Canciones(id_cancion)
    );
    INSERT INTO Lista_Canciones (id_lista,id_cancion) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaUsuariosArtistas()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Artistas;
    CREATE TABLE Usuarios_Artistas (
        id_usuario INT NOT NULL,
        id_artista INT NOT NULL,
        PRIMARY KEY (id_usuario,id_artista),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_artista) REFERENCES Artistas(id_artista)
    );
    INSERT INTO Usuarios_Artistas (id_usuario,id_artista) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaArtistas();
CALL CrearTablaAlbums();
CALL CrearTablaCanciones();
CALL CrearTablaListas();
CALL CrearTablaListaCanciones();
CALL CrearTablaUsuariosArtistas();

CREATE OR REPLACE VIEW Vista_CancionesPorAlbum AS
SELECT a.titulo AS album, COUNT(c.id_cancion) AS total_canciones
FROM Albums a
LEFT JOIN Canciones c ON a.id_album = c.id_album
GROUP BY a.id_album;

CREATE OR REPLACE VIEW Vista_ListasPorUsuario AS
SELECT u.nombre AS usuario, COUNT(l.id_lista) AS total_listas
FROM Usuarios u
LEFT JOIN Listas l ON u.id_usuario = l.id_usuario
GROUP BY u.id_usuario;

CREATE OR REPLACE VIEW Vista_CancionesPorLista AS
SELECT l.nombre AS lista, COUNT(lc.id_cancion) AS total_canciones
FROM Listas l
LEFT JOIN Lista_Canciones lc ON l.id_lista = lc.id_lista
GROUP BY l.id_lista;

CREATE OR REPLACE VIEW Vista_UsuariosArtistas AS
SELECT u.nombre AS usuario, ar.nombre AS artista
FROM Usuarios u
JOIN Usuarios_Artistas ua ON u.id_usuario = ua.id_usuario
JOIN Artistas ar ON ua.id_artista = ar.id_artista;

CREATE OR REPLACE VIEW Vista_CancionesPorArtista AS
SELECT ar.nombre AS artista, COUNT(c.id_cancion) AS total_canciones
FROM Artistas ar
JOIN Albums al ON ar.id_artista = al.id_artista
JOIN Canciones c ON al.id_album = c.id_album
GROUP BY ar.id_artista;

SELECT * FROM Vista_CancionesPorAlbum;
SELECT * FROM Vista_ListasPorUsuario;
SELECT * FROM Vista_CancionesPorLista;
SELECT * FROM Vista_UsuariosArtistas;
SELECT * FROM Vista_CancionesPorArtista;
