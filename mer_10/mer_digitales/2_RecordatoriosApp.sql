CREATE DATABASE IF NOT EXISTS RecordatoriosApp;
USE RecordatoriosApp;

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

CREATE PROCEDURE CrearTablaCategorias()
BEGIN
    DROP TABLE IF EXISTS Categorias;
    CREATE TABLE Categorias (
        id_categoria INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL UNIQUE
    );
    INSERT INTO Categorias (nombre) VALUES
    ('Trabajo'),('Personal'),('Salud'),('Estudio'),('Hogar'),
    ('Viajes'),('Finanzas'),('Eventos'),('Compras'),('Otros');
END;
//

CREATE PROCEDURE CrearTablaPrioridades()
BEGIN
    DROP TABLE IF EXISTS Prioridades;
    CREATE TABLE Prioridades (
        id_prioridad INT AUTO_INCREMENT PRIMARY KEY,
        nivel VARCHAR(50) NOT NULL UNIQUE
    );
    INSERT INTO Prioridades (nivel) VALUES
    ('Alta'),('Media'),('Baja'),('Urgente'),('Normal'),
    ('Baja1'),('Baja2'),('Media1'),('Media2'),('Alta1');
END;
//

CREATE PROCEDURE CrearTablaRecordatorios()
BEGIN
    DROP TABLE IF EXISTS Recordatorios;
    CREATE TABLE Recordatorios (
        id_recordatorio INT AUTO_INCREMENT PRIMARY KEY,
        titulo VARCHAR(100) NOT NULL,
        descripcion VARCHAR(200),
        fecha_recordatorio DATETIME NOT NULL
    );
    INSERT INTO Recordatorios (titulo,descripcion,fecha_recordatorio) VALUES
    ('Reunion trabajo','Reunion con equipo','2025-09-20 10:00'),
    ('Comprar viveres','Ir al supermercado','2025-09-16 17:00'),
    ('Cita medica','Revision anual','2025-09-18 09:00'),
    ('Estudiar SQL','Practicar procedimientos','2025-09-17 15:00'),
    ('Lavar ropa','Separar ropa blanca','2025-09-16 19:00'),
    ('Planificar viaje','Reservar hoteles','2025-09-21 12:00'),
    ('Pagar facturas','Electricidad y agua','2025-09-16 20:00'),
    ('Cumpleanio amigo','Comprar regalo','2025-09-22 18:00'),
    ('Ir de compras','Ropa y accesorios','2025-09-19 16:00'),
    ('Organizar documentos','Archivar papeles','2025-09-23 14:00');
END;
//

CREATE PROCEDURE CrearTablaNotificaciones()
BEGIN
    DROP TABLE IF EXISTS Notificaciones;
    CREATE TABLE Notificaciones (
        id_notificacion INT AUTO_INCREMENT PRIMARY KEY,
        id_recordatorio INT NOT NULL,
        enviada TINYINT(1) DEFAULT 0,
        FOREIGN KEY (id_recordatorio) REFERENCES Recordatorios(id_recordatorio)
    );
    INSERT INTO Notificaciones (id_recordatorio,enviada) VALUES
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
    (6,6),(7,7),(8,7),(9,8),(10,9);
END;
//

CREATE PROCEDURE CrearTablaRecordatoriosPrioridades()
BEGIN
    DROP TABLE IF EXISTS Recordatorios_Prioridades;
    CREATE TABLE Recordatorios_Prioridades (
        id_recordatorio INT NOT NULL,
        id_prioridad INT NOT NULL,
        PRIMARY KEY(id_recordatorio,id_prioridad),
        FOREIGN KEY (id_recordatorio) REFERENCES Recordatorios(id_recordatorio),
        FOREIGN KEY (id_prioridad) REFERENCES Prioridades(id_prioridad)
    );
    INSERT INTO Recordatorios_Prioridades (id_recordatorio,id_prioridad) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaCategorias();
CALL CrearTablaPrioridades();
CALL CrearTablaRecordatorios();
CALL CrearTablaNotificaciones();
CALL CrearTablaUsuariosCategorias();
CALL CrearTablaRecordatoriosPrioridades();

CREATE VIEW Vista_RecordatoriosPorUsuario AS
SELECT u.nombre AS usuario, r.titulo, r.fecha_recordatorio
FROM Recordatorios r
JOIN Usuarios_Categorias uc ON uc.id_usuario = r.id_recordatorio
JOIN Usuarios u ON uc.id_usuario = u.id_usuario;

CREATE VIEW Vista_RecordatoriosPorCategoria AS
SELECT c.nombre AS categoria, COUNT(uc.id_usuario) AS total
FROM Categorias c
LEFT JOIN Usuarios_Categorias uc ON c.id_categoria = uc.id_categoria
GROUP BY c.id_categoria;

CREATE VIEW Vista_RecordatoriosPorPrioridad AS
SELECT p.nivel AS prioridad, COUNT(rp.id_recordatorio) AS total
FROM Prioridades p
LEFT JOIN Recordatorios_Prioridades rp ON p.id_prioridad = rp.id_prioridad
GROUP BY p.id_prioridad;

CREATE VIEW Vista_NotificacionesPendientes AS
SELECT r.titulo, n.enviada
FROM Notificaciones n
JOIN Recordatorios r ON n.id_recordatorio = r.id_recordatorio
WHERE n.enviada = 0;

CREATE VIEW Vista_UsuariosConCategorias AS
SELECT u.nombre AS usuario, c.nombre AS categoria
FROM Usuarios u
JOIN Usuarios_Categorias uc ON u.id_usuario = uc.id_usuario
JOIN Categorias c ON uc.id_categoria = c.id_categoria;

SELECT * FROM Vista_RecordatoriosPorUsuario;
SELECT * FROM Vista_RecordatoriosPorCategoria;
SELECT * FROM Vista_RecordatoriosPorPrioridad;
SELECT * FROM Vista_NotificacionesPendientes;
SELECT * FROM Vista_UsuariosConCategorias;
