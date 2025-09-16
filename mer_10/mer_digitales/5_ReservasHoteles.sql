CREATE DATABASE IF NOT EXISTS ReservasHoteles;
USE ReservasHoteles;

DELIMITER //

CREATE PROCEDURE CrearTablaClientes()
BEGIN
    DROP TABLE IF EXISTS Clientes;
    CREATE TABLE Clientes (
        id_cliente INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE
    );
    INSERT INTO Clientes (nombre,email) VALUES
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

CREATE PROCEDURE CrearTablaHoteles()
BEGIN
    DROP TABLE IF EXISTS Hoteles;
    CREATE TABLE Hoteles (
        id_hotel INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        ciudad VARCHAR(100) NOT NULL
    );
    INSERT INTO Hoteles (nombre,ciudad) VALUES
    ('Hotel Sol','Bogota'),
    ('Hotel Luna','Medellin'),
    ('Hotel Estrella','Cali'),
    ('Hotel Mar','Cartagena'),
    ('Hotel Nube','Barranquilla'),
    ('Hotel Rio','Bucaramanga'),
    ('Hotel Cielo','Pereira'),
    ('Hotel Costa','Santa Marta'),
    ('Hotel Andes','Manizales'),
    ('Hotel Verde','Villavicencio');
END;
//

CREATE PROCEDURE CrearTablaHabitaciones()
BEGIN
    DROP TABLE IF EXISTS Habitaciones;
    CREATE TABLE Habitaciones (
        id_habitacion INT AUTO_INCREMENT PRIMARY KEY,
        id_hotel INT NOT NULL,
        tipo VARCHAR(50) NOT NULL,
        precio DECIMAL(10,2) NOT NULL,
        FOREIGN KEY (id_hotel) REFERENCES Hoteles(id_hotel)
    );
    INSERT INTO Habitaciones (id_hotel,tipo,precio) VALUES
    (1,'Sencilla',100),(1,'Doble',150),(2,'Sencilla',90),(2,'Doble',140),(3,'Sencilla',80),
    (3,'Doble',130),(4,'Sencilla',120),(4,'Doble',170),(5,'Sencilla',110),(5,'Doble',160);
END;
//

CREATE PROCEDURE CrearTablaReservas()
BEGIN
    DROP TABLE IF EXISTS Reservas;
    CREATE TABLE Reservas (
        id_reserva INT AUTO_INCREMENT PRIMARY KEY,
        fecha_inicio DATE NOT NULL,
        fecha_fin DATE NOT NULL
    );
    INSERT INTO Reservas (fecha_inicio,fecha_fin) VALUES
    ('2025-09-01','2025-09-03'),
    ('2025-09-02','2025-09-05'),
    ('2025-09-03','2025-09-04'),
    ('2025-09-04','2025-09-07'),
    ('2025-09-05','2025-09-08'),
    ('2025-09-06','2025-09-09'),
    ('2025-09-07','2025-09-10'),
    ('2025-09-08','2025-09-11'),
    ('2025-09-09','2025-09-12'),
    ('2025-09-10','2025-09-13');
END;
//

CREATE PROCEDURE CrearTablaEmpleados()
BEGIN
    DROP TABLE IF EXISTS Empleados;
    CREATE TABLE Empleados (
        id_empleado INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL
    );
    INSERT INTO Empleados (nombre) VALUES
    ('Luis Perez'),('Carla Gomez'),('Santiago Torres'),('Laura Diaz'),('Miguel Angel'),
    ('Elena Ruiz'),('Pedro Martinez'),('Sofia Hernandez'),('Kevin Culma'),('Ana Lopez');
END;
//

CREATE PROCEDURE CrearTablaClientesReservas()
BEGIN
    DROP TABLE IF EXISTS Clientes_Reservas;
    CREATE TABLE Clientes_Reservas (
        id_cliente INT NOT NULL,
        id_reserva INT NOT NULL,
        PRIMARY KEY(id_cliente,id_reserva),
        FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
        FOREIGN KEY (id_reserva) REFERENCES Reservas(id_reserva)
    );
    INSERT INTO Clientes_Reservas (id_cliente,id_reserva) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaEmpleadosHoteles()
BEGIN
    DROP TABLE IF EXISTS Empleados_Hoteles;
    CREATE TABLE Empleados_Hoteles (
        id_empleado INT NOT NULL,
        id_hotel INT NOT NULL,
        PRIMARY KEY(id_empleado,id_hotel),
        FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado),
        FOREIGN KEY (id_hotel) REFERENCES Hoteles(id_hotel)
    );
    INSERT INTO Empleados_Hoteles (id_empleado,id_hotel) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaClientes();
CALL CrearTablaHoteles();
CALL CrearTablaHabitaciones();
CALL CrearTablaReservas();
CALL CrearTablaEmpleados();
CALL CrearTablaClientesReservas();
CALL CrearTablaEmpleadosHoteles();

CREATE VIEW Vista_ReservasPorCliente AS
SELECT c.nombre AS cliente, r.fecha_inicio, r.fecha_fin
FROM Clientes c
JOIN Clientes_Reservas cr ON c.id_cliente = cr.id_cliente
JOIN Reservas r ON cr.id_reserva = r.id_reserva;

CREATE VIEW Vista_HabitacionesPorHotel AS
SELECT h.nombre AS hotel, ha.tipo, ha.precio
FROM Hoteles h
JOIN Habitaciones ha ON h.id_hotel = ha.id_hotel;

CREATE VIEW Vista_EmpleadosPorHotel AS
SELECT e.nombre AS empleado, h.nombre AS hotel
FROM Empleados e
JOIN Empleados_Hoteles eh ON e.id_empleado = eh.id_empleado
JOIN Hoteles h ON eh.id_hotel = h.id_hotel;

CREATE VIEW Vista_TotalReservasPorHotel AS
SELECT h.nombre AS hotel, COUNT(cr.id_reserva) AS total_reservas
FROM Hoteles h
JOIN Habitaciones ha ON h.id_hotel = ha.id_hotel
JOIN Clientes_Reservas cr ON cr.id_reserva IN (SELECT r.id_reserva FROM Reservas r)
GROUP BY h.id_hotel;

CREATE VIEW Vista_PrecioTotalHabitaciones AS
SELECT h.nombre AS hotel, SUM(ha.precio) AS total_precio
FROM Hoteles h
JOIN Habitaciones ha ON h.id_hotel = ha.id_hotel
GROUP BY h.id_hotel;

SELECT * FROM Vista_ReservasPorCliente;
SELECT * FROM Vista_HabitacionesPorHotel;
SELECT * FROM Vista_EmpleadosPorHotel;
SELECT * FROM Vista_TotalReservasPorHotel;
SELECT * FROM Vista_PrecioTotalHabitaciones;
