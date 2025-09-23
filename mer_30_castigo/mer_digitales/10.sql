CREATE DATABASE IF NOT EXISTS AplicacionTransporte;
USE AplicacionTransporte;

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
    ('Miguel','miguel@gmail.com'),
    ('Felipe','felipe@gmail.com'),
    ('Valentina','valentina@gmail.com'),
    ('Camila','camila@gmail.com'),
    ('Andres','andres@gmail.com'),
    ('Valeria','valeria@gmail.com'),
    ('Jorge','jorge@gmail.com'),
    ('Natalia','natalia@gmail.com'),
    ('Ricardo','ricardo@gmail.com'),
    ('Monica','monica@gmail.com');
END;
//

CREATE PROCEDURE CrearTablaConductores()
BEGIN
    DROP TABLE IF EXISTS Conductores;
    CREATE TABLE Conductores (
        id_conductor INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        licencia VARCHAR(50) NOT NULL UNIQUE
    );
    INSERT INTO Conductores (nombre,licencia) VALUES
    ('Oscar','LIC001'),
    ('Daniela','LIC002'),
    ('Fernando','LIC003'),
    ('Lucia','LIC004'),
    ('Martin','LIC005'),
    ('Sara','LIC006'),
    ('Pablo','LIC007'),
    ('Carolina','LIC008'),
    ('Ivan','LIC009'),
    ('Andrea','LIC010');
END;
//

CREATE PROCEDURE CrearTablaVehiculos()
BEGIN
    DROP TABLE IF EXISTS Vehiculos;
    CREATE TABLE Vehiculos (
        id_vehiculo INT AUTO_INCREMENT PRIMARY KEY,
        tipo VARCHAR(50) NOT NULL,
        placa VARCHAR(50) NOT NULL UNIQUE
    );
    INSERT INTO Vehiculos (tipo,placa) VALUES
    ('Taxi','TXA100'),
    ('Moto','MOT200'),
    ('Bicicleta','BIC300'),
    ('Taxi','TXA101'),
    ('Moto','MOT201'),
    ('Bicicleta','BIC301'),
    ('Taxi','TXA102'),
    ('Moto','MOT202'),
    ('Bicicleta','BIC302'),
    ('Taxi','TXA103');
END;
//

CREATE PROCEDURE CrearTablaServicios()
BEGIN
    DROP TABLE IF EXISTS Servicios;
    CREATE TABLE Servicios (
        id_servicio INT AUTO_INCREMENT PRIMARY KEY,
        id_usuario INT NOT NULL,
        id_conductor INT NOT NULL,
        id_vehiculo INT NOT NULL,
        fecha_servicio DATETIME NOT NULL,
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_conductor) REFERENCES Conductores(id_conductor),
        FOREIGN KEY (id_vehiculo) REFERENCES Vehiculos(id_vehiculo)
    );
    INSERT INTO Servicios (id_usuario,id_conductor,id_vehiculo,fecha_servicio) VALUES
    (1,1,1,'2025-09-20 10:00'),
    (2,2,2,'2025-09-20 11:00'),
    (3,3,3,'2025-09-21 12:00'),
    (4,4,4,'2025-09-21 13:00'),
    (5,5,5,'2025-09-22 14:00'),
    (6,6,6,'2025-09-22 15:00'),
    (7,7,7,'2025-09-23 16:00'),
    (8,8,8,'2025-09-23 17:00'),
    (9,9,9,'2025-09-24 18:00'),
    (10,10,10,'2025-09-24 19:00');
END;
//

CREATE PROCEDURE CrearTablaPagos()
BEGIN
    DROP TABLE IF EXISTS Pagos;
    CREATE TABLE Pagos (
        id_pago INT AUTO_INCREMENT PRIMARY KEY,
        id_servicio INT NOT NULL,
        monto DECIMAL(10,2) NOT NULL,
        metodo VARCHAR(50) NOT NULL,
        FOREIGN KEY (id_servicio) REFERENCES Servicios(id_servicio)
    );
    INSERT INTO Pagos (id_servicio,monto,metodo) VALUES
    (1,15000,'Efectivo'),
    (2,12000,'Tarjeta'),
    (3,8000,'Efectivo'),
    (4,20000,'Tarjeta'),
    (5,18000,'Efectivo'),
    (6,10000,'Tarjeta'),
    (7,14000,'Efectivo'),
    (8,9000,'Tarjeta'),
    (9,22000,'Efectivo'),
    (10,16000,'Tarjeta');
END;
//

CREATE PROCEDURE CrearTablaUsuariosConductores()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Conductores;
    CREATE TABLE Usuarios_Conductores (
        id_usuario INT NOT NULL,
        id_conductor INT NOT NULL,
        PRIMARY KEY(id_usuario,id_conductor),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_conductor) REFERENCES Conductores(id_conductor)
    );
    INSERT INTO Usuarios_Conductores (id_usuario,id_conductor) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaConductoresVehiculos()
BEGIN
    DROP TABLE IF EXISTS Conductores_Vehiculos;
    CREATE TABLE Conductores_Vehiculos (
        id_conductor INT NOT NULL,
        id_vehiculo INT NOT NULL,
        PRIMARY KEY(id_conductor,id_vehiculo),
        FOREIGN KEY (id_conductor) REFERENCES Conductores(id_conductor),
        FOREIGN KEY (id_vehiculo) REFERENCES Vehiculos(id_vehiculo)
    );
    INSERT INTO Conductores_Vehiculos (id_conductor,id_vehiculo) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaConductores();
CALL CrearTablaVehiculos();
CALL CrearTablaServicios();
CALL CrearTablaPagos();
CALL CrearTablaUsuariosConductores();
CALL CrearTablaConductoresVehiculos();

CREATE OR REPLACE VIEW Vista_ServiciosPorUsuario AS
SELECT u.nombre AS usuario, s.id_servicio, s.fecha_servicio
FROM Servicios s
JOIN Usuarios u ON s.id_usuario = u.id_usuario;

CREATE OR REPLACE VIEW Vista_ServiciosPorConductor AS
SELECT c.nombre AS conductor, COUNT(s.id_servicio) AS total_servicios
FROM Conductores c
LEFT JOIN Servicios s ON c.id_conductor = s.id_conductor
GROUP BY c.id_conductor;

CREATE OR REPLACE VIEW Vista_PagosPorMetodo AS
SELECT metodo, SUM(monto) AS total_monto
FROM Pagos
GROUP BY metodo;

CREATE OR REPLACE VIEW Vista_UsuariosConConductores AS
SELECT u.nombre AS usuario, c.nombre AS conductor
FROM Usuarios u
JOIN Usuarios_Conductores uc ON u.id_usuario = uc.id_usuario
JOIN Conductores c ON uc.id_conductor = c.id_conductor;

CREATE OR REPLACE VIEW Vista_ConductoresConVehiculos AS
SELECT c.nombre AS conductor, v.tipo AS tipo_vehiculo, v.placa
FROM Conductores c
JOIN Conductores_Vehiculos cv ON c.id_conductor = cv.id_conductor
JOIN Vehiculos v ON cv.id_vehiculo = v.id_vehiculo;

SELECT * FROM Vista_ServiciosPorUsuario;
SELECT * FROM Vista_ServiciosPorConductor;
SELECT * FROM Vista_PagosPorMetodo;
SELECT * FROM Vista_UsuariosConConductores;
SELECT * FROM Vista_ConductoresConVehiculos;
