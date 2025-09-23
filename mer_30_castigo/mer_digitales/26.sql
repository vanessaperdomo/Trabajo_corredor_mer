CREATE DATABASE IF NOT EXISTS ViajesMascotasApp;
USE ViajesMascotasApp;

DELIMITER //

CREATE PROCEDURE CrearTablaUsuarios()
BEGIN
    DROP TABLE IF EXISTS Usuarios;
    CREATE TABLE Usuarios (
        id_usuario INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100),
        email VARCHAR(100)
    );
    INSERT INTO Usuarios (nombre,email) VALUES
    ('Carlos','carlos@gmail.com'),
    ('Laura','laura@gmail.com'),
    ('Sebastian','sebastian@gmail.com'),
    ('Ana','ana@gmail.com'),
    ('Martin','martin@gmail.com'),
    ('Elena','elena@gmail.com'),
    ('Fernando','fernando@gmail.com'),
    ('Claudia','claudia@gmail.com'),
    ('Julian','julian@gmail.com'),
    ('Sofia','sofia@gmail.com');
END;
//

CREATE PROCEDURE CrearTablaMascotas()
BEGIN
    DROP TABLE IF EXISTS Mascotas;
    CREATE TABLE Mascotas (
        id_mascota INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100),
        tipo VARCHAR(50)
    );
    INSERT INTO Mascotas (nombre, tipo) VALUES
    ('Toby','Perro'),('Mia','Gato'),('Rocky','Perro'),
    ('Luna','Gato'),('Max','Perro'),('Nina','Gato'),
    ('Bobby','Perro'),('Sasha','Gato'),('Zeus','Perro'),
    ('Lola','Gato');
END;
//

CREATE PROCEDURE CrearTablaDestinos()
BEGIN
    DROP TABLE IF EXISTS Destinos;
    CREATE TABLE Destinos (
        id_destino INT AUTO_INCREMENT PRIMARY KEY,
        ciudad VARCHAR(100),
        pais VARCHAR(100)
    );
    INSERT INTO Destinos (ciudad, pais) VALUES
    ('Bogota','Colombia'),
    ('Medellin','Colombia'),
    ('Cartagena','Colombia'),
    ('Quito','Ecuador'),
    ('Lima','Peru'),
    ('Santiago','Chile'),
    ('Buenos Aires','Argentina'),
    ('Montevideo','Uruguay'),
    ('Ciudad de Mexico','Mexico'),
    ('San Jose','Costa Rica');
END;
//

CREATE PROCEDURE CrearTablaServicios()
BEGIN
    DROP TABLE IF EXISTS Servicios;
    CREATE TABLE Servicios (
        id_servicio INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100),
        tipo VARCHAR(50)
    );
    INSERT INTO Servicios (nombre, tipo) VALUES
    ('Hotel Canino','Alojamiento'),
    ('Veterinaria 24h','Salud'),
    ('Peluqueria Pet','Cuidado'),
    ('Guarderia Mascotas','Alojamiento'),
    ('Taxi Pet','Transporte'),
    ('Parque Pet','Recreacion'),
    ('Pet Shop','Compras'),
    ('Clinica Movil','Salud'),
    ('Adiestramiento','Educacion'),
    ('Spa Animal','Cuidado');
END;
//

CREATE PROCEDURE CrearTablaUsuariosMascotas()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Mascotas;
    CREATE TABLE Usuarios_Mascotas (
        id_usuario INT,
        id_mascota INT,
        PRIMARY KEY(id_usuario, id_mascota),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_mascota) REFERENCES Mascotas(id_mascota)
    );
    INSERT INTO Usuarios_Mascotas (id_usuario,id_mascota) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaServiciosDestinos()
BEGIN
    DROP TABLE IF EXISTS Servicios_Destinos;
    CREATE TABLE Servicios_Destinos (
        id_servicio INT,
        id_destino INT,
        PRIMARY KEY(id_servicio, id_destino),
        FOREIGN KEY (id_servicio) REFERENCES Servicios(id_servicio),
        FOREIGN KEY (id_destino) REFERENCES Destinos(id_destino)
    );
    INSERT INTO Servicios_Destinos (id_servicio, id_destino) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaReservas()
BEGIN
    DROP TABLE IF EXISTS Reservas;
    CREATE TABLE Reservas (
        id_reserva INT AUTO_INCREMENT PRIMARY KEY,
        id_usuario INT,
        id_destino INT
    );
    INSERT INTO Reservas (id_usuario, id_destino) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaMascotas();
CALL CrearTablaDestinos();
CALL CrearTablaServicios();
CALL CrearTablaUsuariosMascotas();
CALL CrearTablaServiciosDestinos();
CALL CrearTablaReservas();

CREATE OR REPLACE VIEW Vista_UsuariosConMascotas AS
SELECT u.nombre AS usuario, m.nombre AS mascota
FROM Usuarios u
JOIN Usuarios_Mascotas um ON u.id_usuario = um.id_usuario
JOIN Mascotas m ON um.id_mascota = m.id_mascota;

CREATE OR REPLACE VIEW Vista_ServiciosPorDestino AS
SELECT d.ciudad AS destino, COUNT(sd.id_servicio) AS total_servicios
FROM Destinos d
LEFT JOIN Servicios_Destinos sd ON d.id_destino = sd.id_destino
GROUP BY d.id_destino;

CREATE OR REPLACE VIEW Vista_ReservasPorUsuario AS
SELECT u.nombre AS usuario, COUNT(r.id_reserva) AS total_reservas
FROM Usuarios u
LEFT JOIN Reservas r ON u.id_usuario = r.id_usuario
GROUP BY u.id_usuario;

CREATE OR REPLACE VIEW Vista_ServiciosDisponibles AS
SELECT s.nombre AS servicio, s.tipo AS tipo
FROM Servicios s;

CREATE OR REPLACE VIEW Vista_DestinosConMascotas AS
SELECT u.nombre AS usuario, d.ciudad AS destino
FROM Reservas r
JOIN Usuarios u ON r.id_usuario = u.id_usuario
JOIN Destinos d ON r.id_destino = d.id_destino;

SELECT * FROM Vista_UsuariosConMascotas;
SELECT * FROM Vista_ServiciosPorDestino;
SELECT * FROM Vista_ReservasPorUsuario;
SELECT * FROM Vista_ServiciosDisponibles;
SELECT * FROM Vista_DestinosConMascotas;
