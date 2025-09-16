USE RecordatoriosApp;

-- garantiza que no haya correos repetidos y mejora la búsqueda de usuarios por correo
CREATE UNIQUE INDEX email_idx ON usuarios(email);

-- asegura que no existan dos categorias con el mismo nombre y optimiza busquedas por nombre de categoria.
CREATE UNIQUE INDEX idx_nombre_categoria_unique ON categorias(nombre);

-- índice en id_prioridad para acelerar consultas y joins con la tabla Prioridades
CREATE INDEX prioridad_id ON Prioridades(id_prioridad);

-- Muy util si haces busquedas o filtros por nombre de prioridad
CREATE INDEX nivelPrioridad ON Prioridades(nivel);

-- Muy importante para consultar recordatorios por fecha, ordenar por fecha o traer los próximos eventos rápidamente.
CREATE INDEX fecha_recordatorio ON Recordatorios(fecha_recordatorio);

