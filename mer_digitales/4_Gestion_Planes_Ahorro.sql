CREATE DATABASE IF NOT EXISTS Gestion_Planes_Ahorro;
USE Gestion_Planes_Ahorro;

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

CREATE PROCEDURE CrearTablaPlanesAhorro()
BEGIN
    DROP TABLE IF EXISTS PlanesAhorro;
    CREATE TABLE PlanesAhorro (
        id_plan INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        descripcion VARCHAR(200)
    );
    INSERT INTO PlanesAhorro (nombre,descripcion) VALUES
    ('Plan Basico','Ahorro mensual bajo'),
    ('Plan Estandar','Ahorro mensual medio'),
    ('Plan Avanzado','Ahorro mensual alto'),
    ('Plan Premium','Ahorro con beneficios'),
    ('Plan Corporativo','Ahorro empresarial'),
    ('Plan Familiar','Ahorro familiar'),
    ('Plan Jubilacion','Ahorro largo plazo'),
    ('Plan Emergencia','Ahorro liquido'),
    ('Plan Inversion','Ahorro con inversion'),
    ('Plan Educativo','Ahorro para estudios');
END;
//

CREATE PROCEDURE CrearTablaTransacciones()
BEGIN
    DROP TABLE IF EXISTS Transacciones;
    CREATE TABLE Transacciones (
        id_transaccion INT AUTO_INCREMENT PRIMARY KEY,
        descripcion VARCHAR(200) NOT NULL,
        monto DECIMAL(10,2) NOT NULL,
        fecha DATE NOT NULL
    );
    INSERT INTO Transacciones (descripcion,monto,fecha) VALUES
    ('Deposito mensual',100,'2025-09-01'),
    ('Retiro parcial',50,'2025-09-02'),
    ('Deposito mensual',150,'2025-09-03'),
    ('Retiro parcial',70,'2025-09-04'),
    ('Deposito mensual',200,'2025-09-05'),
    ('Retiro parcial',80,'2025-09-06'),
    ('Deposito mensual',120,'2025-09-07'),
    ('Retiro parcial',60,'2025-09-08'),
    ('Deposito mensual',180,'2025-09-09'),
    ('Retiro parcial',90,'2025-09-10');
END;
//

CREATE PROCEDURE CrearTablaAsesores()
BEGIN
    DROP TABLE IF EXISTS Asesores;
    CREATE TABLE Asesores (
        id_asesor INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL
    );
    INSERT INTO Asesores (nombre) VALUES
    ('Luis Perez'),('Carla Gomez'),('Santiago Torres'),('Laura Diaz'),('Miguel Angel'),
    ('Elena Ruiz'),('Pedro Martinez'),('Sofia Hernandez'),('Kevin Culma'),('Ana Lopez');
END;
//

CREATE PROCEDURE CrearTablaDepartamentos()
BEGIN
    DROP TABLE IF EXISTS Departamentos;
    CREATE TABLE Departamentos (
        id_departamento INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL
    );
    INSERT INTO Departamentos (nombre) VALUES
    ('Ventas'),('Atencion al Cliente'),('Finanzas'),('Marketing'),('Operaciones'),
    ('TI'),('Legal'),('Recursos Humanos'),('Auditoria'),('Planificacion');
END;
//

CREATE PROCEDURE CrearTablaClientesPlanes()
BEGIN
    DROP TABLE IF EXISTS Clientes_Planes;
    CREATE TABLE Clientes_Planes (
        id_cliente INT NOT NULL,
        id_plan INT NOT NULL,
        PRIMARY KEY(id_cliente,id_plan),
        FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
        FOREIGN KEY (id_plan) REFERENCES PlanesAhorro(id_plan)
    );
    INSERT INTO Clientes_Planes (id_cliente,id_plan) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaTransaccionesPlanes()
BEGIN
    DROP TABLE IF EXISTS Transacciones_Planes;
    CREATE TABLE Transacciones_Planes (
        id_transaccion INT NOT NULL,
        id_plan INT NOT NULL,
        PRIMARY KEY(id_transaccion,id_plan),
        FOREIGN KEY (id_transaccion) REFERENCES Transacciones(id_transaccion),
        FOREIGN KEY (id_plan) REFERENCES PlanesAhorro(id_plan)
    );
    INSERT INTO Transacciones_Planes (id_transaccion,id_plan) VALUES
    (1,1),(2,1),(3,2),(4,2),(5,3),
    (6,3),(7,4),(8,4),(9,5),(10,5);
END;
//

DELIMITER ;

CALL CrearTablaClientes();
CALL CrearTablaPlanesAhorro();
CALL CrearTablaTransacciones();
CALL CrearTablaAsesores();
CALL CrearTablaDepartamentos();
CALL CrearTablaClientesPlanes();
CALL CrearTablaTransaccionesPlanes();

CREATE VIEW Vista_TransaccionesPorPlan AS
SELECT p.nombre AS plan, t.descripcion, t.monto, t.fecha
FROM Transacciones t
JOIN Transacciones_Planes tp ON t.id_transaccion = tp.id_transaccion
JOIN PlanesAhorro p ON tp.id_plan = p.id_plan;

CREATE VIEW Vista_ClientesPorPlan AS
SELECT p.nombre AS plan, COUNT(cp.id_cliente) AS total_clientes
FROM PlanesAhorro p
LEFT JOIN Clientes_Planes cp ON p.id_plan = cp.id_plan
GROUP BY p.id_plan;

CREATE VIEW Vista_TransaccionesTotales AS
SELECT p.nombre AS plan, SUM(t.monto) AS total_monto
FROM PlanesAhorro p
JOIN Transacciones_Planes tp ON p.id_plan = tp.id_plan
JOIN Transacciones t ON tp.id_transaccion = t.id_transaccion
GROUP BY p.id_plan;

CREATE VIEW Vista_ClientesConPlanes AS
SELECT c.nombre AS cliente, p.nombre AS plan
FROM Clientes c
JOIN Clientes_Planes cp ON c.id_cliente = cp.id_cliente
JOIN PlanesAhorro p ON cp.id_plan = p.id_plan;

CREATE VIEW Vista_AsesoresDepartamentos AS
SELECT a.nombre AS asesor, d.nombre AS departamento
FROM Asesores a
JOIN Departamentos d ON a.id_asesor = d.id_departamento;

SELECT * FROM Vista_TransaccionesPorPlan;
SELECT * FROM Vista_ClientesPorPlan;
SELECT * FROM Vista_TransaccionesTotales;
SELECT * FROM Vista_ClientesConPlanes;
SELECT * FROM Vista_AsesoresDepartamentos;
