-- Script de Consultas SQL para GlobalMart Ltda.
USE GlobalMart;

-- 1. Listado de todos los proveedores ordenados por nombre
SELECT * FROM Proveedores ORDER BY Nombre;

-- 2. Productos con stock por debajo del mínimo (necesitan reposición)
SELECT 
    ID_Producto,
    Nombre,
    Stock_Actual,
    Stock_Minimo,
    (Stock_Minimo - Stock_Actual) AS Unidades_Necesarias
FROM Productos
WHERE Stock_Actual < Stock_Minimo
ORDER BY (Stock_Minimo - Stock_Actual) DESC;

-- 3. Listado de productos por proveedor
SELECT 
    p.ID_Proveedor,
    pr.Nombre AS Nombre_Proveedor,
    p.ID_Producto,
    p.Nombre AS Nombre_Producto,
    p.Precio_Unitario,
    p.Stock_Actual
FROM Productos p
JOIN Proveedores pr ON p.ID_Proveedor = pr.ID_Proveedor
ORDER BY pr.Nombre, p.Nombre;

-- 4. Total de pedidos por proveedor
SELECT 
    pr.ID_Proveedor,
    pr.Nombre AS Nombre_Proveedor,
    COUNT(p.ID_Pedido) AS Numero_Pedidos,
    SUM(p.Total_Pedido) AS Total_Compras
FROM Pedidos p
JOIN Proveedores pr ON p.ID_Proveedor = pr.ID_Proveedor
GROUP BY pr.ID_Proveedor, pr.Nombre
ORDER BY Total_Compras DESC;

-- 5. Detalles de pedidos pendientes o en proceso
SELECT 
    p.ID_Pedido,
    p.Fecha_Pedido,
    p.Fecha_Entrega_Estimada,
    p.Estado_Pedido,
    pr.Nombre AS Proveedor,
    p.Total_Pedido
FROM Pedidos p
JOIN Proveedores pr ON p.ID_Proveedor = pr.ID_Proveedor
WHERE p.Estado_Pedido IN ('Pendiente', 'En Proceso')
ORDER BY p.Fecha_Entrega_Estimada;

-- 6. Productos más solicitados (por cantidad)
SELECT 
    p.ID_Producto,
    p.Nombre,
    p.Categoria,
    SUM(dp.Cantidad) AS Total_Solicitado
FROM Productos p
JOIN Detalles_Pedido dp ON p.ID_Producto = dp.ID_Producto
GROUP BY p.ID_Producto, p.Nombre, p.Categoria
ORDER BY Total_Solicitado DESC
LIMIT 10;

-- 7. Tiempo promedio de entrega por proveedor
SELECT 
    pr.ID_Proveedor,
    pr.Nombre AS Proveedor,
    AVG(DATEDIFF(p.Fecha_Entrega_Real, p.Fecha_Pedido)) AS Promedio_Dias_Entrega
FROM Pedidos p
JOIN Proveedores pr ON p.ID_Proveedor = pr.ID_Proveedor
WHERE p.Fecha_Entrega_Real IS NOT NULL
GROUP BY pr.ID_Proveedor, pr.Nombre
ORDER BY Promedio_Dias_Entrega;

-- 8. Detalle completo de un pedido específico
SELECT 
    p.ID_Pedido,
    p.Fecha_Pedido,
    p.Estado_Pedido,
    pr.Nombre AS Proveedor,
    prod.Nombre AS Producto,
    dp.Cantidad,
    dp.Precio_Unitario,
    dp.Subtotal
FROM Pedidos p
JOIN Proveedores pr ON p.ID_Proveedor = pr.ID_Proveedor
JOIN Detalles_Pedido dp ON p.ID_Pedido = dp.ID_Pedido
JOIN Productos prod ON dp.ID_Producto = prod.ID_Producto
WHERE p.ID_Pedido = 1; -- Cambiar el ID según el pedido que se quiera consultar

-- 9. Valor total del inventario por categoría
SELECT 
    Categoria,
    SUM(Stock_Actual) AS Total_Unidades,
    SUM(Stock_Actual * Precio_Unitario) AS Valor_Inventario
FROM Productos
GROUP BY Categoria
ORDER BY Valor_Inventario DESC;

-- 10. Pedidos entregados fuera de plazo
SELECT 
    p.ID_Pedido,
    p.Fecha_Pedido,
    p.Fecha_Entrega_Estimada,
    p.Fecha_Entrega_Real,
    DATEDIFF(p.Fecha_Entrega_Real, p.Fecha_Entrega_Estimada) AS Dias_Retraso,
    pr.Nombre AS Proveedor
FROM Pedidos p
JOIN Proveedores pr ON p.ID_Proveedor = pr.ID_Proveedor
WHERE p.Fecha_Entrega_Real > p.Fecha_Entrega_Estimada
ORDER BY Dias_Retraso DESC;