CREATE DATABASE IF NOT EXISTS ComprasLocalesApp;
USE ComprasLocalesApp;

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
    ('Luis','luis@gmail.com'),
    ('Carolina','carolina@gmail.com'),
    ('Mateo','mateo@gmail.com'),
    ('Daniela','daniela@gmail.com'),
    ('Andres','andres@gmail.com'),
    ('Valeria','valeria@gmail.com'),
    ('Jorge','jorge@gmail.com'),
    ('Paula','paula@gmail.com'),
    ('Felipe','felipe@gmail.com'),
    ('Isabela','isabela@gmail.com');
END;
//

CREATE PROCEDURE CrearTablaNegocios()
BEGIN
    DROP TABLE IF EXISTS Negocios;
    CREATE TABLE Negocios (
        id_negocio INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL UNIQUE
    );
    INSERT INTO Negocios (nombre) VALUES
    ('Panaderia La Espiga'),
    ('Verduras El Campo'),
    ('Carnes Don Julio'),
    ('Cafe Aroma'),
    ('Ropa Moderna'),
    ('Libreria Central'),
    ('Tecnologia Local'),
    ('Floristeria Primavera'),
    ('Heladeria Dulce'),
    ('Jugueteria Alegria');
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
    ('Alimentos'),('Bebidas'),('Ropa'),('Tecnologia'),('Hogar'),
    ('Libros'),('Juguetes'),('Flores'),('Salud'),('Otros');
END;
//

CREATE PROCEDURE CrearTablaPedidos()
BEGIN
    DROP TABLE IF EXISTS Pedidos;
    CREATE TABLE Pedidos (
        id_pedido INT AUTO_INCREMENT PRIMARY KEY,
        titulo VARCHAR(100) NOT NULL,
        descripcion VARCHAR(200),
        fecha_pedido DATETIME NOT NULL
    );
    INSERT INTO Pedidos (titulo,descripcion,fecha_pedido) VALUES
    ('Compra pan','Pan integral y baguette','2025-09-20 10:00'),
    ('Frutas frescas','Manzanas y naranjas','2025-09-16 17:00'),
    ('Carne de res','Corte para asado','2025-09-18 09:00'),
    ('Cafe premium','Granos seleccionados','2025-09-17 15:00'),
    ('Camisa hombre','Talla M','2025-09-16 19:00'),
    ('Libro de cocina','Recetas locales','2025-09-21 12:00'),
    ('Celular usado','Gama media','2025-09-16 20:00'),
    ('Ramo flores','Flores variadas','2025-09-22 18:00'),
    ('Helados','Varios sabores','2025-09-19 16:00'),
    ('Juguete educativo','Para nino 5 anos','2025-09-23 14:00');
END;
//

CREATE PROCEDURE CrearTablaNotificaciones()
BEGIN
    DROP TABLE IF EXISTS Notificaciones;
    CREATE TABLE Notificaciones (
        id_notificacion INT AUTO_INCREMENT PRIMARY KEY,
        id_pedido INT NOT NULL,
        enviada TINYINT(1) DEFAULT 0,
        FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido)
    );
    INSERT INTO Notificaciones (id_pedido,enviada) VALUES
    (1,0),(2,0),(3,0),(4,0),(5,0),
    (6,0),(7,0),(8,0),(9,0),(10,0);
END;
//

CREATE PROCEDURE CrearTablaClientesNegocios()
BEGIN
    DROP TABLE IF EXISTS Clientes_Negocios;
    CREATE TABLE Clientes_Negocios (
        id_cliente INT NOT NULL,
        id_negocio INT NOT NULL,
        PRIMARY KEY(id_cliente,id_negocio),
        FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
        FOREIGN KEY (id_negocio) REFERENCES Negocios(id_negocio)
    );
    INSERT INTO Clientes_Negocios (id_cliente,id_negocio) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaPedidosCategorias()
BEGIN
    DROP TABLE IF EXISTS Pedidos_Categorias;
    CREATE TABLE Pedidos_Categorias (
        id_pedido INT NOT NULL,
        id_categoria INT NOT NULL,
        PRIMARY KEY(id_pedido,id_categoria),
        FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido),
        FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
    );
    INSERT INTO Pedidos_Categorias (id_pedido,id_categoria) VALUES
    (1,1),(2,1),(3,1),(4,2),(5,3),
    (6,6),(7,4),(8,8),(9,2),(10,7);
END;
//

DELIMITER ;

CALL CrearTablaClientes();
CALL CrearTablaNegocios();
CALL CrearTablaCategorias();
CALL CrearTablaPedidos();
CALL CrearTablaNotificaciones();
CALL CrearTablaClientesNegocios();
CALL CrearTablaPedidosCategorias();

CREATE OR REPLACE VIEW Vista_PedidosPorCliente AS
SELECT c.nombre AS cliente, p.titulo, p.fecha_pedido
FROM Pedidos p
JOIN Clientes_Negocios cn ON cn.id_cliente = p.id_pedido
JOIN Clientes c ON cn.id_cliente = c.id_cliente;

CREATE OR REPLACE VIEW Vista_PedidosPorNegocio AS
SELECT n.nombre AS negocio, COUNT(cn.id_cliente) AS total
FROM Negocios n
LEFT JOIN Clientes_Negocios cn ON n.id_negocio = cn.id_negocio
GROUP BY n.id_negocio;

CREATE OR REPLACE VIEW Vista_PedidosPorCategoria AS
SELECT cat.nombre AS categoria, COUNT(pc.id_pedido) AS total
FROM Categorias cat
LEFT JOIN Pedidos_Categorias pc ON cat.id_categoria = pc.id_categoria
GROUP BY cat.id_categoria;

CREATE OR REPLACE VIEW Vista_NotificacionesPendientes AS
SELECT p.titulo, n.enviada
FROM Notificaciones n
JOIN Pedidos p ON n.id_pedido = p.id_pedido
WHERE n.enviada = 0;

CREATE OR REPLACE VIEW Vista_ClientesConNegocios AS
SELECT c.nombre AS cliente, n.nombre AS negocio
FROM Clientes c
JOIN Clientes_Negocios cn ON c.id_cliente = cn.id_cliente
JOIN Negocios n ON cn.id_negocio = n.id_negocio;

SELECT * FROM Vista_PedidosPorCliente;
SELECT * FROM Vista_PedidosPorNegocio;
SELECT * FROM Vista_PedidosPorCategoria;
SELECT * FROM Vista_NotificacionesPendientes;
SELECT * FROM Vista_ClientesConNegocios;
