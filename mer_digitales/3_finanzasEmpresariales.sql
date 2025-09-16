CREATE DATABASE IF NOT EXISTS FinanzasEmpresariales;
USE FinanzasEmpresariales;

DELIMITER //

CREATE PROCEDURE CrearTablaEmpresas()
BEGIN
    DROP TABLE IF EXISTS Empresas;
    CREATE TABLE Empresas (
        id_empresa INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL
    );
    INSERT INTO Empresas (nombre) VALUES
    ('Empresa A'),('Empresa B'),('Empresa C'),('Empresa D'),('Empresa E'),
    ('Empresa F'),('Empresa G'),('Empresa H'),('Empresa I'),('Empresa J');
END;
//

CREATE PROCEDURE CrearTablaCuentas()
BEGIN
    DROP TABLE IF EXISTS Cuentas;
    CREATE TABLE Cuentas (
        id_cuenta INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        id_empresa INT NOT NULL,
        FOREIGN KEY (id_empresa) REFERENCES Empresas(id_empresa)
    );
    INSERT INTO Cuentas (nombre,id_empresa) VALUES
    ('Caja',1),('Banco',1),('Caja',2),('Banco',2),('Caja',3),
    ('Banco',3),('Caja',4),('Banco',4),('Caja',5),('Banco',5);
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
    ('Pago proveedor',1000,'2025-09-01'),
    ('Venta producto',500,'2025-09-02'),
    ('Pago impuestos',200,'2025-09-03'),
    ('Cobro cliente',1500,'2025-09-04'),
    ('Compra insumos',300,'2025-09-05'),
    ('Pago nomina',1200,'2025-09-06'),
    ('Cobro servicio',800,'2025-09-07'),
    ('Pago alquiler',600,'2025-09-08'),
    ('Venta producto',700,'2025-09-09'),
    ('Pago proveedor',400,'2025-09-10');
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
    ('Ana Torres'),('Juan Perez'),('Maria Lopez'),('Carlos Garcia'),('Laura Martinez'),
    ('Pedro Gomez'),('Sofia Hernandez'),('Miguel Torres'),('Elena Ruiz'),('Kevin Culma');
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
    ('Contabilidad'),('Finanzas'),('Ventas'),('Marketing'),('Recursos Humanos'),
    ('TI'),('Operaciones'),('Compras'),('Legal'),('Logistica');
END;
//

CREATE PROCEDURE CrearTablaEmpleadosDepartamentos()
BEGIN
    DROP TABLE IF EXISTS Empleados_Departamentos;
    CREATE TABLE Empleados_Departamentos (
        id_empleado INT NOT NULL,
        id_departamento INT NOT NULL,
        PRIMARY KEY(id_empleado,id_departamento),
        FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado),
        FOREIGN KEY (id_departamento) REFERENCES Departamentos(id_departamento)
    );
    INSERT INTO Empleados_Departamentos (id_empleado,id_departamento) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaTransaccionesCuentas()
BEGIN
    DROP TABLE IF EXISTS Transacciones_Cuentas;
    CREATE TABLE Transacciones_Cuentas (
        id_transaccion INT NOT NULL,
        id_cuenta INT NOT NULL,
        PRIMARY KEY(id_transaccion,id_cuenta),
        FOREIGN KEY (id_transaccion) REFERENCES Transacciones(id_transaccion),
        FOREIGN KEY (id_cuenta) REFERENCES Cuentas(id_cuenta)
    );
    INSERT INTO Transacciones_Cuentas (id_transaccion,id_cuenta) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaEmpresas();
CALL CrearTablaCuentas();
CALL CrearTablaTransacciones();
CALL CrearTablaEmpleados();
CALL CrearTablaDepartamentos();
CALL CrearTablaEmpleadosDepartamentos();
CALL CrearTablaTransaccionesCuentas();

CREATE VIEW Vista_TransaccionesPorCuenta AS
SELECT c.nombre AS cuenta, t.descripcion, t.monto, t.fecha
FROM Transacciones t
JOIN Transacciones_Cuentas tc ON t.id_transaccion = tc.id_transaccion
JOIN Cuentas c ON tc.id_cuenta = c.id_cuenta;

CREATE VIEW Vista_TransaccionesPorEmpresa AS
SELECT e.nombre AS empresa, COUNT(t.id_transaccion) AS total_transacciones, SUM(t.monto) AS total_monto
FROM Empresas e
JOIN Cuentas c ON e.id_empresa = c.id_empresa
JOIN Transacciones_Cuentas tc ON c.id_cuenta = tc.id_cuenta
JOIN Transacciones t ON tc.id_transaccion = t.id_transaccion
GROUP BY e.id_empresa;

CREATE VIEW Vista_EmpleadosPorDepartamento AS
SELECT d.nombre AS departamento, e.nombre AS empleado
FROM Empleados e
JOIN Empleados_Departamentos ed ON e.id_empleado = ed.id_empleado
JOIN Departamentos d ON ed.id_departamento = d.id_departamento;

CREATE VIEW Vista_MontoPorCuenta AS
SELECT c.nombre AS cuenta, SUM(t.monto) AS total_monto
FROM Cuentas c
JOIN Transacciones_Cuentas tc ON c.id_cuenta = tc.id_cuenta
JOIN Transacciones t ON tc.id_transaccion = t.id_transaccion
GROUP BY c.id_cuenta;

CREATE VIEW Vista_MontoPorEmpresa AS
SELECT e.nombre AS empresa, SUM(t.monto) AS total_monto
FROM Empresas e
JOIN Cuentas c ON e.id_empresa = c.id_empresa
JOIN Transacciones_Cuentas tc ON c.id_cuenta = tc.id_cuenta
JOIN Transacciones t ON tc.id_transaccion = t.id_transaccion
GROUP BY e.id_empresa;

SELECT * FROM Vista_TransaccionesPorCuenta;
SELECT * FROM Vista_TransaccionesPorEmpresa;
SELECT * FROM Vista_EmpleadosPorDepartamento;
SELECT * FROM Vista_MontoPorCuenta;
SELECT * FROM Vista_MontoPorEmpresa;
