CREATE DATABASE IF NOT EXISTS PlanesAhorroApp;
USE PlanesAhorroApp;

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
    ('Andrea','andrea@email.com'),
    ('Luis','luis@email.com'),
    ('Camila','camila@email.com'),
    ('Jorge','jorge@email.com'),
    ('Valentina','valentina@email.com'),
    ('Mateo','mateo@email.com'),
    ('Isabella','isabella@email.com'),
    ('Daniel','daniel@email.com'),
    ('Santiago','santiago@email.com'),
    ('Lucia','lucia@email.com');
END;
//

CREATE PROCEDURE CrearTablaMetas()
BEGIN
    DROP TABLE IF EXISTS Metas;
    CREATE TABLE Metas (
        id_meta INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL UNIQUE
    );
    INSERT INTO Metas (nombre) VALUES
    ('Comprar vivienda'),('Viaje internacional'),('Fondo de emergencia'),
    ('Educacion universitaria'),('Negocio propio'),('Auto nuevo'),
    ('Jubilacion'),('Reforma hogar'),('Tecnologia'),('Salud');
END;
//

CREATE PROCEDURE CrearTablaPeriodos()
BEGIN
    DROP TABLE IF EXISTS Periodos;
    CREATE TABLE Periodos (
        id_periodo INT AUTO_INCREMENT PRIMARY KEY,
        descripcion VARCHAR(50) NOT NULL UNIQUE
    );
    INSERT INTO Periodos (descripcion) VALUES
    ('Mensual'),('Quincenal'),('Semanal'),('Anual'),('Trimestral'),
    ('Bimestral'),('Diario'),('Semestral'),('Especial'),('Flexible');
END;
//

CREATE PROCEDURE CrearTablaPlanes()
BEGIN
    DROP TABLE IF EXISTS Planes;
    CREATE TABLE Planes (
        id_plan INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        monto_objetivo DECIMAL(10,2) NOT NULL,
        fecha_inicio DATE NOT NULL
    );
    INSERT INTO Planes (nombre,monto_objetivo,fecha_inicio) VALUES
    ('Plan vivienda','150000000','2025-01-01'),
    ('Plan viaje','20000000','2025-02-01'),
    ('Plan emergencia','10000000','2025-03-01'),
    ('Plan educacion','30000000','2025-04-01'),
    ('Plan negocio','50000000','2025-05-01'),
    ('Plan auto','40000000','2025-06-01'),
    ('Plan jubilacion','200000000','2025-07-01'),
    ('Plan reforma','25000000','2025-08-01'),
    ('Plan tecnologia','8000000','2025-09-01'),
    ('Plan salud','12000000','2025-10-01');
END;
//

CREATE PROCEDURE CrearTablaAportes()
BEGIN
    DROP TABLE IF EXISTS Aportes;
    CREATE TABLE Aportes (
        id_aporte INT AUTO_INCREMENT PRIMARY KEY,
        id_plan INT NOT NULL,
        monto DECIMAL(10,2) NOT NULL,
        fecha_aporte DATE NOT NULL,
        FOREIGN KEY (id_plan) REFERENCES Planes(id_plan)
    );
    INSERT INTO Aportes (id_plan,monto,fecha_aporte) VALUES
    (1,500000,'2025-01-15'),(2,300000,'2025-02-15'),
    (3,200000,'2025-03-15'),(4,400000,'2025-04-15'),
    (5,600000,'2025-05-15'),(6,350000,'2025-06-15'),
    (7,800000,'2025-07-15'),(8,250000,'2025-08-15'),
    (9,150000,'2025-09-15'),(10,220000,'2025-10-15');
END;
//

CREATE PROCEDURE CrearTablaUsuariosMetas()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Metas;
    CREATE TABLE Usuarios_Metas (
        id_usuario INT NOT NULL,
        id_meta INT NOT NULL,
        PRIMARY KEY(id_usuario,id_meta),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_meta) REFERENCES Metas(id_meta)
    );
    INSERT INTO Usuarios_Metas (id_usuario,id_meta) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaPlanesPeriodos()
BEGIN
    DROP TABLE IF EXISTS Planes_Periodos;
    CREATE TABLE Planes_Periodos (
        id_plan INT NOT NULL,
        id_periodo INT NOT NULL,
        PRIMARY KEY(id_plan,id_periodo),
        FOREIGN KEY (id_plan) REFERENCES Planes(id_plan),
        FOREIGN KEY (id_periodo) REFERENCES Periodos(id_periodo)
    );
    INSERT INTO Planes_Periodos (id_plan,id_periodo) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaMetas();
CALL CrearTablaPeriodos();
CALL CrearTablaPlanes();
CALL CrearTablaAportes();
CALL CrearTablaUsuariosMetas();
CALL CrearTablaPlanesPeriodos();

CREATE OR REPLACE VIEW Vista_PlanesPorUsuario AS
SELECT u.nombre AS usuario, p.nombre AS plan, p.monto_objetivo
FROM Planes p
JOIN Usuarios_Metas um ON um.id_usuario = p.id_plan
JOIN Usuarios u ON um.id_usuario = u.id_usuario;

CREATE OR REPLACE VIEW Vista_MetasUsuarios AS
SELECT m.nombre AS meta, COUNT(um.id_usuario) AS total
FROM Metas m
LEFT JOIN Usuarios_Metas um ON m.id_meta = um.id_meta
GROUP BY m.id_meta;

CREATE OR REPLACE VIEW Vista_PlanesPorPeriodo AS
SELECT pe.descripcion AS periodo, COUNT(pp.id_plan) AS total
FROM Periodos pe
LEFT JOIN Planes_Periodos pp ON pe.id_periodo = pp.id_periodo
GROUP BY pe.id_periodo;

CREATE OR REPLACE VIEW Vista_AportesPendientes AS
SELECT p.nombre AS plan, a.monto
FROM Aportes a
JOIN Planes p ON a.id_plan = p.id_plan
WHERE a.monto < 500000;

CREATE OR REPLACE VIEW Vista_UsuariosConMetas AS
SELECT u.nombre AS usuario, m.nombre AS meta
FROM Usuarios u
JOIN Usuarios_Metas um ON u.id_usuario = um.id_usuario
JOIN Metas m ON um.id_meta = m.id_meta;

SELECT * FROM Vista_PlanesPorUsuario;
SELECT * FROM Vista_MetasUsuarios;
SELECT * FROM Vista_PlanesPorPeriodo;
SELECT * FROM Vista_AportesPendientes;
SELECT * FROM Vista_UsuariosConMetas;