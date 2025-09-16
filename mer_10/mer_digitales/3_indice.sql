USE FinanzasEmpresariales;

-- Evita cuentas duplicadas en la misma empresa con el mismo nombre
ALTER TABLE Cuentas
ADD CONSTRAINT uq_nombre_cuenta_por_empresa UNIQUE (nombre, id_empresa);

-- Este indice agrupado para consultas por fecha de transaccion
ALTER TABLE Transacciones
ADD INDEX idx_fecha_transaccion (fecha);

-- Este indice sirve para buscar cuentas por el numero unico de la empresa
CREATE INDEX idx_empresa_cuenta ON Cuentas(id_empresa);

-- Este indice compuesto sirve para joins en transacciones_cuentas
CREATE INDEX idx_cuenta_transaccion ON Transacciones_Cuentas(id_cuenta, id_transaccion);

-- Este indice sirve para buscar empleados por departamento
CREATE INDEX idx_departamento_empleado ON Empleados_Departamentos(id_departamento);
