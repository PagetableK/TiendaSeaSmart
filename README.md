# DBSeaSmart
DROP DATABASE DBSeaSmart;

CREATE DATABASE DBSeaSmart;

USE DBSeaSmart;

CREATE TABLE administradores(
	id_administrador INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
	nombre_administrador VARCHAR(20) NOT NULL UNIQUE,
	contra_administrador VARCHAR(20) NOT NULL
);

CREATE TABLE contactos(
	id_contacto INT PRIMARY KEY AUTO_INCREMENT,
	numero_telefono INT(8) NOT NULL,
	telefono_emergencia INT(8) NOT NULL
);

CREATE TABLE clientes(
	id_cliente INT PRIMARY KEY AUTO_INCREMENT,
	nombre_cliente VARCHAR(20) NOT NULL,
	apellido_cliente VARCHAR(20) NOT NULL,
	correo_cliente VARCHAR(35) NOT NULL,
	contra_cliente VARCHAR(20) NOT NULL,
	id_contacto INT NOT NULL,
	FOREIGN KEY(id_contacto)
	REFERENCES contactos(id_contacto)
);

CREATE TABLE direcciones_clientes(
	id_direccion_cliente INT PRIMARY KEY AUTO_INCREMENT,
	descripcion_direccion VARCHAR(50) NOT NULL,
	id_cliente INT NOT NULL,
	FOREIGN KEY (id_cliente)
	REFERENCES clientes(id_cliente)
);

CREATE TABLE categorias(
	id_categoria INT PRIMARY KEY AUTO_INCREMENT,
	nombre_categoria VARCHAR(20) NOT NULL,
	imagen_categoria VARCHAR(25)
);

CREATE TABLE productos(
	id_producto INT PRIMARY KEY AUTO_INCREMENT,
	nombre_producto VARCHAR(30) NOT NULL,
	estado_producto BOOLEAN NOT NULL,
	descripcion_producto VARCHAR(150) NOT NULL,
	imagen_producto VARCHAR(25) NOT NULL,
	precio_producto FLOAT NOT NULL,
	existencias_producto INT NOT NULL,
	id_categoria INT NOT NULL,
	id_administrador INT NOT NULL,
	FOREIGN KEY (id_categoria)
	REFERENCES categorias(id_categoria),
	FOREIGN KEY (id_administrador)
	REFERENCES administradores(id_administrador)
);

CREATE TABLE productos_colores(
	id_producto_color INT PRIMARY KEY AUTO_INCREMENT,
	color_producto VARCHAR(20) NULL,
	id_producto INT,
	FOREIGN KEY (id_producto)
	REFERENCES productos(id_producto)
);

CREATE TABLE productos_tallas(
	id_producto_talla INT PRIMARY KEY AUTO_INCREMENT,
	tallas VARCHAR(30) NOT NULL,
	id_producto_color INT,
	FOREIGN KEY (id_producto_color)
	REFERENCES productos_colores(id_producto_color)
);

CREATE TABLE pedidos(
	id_pedido INT PRIMARY KEY AUTO_INCREMENT,
	fecha_pedido DATE NOT NULL,
	estado_pedido ENUM('Disponible','Agotado') NOT NULL,
	id_cliente INT NOT NULL,
	id_direccion_cliente INT NOT NULL,
	FOREIGN KEY (id_cliente)
	REFERENCES clientes(id_cliente),
	FOREIGN KEY (id_direccion_cliente)
	REFERENCES direcciones_clientes(id_direccion_cliente)
);

CREATE TABLE detalles_pedidos(
	id_detalle_pedido INT PRIMARY KEY AUTO_INCREMENT,
	cantidad_producto INT NOT NULL,
	fecha_valoracion DATE NULL,
	calificacion_producto INT NULL,
	comentario_producto VARCHAR(200) NULL,
	precio_producto NUMERIC(5,2) NOT NULL,
	id_pedido INT NOT NULL,
	id_producto INT NOT NULL,
	FOREIGN KEY(id_pedido)
	REFERENCES pedidos(id_pedido),
	FOREIGN KEY(id_producto)
	REFERENCES productos(id_producto)
);
