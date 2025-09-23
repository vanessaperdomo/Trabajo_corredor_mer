CREATE DATABASE IF NOT EXISTS CocinaApp;
USE CocinaApp;

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
    ('Paula','paula@gmail.com'),
    ('Diego','diego@gmail.com'),
    ('Andres','andres@gmail.com'),
    ('Valeria','valeria@gmail.com'),
    ('Jorge','jorge@gmail.com'),
    ('Natalia','natalia@gmail.com'),
    ('Ricardo','ricardo@gmail.com'),
    ('Monica','monica@gmail.com');
    ('Camila','camila@gmail.com'),

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
    ('Desayuno'),('Almuerzo'),('Cena'),('Postres'),('Bebidas'),
    ('Snacks'),('Vegano'),('SinGluten'),('Rapidas'),('Internacional');
END;
//

CREATE PROCEDURE CrearTablaIngredientes()
BEGIN
    DROP TABLE IF EXISTS Ingredientes;
    CREATE TABLE Ingredientes (
        id_ingrediente INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL UNIQUE
    );
    INSERT INTO Ingredientes (nombre) VALUES
    ('Harina'),('Azucar'),('Leche'),('Huevo'),('Pollo'),
    ('Carne'),('Pescado'),('Verduras'),('Frutas'),('Aceite');
END;
//

CREATE PROCEDURE CrearTablaRecetas()
BEGIN
    DROP TABLE IF EXISTS Recetas;
    CREATE TABLE Recetas (
        id_receta INT AUTO_INCREMENT PRIMARY KEY,
        titulo VARCHAR(100) NOT NULL,
        descripcion VARCHAR(200),
        tiempo_preparacion INT NOT NULL
    );
    INSERT INTO Recetas (titulo,descripcion,tiempo_preparacion) VALUES
    ('Panqueques','Receta de panqueques','20'),
    ('Ensalada','Ensalada mixta','15'),
    ('Pollo al horno','Pollo con especias','60'),
    ('Pasta carbonara','Pasta con salsa','30'),
    ('Tarta de frutas','Postre de frutas','45'),
    ('Smoothie','Bebida de frutas','10'),
    ('Pizza casera','Pizza de queso','50'),
    ('Sopa de verduras','Sopa saludable','40'),
    ('Brownie','Postre de chocolate','35'),
    ('Sandwich','Sandwich rapido','10');
END;
//

CREATE PROCEDURE CrearTablaComentarios()
BEGIN
    DROP TABLE IF EXISTS Comentarios;
    CREATE TABLE Comentarios (
        id_comentario INT AUTO_INCREMENT PRIMARY KEY,
        id_receta INT NOT NULL,
        texto VARCHAR(200) NOT NULL,
        FOREIGN KEY (id_receta) REFERENCES Recetas(id_receta)
    );
    INSERT INTO Comentarios (id_receta,texto) VALUES
    (1,'Excelente'),(2,'Muy facil'),(3,'Delicioso'),(4,'Rico'),
    (5,'Buen sabor'),(6,'Refrescante'),(7,'Increible'),
    (8,'Caliente y rico'),(9,'Dulce perfecto'),(10,'Rapido');
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
    (6,6),(7,7),(8,7),(9,8),(10,9);
END;
//

CREATE PROCEDURE CrearTablaRecetasIngredientes()
BEGIN
    DROP TABLE IF EXISTS Recetas_Ingredientes;
    CREATE TABLE Recetas_Ingredientes (
        id_receta INT NOT NULL,
        id_ingrediente INT NOT NULL,
        PRIMARY KEY(id_receta,id_ingrediente),
        FOREIGN KEY (id_receta) REFERENCES Recetas(id_receta),
        FOREIGN KEY (id_ingrediente) REFERENCES Ingredientes(id_ingrediente)
    );
    INSERT INTO Recetas_Ingredientes (id_receta,id_ingrediente) VALUES
    (1,1),(1,2),(1,3),(2,8),(3,5),
    (4,6),(5,9),(6,9),(7,1),(8,8);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaCategorias();
CALL CrearTablaIngredientes();
CALL CrearTablaRecetas();
CALL CrearTablaComentarios();
CALL CrearTablaUsuariosCategorias();
CALL CrearTablaRecetasIngredientes();

CREATE OR REPLACE VIEW Vista_RecetasPorUsuario AS
SELECT u.nombre AS usuario, r.titulo, r.tiempo_preparacion
FROM Recetas r
JOIN Usuarios_Categorias uc ON uc.id_usuario = r.id_receta
JOIN Usuarios u ON uc.id_usuario = u.id_usuario;

CREATE OR REPLACE VIEW Vista_RecetasPorCategoria AS
SELECT c.nombre AS categoria, COUNT(uc.id_usuario) AS total
FROM Categorias c
LEFT JOIN Usuarios_Categorias uc ON c.id_categoria = uc.id_categoria
GROUP BY c.id_categoria;

CREATE OR REPLACE VIEW Vista_IngredientesPorReceta AS
SELECT r.titulo AS receta, COUNT(ri.id_ingrediente) AS total
FROM Recetas r
LEFT JOIN Recetas_Ingredientes ri ON r.id_receta = ri.id_receta
GROUP BY r.id_receta;

CREATE OR REPLACE VIEW Vista_ComentariosPendientes AS
SELECT r.titulo, c.texto
FROM Comentarios c
JOIN Recetas r ON c.id_receta = r.id_receta;

CREATE OR REPLACE VIEW Vista_UsuariosConCategorias AS
SELECT u.nombre AS usuario, c.nombre AS categoria
FROM Usuarios u
JOIN Usuarios_Categorias uc ON u.id_usuario = uc.id_usuario
JOIN Categorias c ON uc.id_categoria = c.id_categoria;

SELECT * FROM Vista_RecetasPorUsuario;
SELECT * FROM Vista_RecetasPorCategoria;
SELECT * FROM Vista_IngredientesPorReceta;
SELECT * FROM Vista_ComentariosPendientes;
SELECT * FROM Vista_UsuariosConCategorias;
