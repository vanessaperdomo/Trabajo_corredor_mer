CREATE DATABASE IF NOT EXISTS Sistema_Identificacion_Biometrica;
USE Sistema_Identificacion_Biometrica;

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
    ('Ana Torres','ana@email.com'),
    ('Juan Perez','juan@email.com'),
    ('Maria Lopez','maria@email.com'),
    ('Carlos Garcia','carlos@email.com'),
    ('Laura Martinez','laura@email.com'),
    ('Pedro Gomez','pedro@email.com'),
    ('Sofia Hernandez','sofia@email.com'),
    ('Miguel Torres','miguel@email.com'),
    ('Elena Ruiz','elena@email.com'),
    ('Kevin Culma','kevin@email.com');
END;
//

CREATE PROCEDURE CrearTablaBiometrias()
BEGIN
    DROP TABLE IF EXISTS Biometrias;
    CREATE TABLE Biometrias (
        id_biometria INT AUTO_INCREMENT PRIMARY KEY,
        tipo VARCHAR(50) NOT NULL,
        descripcion VARCHAR(200)
    );
    INSERT INTO Biometrias (tipo,descripcion) VALUES
    ('Huella','Huella digital del usuario'),
    ('Rostro','Reconocimiento facial'),
    ('Iris','Reconocimiento de iris'),
    ('Voz','Reconocimiento de voz'),
    ('Firma','Firma digital'),
    ('Huella','Huella digital adicional'),
    ('Rostro','Rostro alternativo'),
    ('Iris','Iris alternativo'),
    ('Voz','Voz alternativa'),
    ('Firma','Firma secundaria');
END;
//

CREATE PROCEDURE CrearTablaDispositivos()
BEGIN
    DROP TABLE IF EXISTS Dispositivos;
    CREATE TABLE Dispositivos (
        id_dispositivo INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        ubicacion VARCHAR(100) NOT NULL
    );
    INSERT INTO Dispositivos (nombre,ubicacion) VALUES
    ('Sensor 1','Entrada principal'),
    ('Sensor 2','Entrada lateral'),
    ('Sensor 3','Oficina 1'),
    ('Sensor 4','Oficina 2'),
    ('Sensor 5','Recepcion'),
    ('Sensor 6','Sala de juntas'),
    ('Sensor 7','Almacen'),
    ('Sensor 8','Cafeteria'),
    ('Sensor 9','Laboratorio'),
    ('Sensor 10','Estacionamiento');
END;
//

CREATE PROCEDURE CrearTablaSesiones()
BEGIN
    DROP TABLE IF EXISTS Sesiones;
    CREATE TABLE Sesiones (
        id_sesion INT AUTO_INCREMENT PRIMARY KEY,
        fecha_inicio DATETIME NOT NULL,
        fecha_fin DATETIME NOT NULL
    );
    INSERT INTO Sesiones (fecha_inicio,fecha_fin) VALUES
    ('2025-09-01 08:00:00','2025-09-01 08:10:00'),
    ('2025-09-01 09:00:00','2025-09-01 09:15:00'),
    ('2025-09-01 10:00:00','2025-09-01 10:05:00'),
    ('2025-09-01 11:00:00','2025-09-01 11:20:00'),
    ('2025-09-01 12:00:00','2025-09-01 12:10:00'),
    ('2025-09-01 13:00:00','2025-09-01 13:25:00'),
    ('2025-09-01 14:00:00','2025-09-01 14:15:00'),
    ('2025-09-01 15:00:00','2025-09-01 15:10:00'),
    ('2025-09-01 16:00:00','2025-09-01 16:20:00'),
    ('2025-09-01 17:00:00','2025-09-01 17:15:00');
END;
//

CREATE PROCEDURE CrearTablaAdministradores()
BEGIN
    DROP TABLE IF EXISTS Administradores;
    CREATE TABLE Administradores (
        id_admin INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL
    );
    INSERT INTO Administradores (nombre) VALUES
    ('Luis Perez'),('Carla Gomez'),('Santiago Torres'),('Laura Diaz'),('Miguel Angel'),
    ('Elena Ruiz'),('Pedro Martinez'),('Sofia Hernandez'),('Kevin Culma'),('Ana Lopez');
END;
//

CREATE PROCEDURE CrearTablaUsuariosBiometrias()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Biometrias;
    CREATE TABLE Usuarios_Biometrias (
        id_usuario INT NOT NULL,
        id_biometria INT NOT NULL,
        PRIMARY KEY(id_usuario,id_biometria),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_biometria) REFERENCES Biometrias(id_biometria)
    );
    INSERT INTO Usuarios_Biometrias (id_usuario,id_biometria) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaDispositivosSesiones()
BEGIN
    DROP TABLE IF EXISTS Dispositivos_Sesiones;
    CREATE TABLE Dispositivos_Sesiones (
        id_dispositivo INT NOT NULL,
        id_sesion INT NOT NULL,
        PRIMARY KEY(id_dispositivo,id_sesion),
        FOREIGN KEY (id_dispositivo) REFERENCES Dispositivos(id_dispositivo),
        FOREIGN KEY (id_sesion) REFERENCES Sesiones(id_sesion)
    );
    INSERT INTO Dispositivos_Sesiones (id_dispositivo,id_sesion) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaBiometrias();
CALL CrearTablaDispositivos();
CALL CrearTablaSesiones();
CALL CrearTablaAdministradores();
CALL CrearTablaUsuariosBiometrias();
CALL CrearTablaDispositivosSesiones();

CREATE VIEW Vista_BiometriasPorUsuario AS
SELECT u.nombre AS usuario, b.tipo, b.descripcion
FROM Usuarios u
JOIN Usuarios_Biometrias ub ON u.id_usuario = ub.id_usuario
JOIN Biometrias b ON ub.id_biometria = b.id_biometria;

CREATE VIEW Vista_SesionesPorDispositivo AS
SELECT d.nombre AS dispositivo, s.fecha_inicio, s.fecha_fin
FROM Dispositivos d
JOIN Dispositivos_Sesiones ds ON d.id_dispositivo = ds.id_dispositivo
JOIN Sesiones s ON ds.id_sesion = s.id_sesion;

CREATE VIEW Vista_UsuariosConBiometrias AS
SELECT u.nombre AS usuario, b.tipo AS biometria
FROM Usuarios u
JOIN Usuarios_Biometrias ub ON u.id_usuario = ub.id_usuario
JOIN Biometrias b ON ub.id_biometria = b.id_biometria;

CREATE VIEW Vista_TotalSesionesPorDispositivo AS
SELECT d.nombre AS dispositivo, COUNT(ds.id_sesion) AS total_sesiones
FROM Dispositivos d
JOIN Dispositivos_Sesiones ds ON d.id_dispositivo = ds.id_dispositivo
GROUP BY d.id_dispositivo;

CREATE VIEW Vista_AdministradoresUsuarios AS
SELECT a.nombre AS administrador, u.nombre AS usuario
FROM Administradores a
JOIN Usuarios u ON a.id_admin = u.id_usuario;

SELECT * FROM Vista_BiometriasPorUsuario;
SELECT * FROM Vista_SesionesPorDispositivo;
SELECT * FROM Vista_UsuariosConBiometrias;
SELECT * FROM Vista_TotalSesionesPorDispositivo;
SELECT * FROM Vista_AdministradoresUsuarios;
