CREATE DATABASE IF NOT EXISTS EvaluacionDesempeno;
USE EvaluacionDesempeno;

DELIMITER //

CREATE PROCEDURE CrearTablaEmpleados()
BEGIN
    DROP TABLE IF EXISTS Empleados;
    CREATE TABLE Empleados (
        id_empleado INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL,
        email VARCHAR(100) NOT NULL UNIQUE
    );
    INSERT INTO Empleados (nombre, email) VALUES
    ('Carlos','carlos@gmail.com'),
    ('Andrea','andrea@gmail.com'),
    ('Marcos','marcos@gmail.com'),
    ('Lucia','lucia@gmail.com'),
    ('Sebastian','sebastian@gmail.com'),
    ('Fernanda','fernanda@gmail.com'),
    ('Julian','julian@gmail.com'),
    ('Lorena','lorena@gmail.com'),
    ('Esteban','esteban@gmail.com'),
    ('Patricia','patricia@gmail.com');
END;
//

CREATE PROCEDURE CrearTablaCompetencias()
BEGIN
    DROP TABLE IF EXISTS Competencias;
    CREATE TABLE Competencias (
        id_competencia INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL UNIQUE
    );
    INSERT INTO Competencias (nombre) VALUES
    ('Liderazgo'),('Trabajo en equipo'),('Comunicacion'),
    ('Resolucion de problemas'),('Adaptabilidad'),
    ('Pensamiento critico'),('Innovacion'),
    ('Organizacion'),('Puntualidad'),('Responsabilidad');
END;
//

CREATE PROCEDURE CrearTablaEvaluadores()
BEGIN
    DROP TABLE IF EXISTS Evaluadores;
    CREATE TABLE Evaluadores (
        id_evaluador INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(100) NOT NULL UNIQUE
    );
    INSERT INTO Evaluadores (nombre) VALUES
    ('Supervisor A'),('Supervisor B'),('Jefe Area 1'),
    ('Jefe Area 2'),('Gerente'),('Coordinador'),
    ('RH 1'),('RH 2'),('Lider Proyectos'),('Consultor Externo');
END;
//

CREATE PROCEDURE CrearTablaEvaluaciones()
BEGIN
    DROP TABLE IF EXISTS Evaluaciones;
    CREATE TABLE Evaluaciones (
        id_evaluacion INT AUTO_INCREMENT PRIMARY KEY,
        titulo VARCHAR(100) NOT NULL,
        descripcion VARCHAR(200),
        fecha DATE NOT NULL
    );
    INSERT INTO Evaluaciones (titulo, descripcion, fecha) VALUES
    ('Evaluacion Trimestre 1','Medicion Q1','2025-03-31'),
    ('Evaluacion Trimestre 2','Medicion Q2','2025-06-30'),
    ('Evaluacion Trimestre 3','Medicion Q3','2025-09-30'),
    ('Evaluacion Trimestre 4','Medicion Q4','2025-12-31'),
    ('Evaluacion Especial','Evaluacion puntual','2025-05-15'),
    ('Evaluacion Proyectos','Solo proyectos','2025-08-20'),
    ('Evaluacion Soft Skills','Habilidades blandas','2025-04-10'),
    ('Evaluacion Liderazgo','Solo lideres','2025-07-12'),
    ('Evaluacion Nuevos','Para nuevos empleados','2025-01-20'),
    ('Evaluacion Final','Resumen anual','2025-12-15');
END;
//

CREATE PROCEDURE CrearTablaComentarios()
BEGIN
    DROP TABLE IF EXISTS Comentarios;
    CREATE TABLE Comentarios (
        id_comentario INT AUTO_INCREMENT PRIMARY KEY,
        id_evaluacion INT NOT NULL,
        texto VARCHAR(200) NOT NULL,
        FOREIGN KEY (id_evaluacion) REFERENCES Evaluaciones(id_evaluacion)
    );
    INSERT INTO Comentarios (id_evaluacion, texto) VALUES
    (1,'Buen desempeno'),(2,'Debe mejorar tiempos'),
    (3,'Excelente actitud'),(4,'Liderazgo destacado'),
    (5,'Requiere apoyo'),(6,'Gran avance'),
    (7,'Buena comunicacion'),(8,'Responsable'),
    (9,'Adaptacion rapida'),(10,'Cumplio objetivos');
END;
//

CREATE PROCEDURE CrearTablaEmpleadosCompetencias()
BEGIN
    DROP TABLE IF EXISTS Empleados_Competencias;
    CREATE TABLE Empleados_Competencias (
        id_empleado INT NOT NULL,
        id_competencia INT NOT NULL,
        PRIMARY KEY(id_empleado, id_competencia),
        FOREIGN KEY (id_empleado) REFERENCES Empleados(id_empleado),
        FOREIGN KEY (id_competencia) REFERENCES Competencias(id_competencia)
    );
    INSERT INTO Empleados_Competencias (id_empleado, id_competencia) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

CREATE PROCEDURE CrearTablaEvaluacionesEvaluadores()
BEGIN
    DROP TABLE IF EXISTS Evaluaciones_Evaluadores;
    CREATE TABLE Evaluaciones_Evaluadores (
        id_evaluacion INT NOT NULL,
        id_evaluador INT NOT NULL,
        PRIMARY KEY(id_evaluacion, id_evaluador),
        FOREIGN KEY (id_evaluacion) REFERENCES Evaluaciones(id_evaluacion),
        FOREIGN KEY (id_evaluador) REFERENCES Evaluadores(id_evaluador)
    );
    INSERT INTO Evaluaciones_Evaluadores (id_evaluacion, id_evaluador) VALUES
    (1,1),(2,2),(3,3),(4,4),(5,5),
    (6,6),(7,7),(8,8),(9,9),(10,10);
END;
//

DELIMITER ;

CALL CrearTablaEmpleados();
CALL CrearTablaCompetencias();
CALL CrearTablaEvaluadores();
CALL CrearTablaEvaluaciones();
CALL CrearTablaComentarios();
CALL CrearTablaEmpleadosCompetencias();
CALL CrearTablaEvaluacionesEvaluadores();

CREATE OR REPLACE VIEW Vista_EvaluacionesPorEmpleado AS
SELECT e.nombre AS empleado, ev.titulo, ev.fecha
FROM Evaluaciones ev
JOIN Empleados_Competencias ec ON ec.id_empleado = ev.id_evaluacion
JOIN Empleados e ON ec.id_empleado = e.id_empleado;

CREATE OR REPLACE VIEW Vista_EmpleadosPorCompetencia AS
SELECT c.nombre AS competencia, COUNT(ec.id_empleado) AS total
FROM Competencias c
LEFT JOIN Empleados_Competencias ec ON c.id_competencia = ec.id_competencia
GROUP BY c.id_competencia;

CREATE OR REPLACE VIEW Vista_EvaluadoresPorEvaluacion AS
SELECT ev.titulo AS evaluacion, COUNT(ee.id_evaluador) AS total
FROM Evaluaciones ev
LEFT JOIN Evaluaciones_Evaluadores ee ON ev.id_evaluacion = ee.id_evaluacion
GROUP BY ev.id_evaluacion;

CREATE OR REPLACE VIEW Vista_ComentariosPorEvaluacion AS
SELECT ev.titulo, c.texto
FROM Comentarios c
JOIN Evaluaciones ev ON c.id_evaluacion = ev.id_evaluacion;

CREATE OR REPLACE VIEW Vista_EmpleadosConCompetencias AS
SELECT e.nombre AS empleado, c.nombre AS competencia
FROM Empleados e
JOIN Empleados_Competencias ec ON e.id_empleado = ec.id_empleado
JOIN Competencias c ON ec.id_competencia = c.id_competencia;

SELECT * FROM Vista_EvaluacionesPorEmpleado;
SELECT * FROM Vista_EmpleadosPorCompetencia;
SELECT * FROM Vista_EvaluadoresPorEvaluacion;
SELECT * FROM Vista_ComentariosPorEvaluacion;
SELECT * FROM Vista_EmpleadosConCompetencias;
