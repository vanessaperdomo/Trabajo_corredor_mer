CREATE DATABASE IF NOT EXISTS InventariosFarmacias;
USE InventariosFarmacias;

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
    ('David','david@gmail.com'),
    ('Johan','johan@gmail.com'),
    ('Vanessa','vanessa@gmail.com'),
    ('Stiven','stiven@gmail.com'),
    ('Andres','andres@gmail.com'),
    ('Valeria','valeria@gmail.com'),
    ('Jorge','jorge@gmail.com'),
    ('Natalia','natalia@gmail.com'),
    ('Ricardo','ricardo@gmail.com'),
    ('Monica','monica@gmail.com');
END;
//

CREATE PROCEDURE CrearTablaMedicamentos()
BEGIN
    DROP TABLE IF EXISTS Medicamentos;
    CREATE TABLE Medicamentos (
        id_medicamento INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        descripcion VARCHAR(200),
        fecha_caducidad DATE NOT NULL,
        stock INT NOT NULL
    );
    INSERT INTO Medicamentos (nombre,descripcion,fecha_caducidad,stock) VALUES
    ('Paracetamol','Analgesico','2026-01-15',100),
    ('Ibuprofeno','Antiinflamatorio','2026-02-10',80),
    ('Amoxicilina','Antibiotico','2025-12-05',50),
    ('Loratadina','Antihistaminico','2026-03-12',60),
    ('Omeprazol','Protector gastrico','2025-11-20',90),
    ('Metformina','Diabetes','2026-04-18',70),
    ('Losartan','Hipertension','2026-05-25',65),
    ('Salbutamol','Broncodilatador','2025-10-30',40),
    ('Diclofenaco','Dolor muscular','2026-06-05',85),
    ('Acetaminofen','Fiebre','2025-09-22',120);
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
    ('Analgesicos'),('Antibioticos'),('Antiinflamatorios'),('Antihistaminicos'),('Gastrointestinales'),
    ('Diabetes'),('Hipertension'),('Respiratorios'),('Vitaminas'),('Otros');
END;
//

CREATE PROCEDURE CrearTablaProveedores()
BEGIN
    DROP TABLE IF EXISTS Proveedores;
    CREATE TABLE Proveedores (
        id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        telefono VARCHAR(50)
    );
    INSERT INTO Proveedores (nombre,telefono) VALUES
    ('FarmaPlus','3001112233'),
    ('DistribuidoraMed','3002223344'),
    ('SaludGlobal','3003334455'),
    ('PharmaExpress','3004445566'),
    ('VitalCare','3005556677'),
    ('MedDistrib','3006667788'),
    ('BioFarm','3007778899'),
    ('Farmacorp','3008889900'),
    ('SaludTotal','3009990011'),
    ('MedicFast','3000001122');
END;
//

CREATE PROCEDURE CrearTablaNotificaciones()
BEGIN
    DROP TABLE IF EXISTS Notificaciones;
    CREATE TABLE Notificaciones (
        id_notificacion INT AUTO_INCREMENT PRIMARY KEY,
        id_medicamento INT NOT NULL,
        tipo VARCHAR(50) NOT NULL,
        enviada TINYINT(1) DEFAULT 0,
        FOREIGN KEY (id_medicamento) REFERENCES Medicamentos(id_medicamento)
    );
    INSERT INTO Notificaciones (id_medicamento,tipo,enviada) VALUES
    (1,'Stock bajo',0),(2,'Proxima caducidad',0),(3,'Stock bajo',0),(4,'Proxima caducidad',0),(5,'Stock bajo',0),
    (6,'Proxima caducidad',0),(7,'Stock bajo',0),(8,'Proxima caducidad',0),(9,'Stock bajo',0),(10,'Proxima caducidad',0);
END;
//

CREATE PROCEDURE CrearTablaMedicamentosCategorias()
BEGIN
    DROP TABLE IF EXISTS Medicamentos_Categorias;
    CREATE TABLE Medicamentos_Categorias (
        id_medicamento INT NOT NULL,
        id_categoria INT NOT NULL,
        PRIMARY KEY(id_medicamento,id_categoria),
        FOREIGN KEY (id_medicamento) REFERENCES Medicamentos(id_medicamento),
        FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria)
    );
    INSERT INTO Medicamentos_Categorias (id_medicamento,id_categoria) VALUES
    (1,1),(2,3),(3,2),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,3),(10,1);
END;
//

CREATE PROCEDURE CrearTablaMedicamentosProveedores()
BEGIN
    DROP TABLE IF EXISTS Medicamentos_Proveedores;
    CREATE TABLE Medicamentos_Proveedores (
        id_medicamento INT NOT NULL,
        id_proveedor INT NOT NULL,
        PRIMARY KEY(id_medicamento,id_proveedor),
        FOREIGN KEY (id_medicamento) REFERENCES Medicamentos(id_medicamento),
        FOREIGN KEY (id_proveedor) REFERENCES Proveedores(id_proveedor)
    );
    INSERT INTO Medicamentos_Proveedores (id_medicamento,id_proveedor) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaMedicamentos();
CALL CrearTablaCategorias();
CALL CrearTablaProveedores();
CALL CrearTablaNotificaciones();
CALL CrearTablaMedicamentosCategorias();
CALL CrearTablaMedicamentosProveedores();

CREATE OR REPLACE VIEW Vista_MedicamentosPorCategoria AS
SELECT c.nombre AS categoria, COUNT(mc.id_medicamento) AS total
FROM Categorias c
LEFT JOIN Medicamentos_Categorias mc ON c.id_categoria = mc.id_categoria
GROUP BY c.id_categoria;

CREATE OR REPLACE VIEW Vista_NotificacionesPendientes AS
SELECT m.nombre AS medicamento, n.tipo, n.enviada
FROM Notificaciones n
JOIN Medicamentos m ON n.id_medicamento = m.id_medicamento
WHERE n.enviada = 0;

CREATE OR REPLACE VIEW Vista_StockBajo AS
SELECT nombre AS medicamento, stock
FROM Medicamentos
WHERE stock < 60;

CREATE OR REPLACE VIEW Vista_ProximosAVencer AS
SELECT nombre AS medicamento, fecha_caducidad
FROM Medicamentos
WHERE fecha_caducidad < DATE_ADD(CURDATE(), INTERVAL 90 DAY);

CREATE OR REPLACE VIEW Vista_MedicamentosPorProveedor AS
SELECT p.nombre AS proveedor, COUNT(mp.id_medicamento) AS total
FROM Proveedores p
LEFT JOIN Medicamentos_Proveedores mp ON p.id_proveedor = mp.id_proveedor
GROUP BY p.id_proveedor;

SELECT * FROM Vista_MedicamentosPorCategoria;
SELECT * FROM Vista_NotificacionesPendientes;
SELECT * FROM Vista_StockBajo;
SELECT * FROM Vista_ProximosAVencer;
SELECT * FROM Vista_MedicamentosPorProveedor;