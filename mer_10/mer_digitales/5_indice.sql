USE ReservasHoteles;

-- Evita correos duplicados
CREATE UNIQUE INDEX uq_email_cliente ON Clientes(email);

-- Mejora busqueda por ciudad
CREATE INDEX idx_ciudad_hotel ON Hoteles(ciudad);

-- Mejora consultas por tipo de habitacion
CREATE INDEX idx_tipo_habitacion ON Habitaciones(tipo);

-- Mejora filtros por fecha de reserva
CREATE INDEX idx_fechas_reserva ON Reservas(fecha_inicio, fecha_fin);

-- Optimiza joins entre empleados y hoteles
CREATE INDEX idx_empleado_hotel ON Empleados_Hoteles(id_hotel, id_empleado);
