CREATE DATABASE IF NOT EXISTS control_contratos;
USE control_contratos;

DELIMITER //

CREATE PROCEDURE crear_tabla_clientes()
BEGIN
    CREATE TABLE IF NOT EXISTS clientes (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        correo VARCHAR(100) UNIQUE NOT NULL
    );
END //

CREATE PROCEDURE crear_tabla_tipos_contrato()
BEGIN
    CREATE TABLE IF NOT EXISTS tipos_contrato (
        id INT AUTO_INCREMENT PRIMARY KEY,
        descripcion VARCHAR(100) NOT NULL
    );
END //

CREATE PROCEDURE crear_tabla_empleados()
BEGIN
    CREATE TABLE IF NOT EXISTS empleados (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        cargo VARCHAR(100) NOT NULL
    );
END //

CREATE PROCEDURE crear_tabla_proyectos()
BEGIN
    CREATE TABLE IF NOT EXISTS proyectos (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        fecha_inicio DATE NOT NULL,
        fecha_fin DATE NOT NULL
    );
END //

CREATE PROCEDURE crear_tabla_contratos()
BEGIN
    CREATE TABLE IF NOT EXISTS contratos (
        id INT AUTO_INCREMENT PRIMARY KEY,
        cliente_id INT NOT NULL,
        tipo_id INT NOT NULL,
        monto DECIMAL(12,2) NOT NULL,
        fecha_firma DATE NOT NULL,
        FOREIGN KEY (cliente_id) REFERENCES clientes(id),
        FOREIGN KEY (tipo_id) REFERENCES tipos_contrato(id)
    );
END //

CREATE PROCEDURE crear_tabla_contrato_empleado()
BEGIN
    CREATE TABLE IF NOT EXISTS contrato_empleado (
        id INT AUTO_INCREMENT PRIMARY KEY,
        contrato_id INT NOT NULL,
        empleado_id INT NOT NULL,
        rol VARCHAR(100) NOT NULL,
        FOREIGN KEY (contrato_id) REFERENCES contratos(id),
        FOREIGN KEY (empleado_id) REFERENCES empleados(id)
    );
END //

CREATE PROCEDURE crear_tabla_contrato_proyecto()
BEGIN
    CREATE TABLE IF NOT EXISTS contrato_proyecto (
        id INT AUTO_INCREMENT PRIMARY KEY,
        contrato_id INT NOT NULL,
        proyecto_id INT NOT NULL,
        FOREIGN KEY (contrato_id) REFERENCES contratos(id),
        FOREIGN KEY (proyecto_id) REFERENCES proyectos(id)
    );
END //

DELIMITER ;

CALL crear_tabla_clientes();
CALL crear_tabla_tipos_contrato();
CALL crear_tabla_empleados();
CALL crear_tabla_proyectos();
CALL crear_tabla_contratos();
CALL crear_tabla_contrato_empleado();
CALL crear_tabla_contrato_proyecto();

DELIMITER //

CREATE PROCEDURE insertar_datos_clientes()
BEGIN
    INSERT IGNORE INTO clientes (nombre, correo) VALUES
    ('Empresa Alfa','alfa@correo.com'),
    ('Empresa Beta','beta@correo.com'),
    ('Empresa Gamma','gamma@correo.com'),
    ('Empresa Delta','delta@correo.com'),
    ('Empresa Epsilon','epsilon@correo.com'),
    ('Empresa Zeta','zeta@correo.com'),
    ('Empresa Eta','eta@correo.com'),
    ('Empresa Theta','theta@correo.com'),
    ('Empresa Iota','iota@correo.com'),
    ('Empresa Kappa','kappa@correo.com');
END //

CREATE PROCEDURE insertar_datos_tipos_contrato()
BEGIN
    INSERT IGNORE INTO tipos_contrato (descripcion) VALUES
    ('Servicios TI'),
    ('Consultoria'),
    ('Mantenimiento'),
    ('Outsourcing'),
    ('Suministros'),
    ('Marketing'),
    ('Legal'),
    ('Construccion'),
    ('Capacitacion'),
    ('Logistica');
END //

CREATE PROCEDURE insertar_datos_empleados()
BEGIN
    INSERT IGNORE INTO empleados (nombre, cargo) VALUES
    ('Ana Torres','Abogada'),
    ('Luis Perez','Ingeniero'),
    ('Maria Rojas','Analista'),
    ('Carlos Diaz','Tecnico'),
    ('Laura Gomez','Gestor'),
    ('Pedro Ruiz','Supervisor'),
    ('Sofia Mendez','Consultor'),
    ('Jorge Silva','Contador'),
    ('Valentina Pino','Arquitecta'),
    ('Andres Mora','Coordinador');
END //

CREATE PROCEDURE insertar_datos_proyectos()
BEGIN
    INSERT IGNORE INTO proyectos (nombre, fecha_inicio, fecha_fin) VALUES
    ('Implementacion ERP','2024-01-01','2024-06-30'),
    ('Migracion Cloud','2024-02-01','2024-07-30'),
    ('Rediseño Web','2024-03-01','2024-09-30'),
    ('Capacitacion Personal','2024-04-01','2024-12-31'),
    ('Marketing Digital','2024-05-01','2024-11-30'),
    ('Infraestructura DataCenter','2024-06-01','2024-12-15'),
    ('Auditoria Interna','2024-07-01','2025-01-31'),
    ('Soporte Postventa','2024-08-01','2025-02-28'),
    ('Automatizacion Procesos','2024-09-01','2025-03-31'),
    ('Sistema Inventario','2024-10-01','2025-04-30');
END //

CREATE PROCEDURE insertar_datos_contratos()
BEGIN
    INSERT IGNORE INTO contratos (cliente_id, tipo_id, monto, fecha_firma) VALUES
    (1,1,50000,'2024-01-15'),
    (2,2,40000,'2024-02-10'),
    (3,3,35000,'2024-03-12'),
    (4,4,60000,'2024-04-18'),
    (5,5,45000,'2024-05-20'),
    (6,6,38000,'2024-06-22'),
    (7,7,42000,'2024-07-25'),
    (8,8,30000,'2024-08-27'),
    (9,9,55000,'2024-09-29'),
    (10,10,47000,'2024-10-31');
END //

CREATE PROCEDURE insertar_datos_contrato_empleado()
BEGIN
    INSERT IGNORE INTO contrato_empleado (contrato_id, empleado_id, rol) VALUES
    (1,1,'Responsable Legal'),
    (2,2,'Lider Tecnico'),
    (3,3,'Analista'),
    (4,4,'Soporte'),
    (5,5,'Gestor'),
    (6,6,'Supervisor'),
    (7,7,'Consultor'),
    (8,8,'Contador'),
    (9,9,'Arquitecto'),
    (10,10,'Coordinador');
END //

CREATE PROCEDURE insertar_datos_contrato_proyecto()
BEGIN
    INSERT IGNORE INTO contrato_proyecto (contrato_id, proyecto_id) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END //

DELIMITER ;

CALL insertar_datos_clientes();
CALL insertar_datos_tipos_contrato();
CALL insertar_datos_empleados();
CALL insertar_datos_proyectos();
CALL insertar_datos_contratos();
CALL insertar_datos_contrato_empleado();
CALL insertar_datos_contrato_proyecto();

CREATE OR REPLACE VIEW vista_contratos_detalle AS
SELECT 
    c.id           AS contrato_id,
    cl.nombre      AS cliente_nombre,
    tc.descripcion AS tipo_contrato,
    c.monto,
    c.fecha_firma
FROM contratos c
JOIN clientes cl        ON c.cliente_id = cl.id
JOIN tipos_contrato tc  ON c.tipo_id    = tc.id;

CREATE OR REPLACE VIEW vista_empleados_por_contrato AS
SELECT
    e.id           AS empleado_id,
    e.nombre       AS empleado_nombre,
    ce.rol         AS rol_en_contrato,
    c.id           AS contrato_id,
    cl.nombre      AS cliente_nombre
FROM empleados e
JOIN contrato_empleado ce ON e.id = ce.empleado_id
JOIN contratos c         ON ce.contrato_id = c.id
JOIN clientes cl         ON c.cliente_id   = cl.id;

CREATE OR REPLACE VIEW vista_proyectos_por_contrato AS
SELECT
    c.id       AS contrato_id,
    p.id       AS proyecto_id,
    p.nombre   AS proyecto_nombre,
    p.fecha_inicio,
    p.fecha_fin
FROM contratos c
JOIN contrato_proyecto cp ON c.id = cp.contrato_id
JOIN proyectos p         ON cp.proyecto_id = p.id;

CREATE OR REPLACE VIEW vista_montos_totales_por_cliente AS
SELECT
    cl.id      AS cliente_id,
    cl.nombre  AS cliente_nombre,
    SUM(c.monto) AS monto_total
FROM clientes cl
LEFT JOIN contratos c ON cl.id = c.cliente_id
GROUP BY cl.id, cl.nombre;

CREATE OR REPLACE VIEW vista_contratos_activos_por_proyecto AS
SELECT
    p.id       AS proyecto_id,
    p.nombre   AS proyecto_nombre,
    COUNT(cp.contrato_id) AS cantidad_contratos_activos
FROM proyectos p
LEFT JOIN contrato_proyecto cp ON p.id = cp.proyecto_id
GROUP BY p.id, p.nombre;