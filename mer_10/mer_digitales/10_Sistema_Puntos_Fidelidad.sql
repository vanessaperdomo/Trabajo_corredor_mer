CREATE DATABASE IF NOT EXISTS Sistema_Puntos_Fidelidad;
USE Sistema_Puntos_Fidelidad;

DELIMITER //

CREATE PROCEDURE CrearTablaClientes()
BEGIN
    DROP TABLE IF EXISTS Clientes;
    CREATE TABLE Clientes (
        id_cliente INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE,
        puntos INT DEFAULT 0
    );
    INSERT INTO Clientes (nombre,email,puntos) VALUES
    ('Ana Torres','ana@email.com',100),
    ('Juan Perez','juan@email.com',150),
    ('Maria Lopez','maria@email.com',200),
    ('Carlos Garcia','carlos@email.com',50),
    ('Laura Martinez','laura@email.com',300),
    ('Pedro Gomez','pedro@email.com',120),
    ('Sofia Hernandez','sofia@email.com',80),
    ('Miguel Torres','miguel@email.com',220),
    ('Elena Ruiz','elena@email.com',170),
    ('Kevin Culma','kevin@email.com',90);
END;
//

CREATE PROCEDURE CrearTablaProductos()
BEGIN
    DROP TABLE IF EXISTS Productos;
    CREATE TABLE Productos (
        id_producto INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        precio DECIMAL(10,2) NOT NULL,
        puntos_otorga INT NOT NULL
    );
    INSERT INTO Productos (nombre,precio,puntos_otorga) VALUES
    ('Café',5000,10),
    ('Pan',2000,5),
    ('Leche',3500,7),
    ('Queso',8000,15),
    ('Carne',20000,30),
    ('Arroz',4500,8),
    ('Azúcar',4000,6),
    ('Aceite',10000,20),
    ('Huevos',12000,12),
    ('Galletas',3000,5);
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

CREATE PROCEDURE CrearTablaAdministradores()
BEGIN
    DROP TABLE IF EXISTS Administradores;
    CREATE TABLE Administradores (
        id_admin INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL
    );
    INSERT INTO Administradores (nombre) VALUES
    ('Admin 1'),('Admin 2'),('Admin 3'),('Admin 4'),('Admin 5'),
    ('Admin 6'),('Admin 7'),('Admin 8'),('Admin 9'),('Admin 10');
END;
//

CREATE PROCEDURE CrearTablaClientesProductos()
BEGIN
    DROP TABLE IF EXISTS Clientes_Productos;
    CREATE TABLE Clientes_Productos (
        id_cliente INT NOT NULL,
        id_producto INT NOT NULL,
        fecha DATE NOT NULL,
        PRIMARY KEY(id_cliente,id_producto,fecha),
        FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
        FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
    );
    INSERT INTO Clientes_Productos (id_cliente,id_producto,fecha) VALUES
    (1,1,'2025-09-10'),(2,2,'2025-09-10'),(3,3,'2025-09-11'),
    (4,4,'2025-09-11'),(5,5,'2025-09-12'),(6,6,'2025-09-12'),
    (7,7,'2025-09-13'),(8,8,'2025-09-13'),(9,9,'2025-09-14'),
    (10,10,'2025-09-14');
END;
//

CREATE PROCEDURE CrearTablaPremios()
BEGIN
    DROP TABLE IF EXISTS Premios;
    CREATE TABLE Premios (
        id_premio INT AUTO_INCREMENT PRIMARY KEY,
        descripcion VARCHAR(100) NOT NULL,
        puntos_necesarios INT NOT NULL
    );
    INSERT INTO Premios (descripcion,puntos_necesarios) VALUES
    ('Descuento 5%',50),
    ('Descuento 10%',100),
    ('Descuento 15%',150),
    ('Producto gratis',200),
    ('Cupón especial',250),
    ('Descuento 20%',300),
    ('Regalo sorpresa',350),
    ('2x1 en productos',400),
    ('Bonificación extra',500),
    ('Premio VIP',1000);
END;
//

CREATE PROCEDURE CrearTablaClientesPremios()
BEGIN
    DROP TABLE IF EXISTS Clientes_Premios;
    CREATE TABLE Clientes_Premios (
        id_cliente INT NOT NULL,
        id_premio INT NOT NULL,
        fecha_canje DATE NOT NULL,
        PRIMARY KEY(id_cliente,id_premio,fecha_canje),
        FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
        FOREIGN KEY (id_premio) REFERENCES Premios(id_premio)
    );
    INSERT INTO Clientes_Premios (id_cliente,id_premio,fecha_canje) VALUES
    (1,1,'2025-09-15'),(2,2,'2025-09-15'),(3,3,'2025-09-16'),
    (4,4,'2025-09-16'),(5,5,'2025-09-17'),(6,6,'2025-09-17'),
    (7,7,'2025-09-18'),(8,8,'2025-09-18'),(9,9,'2025-09-19'),
    (10,10,'2025-09-19');
END;
//

DELIMITER ;

CALL CrearTablaClientes();
CALL CrearTablaProductos();
CALL CrearTablaEmpleados();
CALL CrearTablaAdministradores();
CALL CrearTablaClientesProductos();
CALL CrearTablaPremios();
CALL CrearTablaClientesPremios();

CREATE OR REPLACE VIEW Vista_ComprasClientes AS
SELECT c.nombre AS cliente, p.nombre AS producto, cp.fecha, p.puntos_otorga
FROM Clientes c
JOIN Clientes_Productos cp ON c.id_cliente = cp.id_cliente
JOIN Productos p ON cp.id_producto = p.id_producto;

CREATE OR REPLACE VIEW Vista_PuntosPorCliente AS
SELECT c.nombre AS cliente, SUM(p.puntos_otorga) AS puntos_acumulados
FROM Clientes c
JOIN Clientes_Productos cp ON c.id_cliente = cp.id_cliente
JOIN Productos p ON cp.id_producto = p.id_producto
GROUP BY c.id_cliente;

CREATE OR REPLACE VIEW Vista_CanjesClientes AS
SELECT c.nombre AS cliente, pr.descripcion AS premio, cp.fecha_canje
FROM Clientes c
JOIN Clientes_Premios cp ON c.id_cliente = cp.id_cliente
JOIN Premios pr ON cp.id_premio = pr.id_premio;

CREATE OR REPLACE VIEW Vista_AdministradoresClientes AS
SELECT ad.nombre AS administrador, c.nombre AS cliente
FROM Administradores ad
JOIN Clientes c ON ad.id_admin = c.id_cliente;

CREATE OR REPLACE VIEW Vista_ClientesConPremiosDisponibles AS
SELECT c.nombre AS cliente, c.puntos, pr.descripcion AS premio_disponible, pr.puntos_necesarios
FROM Clientes c
JOIN Premios pr ON c.puntos >= pr.puntos_necesarios
ORDER BY c.nombre, pr.puntos_necesarios;

SELECT * FROM Vista_ComprasClientes;
SELECT * FROM Vista_PuntosPorCliente;
SELECT * FROM Vista_CanjesClientes;
SELECT * FROM Vista_AdministradoresClientes;
SELECT * FROM Vista_ClientesConPremiosDisponibles;