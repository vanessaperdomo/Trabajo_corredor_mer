CREATE DATABASE IF NOT EXISTS SegurosApp;
USE SegurosApp;

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
    ('Andres','andres@gmail.com'),
    ('Beatriz','beatriz@gmail.com'),
    ('Camilo','camilo@gmail.com'),
    ('Daniela','daniela@gmail.com'),
    ('Ernesto','ernesto@gmail.com'),
    ('Fernanda','fernanda@gmail.com'),
    ('Gustavo','gustavo@gmail.com'),
    ('Helena','helena@gmail.com'),
    ('Ignacio','ignacio@gmail.com'),
    ('Juliana','juliana@gmail.com');
END;
//

CREATE PROCEDURE CrearTablaTiposSeguro()
BEGIN
    DROP TABLE IF EXISTS Tipos_Seguro;
    CREATE TABLE Tipos_Seguro (
        id_tipo INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL UNIQUE
    );
    INSERT INTO Tipos_Seguro (nombre) VALUES
    ('Vida'),('Salud'),('Vehiculo'),('Hogar'),('Viaje'),
    ('Mascotas'),('Accidentes'),('Empresarial'),('Tecnologia'),('Educacion');
END;
//

CREATE PROCEDURE CrearTablaCoberturas()
BEGIN
    DROP TABLE IF EXISTS Coberturas;
    CREATE TABLE Coberturas (
        id_cobertura INT AUTO_INCREMENT PRIMARY KEY,
        descripcion VARCHAR(100) NOT NULL UNIQUE
    );
    INSERT INTO Coberturas (descripcion) VALUES
    ('Basica'),('Completa'),('Premium'),('Alta'),('Media'),
    ('Estandar'),('Extendida'),('Especial'),('Limitada'),('Total');
END;
//

CREATE PROCEDURE CrearTablaPolizas()
BEGIN
    DROP TABLE IF EXISTS Polizas;
    CREATE TABLE Polizas (
        id_poliza INT AUTO_INCREMENT PRIMARY KEY,
        numero_poliza VARCHAR(50) NOT NULL,
        fecha_inicio DATE NOT NULL,
        fecha_fin DATE NOT NULL,
        valor DECIMAL(12,2) NOT NULL
    );
    INSERT INTO Polizas (numero_poliza,fecha_inicio,fecha_fin,valor) VALUES
    ('PZ1001','2025-01-01','2026-01-01',1500000.00),
    ('PZ1002','2025-02-01','2026-02-01',1200000.00),
    ('PZ1003','2025-03-01','2026-03-01',1800000.00),
    ('PZ1004','2025-04-01','2026-04-01',1000000.00),
    ('PZ1005','2025-05-01','2026-05-01',2200000.00),
    ('PZ1006','2025-06-01','2026-06-01',1400000.00),
    ('PZ1007','2025-07-01','2026-07-01',2000000.00),
    ('PZ1008','2025-08-01','2026-08-01',1750000.00),
    ('PZ1009','2025-09-01','2026-09-01',1600000.00),
    ('PZ1010','2025-10-01','2026-10-01',1900000.00);
END;
//

CREATE PROCEDURE CrearTablaReclamos()
BEGIN
    DROP TABLE IF EXISTS Reclamos;
    CREATE TABLE Reclamos (
        id_reclamo INT AUTO_INCREMENT PRIMARY KEY,
        id_poliza INT NOT NULL,
        descripcion VARCHAR(200) NOT NULL,
        fecha_reclamo DATETIME NOT NULL,
        FOREIGN KEY (id_poliza) REFERENCES Polizas(id_poliza)
    );
    INSERT INTO Reclamos (id_poliza,descripcion,fecha_reclamo) VALUES
    (1,'Robo de vehiculo','2025-09-10 10:00'),
    (2,'Accidente de transito','2025-09-11 14:00'),
    (3,'Daños en vivienda','2025-09-12 09:00'),
    (4,'Emergencia medica','2025-09-13 16:00'),
    (5,'Viaje cancelado','2025-09-14 11:00'),
    (6,'Mascota enferma','2025-09-15 13:00'),
    (7,'Accidente laboral','2025-09-16 08:00'),
    (8,'Robo de equipo','2025-09-17 15:00'),
    (9,'Accidente escolar','2025-09-18 12:00'),
    (10,'Daño tecnologico','2025-09-19 18:00');
END;
//

CREATE PROCEDURE CrearTablaClientesTipos()
BEGIN
    DROP TABLE IF EXISTS Clientes_Tipos;
    CREATE TABLE Clientes_Tipos (
        id_cliente INT NOT NULL,
        id_tipo INT NOT NULL,
        PRIMARY KEY(id_cliente,id_tipo),
        FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
        FOREIGN KEY (id_tipo) REFERENCES Tipos_Seguro(id_tipo)
    );
    INSERT INTO Clientes_Tipos (id_cliente,id_tipo) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaPolizasCoberturas()
BEGIN
    DROP TABLE IF EXISTS Polizas_Coberturas;
    CREATE TABLE Polizas_Coberturas (
        id_poliza INT NOT NULL,
        id_cobertura INT NOT NULL,
        PRIMARY KEY(id_poliza,id_cobertura),
        FOREIGN KEY (id_poliza) REFERENCES Polizas(id_poliza),
        FOREIGN KEY (id_cobertura) REFERENCES Coberturas(id_cobertura)
    );
    INSERT INTO Polizas_Coberturas (id_poliza,id_cobertura) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaClientes();
CALL CrearTablaTiposSeguro();
CALL CrearTablaCoberturas();
CALL CrearTablaPolizas();
CALL CrearTablaReclamos();
CALL CrearTablaClientesTipos();
CALL CrearTablaPolizasCoberturas();

CREATE OR REPLACE VIEW Vista_PolizasPorCliente AS
SELECT c.nombre AS cliente, p.numero_poliza, p.fecha_inicio, p.fecha_fin
FROM Clientes_Tipos ct
JOIN Clientes c ON ct.id_cliente = c.id_cliente
JOIN Polizas p ON ct.id_cliente = p.id_poliza;

CREATE OR REPLACE VIEW Vista_PolizasPorTipo AS
SELECT t.nombre AS tipo_seguro, COUNT(ct.id_cliente) AS total
FROM Tipos_Seguro t
LEFT JOIN Clientes_Tipos ct ON t.id_tipo = ct.id_tipo
GROUP BY t.id_tipo;

CREATE OR REPLACE VIEW Vista_PolizasPorCobertura AS
SELECT co.descripcion AS cobertura, COUNT(pc.id_poliza) AS total
FROM Coberturas co
LEFT JOIN Polizas_Coberturas pc ON co.id_cobertura = pc.id_cobertura
GROUP BY co.id_cobertura;

CREATE OR REPLACE VIEW Vista_ReclamosPendientes AS
SELECT p.numero_poliza, r.descripcion, r.fecha_reclamo
FROM Reclamos r
JOIN Polizas p ON r.id_poliza = p.id_poliza;

CREATE OR REPLACE VIEW Vista_ClientesConTipos AS
SELECT c.nombre AS cliente, t.nombre AS tipo_seguro
FROM Clientes c
JOIN Clientes_Tipos ct ON c.id_cliente = ct.id_cliente
JOIN Tipos_Seguro t ON ct.id_tipo = t.id_tipo;

SELECT * FROM Vista_PolizasPorCliente;
SELECT * FROM Vista_PolizasPorTipo;
SELECT * FROM Vista_PolizasPorCobertura;
SELECT * FROM Vista_ReclamosPendientes;
SELECT * FROM Vista_ClientesConTipos;