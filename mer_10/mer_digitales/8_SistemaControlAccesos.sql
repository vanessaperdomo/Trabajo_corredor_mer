CREATE DATABASE IF NOT EXISTS SistemaControlAccesos;
USE SistemaControlAccesos;

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

CREATE PROCEDURE CrearTablaPuertas()
BEGIN
    DROP TABLE IF EXISTS Puertas;
    CREATE TABLE Puertas (
        id_puerta INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        ubicacion VARCHAR(100) NOT NULL
    );
    INSERT INTO Puertas (nombre,ubicacion) VALUES
    ('Entrada Principal','Lobby'),
    ('Entrada Lateral','Lado Norte'),
    ('Oficina 1','Segundo Piso'),
    ('Oficina 2','Segundo Piso'),
    ('Sala Juntas','Tercer Piso'),
    ('Laboratorio','Tercer Piso'),
    ('Almacen','Primer Piso'),
    ('Cafeteria','Primer Piso'),
    ('Recepcion','Lobby'),
    ('Estacionamiento','Exterior');
END;
//

CREATE PROCEDURE CrearTablaAccesos()
BEGIN
    DROP TABLE IF EXISTS Accesos;
    CREATE TABLE Accesos (
        id_acceso INT AUTO_INCREMENT PRIMARY KEY,
        fecha DATETIME NOT NULL,
        tipo VARCHAR(50) NOT NULL
    );
    INSERT INTO Accesos (fecha,tipo) VALUES
    ('2025-09-01 08:00:00','Entrada'),
    ('2025-09-01 09:00:00','Salida'),
    ('2025-09-01 10:00:00','Entrada'),
    ('2025-09-01 11:00:00','Salida'),
    ('2025-09-01 12:00:00','Entrada'),
    ('2025-09-01 13:00:00','Salida'),
    ('2025-09-01 14:00:00','Entrada'),
    ('2025-09-01 15:00:00','Salida'),
    ('2025-09-01 16:00:00','Entrada'),
    ('2025-09-01 17:00:00','Salida');
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

CREATE PROCEDURE CrearTablaUsuariosAccesos()
BEGIN
    DROP TABLE IF EXISTS Usuarios_Accesos;
    CREATE TABLE Usuarios_Accesos (
        id_usuario INT NOT NULL,
        id_acceso INT NOT NULL,
        PRIMARY KEY(id_usuario,id_acceso),
        FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario),
        FOREIGN KEY (id_acceso) REFERENCES Accesos(id_acceso)
    );
    INSERT INTO Usuarios_Accesos (id_usuario,id_acceso) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaEmpleadosPuertas()
BEGIN
    DROP TABLE IF EXISTS Empleados_Puertas;
    CREATE TABLE Empleados_Puertas (
        id_empleado INT NOT NULL,
        id_puerta INT NOT NULL,
        PRIMARY KEY(id_empleado,id_puerta),
        FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado),
        FOREIGN KEY (id_puerta) REFERENCES Puertas(id_puerta)
    );
    INSERT INTO Empleados_Puertas (id_empleado,id_puerta) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaUsuarios();
CALL CrearTablaPuertas();
CALL CrearTablaAccesos();
CALL CrearTablaEmpleados();
CALL CrearTablaAdministradores();
CALL CrearTablaUsuariosAccesos();
CALL CrearTablaEmpleadosPuertas();

CREATE VIEW Vista_AccesosPorUsuario AS
SELECT u.nombre AS usuario, a.fecha, a.tipo
FROM Usuarios u
JOIN Usuarios_Accesos ua ON u.id_usuario = ua.id_usuario
JOIN Accesos a ON ua.id_acceso = a.id_acceso;

CREATE VIEW Vista_PuertasPorEmpleado AS
SELECT e.nombre AS empleado, p.nombre AS puerta, p.ubicacion
FROM Empleados e
JOIN Empleados_Puertas ep ON e.id_empleado = ep.id_empleado
JOIN Puertas p ON ep.id_puerta = p.id_puerta;

CREATE VIEW Vista_UsuariosConAccesos AS
SELECT u.nombre AS usuario, a.tipo AS tipo_acceso
FROM Usuarios u
JOIN Usuarios_Accesos ua ON u.id_usuario = ua.id_usuario
JOIN Accesos a ON ua.id_acceso = a.id_acceso;

CREATE VIEW Vista_TotalAccesosPorPuerta AS
SELECT p.nombre AS puerta, COUNT(ep.id_empleado) AS total_empleados
FROM Puertas p
JOIN Empleados_Puertas ep ON p.id_puerta = ep.id_puerta
GROUP BY p.id_puerta;

CREATE VIEW Vista_AdministradoresUsuarios AS
SELECT ad.nombre AS administrador, u.nombre AS usuario
FROM Administradores ad
JOIN Usuarios u ON ad.id_admin = u.id_usuario;

SELECT * FROM Vista_AccesosPorUsuario;
SELECT * FROM Vista_PuertasPorEmpleado;
SELECT * FROM Vista_UsuariosConAccesos;
SELECT * FROM Vista_TotalAccesosPorPuerta;
SELECT * FROM Vista_AdministradoresUsuarios;
