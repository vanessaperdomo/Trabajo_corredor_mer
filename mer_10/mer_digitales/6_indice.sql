USE Plataforma_Recompensas;

-- Este indice asegura que no haya emails duplicados en la tabla usuarios
CREATE UNIQUE INDEX email_persona ON usuarios(email);

-- Este indice mejora la busqueda por nombre y puntos en la tabla recompensas
ALTER TABLE Recompensas 
ADD INDEX nomPuntos (nombre, puntos);

-- Mejora consultas por fecha en transacciones
CREATE INDEX idx_fecha_transaccion ON Transacciones(fecha);

-- Optimiza joins entre usuarios y recompensas
CREATE INDEX idx_usuario_recompensa ON Usuarios_Recompensas(id_recompensa, id_usuario);

-- Optimiza joins entre transacciones y recompensas
CREATE INDEX idx_transaccion_recompensa ON Transacciones_Recompensas(id_recompensa, id_transaccion);
