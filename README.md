# DBSeaSmart
DROP DATABASE IF EXISTS DBSeaSmart;

CREATE DATABASE DBSeaSmart;

USE DBSeaSmart;

CREATE TABLE administradores(
	id_administrador INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	nombre_administrador VARCHAR(20) NOT NULL,
	apellido_administrador VARCHAR(20) NOT NULL,
	correo_administrador VARCHAR(100) UNIQUE NOT NULL,
	contra_administrador VARCHAR(20) NOT NULL,
	fecha_registro DATE NOT NULL
);

CREATE TABLE clientes(
	id_cliente INT PRIMARY KEY AUTO_INCREMENT,
	nombre_cliente VARCHAR(20) NOT NULL,
	apellido_cliente VARCHAR(20) NOT NULL,
	correo_cliente VARCHAR(35) UNIQUE NOT NULL,
	contra_cliente VARCHAR(20) NOT NULL,
	dui_cliente VARCHAR(10) UNIQUE NOT NULL,
	telefono_movil VARCHAR(14) UNIQUE NOT NULL,
	telefono_fijo VARCHAR(14) UNIQUE NOT NULL
);

CREATE TABLE categorias(
	id_categoria INT PRIMARY KEY AUTO_INCREMENT,
	nombre_categoria VARCHAR(20) NOT NULL,
	imagen_categoria VARCHAR(25) NOT NULL,
   descripcion_categoria varchar(100) NOT NULL
);

CREATE TABLE sub_categorias(
	id_sub_categoria INT PRIMARY KEY AUTO_INCREMENT,
	nombre_sub_categoria VARCHAR(20) NOT NULL,
	descripcion_sub_categoria VARCHAR(200) NOT NULL,
	id_categoria INT,
	FOREIGN KEY (id_categoria)
	REFERENCES categorias(id_categoria)
);

CREATE TABLE productos(
	id_producto INT PRIMARY KEY AUTO_INCREMENT,
	nombre_producto VARCHAR(30) NOT NULL,
	descripcion_producto VARCHAR(500) NOT NULL,
	id_sub_categoria INT NOT NULL,
	id_administrador INT NOT NULL,
	FOREIGN KEY (id_sub_categoria)
	REFERENCES sub_categorias(id_sub_categoria),
	FOREIGN KEY (id_administrador)
	REFERENCES administradores(id_administrador)
);

CREATE TABLE productos_colores(
	id_producto_color INT PRIMARY KEY AUTO_INCREMENT,
	color_producto VARCHAR(20) NULL
);

CREATE TABLE productos_tallas(
	id_producto_talla INT PRIMARY KEY AUTO_INCREMENT,
	talla VARCHAR(30) NOT NULL
);

CREATE TABLE detalles_productos(
	id_detalle_producto INT primary key auto_increment,
   id_producto_color INT NULL,
   id_producto_talla INT NULL,
   id_producto INT NOT NULL,
	precio_producto FLOAT NOT NULL,
	imagen_producto VARCHAR(25) NULL,
   estado_producto BOOLEAN NOT NULL,
   existencia_producto INT NOT NULL,
   CHECK(existencia_producto >= 0),
   FOREIGN KEY (id_producto_color)
   REFERENCES productos_colores(id_producto_color),
   FOREIGN KEY (id_producto_talla)
	REFERENCES productos_tallas(id_producto_talla),
   FOREIGN KEY (id_producto)
	REFERENCES productos(id_producto)
);

CREATE TABLE pedidos(
	id_pedido INT PRIMARY KEY AUTO_INCREMENT,
	fecha_pedido DATE NOT NULL,
	estado_pedido ENUM('Pendiente', 'Siendo enviado','Finalizado', 'Enviado', 'Anulado') NOT NULL,
   direccion_pedido VARCHAR(100) NOT NULL,
	id_cliente INT NOT NULL,
	FOREIGN KEY (id_cliente)
	REFERENCES clientes(id_cliente)
);
-- ALTER TABLE pedidos
-- modify column estado_pedido ENUM('Pendiente', 'Siendo enviado','Finalizado', 'Enviado', 'Anulado') NOT NULL;

-- show create table pedidos;
CREATE TABLE detalles_pedidos(
	id_detalle_pedido INT PRIMARY KEY AUTO_INCREMENT,
	cantidad_producto INT NOT NULL,
   precio_producto FLOAT NOT NULL,
	id_pedido INT NOT NULL,
	id_detalle_producto INT NOT NULL,
	FOREIGN KEY(id_detalle_producto)
	REFERENCES detalles_productos(id_detalle_producto),
	FOREIGN KEY(id_pedido)
	REFERENCES pedidos(id_pedido)
);

CREATE TABLE valoraciones(
	id_valoracion INT PRIMARY KEY,
	fecha_valoracion DATE NOT NULL,
	calificacion_producto INT NOT NULL,
	comentario_producto VARCHAR(200) NOT NULL,
   estado_comentario BOOLEAN DEFAULT 0 NOT NULL,
   id_detalle_producto INT NOT NULL,
   FOREIGN KEY(id_detalle_producto)
	REFERENCES detalles_productos(id_detalle_producto)
);

/*
---------------------------------------------------------------------------- 

---------------------------------------------------------------------------- 

-- TRIGGERS
-- AGREGAR UN REGISTRO EN DETALLES PRODUCTOS CUANDO SE AGREGUE UN REGISTRO EN LA TABLA PRODUCTOS
DELIMITER //
CREATE TRIGGER crear_detalle_producto
AFTER INSERT ON productos
FOR EACH ROW BEGIN
	DECLARE id_productoo INT;
    SET id_productoo = (SELECT MAX(id_producto) FROM productos);
	INSERT INTO detalles_productos (id_producto, precio_producto, estado_producto, existencia_producto) VALUES(id_productoo, 00.00, 'Disponible', 1);
END//
DELIMITER ;

-- INSERT's NECESARIOS PARA EJECUTAR EL TRIGGER
INSERT INTO categorias (nombre_categoria, imagen_categoria, descripcion_categoria)VALUES('Hombres', 'a', 'Hola');
INSERT INTO sub_categorias (nombre_sub_categoria, descripcion_sub_categoria, id_categoria) VALUES('Shorts', 'Hola', 1);
INSERT INTO administradores (nombre_administrador, apellido_administrador, correo_administrador, contra_administrador, fecha_registro) values('Pablo', 'Sánchez', 'pablo@gmail.com', 'Pablo1234', '2022-01-01');
INSERT INTO productos (nombre_producto, descripcion_producto, id_sub_categoria, id_administrador) VALUES('Shorts elásticos de cintura', 'Hola', 1, 1);
select * from detalles_productos;

-- DISMINUIR LA CANTIDAD DE PRODUCTOS CUANDO SE REALIZA UN PEDIDO
DELIMITER //
CREATE TRIGGER disminuir_producto
AFTER INSERT ON detalles_pedidos
FOR EACH ROW
BEGIN
	UPDATE detalles_productos
	SET existencia_producto  = existencia_producto - NEW.cantidad_producto
    WHERE id_detalle_producto = NEW.id_detalle_producto;
END//
DELIMITER ;

-- INSERT's NECESARIOS PARA EJECUTAR EL TRIGGER
INSERT INTO clientes (nombre_cliente,apellido_cliente,correo_cliente,contra_cliente,dui_cliente,direccion_cliente,telefono_movil,telefono_fijo) VALUES('PabloX', 'SancheX', 'pablo@gmail.com', '12345','1234567891','Col Al Pan Francés', '12345678', '87654321');
INSERT INTO pedidos (fecha_pedido, estado_pedido, id_cliente) VALUES('2022-14-02', 'Pendiente', 1);
INSERT INTO detalles_pedidos (cantidad_producto, precio_producto, id_pedido, id_detalle_producto) VALUES(5, 100.00, 3, 1);
SELECT * FROM detalles_pedidos;
SELECT * FROM detalles_productos;
---------------------------------------------------------------------------- 

---------------------------------------------------------------------------- 

-- PROCEDIMIENTOS ALMACENADOS
-- DISMINUIR LA CANTIDAD DE PRODUCTOS EN EL CARRITO DE COMPRAS Y AUMENTAR LA CANTIDAD DE EXISTENCIAS
-- DE PRODUCTOS
DELIMITER //
CREATE PROCEDURE devolver_producto(IN id_detalle_p INT, IN nueva_cantidad INT)
BEGIN
	DECLARE detalle_producto_id INT;
    DECLARE cantidad_devuelta INT;
    
    SELECT id_detalle_producto, cantidad_producto INTO detalle_producto_id, cantidad_devuelta
    FROM detalles_pedidos
    WHERE id_detalle_pedido = id_detalle_p;
    
	UPDATE detalles_productos
    SET existencia_producto = existencia_producto + (cantidad_devuelta - nueva_cantidad)
    WHERE id_detalle_producto = detalle_producto_id; 	
    
    UPDATE detalles_pedidos
    SET cantidad_producto = nueva_cantidad
    WHERE id_detalle_pedido = id_detalle_p;
END//
DELIMITER ;

-- INSERT's NECESARIOS PARA EJECUTAR EL TRIGGER
INSERT INTO productos (nombre_producto, descripcion_producto, id_sub_categoria, id_administrador) VALUES('Jammer de cintura elástica', 'Descripción...', 1, 1);
INSERT INTO detalles_pedidos (cantidad_producto, precio_producto, id_pedido, id_detalle_producto) VALUES(5, 200.00, 2, 2);

CALL devolver_producto(6, 3);

SELECT * FROM detalles_pedidos;
SELECT * FROM detalles_productos;

---------------------------------------------------------------------------- 

---------------------------------------------------------------------------- 

-- FUNCIONES
-- CALCULAR EL PRECIO TOTAL DE UN PRODUCTO EN EL CARRITO
DELIMITER //
CREATE FUNCTION calcular_total_producto(detalle_producto_id INT, cantidad INT)
RETURNS FLOAT
BEGIN
	DECLARE total FLOAT;
    DECLARE producto_p FLOAT;
    
    SELECT precio_producto INTO producto_p 
    FROM detalles_productos 
    WHERE id_detalle_producto = detalle_producto_id;
    
    SET total = producto_p * cantidad;
    
    RETURN total;
END //
DELIMITER ;

UPDATE detalles_productos SET precio_producto = 100.00 WHERE id_detalle_producto = 2;

SELECT calcular_total_producto(2, 3);

SELECT * FROM detalles_productos;
*/

