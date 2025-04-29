-- Script de Inserción de Datos para GlobalMart Ltda.
USE GlobalMart;

-- Inserción de datos en la tabla Proveedores
INSERT INTO Proveedores (Nombre, Direccion, Telefono, Email, Contacto_Principal, Condiciones_Pago, Fecha_Alta)
VALUES
('Distribuidora Alimenticia S.A.', 'Calle Principal 123, Madrid', '912345678', 'contacto@distribuidora.com', 'María López', 'Pago a 30 días', '2023-01-15'),
('Electrónicos Globales', 'Avenida Tecnológica 45, Barcelona', '934567890', 'ventas@electronicos.com', 'Carlos Rodríguez', 'Pago a 45 días', '2023-02-20'),
('Muebles y Decoración', 'Plaza del Mueble 78, Valencia', '963456789', 'info@mueblesdeco.com', 'Ana Martínez', 'Pago a 60 días', '2023-03-10'),
('Textiles Modernos', 'Calle Textil 34, Sevilla', '954567890', 'pedidos@textiles.com', 'Pedro Sánchez', 'Pago a 30 días', '2023-04-05'),
('Suministros Oficina Pro', 'Avenida Oficina 56, Bilbao', '944567890', 'ventas@suministros.com', 'Laura García', 'Pago a 15 días', '2023-05-12');

-- Inserción de datos en la tabla Productos
INSERT INTO Productos (Nombre, Descripcion, Precio_Unitario, Stock_Actual, Stock_Minimo, Categoria, ID_Proveedor)
VALUES
('Arroz Premium', 'Arroz de grano largo de alta calidad', 2.50, 150, 30, 'Alimentación', 1),
('Aceite de Oliva', 'Aceite de oliva virgen extra 1L', 5.75, 100, 20, 'Alimentación', 1),
('Smartphone X10', 'Smartphone de última generación', 499.99, 25, 5, 'Electrónica', 2),
('Tablet Pro', 'Tablet de 10 pulgadas con 128GB', 349.99, 15, 3, 'Electrónica', 2),
('Sofá Moderno', 'Sofá de 3 plazas en color gris', 599.99, 8, 2, 'Muebles', 3),
('Mesa de Centro', 'Mesa de centro de madera y cristal', 149.99, 12, 3, 'Muebles', 3),
('Camiseta Algodón', 'Camiseta 100% algodón varios colores', 15.99, 80, 15, 'Textil', 4),
('Pantalón Vaquero', 'Pantalón vaquero clásico', 29.99, 60, 10, 'Textil', 4),
('Papel A4', 'Paquete de 500 hojas papel A4', 4.99, 200, 50, 'Oficina', 5),
('Bolígrafos Pack', 'Pack de 10 bolígrafos azules', 3.50, 150, 30, 'Oficina', 5);

-- Inserción de datos en la tabla Pedidos
INSERT INTO Pedidos (Fecha_Pedido, Fecha_Entrega_Estimada, Fecha_Entrega_Real, Estado_Pedido, Total_Pedido, ID_Proveedor)
VALUES
('2023-06-01', '2023-06-10', '2023-06-09', 'Entregado', 1250.00, 1),
('2023-06-15', '2023-06-30', '2023-06-28', 'Entregado', 3500.00, 2),
('2023-07-01', '2023-07-15', '2023-07-16', 'Entregado', 2100.00, 3),
('2023-07-10', '2023-07-25', NULL, 'En Proceso', 1800.00, 4),
('2023-07-20', '2023-08-05', NULL, 'Pendiente', 950.00, 5);

-- Inserción de datos en la tabla Detalles_Pedido
INSERT INTO Detalles_Pedido (ID_Pedido, ID_Producto, Cantidad, Precio_Unitario, Subtotal)
VALUES
(1, 1, 200, 2.50, 500.00),
(1, 2, 150, 5.00, 750.00),
(2, 3, 5, 450.00, 2250.00),
(2, 4, 4, 312.50, 1250.00),
(3, 5, 3, 550.00, 1650.00),
(3, 6, 3, 150.00, 450.00),
(4, 7, 50, 16.00, 800.00),
(4, 8, 40, 25.00, 1000.00),
(5, 9, 100, 4.50, 450.00),
(5, 10, 150, 3.33, 500.00);