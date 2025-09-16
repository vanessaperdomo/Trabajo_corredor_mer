USE Sistema_Puntos_Fidelidad;

-- Este indice agrupado en Clientes, mejora busquedas por nombre y puntos
ALTER TABLE Clientes
ADD INDEX nombre_puntos (nombre, puntos);

-- Este indice agrupado en Productos, optimiza consultas por precio y puntos que otorga
ALTER TABLE Productos
ADD INDEX precio_puntos (precio, puntos_otorga);

-- Este indice agrupado en Clientes_Productos, acelera joins por cliente y producto
ALTER TABLE Clientes_Productos
ADD INDEX cliente_producto (id_cliente, id_producto);

-- Este indice agrupado en Clientes_Productos, ideal para reportes por cliente en rango de fechas
ALTER TABLE Clientes_Productos
ADD INDEX cliente_fecha (id_cliente, fecha);

-- Este indice agrupado en Clientes_Premios, mejora consultas de canjes por cliente y premio
ALTER TABLE Clientes_Premios
ADD INDEX clientePremio (id_cliente, id_premio);
