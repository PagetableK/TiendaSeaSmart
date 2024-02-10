# DBSeaSmart
DROP DATABASE DBSeaSmart;

CREATE DATABASE DBSeaSmart;

USE DBSeaSmart;

CREATE TABLE administradores(
	id_administrador INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	nombre_administrador VARCHAR(20) NOT NULL,
	apellido_administrador VARCHAR(20) NOT NULL,
	correo_administrador VARCHAR(100) NOT NULL,
	contra_administrador VARCHAR(20) NOT NULL,
	fecha_registro DATE NOT NULL
);

CREATE TABLE clientes(
	id_cliente INT PRIMARY KEY AUTO_INCREMENT,
	nombre_cliente VARCHAR(20) NOT NULL,
	apellido_cliente VARCHAR(20) NOT NULL,
	correo_cliente VARCHAR(35) NOT NULL,
	contra_cliente VARCHAR(20) NOT NULL,
	dui_cliente VARCHAR(10) NOT NULL,
	direccion_cliente VARCHAR(50) NOT NULL,
	telefono_movil INT(8) NOT NULL,
	telefono_fijo INT(8) NOT NULL
);

CREATE TABLE categorias(
	id_categoria INT PRIMARY KEY AUTO_INCREMENT,
	nombre_categoria VARCHAR(20) NOT NULL,
	imagen_categoria VARCHAR(25) NOT NULL
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
	estado_producto BOOLEAN NOT NULL,
	descripcion_producto VARCHAR(500) NOT NULL,
	imagen_producto VARCHAR(25) NOT NULL,
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
    id_producto INT,
    existencia_producto INT CHECK(existencia_producto >= 0),
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
	estado_pedido ENUM('Pendiente','Finalizado', 'Enviado', 'Anulado') NOT NULL,
	id_cliente INT NOT NULL,
	FOREIGN KEY (id_cliente)
	REFERENCES clientes(id_cliente)
);

CREATE TABLE detalles_pedidos(
	id_detalle_pedido INT PRIMARY KEY AUTO_INCREMENT,
	cantidad_producto INT NOT NULL,
	fecha_valoracion DATE NULL,
	calificacion_producto INT NULL,
	comentario_producto VARCHAR(200) NULL,
    estado_comentario BOOLEAN DEFAULT 0,
	id_pedido INT NOT NULL,
	id_detalle_producto INT NOT NULL,
	FOREIGN KEY(id_detalle_producto)
	REFERENCES detalles_productos(id_detalle_producto),
	FOREIGN KEY(id_pedido)
	REFERENCES pedidos(id_pedido)
);
