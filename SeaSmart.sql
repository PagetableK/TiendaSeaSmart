# DBSeaSmart
DROP DATABASE IF EXISTS dbseasmart;

CREATE DATABASE dbseasmart;

USE dbseasmart;

CREATE TABLE administradores(
	id_administrador INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	nombre_administrador VARCHAR(50) NOT NULL,
	apellido_administrador VARCHAR(50) NOT NULL,
	correo_administrador VARCHAR(100) UNIQUE NOT NULL,
	contra_administrador VARCHAR(255) NOT NULL,
	fecha_registro DATE NOT NULL,
	estado_administrador tinyint(1) NOT NULL DEFAULT 1
);

CREATE TABLE clientes(
	id_cliente INT PRIMARY KEY AUTO_INCREMENT,
	nombre_cliente VARCHAR(50) NOT NULL,
	apellido_cliente VARCHAR(50) NOT NULL,
	correo_cliente VARCHAR(100) UNIQUE NOT NULL,
	contra_cliente VARCHAR(255) NOT NULL,
	dui_cliente VARCHAR(11) UNIQUE NOT NULL,
	telefono_movil VARCHAR(14) UNIQUE NOT NULL,
	telefono_fijo VARCHAR(14) UNIQUE NULL,
	estado_cliente tinyint(1) NOT NULL DEFAULT 1
);

CREATE TABLE direcciones(
	id_direccion INT PRIMARY KEY AUTO_INCREMENT,
	direccion VARCHAR(100) NOT NULL,
	id_cliente INT NOT NULL,
	FOREIGN KEY (id_cliente)
	REFERENCES clientes(id_cliente)
);

CREATE TABLE categorias(
	id_categoria INT PRIMARY KEY AUTO_INCREMENT,
	nombre_categoria VARCHAR(50) NOT NULL UNIQUE,
	imagen_categoria VARCHAR(25) NOT NULL,
   descripcion_categoria varchar(100) NOT NULL
);

CREATE TABLE sub_categorias(
	id_sub_categoria INT PRIMARY KEY AUTO_INCREMENT,
	nombre_sub_categoria VARCHAR(50) NOT NULL UNIQUE,
	descripcion_sub_categoria VARCHAR(200) NOT NULL,
	id_categoria INT,
	FOREIGN KEY (id_categoria)
	REFERENCES categorias(id_categoria)
);

CREATE TABLE productos(
	id_producto INT PRIMARY KEY AUTO_INCREMENT,
	nombre_producto VARCHAR(30) NOT NULL UNIQUE,
	descripcion_producto VARCHAR(500) NOT NULL,
	estado_producto tinyint(1) NOT NULL DEFAULT 1,
	precio_producto FLOAT NOT NULL,
	id_sub_categoria INT NOT NULL,
	id_administrador INT NOT NULL,
	FOREIGN KEY (id_sub_categoria)
	REFERENCES sub_categorias(id_sub_categoria),
	FOREIGN KEY (id_administrador)
	REFERENCES administradores(id_administrador)
);

CREATE TABLE productos_colores(
	id_producto_color INT PRIMARY KEY AUTO_INCREMENT,
	color_producto VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE productos_tallas(
	id_producto_talla INT PRIMARY KEY AUTO_INCREMENT,
	talla VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE detalles_productos(
	id_detalle_producto INT primary key auto_increment,
   id_producto_color INT NULL,
   id_producto_talla INT NULL,
   id_producto INT NOT NULL,
   imagen_producto VARCHAR(25) NULL,
   estado_detalle_producto tinyint(1) NOT NULL DEFAULT 1,
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
	fecha_pedido DATE NULL,
	estado_pedido ENUM('Pendiente', 'Siendo enviado', 'Enviado', 'Anulado', 'En carrito') NOT NULL,
        direccion VARCHAR(100) NULL,
	id_cliente INT NOT NULL,
	FOREIGN KEY (id_cliente)
	REFERENCES clientes(id_cliente)
);

CREATE TABLE detalles_pedidos(
	id_detalle_pedido INT PRIMARY KEY AUTO_INCREMENT,
	cantidad_producto INT NOT NULL,
   precio_producto FLOAT NOT NULL,
	id_pedido INT NOT NULL,
	id_detalle_producto INT NOT NULL,
	CHECK(precio_producto >= 1),
	FOREIGN KEY(id_detalle_producto)
	REFERENCES detalles_productos(id_detalle_producto),
	FOREIGN KEY(id_pedido)
	REFERENCES pedidos(id_pedido)
);

CREATE TABLE valoraciones(
	id_valoracion INT PRIMARY KEY AUTO_INCREMENT,
	fecha_valoracion DATE NOT NULL,
	calificacion_producto INT NOT NULL,
	comentario_producto VARCHAR(200) NOT NULL,
   estado_comentario tinyint(1) NOT NULL DEFAULT 1,
   id_detalle_pedido INT NOT NULL,
	CHECK(calificacion_producto >= 1 AND calificacion_producto <=5),
   FOREIGN KEY(id_detalle_pedido)
	REFERENCES detalles_pedidos(id_detalle_pedido)
);
