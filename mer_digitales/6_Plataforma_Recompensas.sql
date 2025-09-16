CREATE DATABASE IF NOT EXISTS Plataforma_Recompensas;
USE Plataforma_Recompensas;

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

CREATE PROCEDURE CrearTablaRecompensas()
BEGIN
    DROP TABLE IF EXISTS Recompensas;
    CREATE TABLE Recompensas (
        id_recompensa INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        puntos INT NOT NULL
    );
    INSERT INTO Recompensas (nombre,puntos) VALUES
    ('Descuento 5%','50'),
    ('Descuento 10%','100'),
    ('Producto Gratis','150'),
    ('Envio Gratis','80'),
    ('Gift Card 20','200'),
    ('Gift Card 50','500'),
    ('Acceso Premium','300'),
    ('Entrada Evento','250'),
    ('Cupon Restaurante','120'),
    ('Cupon Cine','90');
END;
//

CREATE PROCEDURE CrearTablaTransacciones()
BEGIN
    DROP TABLE IF EXISTS Transacciones;
    CREATE TABLE Transacciones (
        id_transaccion INT AUTO_INCREMENT PRIMARY KEY,
        descripcion VARCHAR(200) NOT NULL,
        puntos INT NOT NULL,
        fecha DATE NOT NULL
    );
    INSERT INTO Transacciones (descripcion,puntos,fecha) VALUES
    ('Compra puntos',50,'2025-09-01'),
    ('Redencion recompensa',100,'2025-09-02'),
    ('Compra puntos',150,'2025-09-03'),
    ('Redencion recompensa',80,'2025-09-04'),
    ('Compra puntos',200,'2025-09-05'),
    ('Redencion recompensa',50,'2025-09-06'),
    ('Compra puntos',120,'2025-09-07'),
    ('Redencion recompensa',60,'2025-09-08'),
    ('Compra puntos',180,'2025-09-09'),
    ('Redencion recompensa',90,'2025-09-10');
END;
//

CREATE PROCEDURE CrearTablaCategorias()
BEGIN
    DROP TABLE IF EXISTS Categorias;
    CREATE TABLE Categorias (
        id_categoria INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL
    );
    INSERT INTO Categorias (nombre) VALUES
    ('Descuentos'),('Productos'),('Envios'),('Gift Cards'),('Servicios'),
    ('Eventos'),('Cine'),('Restaurantes'),('Acceso Premium'),('Otros');
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
    ('Luis Perez'),('Carla Gomez'),('Santiago Torres'),('Laura Diaz'),('Miguel Angel'),
    ('Elena Ruiz'),('Pedro Martinez'),('Sofia Hernandez'),('Kevin Culma'),('Ana Lopez');
END;
//

CREATE PROCEDURE CrearTablaUsuariosRecompensas()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Recompensas;
    CREATE TABLE Usuarios_Recompensas (
        id_usuario INT NOT NULL,
        id_recompensa INT NOT NULL,
        PRIMARY KEY(id_usuario,id_recompensa),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_recompensa) REFERENCES Recompensas(id_recompensa)
    );
    INSERT INTO Usuarios_Recompensas (id_usuario,id_recompensa) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaTransaccionesRecompensas()
BEGIN
    DROP TABLE IF EXISTS Transacciones_Recompensas;
    CREATE TABLE Transacciones_Recompensas (
        id_transaccion INT NOT NULL,
        id_recompensa INT NOT NULL,
        PRIMARY KEY(id_transaccion,id_recompensa),
        FOREIGN KEY (id_transaccion) REFERENCES Transacciones(id_transaccion),
        FOREIGN KEY (id_recompensa) REFERENCES Recompensas(id_recompensa)
    );
    INSERT INTO Transacciones_Recompensas (id_transaccion,id_recompensa) VALUES
    (1,1),(2,1),(3,2),(4,2),(5,3),
    (6,3),(7,4),(8,4),(9,5),(10,5);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaRecompensas();
CALL CrearTablaTransacciones();
CALL CrearTablaCategorias();
CALL CrearTablaAdministradores();
CALL CrearTablaUsuariosRecompensas();
CALL CrearTablaTransaccionesRecompensas();

CREATE VIEW Vista_TransaccionesPorRecompensa AS
SELECT r.nombre AS recompensa, t.descripcion, t.puntos, t.fecha
FROM Transacciones t
JOIN Transacciones_Recompensas tr ON t.id_transaccion = tr.id_transaccion
JOIN Recompensas r ON tr.id_recompensa = r.id_recompensa;

CREATE VIEW Vista_UsuariosPorRecompensa AS
SELECT r.nombre AS recompensa, COUNT(ur.id_usuario) AS total_usuarios
FROM Recompensas r
LEFT JOIN Usuarios_Recompensas ur ON r.id_recompensa = ur.id_recompensa
GROUP BY r.id_recompensa;

CREATE VIEW Vista_PuntosTotalesPorRecompensa AS
SELECT r.nombre AS recompensa, SUM(t.puntos) AS total_puntos
FROM Recompensas r
JOIN Transacciones_Recompensas tr ON r.id_recompensa = tr.id_recompensa
JOIN Transacciones t ON tr.id_transaccion = t.id_transaccion
GROUP BY r.id_recompensa;

CREATE VIEW Vista_UsuariosConRecompensas AS
SELECT u.nombre AS usuario, r.nombre AS recompensa
FROM Usuarios u
JOIN Usuarios_Recompensas ur ON u.id_usuario = ur.id_usuario
JOIN Recompensas r ON ur.id_recompensa = r.id_recompensa;

CREATE VIEW Vista_AdministradoresCategorias AS
SELECT a.nombre AS administrador, c.nombre AS categoria
FROM Administradores a
JOIN Categorias c ON a.id_admin = c.id_categoria;

SELECT * FROM Vista_TransaccionesPorRecompensa;
SELECT * FROM Vista_UsuariosPorRecompensa;
SELECT * FROM Vista_PuntosTotalesPorRecompensa;
SELECT * FROM Vista_UsuariosConRecompensas;
SELECT * FROM Vista_AdministradoresCategorias;
