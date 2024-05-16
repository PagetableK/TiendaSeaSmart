-- VIEW PARA MOSTRAR VALORACIONES

CREATE VIEW view_valoraciones AS
SELECT CONCAT(p.nombre_producto, ' - ', pc.color_producto) AS nombre_producto_color,
       c.nombre_cliente, 
       v.id_valoracion,
       v.fecha_valoracion, 
       v.calificacion_producto, 
       v.comentario_producto, 
       v.estado_comentario
FROM valoraciones v
INNER JOIN detalles_productos dp ON v.id_detalle_producto = dp.id_detalle_producto
INNER JOIN productos p ON dp.id_producto = p.id_producto
INNER JOIN administradores a ON p.id_administrador = a.id_administrador
INNER JOIN clientes c ON a.id_administrador = c.id_cliente
INNER JOIN productos_colores pc ON dp.id_producto_color = pc.id_producto_color;

