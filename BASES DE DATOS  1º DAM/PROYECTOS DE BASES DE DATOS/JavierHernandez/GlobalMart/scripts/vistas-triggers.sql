-- Script de Vistas y Triggers para GlobalMart Ltda.
USE GlobalMart;

-- VISTAS

-- Vista 1: Resumen de Inventario
-- Muestra un resumen del inventario actual con información de stock y valor
CREATE OR REPLACE VIEW Resumen_Inventario AS
SELECT 
    p.ID_Producto,
    p.Nombre,
    p.Categoria,
    p.Stock_Actual,
    p.Stock_Minimo,
    p.Precio_Unitario,
    (p.Stock_Actual * p.Precio_Unitario) AS Valor_Total,
    pr.Nombre AS Proveedor
FROM Productos p
JOIN Proveedores pr ON p.ID_Proveedor = pr.ID_Proveedor;

-- Vista 2: Estado de Pedidos
-- Muestra el estado actual de todos los pedidos con información del proveedor
CREATE OR REPLACE VIEW Estado_Pedidos AS
SELECT 
    p.ID_Pedido,
    p.Fecha_Pedido,
    p.Fecha_Entrega_Estimada,
    p.Fecha_Entrega_Real,
    p.Estado_Pedido,
    p.Total_Pedido,
    pr.Nombre AS Proveedor,
    pr.Contacto_Principal,
    pr.Telefono
FROM Pedidos p
JOIN Proveedores pr ON p.ID_Proveedor = pr.ID_Proveedor;

-- Vista 3: Productos por Reponer
-- Muestra los productos que necesitan reposición (stock por debajo del mínimo)
CREATE OR REPLACE VIEW Productos_Por_Reponer AS
SELECT 
    p.ID_Producto,
    p.Nombre,
    p.Stock_Actual,
    p.Stock_Minimo,
    (p.Stock_Minimo - p.Stock_Actual) AS Unidades_Necesarias,
    pr.Nombre AS Proveedor,
    pr.Telefono,
    pr.Email
FROM Productos p
JOIN Proveedores pr ON p.ID_Proveedor = pr.ID_Proveedor
WHERE p.Stock_Actual < p.Stock_Minimo;

-- TRIGGERS

-- Trigger 1: Actualizar stock al registrar un pedido
DELIMITER //
CREATE TRIGGER actualizar_stock_pedido
AFTER INSERT ON Detalles_Pedido
FOR EACH ROW
BEGIN
    -- Actualizar el stock del producto
    UPDATE Productos
    SET Stock_Actual = Stock_Actual - NEW.Cantidad
    WHERE ID_Producto = NEW.ID_Producto;
    
    -- Verificar si el stock está por debajo del mínimo y generar una alerta (se podría implementar con una tabla de alertas)
    INSERT INTO Alertas_Stock (ID_Producto, Fecha_Alerta, Mensaje)
    SELECT 
        NEW.ID_Producto, 
        NOW(), 
        CONCAT('Stock bajo para producto ID: ', NEW.ID_Producto, '. Stock actual: ', 
               (SELECT Stock_Actual FROM Productos WHERE ID_Producto = NEW.ID_Producto))
    WHERE (SELECT Stock_Actual FROM Productos WHERE ID_Producto = NEW.ID_Producto) < 
          (SELECT Stock_Minimo FROM Productos WHERE ID_Producto = NEW.ID_Producto);
END //
DELIMITER ;

-- Tabla para alertas de stock (necesaria para el trigger anterior)
CREATE TABLE IF NOT EXISTS Alertas_Stock (
    ID_Alerta INT AUTO_INCREMENT PRIMARY KEY,
    ID_Producto INT NOT NULL,
    Fecha_Alerta DATETIME NOT NULL,
    Mensaje TEXT NOT NULL,
    Leida BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Producto)
);

-- Trigger 2: Actualizar el total del pedido al añadir o modificar detalles
DELIMITER //
CREATE TRIGGER actualizar_total_pedido
AFTER INSERT ON Detalles_Pedido
FOR EACH ROW
BEGIN
    UPDATE Pedidos
    SET Total_Pedido = (SELECT SUM(Subtotal) FROM Detalles_Pedido WHERE ID_Pedido = NEW.ID_Pedido)
    WHERE ID_Pedido = NEW.ID_Pedido;
END //
DELIMITER ;

-- Trigger 3: Verificar disponibilidad de stock antes de registrar un pedido
DELIMITER //
CREATE TRIGGER verificar_stock_disponible
BEFORE INSERT ON Detalles_Pedido
FOR EACH ROW
BEGIN
    DECLARE stock_disponible INT;
    
    -- Obtener el stock actual del producto
    SELECT Stock_Actual INTO stock_disponible
    FROM Productos
    WHERE ID_Producto = NEW.ID_Producto;
    
    -- Verificar si hay suficiente stock
    IF stock_disponible < NEW.Cantidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No hay suficiente stock disponible para este producto';
    END IF;
END //
DELIMITER ;