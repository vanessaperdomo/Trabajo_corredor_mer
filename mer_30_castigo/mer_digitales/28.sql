CREATE DATABASE IF NOT EXISTS JuegosApp;
USE JuegosApp;

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
    ('Mario','mario@gmail.com'),
    ('Lucia','lucia@gmail.com'),
    ('Tomas','tomas@gmail.com'),
    ('Elisa','elisa@gmail.com'),
    ('Mateo','mateo@gmail.com'),
    ('Sara','sara@gmail.com'),
    ('Nicolas','nicolas@gmail.com'),
    ('Daniela','daniela@gmail.com'),
    ('Andres','andres@gmail.com'),
    ('Clara','clara@gmail.com');
END;
//

CREATE PROCEDURE CrearTablaJuegos()
BEGIN
    DROP TABLE IF EXISTS Juegos;
    CREATE TABLE Juegos (
        id_juego INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL UNIQUE
    );
    INSERT INTO Juegos (nombre) VALUES
    ('Galaxy Race'),('Zombie Run'),('Battle Arena'),
    ('Mystic Quest'),('Pixel War'),('Speed Drift'),
    ('Magic Duel'),('Sky Block'),('Ocean Wars'),('Dungeon');
END;
//

CREATE PROCEDURE CrearTablaModos()
BEGIN
    DROP TABLE IF EXISTS Modos;
    CREATE TABLE Modos (
        id_modo INT AUTO_INCREMENT PRIMARY KEY,
        tipo VARCHAR(50) NOT NULL UNIQUE
    );
    INSERT INTO Modos (tipo) VALUES
    ('Individual'),('Multijugador'),('Cooperativo'),('Ranked'),('Arcade'),
    ('Campana'),('Survival'),('Versus'),('Libre'),('Competitivo');
END;
//

CREATE PROCEDURE CrearTablaPartidas()
BEGIN
    DROP TABLE IF EXISTS Partidas;
    CREATE TABLE Partidas (
        id_partida INT AUTO_INCREMENT PRIMARY KEY,
        id_juego INT,
        duracion INT,
        FOREIGN KEY (id_juego) REFERENCES Juegos(id_juego)
    );
    INSERT INTO Partidas (id_juego,duracion) VALUES
    (1,20),(2,15),(3,30),(4,40),(5,25),
    (6,18),(7,22),(8,35),(9,28),(10,32);
END;
//

CREATE PROCEDURE CrearTablaRanking()
BEGIN
    DROP TABLE IF EXISTS Ranking;
    CREATE TABLE Ranking (
        id_ranking INT AUTO_INCREMENT PRIMARY KEY,
        id_juego INT,
        posicion INT,
        FOREIGN KEY (id_juego) REFERENCES Juegos(id_juego)
    );
    INSERT INTO Ranking (id_juego,posicion) VALUES
    (1,1),(2,3),(3,2),(4,5),(5,4),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaUsuariosJuegos()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Juegos;
    CREATE TABLE Usuarios_Juegos (
        id_usuario INT,
        id_juego INT,
        PRIMARY KEY(id_usuario,id_juego),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_juego) REFERENCES Juegos(id_juego)
    );
    INSERT INTO Usuarios_Juegos (id_usuario,id_juego) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaPartidasModos()
BEGIN
    DROP TABLE IF EXISTS Partidas_Modos;
    CREATE TABLE Partidas_Modos (
        id_partida INT,
        id_modo INT,
        PRIMARY KEY(id_partida,id_modo),
        FOREIGN KEY (id_partida) REFERENCES Partidas(id_partida),
        FOREIGN KEY (id_modo) REFERENCES Modos(id_modo)
    );
    INSERT INTO Partidas_Modos (id_partida,id_modo) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaJuegos();
CALL CrearTablaModos();
CALL CrearTablaPartidas();
CALL CrearTablaRanking();
CALL CrearTablaUsuariosJuegos();
CALL CrearTablaPartidasModos();

CREATE OR REPLACE VIEW Vista_UsuariosPorJuego AS
SELECT u.nombre AS usuario, j.nombre AS juego
FROM Usuarios u
JOIN Usuarios_Juegos uj ON u.id_usuario = uj.id_usuario
JOIN Juegos j ON uj.id_juego = j.id_juego;

CREATE OR REPLACE VIEW Vista_PartidasPorJuego AS
SELECT j.nombre AS juego, p.duracion
FROM Juegos j
JOIN Partidas p ON j.id_juego = p.id_juego;

CREATE OR REPLACE VIEW Vista_ModosPorPartida AS
SELECT p.id_partida, m.tipo AS modo
FROM Partidas p
JOIN Partidas_Modos pm ON p.id_partida = pm.id_partida
JOIN Modos m ON pm.id_modo = m.id_modo;

CREATE OR REPLACE VIEW Vista_RankingJuegos AS
SELECT j.nombre AS juego, r.posicion
FROM Ranking r
JOIN Juegos j ON r.id_juego = j.id_juego;

CREATE OR REPLACE VIEW Vista_UsuariosConRanking AS
SELECT u.nombre AS usuario, r.posicion
FROM Usuarios u
JOIN Usuarios_Juegos uj ON u.id_usuario = uj.id_usuario
JOIN Ranking r ON uj.id_juego = r.id_juego;

SELECT * FROM Vista_UsuariosPorJuego;
SELECT * FROM Vista_PartidasPorJuego;
SELECT * FROM Vista_ModosPorPartida;
SELECT * FROM Vista_RankingJuegos;
SELECT * FROM Vista_UsuariosConRanking;