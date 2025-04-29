-- Script de Consultas SQL para CarRentalX
USE CarRentalX;

-- 1. Listado de todos los vehículos disponibles
SELECT v.ID_Vehiculo, v.Matricula, v.Marca, v.Modelo, v.Anio, v.Tipo_Combustible, v.Precio_Diario, s.Nombre AS Sucursal
FROM Vehiculos v
JOIN Sucursales s ON v.ID_Sucursal = s.ID_Sucursal
WHERE v.Estado = 'Disponible'
ORDER BY v.Precio_Diario;

-- 2. Listado de reservas activas con información del cliente y vehículo
SELECT r.ID_Reserva, r.Fecha_Inicio, r.Fecha_Fin, r.Costo_Total, 
       c.Nombre AS Nombre_Cliente, c.Apellidos AS Apellidos_Cliente, 
       v.Marca, v.Modelo, v.Matricula,
       s.Nombre AS Sucursal
FROM Reservas r
JOIN Clientes c ON r.ID_Cliente = c.ID_Cliente
JOIN Vehiculos v ON r.ID_Vehiculo = v.ID_Vehiculo
JOIN Sucursales s ON r.ID_Sucursal = s.ID_Sucursal
WHERE r.Estado_Reserva = 'Activa'
ORDER BY r.Fecha_Fin;

-- 3. Vehículos más alquilados (número de veces que se ha alquilado cada vehículo)
SELECT v.ID_Vehiculo, v.Marca, v.Modelo, v.Matricula, COUNT(r.ID_Reserva) AS Numero_Alquileres
FROM Vehiculos v
LEFT JOIN Reservas r ON v.ID_Vehiculo = r.ID_Vehiculo
GROUP BY v.ID_Vehiculo, v.Marca, v.Modelo, v.Matricula
ORDER BY Numero_Alquileres DESC;

-- 4. Clientes frecuentes (número de reservas por cliente)
SELECT c.ID_Cliente, c.Nombre, c.Apellidos, c.Email, COUNT(r.ID_Reserva) AS Numero_Reservas
FROM Clientes c
LEFT JOIN Reservas r ON c.ID_Cliente = r.ID_Cliente
GROUP BY c.ID_Cliente, c.Nombre, c.Apellidos, c.Email
ORDER BY Numero_Reservas DESC;

-- 5. Ingresos mensuales por sucursal (año 2023)
SELECT s.ID_Sucursal, s.Nombre AS Sucursal, 
       MONTH(r.Fecha_Inicio) AS Mes, 
       SUM(r.Costo_Total) AS Ingresos_Totales
FROM Sucursales s
JOIN Reservas r ON s.ID_Sucursal = r.ID_Sucursal
WHERE YEAR(r.Fecha_Inicio) = 2023 AND r.Estado_Reserva IN ('Completada', 'Activa')
GROUP BY s.ID_Sucursal, s.Nombre, MONTH(r.Fecha_Inicio)
ORDER BY s.ID_Sucursal, MONTH(r.Fecha_Inicio);

-- 6. Empleados con más reservas gestionadas
SELECT e.ID_Empleado, e.Nombre, e.Apellidos, e.Cargo, s.Nombre AS Sucursal, COUNT(r.ID_Reserva) AS Reservas_Gestionadas
FROM Empleados e
JOIN Sucursales s ON e.ID_Sucursal = s.ID_Sucursal
LEFT JOIN Reservas r ON e.ID_Empleado = r.ID_Empleado
GROUP BY e.ID_Empleado, e.Nombre, e.Apellidos, e.Cargo, s.Nombre
ORDER BY Reservas_Gestionadas DESC;

-- 7. Duración media de las reservas por tipo de vehículo
SELECT v.Tipo_Combustible, AVG(DATEDIFF(r.Fecha_Fin, r.Fecha_Inicio)) AS Duracion_Media_Dias
FROM Reservas r
JOIN Vehiculos v ON r.ID_Vehiculo = v.ID_Vehiculo
GROUP BY v.Tipo_Combustible
ORDER BY Duracion_Media_Dias DESC;

-- 8. Reservas por mes y año
SELECT YEAR(Fecha_Inicio) AS Anio, MONTH(Fecha_Inicio) AS Mes, COUNT(*) AS Total_Reservas
FROM Reservas
GROUP BY YEAR(Fecha_Inicio), MONTH(Fecha_Inicio)
ORDER BY Anio, Mes;

-- 9. Vehículos que nunca han sido alquilados
SELECT v.ID_Vehiculo, v.Marca, v.Modelo, v.Matricula, s.Nombre AS Sucursal
FROM Vehiculos v
JOIN Sucursales s ON v.ID_Sucursal = s.ID_Sucursal
LEFT JOIN Reservas r ON v.ID_Vehiculo = r.ID_Vehiculo
WHERE r.ID_Reserva IS NULL;

-- 10. Clientes que han gastado más dinero en alquileres
SELECT c.ID_Cliente, c.Nombre, c.Apellidos, SUM(r.Costo_Total) AS Total_Gastado
FROM Clientes c
JOIN Reservas r ON c.ID_Cliente = r.ID_Cliente
WHERE r.Estado_Reserva IN ('Completada', 'Activa')
GROUP BY c.ID_Cliente, c.Nombre, c.Apellidos
ORDER BY Total_Gastado DESC
LIMIT 5;