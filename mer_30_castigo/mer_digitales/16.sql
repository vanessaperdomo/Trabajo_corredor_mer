CREATE DATABASE IF NOT EXISTS ReservasHoteles;
USE ReservasHoteles;

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
    ('Martin','martin@gmail.com'),
    ('Paula','paula@gmail.com'),
    ('Sebastian','sebastian@gmail.com'),
    ('Angela','angela@gmail.com'),
    ('Cristian','cristian@gmail.com'),
    ('Mariana','mariana@gmail.com'),
    ('Fernando','fernando@gmail.com'),
    ('Natalia','natalia@gmail.com'),
    ('Adrian','adrian@gmail.com'),
    ('Carolina','carolina@g*mail.com');
END;
//

CREATE PROCEDURE CrearTablaHoteles()
BEGIN
    DROP TABLE IF EXISTS Hoteles;
    CREATE TABLE Hoteles (
        id_hotel INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL UNIQUE
    );
    INSERT INTO Hoteles (nombre) VALUES
    ('Hotel Sol'),('Hotel Luna'),('Hotel Mar'),('Hotel Cielo'),('Hotel Estrella'),
    ('Hotel Arena'),('Hotel Lago'),('Hotel Bosque'),('Hotel Nube'),('Hotel Rio');
END;
//

CREATE PROCEDURE CrearTablaHabitaciones()
BEGIN
    DROP TABLE IF EXISTS Habitaciones;
    CREATE TABLE Habitaciones (
        id_habitacion INT AUTO_INCREMENT PRIMARY KEY,
        id_hotel INT NOT NULL,
        tipo VARCHAR(50) NOT NULL,
        FOREIGN KEY (id_hotel) REFERENCES Hoteles(id_hotel)
    );
    INSERT INTO Habitaciones (id_hotel,tipo) VALUES
    (1,'Sencilla'),(2,'Doble'),(3,'Suite'),(4,'Sencilla'),(5,'Doble'),
    (6,'Suite'),(7,'Sencilla'),(8,'Doble'),(9,'Suite'),(10,'Sencilla');
END;
//

CREATE PROCEDURE CrearTablaReservas()
BEGIN
    DROP TABLE IF EXISTS Reservas;
    CREATE TABLE Reservas (
        id_reserva INT AUTO_INCREMENT PRIMARY KEY,
        id_usuario INT NOT NULL,
        id_habitacion INT NOT NULL,
        fecha_reserva DATETIME NOT NULL,
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_habitacion) REFERENCES Habitaciones(id_habitacion)
    );
    INSERT INTO Reservas (id_usuario,id_habitacion,fecha_reserva) VALUES
    (1,1,'2025-09-20 10:00'),
    (2,2,'2025-09-16 17:00'),
    (3,3,'2025-09-18 09:00'),
    (4,4,'2025-09-17 15:00'),
    (5,5,'2025-09-16 19:00'),
    (6,6,'2025-09-21 12:00'),
    (7,7,'2025-09-16 20:00'),
    (8,8,'2025-09-22 18:00'),
    (9,9,'2025-09-19 16:00'),
    (10,10,'2025-09-23 14:00');
END;
//

CREATE PROCEDURE CrearTablaServicios()
BEGIN
    DROP TABLE IF EXISTS Servicios;
    CREATE TABLE Servicios (
        id_servicio INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL UNIQUE
    );
    INSERT INTO Servicios (nombre) VALUES
    ('Piscina'),('Gimnasio'),('Spa'),('Restaurante'),('Bar'),
    ('WiFi'),('Transporte'),('Lavanderia'),('Estacionamiento'),('Desayuno');
END;
//

CREATE PROCEDURE CrearTablaHotelesServicios()
BEGIN
    DROP TABLE IF EXISTS Hoteles_Servicios;
    CREATE TABLE Hoteles_Servicios (
        id_hotel INT NOT NULL,
        id_servicio INT NOT NULL,
        PRIMARY KEY(id_hotel,id_servicio),
        FOREIGN KEY (id_hotel) REFERENCES Hoteles(id_hotel),
        FOREIGN KEY (id_servicio) REFERENCES Servicios(id_servicio)
    );
    INSERT INTO Hoteles_Servicios (id_hotel,id_servicio) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaUsuariosReservas()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Reservas;
    CREATE TABLE Usuarios_Reservas (
        id_usuario INT NOT NULL,
        id_reserva INT NOT NULL,
        PRIMARY KEY(id_usuario,id_reserva),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_reserva) REFERENCES Reservas(id_reserva)
    );
    INSERT INTO Usuarios_Reservas (id_usuario,id_reserva) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaHoteles();
CALL CrearTablaHabitaciones();
CALL CrearTablaReservas();
CALL CrearTablaServicios();
CALL CrearTablaHotelesServicios();
CALL CrearTablaUsuariosReservas();

CREATE OR REPLACE VIEW Vista_ReservasPorUsuario AS
SELECT u.nombre AS usuario, r.fecha_reserva
FROM Reservas r
JOIN Usuarios u ON u.id_usuario = r.id_usuario;

CREATE OR REPLACE VIEW Vista_HotelesConServicios AS
SELECT h.nombre AS hotel, s.nombre AS servicio
FROM Hoteles h
JOIN Hoteles_Servicios hs ON h.id_hotel = hs.id_hotel
JOIN Servicios s ON hs.id_servicio = s.id_servicio;

CREATE OR REPLACE VIEW Vista_TotalReservasPorUsuario AS
SELECT u.nombre AS usuario, COUNT(r.id_reserva) AS total_reservas
FROM Usuarios u
LEFT JOIN Reservas r ON u.id_usuario = r.id_usuario
GROUP BY u.id_usuario;

CREATE OR REPLACE VIEW Vista_PrecioPromedioPorHotel AS
SELECT h.nombre AS hotel, AVG(hab.precio) AS precio_promedio
FROM Hoteles h
LEFT JOIN Habitaciones hab ON h.id_hotel = hab.id_hotel
GROUP BY h.id_hotel;

CREATE OR REPLACE VIEW Vista_UsuariosSinReservas AS
SELECT u.id_usuario, u.nombre, u.email
FROM Usuarios u
LEFT JOIN Reservas r ON u.id_usuario = r.id_usuario
WHERE r.id_reserva IS NULL;

SELECT * FROM Vista_ReservasPorUsuario;
SELECT * FROM Vista_HotelesConServicios;
SELECT * FROM Vista_TotalReservasPorUsuario;
SELECT * FROM Vista_PrecioPromedioPorHotel;
SELECT * FROM Vista_UsuariosSinReservas;
