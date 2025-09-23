CREATE DATABASE IF NOT EXISTS SistemaRevisionProductos;
USE SistemaRevisionProductos;

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
    ('Lucas','lucas@gmail.com'),
    ('Valeria','valeria@gmail.com'),
    ('Esteban','esteban@gmail.com'),
    ('Daniela','daniela@gmail.com'),
    ('Ricardo','ricardo@gmail.com'),
    ('Alejandra','alejandra@gmail.com'),
    ('Hector','hector@gmail.com'),
    ('Melissa','melissa@gmail.com'),
    ('Gabriel','gabriel@gmail.com'),
    ('Patricia','patricia@gmail.com');
END;
//

CREATE PROCEDURE CrearTablaProductos()
BEGIN
    DROP TABLE IF EXISTS Productos;
    CREATE TABLE Productos (
        id_producto INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        descripcion VARCHAR(200)
    );
    INSERT INTO Productos (nombre,descripcion) VALUES
    ('Auriculares','Bluetooth y cancelacion de ruido'),
    ('Smartphone','Pantalla OLED y camara avanzada'),
    ('Portatil','Ligero y de alto rendimiento'),
    ('Cafetera','Programable y de acero inoxidable'),
    ('Silla ergonomica','Ideal para oficina'),
    ('Teclado mecanico','Retroiluminado'),
    ('Camara digital','Alta resolucion'),
    ('Tablet','Pantalla de 10 pulgadas'),
    ('Monitor','Resolucion 4K'),
    ('Reloj inteligente','Monitoreo de actividad');
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
    ('Electronica'),('Hogar'),('Oficina'),('Deporte'),('Moda'),
    ('Juguetes'),('Salud'),('Automotriz'),('Libros'),('Otros');
END;
//

CREATE PROCEDURE CrearTablaResenas()
BEGIN
    DROP TABLE IF EXISTS Resenas;
    CREATE TABLE Resenas (
        id_resena INT AUTO_INCREMENT PRIMARY KEY,
        id_usuario INT NOT NULL,
        id_producto INT NOT NULL,
        comentario VARCHAR(250),
        fecha_resena DATETIME NOT NULL,
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
    );
    INSERT INTO Resenas (id_usuario,id_producto,comentario,fecha_resena) VALUES
    (1,1,'Excelente sonido','2025-09-20 10:00'),
    (2,2,'Camara de gran calidad','2025-09-18 15:00'),
    (3,3,'Rendimiento impecable','2025-09-19 11:00'),
    (4,4,'Cafe delicioso','2025-09-17 09:00'),
    (5,5,'Muy comoda','2025-09-16 14:00'),
    (6,6,'Teclado con gran respuesta','2025-09-21 12:00'),
    (7,7,'Fotos nitidas','2025-09-22 18:00'),
    (8,8,'Ideal para leer','2025-09-23 13:00'),
    (9,9,'Colores brillantes','2025-09-20 17:00'),
    (10,10,'Bateria duradera','2025-09-21 19:00');
END;
//

CREATE PROCEDURE CrearTablaValoraciones()
BEGIN
    DROP TABLE IF EXISTS Valoraciones;
    CREATE TABLE Valoraciones (
        id_valoracion INT AUTO_INCREMENT PRIMARY KEY,
        id_resena INT NOT NULL,
        puntuacion INT NOT NULL,
        FOREIGN KEY (id_resena) REFERENCES Resenas(id_resena)
    );
    INSERT INTO Valoraciones (id_resena,puntuacion) VALUES
    (1,5),(2,4),(3,5),(4,4),(5,5),
    (6,4),(7,5),(8,4),(9,5),(10,5);
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
    (1,1),(2,1),(3,2),(4,3),(5,4),
    (6,5),(7,6),(8,7),(9,8),(10,9);
END;
//

CREATE PROCEDURE CrearTablaProductosCategorias()
BEGIN
    DROP TABLE IF EXISTS Productos_Categorias;
    CREATE TABLE Productos_Categorias (
        id_producto INT NOT NULL,
        id_categoria INT NOT NULL,
        PRIMARY KEY(id_producto,id_categoria),
        FOREIGN KEY (id_producto) REFERENCES Productos(id_producto),
        FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
    );
    INSERT INTO Productos_Categorias (id_producto,id_categoria) VALUES
    (1,1),(2,1),(3,1),(4,2),(5,3),
    (6,1),(7,1),(8,1),(9,1),(10,1);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaProductos();
CALL CrearTablaCategorias();
CALL CrearTablaResenas();
CALL CrearTablaValoraciones();
CALL CrearTablaUsuariosCategorias();
CALL CrearTablaProductosCategorias();

CREATE OR REPLACE VIEW Vista_ResenasPorUsuario AS
SELECT u.nombre AS usuario, p.nombre AS producto, r.comentario, r.fecha_resena
FROM Resenas r
JOIN Usuarios u ON r.id_usuario = u.id_usuario
JOIN Productos p ON r.id_producto = p.id_producto;

CREATE OR REPLACE VIEW Vista_ValoracionPromedioPorProducto AS
SELECT p.nombre AS producto, AVG(v.puntuacion) AS promedio
FROM Productos p
LEFT JOIN Resenas r ON p.id_producto = r.id_producto
LEFT JOIN Valoraciones v ON r.id_resena = v.id_resena
GROUP BY p.id_producto;

CREATE OR REPLACE VIEW Vista_UsuariosConCategorias AS
SELECT u.nombre AS usuario, c.nombre AS categoria
FROM Usuarios u
JOIN Usuarios_Categorias uc ON u.id_usuario = uc.id_usuario
JOIN Categorias c ON uc.id_categoria = c.id_categoria;

CREATE OR REPLACE VIEW Vista_ProductosPorCategoria AS
SELECT c.nombre AS categoria, COUNT(pc.id_producto) AS total_productos
FROM Categorias c
LEFT JOIN Productos_Categorias pc ON c.id_categoria = pc.id_categoria
GROUP BY c.id_categoria;

CREATE OR REPLACE VIEW vista_usuarios_con_proyectos AS
SELECT u.id_usuario, u.nombre, u.email, COUNT(up.id_proyecto) AS total_proyectos
FROM Usuarios u
JOIN Usuario_Proyecto up ON u.id_usuario = up.id_usuario
GROUP BY u.id_usuario, u.nombre, u.email
ORDER BY total_proyectos DESC;

SELECT * FROM Vista_ResenasPorUsuario;
SELECT * FROM Vista_ValoracionPromedioPorProducto;
SELECT * FROM Vista_UsuariosConCategorias;
SELECT * FROM Vista_ProductosPorCategoria;
SELECT * FROM vista_usuarios_con_proyectos;