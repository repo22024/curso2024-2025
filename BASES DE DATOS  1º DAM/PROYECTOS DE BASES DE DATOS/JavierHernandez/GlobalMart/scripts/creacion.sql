-- Script de Creación de Tablas para GlobalMart Ltda.

-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS GlobalMart;
USE GlobalMart;

-- Tabla Proveedores
CREATE TABLE IF NOT EXISTS Proveedores (
    ID_Proveedor INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Direccion VARCHAR(200) NOT NULL,
    Telefono VARCHAR(15) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Contacto_Principal VARCHAR(100) NOT NULL,
    Condiciones_Pago VARCHAR(200) NOT NULL,
    Fecha_Alta DATE NOT NULL
);

-- Tabla Productos
CREATE TABLE IF NOT EXISTS Productos (
    ID_Producto INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion TEXT,
    Precio_Unitario DECIMAL(10, 2) NOT NULL,
    Stock_Actual INT NOT NULL DEFAULT 0,
    Stock_Minimo INT NOT NULL DEFAULT 10,
    Categoria VARCHAR(50) NOT NULL,
    ID_Proveedor INT NOT NULL,
    FOREIGN KEY (ID_Proveedor) REFERENCES Proveedores(ID_Proveedor)
);

-- Tabla Pedidos
CREATE TABLE IF NOT EXISTS Pedidos (
    ID_Pedido INT AUTO_INCREMENT PRIMARY KEY,
    Fecha_Pedido DATE NOT NULL,
    Fecha_Entrega_Estimada DATE NOT NULL,
    Fecha_Entrega_Real DATE,
    Estado_Pedido ENUM('Pendiente', 'En Proceso', 'Entregado', 'Cancelado') NOT NULL DEFAULT 'Pendiente',
    Total_Pedido DECIMAL(10, 2) NOT NULL DEFAULT 0,
    ID_Proveedor INT NOT NULL,
    FOREIGN KEY (ID_Proveedor) REFERENCES Proveedores(ID_Proveedor),
    CHECK (Fecha_Entrega_Estimada >= Fecha_Pedido)
);

-- Tabla Detalles_Pedido
CREATE TABLE IF NOT EXISTS Detalles_Pedido (
    ID_Detalle INT AUTO_INCREMENT PRIMARY KEY,
    ID_Pedido INT NOT NULL,
    ID_Producto INT NOT NULL,
    Cantidad INT NOT NULL,
    Precio_Unitario DECIMAL(10, 2) NOT NULL,
    Subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (ID_Pedido) REFERENCES Pedidos(ID_Pedido),
    FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Producto),
    UNIQUE (ID_Pedido, ID_Producto)
);