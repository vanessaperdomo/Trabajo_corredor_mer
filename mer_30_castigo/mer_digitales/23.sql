CREATE DATABASE IF NOT EXISTS PlanificacionTareas;
USE PlanificacionTareas;

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
    ('Mateo','mateo@gmail.com'),
    ('Isabella','isabella@gmail.com'),
    ('Tomas','tomas@gmail.com'),
    ('Sofia','sofia@gmail.com'),
    ('Gabriel','gabriel@gmail.com'),
    ('Valentina','valentina@gmail.com'),
    ('Benjamin','benjamin@gmail.com'),
    ('Martina','martina@gmail.com'),
    ('Emiliano','emiliano@gmail.com'),
    ('Renata','renata@gmail.com');
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
    ('Trabajo'),('Estudio'),('Personal'),('Salud'),('Hogar'),
    ('Finanzas'),('Proyecto'),('Urgente'),('Recurrente'),('Otro');
END;
//

CREATE PROCEDURE CrearTablaProyectos()
BEGIN
    DROP TABLE IF EXISTS Proyectos;
    CREATE TABLE Proyectos (
        id_proyecto INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL UNIQUE
    );
    INSERT INTO Proyectos (nombre) VALUES
    ('Lanzamiento App'),('Sitio Web'),('Investigacion UX'),
    ('Marketing Digital'),('Plan de Ventas'),
    ('Tesis'),('Reforma Hogar'),('Viaje Anual'),
    ('Curso Online'),('Organizacion Finanza');
END;
//

CREATE PROCEDURE CrearTablaTareas()
BEGIN
    DROP TABLE IF EXISTS Tareas;
    CREATE TABLE Tareas (
        id_tarea INT AUTO_INCREMENT PRIMARY KEY,
        titulo VARCHAR(100) NOT NULL,
        descripcion VARCHAR(200),
        duracion_min INT NOT NULL
    );
    INSERT INTO Tareas (titulo, descripcion, duracion_min) VALUES
    ('Correos','Revisar emails',15),
    ('SQL','Practicar SQL',45),
    ('Gimnasio','Ejercicio diario',60),
    ('Cocina','Limpiar cocina',30),
    ('Facturas','Pagar servicios',20),
    ('Informe','Redactar reporte',90),
    ('Reunion','Reunion semanal',40),
    ('CV','Actualizar hoja de vida',25),
    ('Viaje','Organizar viaje',50),
    ('Lectura','Leer libro',60);
END;
//

CREATE PROCEDURE CrearTablaComentarios()
BEGIN
    DROP TABLE IF EXISTS Comentarios;
    CREATE TABLE Comentarios (
        id_comentario INT AUTO_INCREMENT PRIMARY KEY,
        id_tarea INT NOT NULL,
        texto VARCHAR(200) NOT NULL,
        FOREIGN KEY (id_tarea) REFERENCES Tareas(id_tarea)
    );
    INSERT INTO Comentarios (id_tarea, texto) VALUES
    (1,'Muy util'),(2,'Debo repasar mas'),
    (3,'Me senti con energia'),(4,'Faltaron utensilios'),
    (5,'Todo pagado'),(6,'Falta revisar datos'),
    (7,'Buena participacion'),(8,'Listo'),
    (9,'Reservas hechas'),(10,'Lectura fluida');
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

CREATE PROCEDURE CrearTablaTareasProyectos()
BEGIN
    DROP TABLE IF EXISTS Tareas_Proyectos;
    CREATE TABLE Tareas_Proyectos (
        id_tarea INT NOT NULL,
        id_proyecto INT NOT NULL,
        PRIMARY KEY(id_tarea,id_proyecto),
        FOREIGN KEY (id_tarea) REFERENCES Tareas(id_tarea),
        FOREIGN KEY (id_proyecto) REFERENCES Proyectos(id_proyecto)
    );
    INSERT INTO Tareas_Proyectos (id_tarea, id_proyecto) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaCategorias();
CALL CrearTablaProyectos();
CALL CrearTablaTareas();
CALL CrearTablaComentarios();
CALL CrearTablaUsuariosCategorias();
CALL CrearTablaTareasProyectos();

CREATE OR REPLACE VIEW Vista_TareasPorUsuario AS
SELECT u.nombre AS usuario, t.titulo, t.duracion_min
FROM Tareas t
JOIN Usuarios_Categorias uc ON uc.id_usuario = t.id_tarea
JOIN Usuarios u ON uc.id_usuario = u.id_usuario;

CREATE OR REPLACE VIEW Vista_UsuariosPorCategoria AS
SELECT c.nombre AS categoria, COUNT(uc.id_usuario) AS total
FROM Categorias c
LEFT JOIN Usuarios_Categorias uc ON c.id_categoria = uc.id_categoria
GROUP BY c.id_categoria;

CREATE OR REPLACE VIEW Vista_TareasPorProyecto AS
SELECT p.nombre AS proyecto, COUNT(tp.id_tarea) AS total
FROM Proyectos p
LEFT JOIN Tareas_Proyectos tp ON p.id_proyecto = tp.id_proyecto
GROUP BY p.id_proyecto;

CREATE OR REPLACE VIEW Vista_ComentariosPorTarea AS
SELECT t.titulo, c.texto
FROM Comentarios c
JOIN Tareas t ON c.id_tarea = t.id_tarea;

CREATE OR REPLACE VIEW Vista_UsuariosConCategorias AS
SELECT u.nombre AS usuario, c.nombre AS categoria
FROM Usuarios u
JOIN Usuarios_Categorias uc ON u.id_usuario = uc.id_usuario
JOIN Categorias c ON uc.id_categoria = c.id_categoria;

SELECT * FROM Vista_TareasPorUsuario;
SELECT * FROM Vista_UsuariosPorCategoria;
SELECT * FROM Vista_TareasPorProyecto;
SELECT * FROM Vista_ComentariosPorTarea;
SELECT * FROM Vista_UsuariosConCategorias;
