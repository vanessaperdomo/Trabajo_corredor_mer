CREATE DATABASE IF NOT EXISTS RecordatoriosApp;
USE RecordatoriosApp;

DELIMITER //

CREATE PROCEDURE CrearTablaUsuarios()
BEGIN
    DROP TABLE IF EXISTS Usuarios;
    CREATE TABLE Usuarios (
        id_usuario INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100),
        email VARCHAR(100)
    );
    INSERT INTO Usuarios (nombre, email) VALUES
    ('Luis','luis@gmail.com'),
    ('Paula','paula@gmail.com'),
    ('Diego','diego@gmail.com'),
    ('Andres','andres@gmail.com'),
    ('Valeria','valeria@gmail.com'),
    ('Jorge','jorge@gmail.com'),
    ('Natalia','natalia@gmail.com'),
    ('Ricardo','ricardo@gmail.com'),
    ('Monica','monica@gmail.com'),
    ('Camila','camila@gmail.com');
END;
//

CREATE PROCEDURE CrearTablaCategorias()
BEGIN
    DROP TABLE IF EXISTS Categorias;
    CREATE TABLE Categorias (
        id_categoria INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50)
    );
    INSERT INTO Categorias (nombre) VALUES
    ('Trabajo'),('Personal'),('Salud'),('Estudios'),
    ('Finanzas'),('Eventos'),('Reuniones'),('Tareas'),
    ('Compras'),('Viajes');
END;
//

CREATE PROCEDURE CrearTablaEtiquetas()
BEGIN
    DROP TABLE IF EXISTS Etiquetas;
    CREATE TABLE Etiquetas (
        id_etiqueta INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50)
    );
    INSERT INTO Etiquetas (nombre) VALUES
    ('Urgente'),('Importante'),('Opcional'),('Hoy'),
    ('Esta Semana'),('Mensual'),('Anual'),('Prioridad Alta'),
    ('Recordar'),('Pendiente');
END;
//

CREATE PROCEDURE CrearTablaRecordatorios()
BEGIN
    DROP TABLE IF EXISTS Recordatorios;
    CREATE TABLE Recordatorios (
        id_recordatorio INT AUTO_INCREMENT PRIMARY KEY,
        titulo VARCHAR(100),
        fecha DATE
    );
    INSERT INTO Recordatorios (titulo, fecha) VALUES
    ('Cita medica','2025-10-01'),
    ('Pago de servicios','2025-09-25'),
    ('Reunion equipo','2025-09-23'),
    ('Estudiar SQL','2025-09-22'),
    ('Comprar regalos','2025-09-30'),
    ('Enviar informe','2025-09-24'),
    ('Clase de yoga','2025-09-26'),
    ('Pedir cita dentista','2025-09-27'),
    ('Viaje a Bogota','2025-10-05'),
    ('Renovar licencia','2025-10-10');
END;
//

CREATE PROCEDURE CrearTablaComentarios()
BEGIN
    DROP TABLE IF EXISTS Comentarios;
    CREATE TABLE Comentarios (
        id_comentario INT AUTO_INCREMENT PRIMARY KEY,
        id_recordatorio INT,
        texto VARCHAR(100)
    );
    INSERT INTO Comentarios (id_recordatorio, texto) VALUES
    (1, 'Llevar resultados'),
    (2, 'Pagar en linea'),
    (3, 'Preparar material'),
    (4, 'Revisar temas'),
    (5, 'Buscar descuentos'),
    (6, 'Revisar informe'),
    (7, 'Llevar ropa'),
    (8, 'Confirmar cita'),
    (9, 'Revisar vuelo'),
    (10, 'Llevar documentos');
END;
//

CREATE PROCEDURE CrearTablaUsuariosCategorias()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Categorias;
    CREATE TABLE Usuarios_Categorias (
        id_usuario INT,
        id_categoria INT,
        PRIMARY KEY(id_usuario, id_categoria),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
    );
    INSERT INTO Usuarios_Categorias (id_usuario, id_categoria) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaRecordatoriosEtiquetas()
BEGIN
    DROP TABLE IF EXISTS Recordatorios_Etiquetas;
    CREATE TABLE Recordatorios_Etiquetas (
        id_recordatorio INT,
        id_etiqueta INT,
        PRIMARY KEY(id_recordatorio, id_etiqueta),
        FOREIGN KEY (id_recordatorio) REFERENCES Recordatorios(id_recordatorio),
        FOREIGN KEY (id_etiqueta) REFERENCES Etiquetas(id_etiqueta)
    );
    INSERT INTO Recordatorios_Etiquetas (id_recordatorio, id_etiqueta) VALUES
    (1,1),(2,2),(3,2),(4,4),(5,5),
    (6,1),(7,4),(8,9),(9,10),(10,1);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaCategorias();
CALL CrearTablaEtiquetas();
CALL CrearTablaRecordatorios();
CALL CrearTablaComentarios();
CALL CrearTablaUsuariosCategorias();
CALL CrearTablaRecordatoriosEtiquetas();

CREATE OR REPLACE VIEW Vista_RecordatoriosPorUsuario AS
SELECT u.nombre AS usuario, r.titulo
FROM Recordatorios r
JOIN Usuarios_Categorias uc ON r.id_recordatorio = uc.id_usuario
JOIN Usuarios u ON uc.id_usuario = u.id_usuario;

CREATE OR REPLACE VIEW Vista_RecordatoriosPorCategoria AS
SELECT c.nombre AS categoria, COUNT(uc.id_usuario) AS total
FROM Categorias c
LEFT JOIN Usuarios_Categorias uc ON c.id_categoria = uc.id_categoria
GROUP BY c.id_categoria;

CREATE OR REPLACE VIEW Vista_EtiquetasPorRecordatorio AS
SELECT r.titulo AS recordatorio, COUNT(re.id_etiqueta) AS total
FROM Recordatorios r
LEFT JOIN Recordatorios_Etiquetas re ON r.id_recordatorio = re.id_recordatorio
GROUP BY r.id_recordatorio;

CREATE OR REPLACE VIEW Vista_ComentariosPendientes AS
SELECT r.titulo, c.texto
FROM Comentarios c
JOIN Recordatorios r ON c.id_recordatorio = r.id_recordatorio;

CREATE OR REPLACE VIEW Vista_UsuariosConCategorias AS
SELECT u.nombre AS usuario, c.nombre AS categoria
FROM Usuarios u
JOIN Usuarios_Categorias uc ON u.id_usuario = uc.id_usuario
JOIN Categorias c ON uc.id_categoria = c.id_categoria;

SELECT * FROM Vista_RecordatoriosPorUsuario;
SELECT * FROM Vista_RecordatoriosPorCategoria;
SELECT * FROM Vista_EtiquetasPorRecordatorio;
SELECT * FROM Vista_ComentariosPendientes;
SELECT * FROM Vista_UsuariosConCategorias;
