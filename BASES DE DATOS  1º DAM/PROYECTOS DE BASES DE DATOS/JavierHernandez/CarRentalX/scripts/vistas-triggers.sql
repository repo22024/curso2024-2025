-- Script de Vistas y Triggers para CarRentalX
USE CarRentalX;

-- VISTAS

-- Vista de vehículos disponibles con información de la sucursal
CREATE OR REPLACE VIEW VehiculosDisponibles AS
SELECT v.ID_Vehiculo, v.Matricula, v.Marca, v.Modelo, v.Anio, v.Tipo_Combustible, 
       v.Precio_Diario, s.Nombre AS Sucursal, s.Direccion AS Direccion_Sucursal, 
       s.Telefono AS Telefono_Sucursal
FROM Vehiculos v
JOIN Sucursales s ON v.ID_Sucursal = s.ID_Sucursal
WHERE v.Estado = 'Disponible';

-- Vista de reservas activas con información detallada
CREATE OR REPLACE VIEW ReservasActivas AS
SELECT r.ID_Reserva, r.Fecha_Inicio, r.Fecha_Fin, r.Costo_Total, 
       c.Nombre AS Nombre_Cliente, c.Apellidos AS Apellidos_Cliente, 
       c.Telefono AS Telefono_Cliente, c.Email AS Email_Cliente,
       v.Marca AS Marca_Vehiculo, v.Modelo AS Modelo_Vehiculo, v.Matricula,
       e.Nombre AS Nombre_Empleado, e.Apellidos AS Apellidos_Empleado,
       s.Nombre AS Sucursal
FROM Reservas r
JOIN Clientes c ON r.ID_Cliente = c.ID_Cliente
JOIN Vehiculos v ON r.ID_Vehiculo = v.ID_Vehiculo
JOIN Empleados e ON r.ID_Empleado = e.ID_Empleado
JOIN Sucursales s ON r.ID_Sucursal = s.ID_Sucursal
WHERE r.Estado_Reserva = 'Activa';

-- Vista de ingresos mensuales por sucursal
CREATE OR REPLACE VIEW IngresosMensualesPorSucursal AS
SELECT s.ID_Sucursal, s.Nombre AS Sucursal, 
       YEAR(r.Fecha_Inicio) AS Anio,
       MONTH(r.Fecha_Inicio) AS Mes, 
       SUM(r.Costo_Total) AS Ingresos_Totales
FROM Sucursales s
JOIN Reservas r ON s.ID_Sucursal = r.ID_Sucursal
WHERE r.Estado_Reserva IN ('Completada', 'Activa')
GROUP BY s.ID_Sucursal, s.Nombre, YEAR(r.Fecha_Inicio), MONTH(r.Fecha_Inicio);

-- Vista de clientes frecuentes
CREATE OR REPLACE VIEW ClientesFrecuentes AS
SELECT c.ID_Cliente, c.Nombre, c.Apellidos, c.Email, c.Telefono,
       COUNT(r.ID_Reserva) AS Numero_Reservas,
       SUM(r.Costo_Total) AS Total_Gastado
FROM Clientes c
JOIN Reservas r ON c.ID_Cliente = r.ID_Cliente
WHERE r.Estado_Reserva IN ('Completada', 'Activa')
GROUP BY c.ID_Cliente, c.Nombre, c.Apellidos, c.Email, c.Telefono
HAVING COUNT(r.ID_Reserva) >= 2;

-- TRIGGERS

-- Trigger para actualizar el estado del vehículo cuando se crea una reserva
DELIMITER //
CREATE TRIGGER ActualizarEstadoVehiculoReserva
AFTER INSERT ON Reservas
FOR EACH ROW
BEGIN
    IF NEW.Estado_Reserva IN ('Pendiente', 'Activa') THEN
        UPDATE Vehiculos
        SET Estado = 'Alquilado'
        WHERE ID_Vehiculo = NEW.ID_Vehiculo;
    END IF;
END //
DELIMITER ;

-- Trigger para actualizar el estado del vehículo cuando se actualiza una reserva
DELIMITER //
CREATE TRIGGER ActualizarEstadoVehiculoActualizacion
AFTER UPDATE ON Reservas
FOR EACH ROW
BEGIN
    IF NEW.Estado_Reserva = 'Completada' OR NEW.Estado_Reserva = 'Cancelada' THEN
        UPDATE Vehiculos
        SET Estado = 'Disponible'
        WHERE ID_Vehiculo = NEW.ID_Vehiculo;
    ELSEIF NEW.Estado_Reserva IN ('Pendiente', 'Activa') AND OLD.Estado_Reserva IN ('Completada', 'Cancelada') THEN
        UPDATE Vehiculos
        SET Estado = 'Alquilado'
        WHERE ID_Vehiculo = NEW.ID_Vehiculo;
    END IF;
END //
DELIMITER ;

-- Trigger para verificar la disponibilidad del vehículo antes de crear una reserva
DELIMITER //
CREATE TRIGGER VerificarDisponibilidadVehiculo
BEFORE INSERT ON Reservas
FOR EACH ROW
BEGIN
    DECLARE vehiculo_estado VARCHAR(20);
    
    SELECT Estado INTO vehiculo_estado
    FROM Vehiculos
    WHERE ID_Vehiculo = NEW.ID_Vehiculo;
    
    IF vehiculo_estado != 'Disponible' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El vehículo no está disponible para reserva';
    END IF;
END //
DELIMITER ;