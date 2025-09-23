CREATE DATABASE IF NOT EXISTS PasarelaPagos;
USE PasarelaPagos;

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

CREATE PROCEDURE CrearTablaMetodosPago()
BEGIN
    DROP TABLE IF EXISTS Metodos_Pago;
    CREATE TABLE Metodos_Pago (
        id_metodo INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL UNIQUE
    );
    INSERT INTO Metodos_Pago (nombre) VALUES
    ('Tarjeta Credito'),('Tarjeta Debito'),('Transferencia Bancaria'),
    ('PSE'),('PayPal'),('Nequi'),('Daviplata'),('Cripto'),
    ('Contraentrega'),('Bono de Regalo');
END;
//

CREATE PROCEDURE CrearTablaEstadosPago()
BEGIN
    DROP TABLE IF EXISTS Estados_Pago;
    CREATE TABLE Estados_Pago (
        id_estado INT AUTO_INCREMENT PRIMARY KEY,
        estado VARCHAR(50) NOT NULL UNIQUE
    );
    INSERT INTO Estados_Pago (estado) VALUES
    ('Pendiente'),('Pagado'),('Fallido'),('En proceso'),('Reembolsado'),
    ('Cancelado'),('Expirado'),('Revisando'),('Autenticado'),('Rechazado');
END;
//

CREATE PROCEDURE CrearTablaPagos()
BEGIN
    DROP TABLE IF EXISTS Pagos;
    CREATE TABLE Pagos (
        id_pago INT AUTO_INCREMENT PRIMARY KEY,
        monto DECIMAL(10,2) NOT NULL,
        descripcion VARCHAR(200),
        fecha_pago DATETIME NOT NULL
    );
    INSERT INTO Pagos (monto,descripcion,fecha_pago) VALUES
    (120000,'Compra en linea','2025-09-16 14:00'),
    (80000,'Suscripcion mensual','2025-09-17 10:00'),
    (55000,'Factura de servicios','2025-09-18 08:30'),
    (320000,'Compra electrodomestico','2025-09-19 16:00'),
    (99000,'Renovacion membresia','2025-09-20 09:00'),
    (25000,'Pago curso online','2025-09-21 11:00'),
    (45000,'Recarga celular','2025-09-21 15:00'),
    (75000,'Compra ropa','2025-09-22 13:00'),
    (38000,'Suscripcion app','2025-09-23 18:00'),
    (67000,'Compra libros','2025-09-23 20:00');
END;
//

CREATE PROCEDURE CrearTablaUsuariosPagos()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Pagos;
    CREATE TABLE Usuarios_Pagos (
        id_usuario INT NOT NULL,
        id_pago INT NOT NULL,
        PRIMARY KEY (id_usuario, id_pago),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_pago) REFERENCES Pagos(id_pago)
    );
    INSERT INTO Usuarios_Pagos (id_usuario,id_pago) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaPagosMetodos()
BEGIN
    DROP TABLE IF EXISTS Pagos_Metodos;
    CREATE TABLE Pagos_Metodos (
        id_pago INT NOT NULL,
        id_metodo INT NOT NULL,
        PRIMARY KEY (id_pago, id_metodo),
        FOREIGN KEY (id_pago) REFERENCES Pagos(id_pago),
        FOREIGN KEY (id_metodo) REFERENCES Metodos_Pago(id_metodo)
    );
    INSERT INTO Pagos_Metodos (id_pago,id_metodo) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaPagosEstados()
BEGIN
    DROP TABLE IF EXISTS Pagos_Estados;
    CREATE TABLE Pagos_Estados (
        id_pago INT NOT NULL,
        id_estado INT NOT NULL,
        PRIMARY KEY (id_pago, id_estado),
        FOREIGN KEY (id_pago) REFERENCES Pagos(id_pago),
        FOREIGN KEY (id_estado) REFERENCES Estados_Pago(id_estado)
    );
    INSERT INTO Pagos_Estados (id_pago,id_estado) VALUES
    (1,2),(2,2),(3,1),(4,2),(5,2),
    (6,2),(7,1),(8,2),(9,3),(10,4);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaMetodosPago();
CALL CrearTablaEstadosPago();
CALL CrearTablaPagos();
CALL CrearTablaUsuariosPagos();
CALL CrearTablaPagosMetodos();
CALL CrearTablaPagosEstados();

CREATE OR REPLACE VIEW Vista_PagosPorUsuario AS
SELECT u.nombre AS usuario, p.monto, p.descripcion, p.fecha_pago
FROM Pagos p
JOIN Usuarios_Pagos up ON up.id_pago = p.id_pago
JOIN Usuarios u ON up.id_usuario = u.id_usuario;

CREATE OR REPLACE VIEW Vista_PagosPorMetodo AS
SELECT m.nombre AS metodo, COUNT(pm.id_pago) AS total
FROM Metodos_Pago m
LEFT JOIN Pagos_Metodos pm ON m.id_metodo = pm.id_metodo
GROUP BY m.id_metodo;

CREATE OR REPLACE VIEW Vista_PagosPorEstado AS
SELECT e.estado, COUNT(pe.id_pago) AS total
FROM Estados_Pago e
LEFT JOIN Pagos_Estados pe ON e.id_estado = pe.id_estado
GROUP BY e.id_estado;

CREATE OR REPLACE VIEW Vista_UsuariosConPagos AS
SELECT u.nombre AS usuario, COUNT(up.id_pago) AS total_pagos
FROM Usuarios u
LEFT JOIN Usuarios_Pagos up ON u.id_usuario = up.id_usuario
GROUP BY u.id_usuario;

CREATE OR REPLACE VIEW Vista_PagosDetallados AS
SELECT p.id_pago, u.nombre AS usuario, p.monto, m.nombre AS metodo, e.estado, p.fecha_pago
FROM Pagos p
JOIN Usuarios_Pagos up ON up.id_pago = p.id_pago
JOIN Usuarios u ON up.id_usuario = u.id_usuario
JOIN Pagos_Metodos pm ON pm.id_pago = p.id_pago
JOIN Metodos_Pago m ON pm.id_metodo = m.id_metodo
JOIN Pagos_Estados pe ON pe.id_pago = p.id_pago
JOIN Estados_Pago e ON pe.id_estado = e.id_estado;

SELECT * FROM Vista_PagosPorUsuario;
SELECT * FROM Vista_PagosPorMetodo;
SELECT * FROM Vista_PagosPorEstado;
SELECT * FROM Vista_UsuariosConPagos;
SELECT * FROM Vista_PagosDetallados;
