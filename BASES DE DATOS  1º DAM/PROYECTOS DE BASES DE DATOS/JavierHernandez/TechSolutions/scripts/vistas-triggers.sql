-- Script de Vistas y Triggers para TechSolutions Inc.
USE TechSolutions;

-- VISTAS

-- Vista 1: Información completa de empleados
CREATE OR REPLACE VIEW Informacion_Empleados AS
SELECT 
    e.ID_Empleado,
    CONCAT(e.Nombre, ' ', e.Apellidos) AS Nombre_Completo,
    e.Email,
    e.Telefono,
    e.Fecha_Contratacion,
    e.Salario,
    d.Nombre AS Departamento,
    p.Titulo AS Puesto,
    p.Nivel_Experiencia,
    CONCAT(sup.Nombre, ' ', sup.Apellidos) AS Supervisor
FROM Empleados e
JOIN Departamentos d ON e.ID_Departamento = d.ID_Departamento
JOIN Asignaciones a ON e.ID_Empleado = a.ID_Empleado AND a.Es_Actual = TRUE
JOIN Puestos p ON a.ID_Puesto = p.ID_Puesto
LEFT JOIN Empleados sup ON e.ID_Supervisor = sup.ID_Empleado;

-- Vista 2: Resumen de proyectos
CREATE OR REPLACE VIEW Resumen_Proyectos AS
SELECT 
    p.ID_Proyecto,
    p.Nombre,
    p.Estado,
    p.Fecha_Inicio,
    p.Fecha_Fin_Estimada,
    p.Fecha_Fin_Real,
    p.Presupuesto,
    d.Nombre AS Departamento,
    CONCAT(e.Nombre, ' ', e.Apellidos) AS Gerente,
    COUNT(ap.ID_Empleado) AS Tamaño_Equipo,
    SUM(ap.Horas_Asignadas) AS Total_Horas_Asignadas
FROM Proyectos p
JOIN Departamentos d ON p.ID_Departamento = d.ID_Departamento
JOIN Empleados e ON p.ID_Gerente = e.ID_Empleado
LEFT JOIN Asignaciones_Proyecto ap ON p.ID_Proyecto = ap.ID_Proyecto
GROUP BY p.ID_Proyecto, p.Nombre, p.Estado, p.Fecha_Inicio, p.Fecha_Fin_Estimada, 
         p.Fecha_Fin_Real, p.Presupuesto, d.Nombre, e.Nombre, e.Apellidos;

-- Vista 3: Estado de vacantes y aplicaciones
CREATE OR REPLACE VIEW Estado_Vacantes AS
SELECT 
    v.ID_Vacante,
    p.Titulo AS Puesto,
    d.Nombre AS Departamento,
    v.Fecha_Publicacion,
    v.Fecha_Limite,
    v.Estado AS Estado_Vacante,
    v.Numero_Posiciones,
    COUNT(a.ID_Aplicacion) AS Total_Aplicaciones,
    SUM(CASE WHEN a.Estado = 'Pendiente' THEN 1 ELSE 0 END) AS Pendientes,
    SUM(CASE WHEN a.Estado = 'Revisada' THEN 1 ELSE 0 END) AS Revisadas,
    SUM(CASE WHEN a.Estado = 'Entrevista' THEN 1 ELSE 0 END) AS En_Entrevista,
    SUM(CASE WHEN a.Estado = 'Oferta' THEN 1 ELSE 0 END) AS Con_Oferta,
    SUM(CASE WHEN a.Estado = 'Contratado' THEN 1 ELSE 0 END) AS Contratados,
    SUM(CASE WHEN a.Estado = 'Rechazado' THEN 1 ELSE 0 END) AS Rechazados
FROM Vacantes v
JOIN Puestos p ON v.ID_Puesto = p.ID_Puesto
JOIN Departamentos d ON v.ID_Departamento = d.ID_Departamento
LEFT JOIN Aplicaciones a ON v.ID_Vacante = a.ID_Vacante
GROUP BY v.ID_Vacante, p.Titulo, d.Nombre, v.Fecha_Publicacion, v.Fecha_Limite, v.Estado, v.Numero_Posiciones;

-- TRIGGERS

-- Trigger 1: Actualizar estado de vacante cuando se contrata a un candidato
DELIMITER //
CREATE TRIGGER actualizar_estado_vacante
AFTER UPDATE ON Aplicaciones
FOR EACH ROW
BEGIN
    DECLARE posiciones_cubiertas INT;
    DECLARE posiciones_totales INT;
    
    -- Si el estado cambia a 'Contratado'
    IF NEW.Estado = 'Contratado' AND OLD.Estado != 'Contratado' THEN
        -- Contar cuántas posiciones ya están cubiertas para esta vacante
        SELECT COUNT(*) INTO posiciones_cubiertas
        FROM Aplicaciones
        WHERE ID_Vacante = NEW.ID_Vacante AND Estado = 'Contratado';
        
        -- Obtener el número total de posiciones para esta vacante
        SELECT Numero_Posiciones INTO posiciones_totales
        FROM Vacantes
        WHERE ID_Vacante = NEW.ID_Vacante;
        
        -- Si todas las posiciones están cubiertas, cambiar el estado de la vacante a 'Cerrada'
        IF posiciones_cubiertas >= posiciones_totales THEN
            UPDATE Vacantes
            SET Estado = 'Cerrada'
            WHERE ID_Vacante = NEW.ID_Vacante;
        END IF;
    END IF;
END //
DELIMITER ;

-- Trigger 2: Actualizar estado del candidato cuando cambia el estado de su aplicación
DELIMITER //
CREATE TRIGGER actualizar_estado_candidato
AFTER UPDATE ON Aplicaciones
FOR EACH ROW
BEGIN
    -- Actualizar el estado del candidato según el estado de la aplicación
    IF NEW.Estado != OLD.Estado THEN
        UPDATE Candidatos
        SET Estado = NEW.Estado
        WHERE ID_Candidato = NEW.ID_Candidato;
    END IF;
END //
DELIMITER ;

-- Trigger 3: Verificar que el salario de un empleado esté dentro del rango del puesto
DELIMITER //
CREATE TRIGGER verificar_salario_empleado
BEFORE INSERT ON Empleados
FOR EACH ROW
BEGIN
    DECLARE min_salario DECIMAL(10, 2);
    DECLARE max_salario DECIMAL(10, 2);
    DECLARE puesto_id INT;
    
    -- Obtener el ID del puesto que se asignará al empleado
    -- Nota: Este trigger asume que se insertará un registro en la tabla Asignaciones después
    -- En un sistema real, esto podría manejarse con procedimientos almacenados
    
    -- Como ejemplo, verificamos que el salario esté dentro de algún rango válido de puestos
    SELECT MIN(Salario_Minimo), MAX(Salario_Maximo)
    INTO min_salario, max_salario
    FROM Puestos;
    
    -- Verificar que el salario esté dentro del rango global
    IF NEW.Salario < min_salario OR NEW.Salario > max_salario THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El salario está fuera del rango permitido para cualquier puesto';
    END IF;
END //
DELIMITER ;

-- Trigger 4: Marcar asignaciones anteriores como no actuales al crear una nueva
DELIMITER //
CREATE TRIGGER actualizar_asignaciones_empleado
BEFORE INSERT ON Asignaciones
FOR EACH ROW
BEGIN
    -- Si la nueva asignación es actual, desactivar las anteriores
    IF NEW.Es_Actual = TRUE THEN
        UPDATE Asignaciones
        SET 
            Es_Actual = FALSE,
            Fecha_Fin = CURDATE()
        WHERE 
            ID_Empleado = NEW.ID_Empleado 
            AND Es_Actual = TRUE;
    END IF;
END //
DELIMITER ;