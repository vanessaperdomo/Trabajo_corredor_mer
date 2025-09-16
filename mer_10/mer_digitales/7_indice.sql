USE Sistema_Identificacion_Biometrica;

-- Este indice evita duplicados y mejora consultas por email
CREATE UNIQUE INDEX idx_email_usuarios ON Usuarios(email);

-- Este indice sirve para agilizar reportes por tipo de biometria
CREATE INDEX idx_tipo_biometria ON Biometrias(tipo);

-- Este indice hace mas rapidas las consultas de sesiones por rango de fechas
CREATE INDEX idx_fecha_inicio ON Sesiones(fecha_inicio);

--  Este indice compuesto sirve para optimizar las uniones y filtrados en Usuarios_Biometrias
CREATE INDEX idx_usuario_biometria ON Usuarios_Biometrias(id_usuario, id_biometria);

-- Este indice compuesto sirve para consultar sesiones por dispositivo rapidamente
CREATE INDEX idx_dispositivo_sesion ON Dispositivos_Sesiones(id_dispositivo, id_sesion);
