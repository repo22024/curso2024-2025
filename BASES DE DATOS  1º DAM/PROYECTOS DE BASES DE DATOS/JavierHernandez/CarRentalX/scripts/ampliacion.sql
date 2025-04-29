-- Script de Ampliación para CarRentalX
USE CarRentalX;

-- 1. Procedimiento almacenado para calcular el costo total de una reserva
DELIMITER //
CREATE PROCEDURE CalcularCostoReserva(
    IN p_id_vehiculo INT,
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE,
    OUT p_costo_total DECIMAL(10, 2)
)
BEGIN
    DECLARE v_precio_diario DECIMAL(10, 2);
    DECLARE v_dias INT;
    
    -- Obtener el precio diario del vehículo
    SELECT Precio_Diario INTO v_precio_diario
    FROM Vehiculos
    WHERE ID_Vehiculo = p_id_vehiculo;
    
    -- Calcular el número de días
    SET v_dias = DATEDIFF(p_fecha_fin, p_fecha_inicio);
    
    -- Calcular el costo total
    SET p_costo_total = v_precio_diario * v_dias;
    
    -- Si la reserva es por más de 7 días, aplicar un descuento del 10%
    IF v_dias > 7 THEN
        SET p_costo_total = p_costo_total * 0.9;
    END IF;
END //
DELIMITER ;

-- 2. Función para verificar la disponibilidad de un vehículo en un rango de fechas
DELIMITER //
CREATE FUNCTION VerificarDisponibilidadFechas(
    p_id_vehiculo INT,
    p_fecha_inicio DATE,
    p_fecha_fin DATE
) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE v_disponible BOOLEAN;
    DECLARE v_count INT;
    
    -- Verificar si hay reservas que se solapan con el rango de fechas
    SELECT COUNT(*) INTO v_count
    FROM Reservas
    WHERE ID_Vehiculo = p_id_vehiculo
    AND Estado_Reserva IN ('Pendiente', 'Activa')
    AND (
        (Fecha_Inicio <= p_fecha_inicio AND Fecha_Fin >= p_fecha_inicio) OR
        (Fecha_Inicio <= p_fecha_fin AND Fecha_Fin >= p_fecha_fin) OR
        (Fecha_Inicio >= p_fecha_inicio AND Fecha_Fin <= p_fecha_fin)
    );
    
    -- Si no hay reservas que se solapen, el vehículo está disponible
    IF v_count = 0 THEN
        SET v_disponible = TRUE;
    ELSE
        SET v_disponible = FALSE;
    END IF;
    
    RETURN v_disponible;
END //
DELIMITER ;

-- 3. Tabla para registrar el historial de mantenimiento de vehículos
CREATE TABLE IF NOT EXISTS Mantenimiento_Vehiculos (
    ID_Mantenimiento INT AUTO_INCREMENT PRIMARY KEY,
    ID_Vehiculo INT NOT NULL,
    Fecha_Mantenimiento DATE NOT NULL,
    Descripcion VARCHAR(200) NOT NULL,
    Costo DECIMAL(10, 2) NOT NULL,
    Realizado_Por VARCHAR(100) NOT NULL,
    FOREIGN KEY (ID_Vehiculo) REFERENCES Vehiculos(ID_Vehiculo)
);

-- 4. Procedimiento para registrar un mantenimiento de vehículo
DELIMITER //
CREATE PROCEDURE RegistrarMantenimiento(
    IN p_id_vehiculo INT,
    IN p_descripcion VARCHAR(200),
    IN p_costo DECIMAL(10, 2),
    IN p_realizado_por VARCHAR(100)
)
BEGIN
    -- Insertar el registro de mantenimiento
    INSERT INTO Mantenimiento_Vehiculos (ID_Vehiculo, Fecha_Mantenimiento, Descripcion, Costo, Realizado_Por)
    VALUES (p_id_vehiculo, CURDATE(), p_descripcion, p_costo, p_realizado_por);
    
    -- Actualizar el estado del vehículo a 'Mantenimiento'
    UPDATE Vehiculos
    SET Estado = 'Mantenimiento'
    WHERE ID_Vehiculo = p_id_vehiculo;
END //
DELIMITER ;

-- 5. Procedimiento para finalizar un mantenimiento de vehículo
DELIMITER //
CREATE PROCEDURE FinalizarMantenimiento(
    IN p_id_vehiculo INT
)
BEGIN
    -- Verificar si el vehículo está en mantenimiento
    DECLARE v_estado VARCHAR(20);
    
    SELECT Estado INTO v_estado
    FROM Vehiculos
    WHERE ID_Vehiculo = p_id_vehiculo;
    
    IF v_estado = 'Mantenimiento' THEN
        -- Actualizar el estado del vehículo a 'Disponible'
        UPDATE Vehiculos
        SET Estado = 'Disponible'
        WHERE ID_Vehiculo = p_id_vehiculo;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El vehículo no está en mantenimiento';
    END IF;
END //
DELIMITER ;

-- 6. Vista para mostrar el historial de mantenimiento de vehículos
CREATE OR REPLACE VIEW HistorialMantenimiento AS
SELECT m.ID_Mantenimiento, v.Matricula, v.Marca, v.Modelo, 
       m.Fecha_Mantenimiento, m.Descripcion, m.Costo, m.Realizado_Por
FROM Mantenimiento_Vehiculos m
JOIN Vehiculos v ON m.ID_Vehiculo = v.ID_Vehiculo
ORDER BY m.Fecha_Mantenimiento DESC;

-- 7. Evento para verificar y actualizar el estado de las reservas diariamente
DELIMITER //
CREATE EVENT ActualizarEstadoReservas
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_DATE
DO
BEGIN
    -- Actualizar reservas pendientes a activas si la fecha de inicio es hoy
    UPDATE Reservas
    SET Estado_Reserva = 'Activa'
    WHERE Estado_Reserva = 'Pendiente' AND Fecha_Inicio = CURDATE();
    
    -- Actualizar reservas activas a completadas si la fecha de fin es ayer
    UPDATE Reservas
    SET Estado_Reserva = 'Completada'
    WHERE Estado_Reserva = 'Activa' AND Fecha_Fin < CURDATE();
END //
DELIMITER ;