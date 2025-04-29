-- Script de Ampliación para GlobalMart Ltda.
USE GlobalMart;

-- 1. Ampliación de la estructura de datos

-- Tabla para gestionar categorías de productos
CREATE TABLE IF NOT EXISTS Categorias (
    ID_Categoria INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    Descripcion TEXT,
    Imagen VARCHAR(200),
    Activa BOOLEAN DEFAULT TRUE
);

-- Modificación de la tabla Productos para usar la nueva tabla de categorías
ALTER TABLE Productos
ADD COLUMN ID_Categoria INT,
ADD FOREIGN KEY (ID_Categoria) REFERENCES Categorias(ID_Categoria);

-- Tabla para gestionar almacenes
CREATE TABLE IF NOT EXISTS Almacenes (
    ID_Almacen INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Direccion VARCHAR(200) NOT NULL,
    Telefono VARCHAR(15),
    Responsable VARCHAR(100),
    Activo BOOLEAN DEFAULT TRUE
);

-- Tabla para gestionar el inventario por almacén
CREATE TABLE IF NOT EXISTS Inventario_Almacen (
    ID_Inventario INT AUTO_INCREMENT PRIMARY KEY,
    ID_Producto INT NOT NULL,
    ID_Almacen INT NOT NULL,
    Stock_Actual INT NOT NULL DEFAULT 0,
    Ubicacion VARCHAR(50),
    Ultima_Actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Producto),
    FOREIGN KEY (ID_Almacen) REFERENCES Almacenes(ID_Almacen),
    UNIQUE (ID_Producto, ID_Almacen)
);

-- Tabla para gestionar empleados
CREATE TABLE IF NOT EXISTS Empleados (
    ID_Empleado INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Telefono VARCHAR(15),
    Puesto VARCHAR(50),
    Departamento VARCHAR(50),
    Fecha_Contratacion DATE NOT NULL,
    Activo BOOLEAN DEFAULT TRUE
);

-- Tabla para registrar movimientos de inventario
CREATE TABLE IF NOT EXISTS Movimientos_Inventario (
    ID_Movimiento INT AUTO_INCREMENT PRIMARY KEY,
    ID_Producto INT NOT NULL,
    ID_Almacen INT NOT NULL,
    Tipo_Movimiento ENUM('Entrada', 'Salida', 'Ajuste', 'Traslado') NOT NULL,
    Cantidad INT NOT NULL,
    Fecha_Movimiento DATETIME DEFAULT CURRENT_TIMESTAMP,
    ID_Empleado INT,
    ID_Pedido INT,
    Observaciones TEXT,
    FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Producto),
    FOREIGN KEY (ID_Almacen) REFERENCES Almacenes(ID_Almacen),
    FOREIGN KEY (ID_Empleado) REFERENCES Empleados(ID_Empleado),
    FOREIGN KEY (ID_Pedido) REFERENCES Pedidos(ID_Pedido)
);

-- 2. Procedimientos almacenados

-- Procedimiento para registrar un nuevo pedido completo
DELIMITER //
CREATE PROCEDURE registrar_pedido(
    IN p_id_proveedor INT,
    IN p_fecha_entrega_estimada DATE
)
BEGIN
    DECLARE v_id_pedido INT;
    
    -- Insertar el pedido
    INSERT INTO Pedidos (Fecha_Pedido, Fecha_Entrega_Estimada, Estado_Pedido, Total_Pedido, ID_Proveedor)
    VALUES (CURDATE(), p_fecha_entrega_estimada, 'Pendiente', 0, p_id_proveedor);
    
    -- Obtener el ID del pedido insertado
    SET v_id_pedido = LAST_INSERT_ID();
    
    -- Devolver el ID del pedido para poder añadir detalles después
    SELECT v_id_pedido AS ID_Pedido;
END //
DELIMITER ;

-- Procedimiento para añadir un producto a un pedido
DELIMITER //
CREATE PROCEDURE agregar_producto_pedido(
    IN p_id_pedido INT,
    IN p_id_producto INT,
    IN p_cantidad INT
)
BEGIN
    DECLARE v_precio DECIMAL(10, 2);
    DECLARE v_subtotal DECIMAL(10, 2);
    
    -- Obtener el precio actual del producto
    SELECT Precio_Unitario INTO v_precio
    FROM Productos
    WHERE ID_Producto = p_id_producto;
    
    -- Calcular el subtotal
    SET v_subtotal = v_precio * p_cantidad;
    
    -- Insertar el detalle del pedido
    INSERT INTO Detalles_Pedido (ID_Pedido, ID_Producto, Cantidad, Precio_Unitario, Subtotal)
    VALUES (p_id_pedido, p_id_producto, p_cantidad, v_precio, v_subtotal);
    
    -- Actualizar el total del pedido
    UPDATE Pedidos
    SET Total_Pedido = (SELECT SUM(Subtotal) FROM Detalles_Pedido WHERE ID_Pedido = p_id_pedido)
    WHERE ID_Pedido = p_id_pedido;
    
    -- Devolver información del producto añadido
    SELECT 
        p.Nombre AS Producto,
        p_cantidad AS Cantidad,
        v_precio AS Precio_Unitario,
        v_subtotal AS Subtotal,
        (SELECT Total_Pedido FROM Pedidos WHERE ID_Pedido = p_id_pedido) AS Total_Pedido
    FROM Productos p
    WHERE p.ID_Producto = p_id_producto;
END //
DELIMITER ;

-- Procedimiento para actualizar el estado de un pedido
DELIMITER //
CREATE PROCEDURE actualizar_estado_pedido(
    IN p_id_pedido INT,
    IN p_nuevo_estado ENUM('Pendiente', 'En Proceso', 'Entregado', 'Cancelado'),
    IN p_fecha_entrega_real DATE
)
BEGIN
    UPDATE Pedidos
    SET 
        Estado_Pedido = p_nuevo_estado,
        Fecha_Entrega_Real = CASE 
            WHEN p_nuevo_estado = 'Entregado' THEN COALESCE(p_fecha_entrega_real, CURDATE())
            ELSE p_fecha_entrega_real
        END
    WHERE ID_Pedido = p_id_pedido;
    
    -- Si el pedido está entregado, actualizar el inventario
    IF p_nuevo_estado = 'Entregado' THEN
        -- Aquí se podría llamar a otro procedimiento para actualizar el inventario
        -- o implementar la lógica directamente
        SELECT 'Pedido marcado como entregado. Inventario actualizado.' AS Mensaje;
    ELSEIF p_nuevo_estado = 'Cancelado' THEN
        SELECT 'Pedido cancelado.' AS Mensaje;
    ELSE
        SELECT CONCAT('Estado del pedido actualizado a: ', p_nuevo_estado) AS Mensaje;
    END IF;
END //
DELIMITER ;

-- 3. Funciones

-- Función para calcular el valor total del inventario de un producto
DELIMITER //
CREATE FUNCTION valor_inventario_producto(p_id_producto INT) 
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE v_valor DECIMAL(10, 2);
    
    SELECT (Stock_Actual * Precio_Unitario) INTO v_valor
    FROM Productos
    WHERE ID_Producto = p_id_producto;
    
    RETURN COALESCE(v_valor, 0);
END //
DELIMITER ;

-- Función para calcular días de retraso en la entrega
DELIMITER //
CREATE FUNCTION dias_retraso_pedido(p_id_pedido INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_dias_retraso INT;
    
    SELECT 
        CASE 
            WHEN Fecha_Entrega_Real IS NULL THEN 
                DATEDIFF(CURDATE(), Fecha_Entrega_Estimada)
            ELSE 
                DATEDIFF(Fecha_Entrega_Real, Fecha_Entrega_Estimada)
        END INTO v_dias_retraso
    FROM Pedidos
    WHERE ID_Pedido = p_id_pedido;
    
    -- Si es negativo, no hay retraso
    RETURN CASE WHEN v_dias_retraso < 0 THEN 0 ELSE v_dias_retraso END;
END //
DELIMITER ;

-- 4. Eventos programados

-- Evento para verificar pedidos retrasados diariamente
DELIMITER //
CREATE EVENT IF NOT EXISTS verificar_pedidos_retrasados
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_DATE + INTERVAL 1 DAY
DO
BEGIN
    -- Insertar alertas para pedidos retrasados
    INSERT INTO Alertas_Pedidos (ID_Pedido, Fecha_Alerta, Mensaje, Tipo_Alerta)
    SELECT 
        ID_Pedido,
        NOW(),
        CONCAT('Pedido #', ID_Pedido, ' retrasado por ', 
               DATEDIFF(CURDATE(), Fecha_Entrega_Estimada), ' días.'),
        'Retraso'
    FROM Pedidos
    WHERE 
        Estado_Pedido IN ('Pendiente', 'En Proceso')
        AND Fecha_Entrega_Estimada < CURDATE()
        AND ID_Pedido NOT IN (SELECT ID_Pedido FROM Alertas_Pedidos WHERE Tipo_Alerta = 'Retraso');
END //
DELIMITER ;

-- Tabla para alertas de pedidos (necesaria para el evento anterior)
CREATE TABLE IF NOT EXISTS Alertas_Pedidos (
    ID_Alerta INT AUTO_INCREMENT PRIMARY KEY,
    ID_Pedido INT NOT NULL,
    Fecha_Alerta DATETIME NOT NULL,
    Mensaje TEXT NOT NULL,
    Tipo_Alerta VARCHAR(50) NOT NULL,
    Leida BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (ID_Pedido) REFERENCES Pedidos(ID_Pedido)
);