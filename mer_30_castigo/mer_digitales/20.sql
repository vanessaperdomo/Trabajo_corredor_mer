CREATE DATABASE IF NOT EXISTS RegistroVehiculos;
USE RegistroVehiculos;

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
    ('Luis','luis@gmail.com'),
    ('Carla','carla@gmail.com'),
    ('Miguel','miguel@gmail.com'),
    ('Ana','ana@gmail.com'),
    ('Pedro','pedro@gmail.com'),
    ('Sofia','sofia@gmail.com'),
    ('Jorge','jorge@gmail.com'),
    ('Valeria','valeria@gmail.com'),
    ('Daniel','daniel@gmail.com'),
    ('Lucia','lucia@gmail.com');
END;
//

CREATE PROCEDURE CrearTablaVehiculos()
BEGIN
    DROP TABLE IF EXISTS Vehiculos;
    CREATE TABLE Vehiculos (
        id_vehiculo INT AUTO_INCREMENT PRIMARY KEY,
        placa VARCHAR(20) NOT NULL UNIQUE,
        modelo VARCHAR(50) NOT NULL
    );
    INSERT INTO Vehiculos (placa,modelo) VALUES
    ('ABC123','Sedan'),
    ('XYZ987','SUV'),
    ('LMN456','Pickup'),
    ('JKL321','Hatchback'),
    ('OPQ654','Convertible'),
    ('RST789','Coupe'),
    ('UVW111','Camioneta'),
    ('DEF222','Van'),
    ('GHI333','Sedan'),
    ('JKM444','SUV');
END;
//

CREATE PROCEDURE CrearTablaCategorias()
BEGIN
    DROP TABLE IF EXISTS Categorias;
    CREATE TABLE Categorias (
        id_categoria INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL UNIQUE
    );
    INSERT INTO Categorias (nombre) VALUES
    ('Particular'),('Publico'),('Carga'),('Transporte'),
    ('Oficial'),('Escolar'),('Turismo'),('Emergencia'),
    ('Diplomatico'),('Otros');
END;
//

CREATE PROCEDURE CrearTablaRenovaciones()
BEGIN
    DROP TABLE IF EXISTS Renovaciones;
    CREATE TABLE Renovaciones (
        id_renovacion INT AUTO_INCREMENT PRIMARY KEY,
        id_vehiculo INT NOT NULL,
        fecha_renovacion DATETIME NOT NULL,
        FOREIGN KEY (id_vehiculo) REFERENCES Vehiculos(id_vehiculo)
    );
    INSERT INTO Renovaciones (id_vehiculo,fecha_renovacion) VALUES
    (1,'2025-09-20 10:00'),(2,'2025-09-16 17:00'),
    (3,'2025-09-18 09:00'),(4,'2025-09-17 15:00'),
    (5,'2025-09-16 19:00'),(6,'2025-09-21 12:00'),
    (7,'2025-09-16 20:00'),(8,'2025-09-22 18:00'),
    (9,'2025-09-19 16:00'),(10,'2025-09-23 14:00');
END;
//

CREATE PROCEDURE CrearTablaNotificaciones()
BEGIN
    DROP TABLE IF EXISTS Notificaciones;
    CREATE TABLE Notificaciones (
        id_notificacion INT AUTO_INCREMENT PRIMARY KEY,
        id_renovacion INT NOT NULL,
        enviada TINYINT(1) DEFAULT 0,
        FOREIGN KEY (id_renovacion) REFERENCES Renovaciones(id_renovacion)
    );
    INSERT INTO Notificaciones (id_renovacion,enviada) VALUES
    (1,0),(2,0),(3,0),(4,0),(5,0),
    (6,0),(7,0),(8,0),(9,0),(10,0);
END;
//

CREATE PROCEDURE CrearTablaUsuariosCategorias()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Categorias;
    CREATE TABLE Usuarios_Categorias (
        id_usuario INT NOT NULL,
        id_categoria INT NOT NULL,
        PRIMARY KEY(id_usuario,id_categoria),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
    );
    INSERT INTO Usuarios_Categorias (id_usuario,id_categoria) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaVehiculosCategorias()
BEGIN
    DROP TABLE IF EXISTS Vehiculos_Categorias;
    CREATE TABLE Vehiculos_Categorias (
        id_vehiculo INT NOT NULL,
        id_categoria INT NOT NULL,
        PRIMARY KEY(id_vehiculo,id_categoria),
        FOREIGN KEY (id_vehiculo) REFERENCES Vehiculos(id_vehiculo),
        FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
    );
    INSERT INTO Vehiculos_Categorias (id_vehiculo,id_categoria) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaVehiculos();
CALL CrearTablaCategorias();
CALL CrearTablaRenovaciones();
CALL CrearTablaNotificaciones();
CALL CrearTablaUsuariosCategorias();
CALL CrearTablaVehiculosCategorias();

CREATE OR REPLACE VIEW Vista_RenovacionesPorUsuario AS
SELECT u.nombre AS usuario, v.placa AS vehiculo, r.fecha_renovacion
FROM Renovaciones r
JOIN Vehiculos v ON r.id_vehiculo = v.id_vehiculo
JOIN Vehiculos_Categorias vc ON vc.id_vehiculo = v.id_vehiculo
JOIN Usuarios_Categorias uc ON uc.id_categoria = vc.id_categoria
JOIN Usuarios u ON u.id_usuario = uc.id_usuario;

CREATE OR REPLACE VIEW Vista_VehiculosPorCategoria AS
SELECT c.nombre AS categoria, COUNT(vc.id_vehiculo) AS total
FROM Categorias c
LEFT JOIN Vehiculos_Categorias vc ON c.id_categoria = vc.id_categoria
GROUP BY c.id_categoria;

CREATE OR REPLACE VIEW Vista_NotificacionesPendientes AS
SELECT v.placa AS vehiculo, n.enviada
FROM Notificaciones n
JOIN Renovaciones r ON n.id_renovacion = r.id_renovacion
JOIN Vehiculos v ON r.id_vehiculo = v.id_vehiculo
WHERE n.enviada = 0;

CREATE OR REPLACE VIEW Vista_UsuariosConCategorias AS
SELECT u.nombre AS usuario, c.nombre AS categoria
FROM Usuarios u
JOIN Usuarios_Categorias uc ON u.id_usuario = uc.id_usuario
JOIN Categorias c ON uc.id_categoria = c.id_categoria;

CREATE OR REPLACE VIEW Vista_VehiculosConCategorias AS
SELECT v.placa AS vehiculo, c.nombre AS categoria
FROM Vehiculos v
JOIN Vehiculos_Categorias vc ON v.id_vehiculo = vc.id_vehiculo
JOIN Categorias c ON vc.id_categoria = c.id_categoria;

SELECT * FROM Vista_RenovacionesPorUsuario;
SELECT * FROM Vista_VehiculosPorCategoria;
SELECT * FROM Vista_NotificacionesPendientes;
SELECT * FROM Vista_UsuariosConCategorias;
SELECT * FROM Vista_VehiculosConCategorias;
