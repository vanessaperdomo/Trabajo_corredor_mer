USE Gestion_Planes_Ahorro;

-- Este indice evita clientes duplicados por email
CREATE UNIQUE INDEX uq_email_cliente ON Clientes(email);

-- Este indice evita nombres de planes repetidos
CREATE UNIQUE INDEX uq_nombre_plan ON PlanesAhorro(nombre);

-- Este indice evita nombres de departamentos repetidos
CREATE UNIQUE INDEX uq_nombre_departamento ON Departamentos(nombre);

-- Este indice compuesto sirve para consultas por fecha y monto
ALTER TABLE Transacciones
ADD INDEX idx_fecha_monto (fecha, monto);

-- Este indice compuesto sirve para joins y agregaciones por plan y transaccion
ALTER TABLE Transacciones_Planes
ADD INDEX idx_plan_transaccion (id_plan, id_transaccion);