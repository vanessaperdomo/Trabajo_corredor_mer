USE control_contratos;

-- Este indice practicamente es util para identificar a cierto cliente de una forma rapida 
CREATE INDEX idx_contratos_cliente ON contratos(cliente_id);

-- Este índice es útil para filtrar contratos por tipo (ej: servicios, compras, etc.)
CREATE INDEX idx_contratos_tipo ON contratos(tipo_id);

-- Este índice acelera los JOIN entre contratos y empleados (muy útil si hay miles de contratos).
CREATE INDEX idx_contrato_empleado_contrato ON contrato_empleado(contrato_id);

-- Este índice es útil para saber en qué contratos participa un empleado.
CREATE INDEX idx_contrato_empleado_empleado ON contrato_empleado(empleado_id);

-- Este índice acelera las consultas de proyectos relacionados a contratos.
CREATE INDEX idx_contrato_proyecto_contrato ON contrato_proyecto(contrato_id);

-- Este índice es útil para consultar rapidamente que contratos pertenecen a un proyecto.
CREATE INDEX idx_contrato_proyecto_proyecto ON contrato_proyecto(proyecto_id);
