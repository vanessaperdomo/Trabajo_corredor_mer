CREATE DATABASE IF NOT EXISTS GestionProduccion;
USE GestionProduccion;

DELIMITER //

CREATE PROCEDURE CrearTablaEmpleados()
BEGIN
    DROP TABLE IF EXISTS Empleados;
    CREATE TABLE Empleados (
        id_empleado INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE
    );
    INSERT INTO Empleados (nombre,email) VALUES
    ('Carlos','carlos@gmail.com'),
    ('Maria','maria@gmail.com'),
    ('Luis','luis@gmail.com'),
    ('Andrea','andrea@gmail.com'),
    ('Pedro','pedro@gmail.com'),
    ('Sofia','sofia@gmail.com'),
    ('Jorge','jorge@gmail.com'),
    ('Camila','camila@gmail.com'),
    ('Daniel','daniel@gmail.com'),
    ('Laura','laura@gmail.com');
END;
//

CREATE PROCEDURE CrearTablaLineasProduccion()
BEGIN
    DROP TABLE IF EXISTS LineasProduccion;
    CREATE TABLE LineasProduccion (
        id_linea INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL UNIQUE
    );
    INSERT INTO LineasProduccion (nombre) VALUES
    ('Linea A'),('Linea B'),('Linea C'),('Linea D'),('Linea E'),
    ('Linea F'),('Linea G'),('Linea H'),('Linea I'),('Linea J');
END;
//

CREATE PROCEDURE CrearTablaMaquinas()
BEGIN
    DROP TABLE IF EXISTS Maquinas;
    CREATE TABLE Maquinas (
        id_maquina INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL UNIQUE
    );
    INSERT INTO Maquinas (nombre) VALUES
    ('Maquina 1'),('Maquina 2'),('Maquina 3'),('Maquina 4'),('Maquina 5'),
    ('Maquina 6'),('Maquina 7'),('Maquina 8'),('Maquina 9'),('Maquina 10');
END;
//

CREATE PROCEDURE CrearTablaProductos()
BEGIN
    DROP TABLE IF EXISTS Productos;
    CREATE TABLE Productos (
        id_producto INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL UNIQUE,
        descripcion VARCHAR(200)
    );
    INSERT INTO Productos (nombre,descripcion) VALUES
    ('Producto A','Descripcion A'),
    ('Producto B','Descripcion B'),
    ('Producto C','Descripcion C'),
    ('Producto D','Descripcion D'),
    ('Producto E','Descripcion E'),
    ('Producto F','Descripcion F'),
    ('Producto G','Descripcion G'),
    ('Producto H','Descripcion H'),
    ('Producto I','Descripcion I'),
    ('Producto J','Descripcion J');
END;
//

CREATE PROCEDURE CrearTablaOrdenesProduccion()
BEGIN
    DROP TABLE IF EXISTS OrdenesProduccion;
    CREATE TABLE OrdenesProduccion (
        id_orden INT AUTO_INCREMENT PRIMARY KEY,
        fecha_inicio DATETIME NOT NULL,
        fecha_fin DATETIME NOT NULL
    );
    INSERT INTO OrdenesProduccion (fecha_inicio,fecha_fin) VALUES
    ('2025-09-20 08:00','2025-09-20 16:00'),
    ('2025-09-21 08:00','2025-09-21 16:00'),
    ('2025-09-22 08:00','2025-09-22 16:00'),
    ('2025-09-23 08:00','2025-09-23 16:00'),
    ('2025-09-24 08:00','2025-09-24 16:00'),
    ('2025-09-25 08:00','2025-09-25 16:00'),
    ('2025-09-26 08:00','2025-09-26 16:00'),
    ('2025-09-27 08:00','2025-09-27 16:00'),
    ('2025-09-28 08:00','2025-09-28 16:00'),
    ('2025-09-29 08:00','2025-09-29 16:00');
END;
//

CREATE PROCEDURE CrearTablaEmpleadosLineas()
BEGIN
    DROP TABLE IF EXISTS Empleados_Lineas;
    CREATE TABLE Empleados_Lineas (
        id_empleado INT NOT NULL,
        id_linea INT NOT NULL,
        PRIMARY KEY(id_empleado,id_linea),
        FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado),
        FOREIGN KEY (id_linea) REFERENCES LineasProduccion(id_linea)
    );
    INSERT INTO Empleados_Lineas (id_empleado,id_linea) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaOrdenesProductos()
BEGIN
    DROP TABLE IF EXISTS Ordenes_Productos;
    CREATE TABLE Ordenes_Productos (
        id_orden INT NOT NULL,
        id_producto INT NOT NULL,
        PRIMARY KEY(id_orden,id_producto),
        FOREIGN KEY (id_orden) REFERENCES OrdenesProduccion(id_orden),
        FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
    );
    INSERT INTO Ordenes_Productos (id_orden,id_producto) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaEmpleados();
CALL CrearTablaLineasProduccion();
CALL CrearTablaMaquinas();
CALL CrearTablaProductos();
CALL CrearTablaOrdenesProduccion();
CALL CrearTablaEmpleadosLineas();
CALL CrearTablaOrdenesProductos();

CREATE OR REPLACE VIEW Vista_EmpleadosPorLinea AS
SELECT l.nombre AS linea, COUNT(el.id_empleado) AS total_empleados
FROM LineasProduccion l
LEFT JOIN Empleados_Lineas el ON l.id_linea = el.id_linea
GROUP BY l.id_linea;

CREATE OR REPLACE VIEW Vista_ProductosPorOrden AS
SELECT o.id_orden AS orden, COUNT(op.id_producto) AS total_productos
FROM OrdenesProduccion o
LEFT JOIN Ordenes_Productos op ON o.id_orden = op.id_orden
GROUP BY o.id_orden;

CREATE OR REPLACE VIEW Vista_OrdenesConProductos AS
SELECT o.id_orden AS orden, p.nombre AS producto
FROM OrdenesProduccion o
JOIN Ordenes_Productos op ON o.id_orden = op.id_orden
JOIN Productos p ON op.id_producto = p.id_producto;

CREATE OR REPLACE VIEW Vista_EmpleadosConLineas AS
SELECT e.nombre AS empleado, l.nombre AS linea
FROM Empleados e
JOIN Empleados_Lineas el ON e.id_empleado = el.id_empleado
JOIN LineasProduccion l ON el.id_linea = l.id_linea;

CREATE OR REPLACE VIEW Vista_MaquinasDisponibles AS
SELECT m.nombre AS maquina
FROM Maquinas m
WHERE m.id_maquina NOT IN (SELECT id_maquina FROM Maquinas WHERE id_maquina IS NULL);

SELECT * FROM Vista_EmpleadosPorLinea;
SELECT * FROM Vista_ProductosPorOrden;
SELECT * FROM Vista_OrdenesConProductos;
SELECT * FROM Vista_EmpleadosConLineas;
SELECT * FROM Vista_MaquinasDisponibles;