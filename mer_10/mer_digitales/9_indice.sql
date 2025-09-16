USE CompraBoletos;

-- indice unico para evitar correos duplicados y mejorar las busquedas por email
CREATE UNIQUE INDEX email_usuarios ON Usuarios(email);

-- indice agrupado en eventos para buscar por nombre y fecha de forma eficiente
CREATE INDEX evento_nombre_fecha ON Eventos(nombre, fecha);

-- indice agrupado en boletos para filtrar por precio y ordenar por asiento
CREATE INDEX precio_asiento ON Boletos(precio, asiento);

-- indice agrupado en la tabla intermedia para acelerar consultas por usuario y boleto
CREATE INDEX usuario_boleto ON Usuarios_Boletos(id_usuario, id_boleto);

-- indice agrupado en la tabla de eventos y boletos para agilizar los joins y contar boletos por evento
CREATE INDEX evento_boleto ON Eventos_Boletos(id_evento, id_boleto);
