CREATE DATABASE IF NOT EXISTS CompraBoletos;
USE CompraBoletos;

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

CREATE PROCEDURE CrearTablaEventos()
BEGIN
    DROP TABLE IF EXISTS Eventos;
    CREATE TABLE Eventos (
        id_evento INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        fecha DATE NOT NULL,
        ubicacion VARCHAR(100) NOT NULL
    );
    INSERT INTO Eventos (nombre,fecha,ubicacion) VALUES
    ('Concierto Rock','2025-09-15','Estadio Central'),
    ('Teatro Comedia','2025-09-16','Teatro Principal'),
    ('Concierto Jazz','2025-09-17','Sala de Conciertos'),
    ('Feria Artes','2025-09-18','Centro Cultural'),
    ('Partido Futbol','2025-09-19','Estadio Norte'),
    ('Obra Musical','2025-09-20','Teatro Principal'),
    ('Conferencia','2025-09-21','Centro de Convenciones'),
    ('Exposicion','2025-09-22','Museo Local'),
    ('Cine Estreno','2025-09-23','Cine Plaza'),
    ('Festival Gastronomia','2025-09-24','Parque Central');
END;
//

CREATE PROCEDURE CrearTablaBoletos()
BEGIN
    DROP TABLE IF EXISTS Boletos;
    CREATE TABLE Boletos (
        id_boleto INT AUTO_INCREMENT PRIMARY KEY,
        precio DECIMAL(10,2) NOT NULL,
        asiento VARCHAR(10) NOT NULL
    );
    INSERT INTO Boletos (precio,asiento) VALUES
    (50,'A1'),(60,'A2'),(70,'B1'),(80,'B2'),(90,'C1'),
    (100,'C2'),(110,'D1'),(120,'D2'),(130,'E1'),(140,'E2');
END;
//

CREATE PROCEDURE CrearTablaEmpleados()
BEGIN
    DROP TABLE IF EXISTS Empleados;
    CREATE TABLE Empleados (
        id_empleado INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL
    );
    INSERT INTO Empleados (nombre) VALUES
    ('Luis Perez'),('Carla Gomez'),('Santiago Torres'),('Laura Diaz'),('Miguel Angel'),
    ('Elena Ruiz'),('Pedro Martinez'),('Sofia Hernandez'),('Kevin Culma'),('Ana Lopez');
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
    ('Admin 1'),('Admin 2'),('Admin 3'),('Admin 4'),('Admin 5'),
    ('Admin 6'),('Admin 7'),('Admin 8'),('Admin 9'),('Admin 10');
END;
//

CREATE PROCEDURE CrearTablaUsuariosBoletos()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Boletos;
    CREATE TABLE Usuarios_Boletos (
        id_usuario INT NOT NULL,
        id_boleto INT NOT NULL,
        PRIMARY KEY(id_usuario,id_boleto),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_boleto) REFERENCES Boletos(id_boleto)
    );
    INSERT INTO Usuarios_Boletos (id_usuario,id_boleto) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaEventosBoletos()
BEGIN
    DROP TABLE IF EXISTS Eventos_Boletos;
    CREATE TABLE Eventos_Boletos (
        id_evento INT NOT NULL,
        id_boleto INT NOT NULL,
        PRIMARY KEY(id_evento,id_boleto),
        FOREIGN KEY (id_evento) REFERENCES Eventos(id_evento),
        FOREIGN KEY (id_boleto) REFERENCES Boletos(id_boleto)
    );
    INSERT INTO Eventos_Boletos (id_evento,id_boleto) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaEventos();
CALL CrearTablaBoletos();
CALL CrearTablaEmpleados();
CALL CrearTablaAdministradores();
CALL CrearTablaUsuariosBoletos();
CALL CrearTablaEventosBoletos();

CREATE VIEW Vista_BoletosPorUsuario AS
SELECT u.nombre AS usuario, b.precio, b.asiento
FROM Usuarios u
JOIN Usuarios_Boletos ub ON u.id_usuario = ub.id_usuario
JOIN Boletos b ON ub.id_boleto = b.id_boleto;

CREATE VIEW Vista_BoletosPorEvento AS
SELECT e.nombre AS evento, b.precio, b.asiento
FROM Eventos e
JOIN Eventos_Boletos eb ON e.id_evento = eb.id_evento
JOIN Boletos b ON eb.id_boleto = b.id_boleto;

CREATE VIEW Vista_UsuariosConBoletos AS
SELECT u.nombre AS usuario, b.asiento AS boleto
FROM Usuarios u
JOIN Usuarios_Boletos ub ON u.id_usuario = ub.id_usuario
JOIN Boletos b ON ub.id_boleto = b.id_boleto;

CREATE VIEW Vista_TotalBoletosPorEvento AS
SELECT e.nombre AS evento, COUNT(eb.id_boleto) AS total_boletos
FROM Eventos e
JOIN Eventos_Boletos eb ON e.id_evento = eb.id_evento
GROUP BY e.id_evento;

CREATE VIEW Vista_AdministradoresUsuarios AS
SELECT ad.nombre AS administrador, u.nombre AS usuario
FROM Administradores ad
JOIN Usuarios u ON ad.id_admin = u.id_usuario;

SELECT * FROM Vista_BoletosPorUsuario;
SELECT * FROM Vista_BoletosPorEvento;
SELECT * FROM Vista_UsuariosConBoletos;
SELECT * FROM Vista_TotalBoletosPorEvento;
SELECT * FROM Vista_AdministradoresUsuarios;
