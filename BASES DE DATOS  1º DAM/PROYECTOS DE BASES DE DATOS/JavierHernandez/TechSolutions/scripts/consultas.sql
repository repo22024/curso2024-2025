-- Script de Consultas SQL para TechSolutions Inc.
USE TechSolutions;

-- 1. Listado de empleados por departamento
SELECT 
    d.Nombre AS Departamento,
    e.ID_Empleado,
    CONCAT(e.Nombre, ' ', e.Apellidos) AS Empleado,
    p.Titulo AS Puesto,
    e.Fecha_Contratacion,
    e.Salario
FROM Empleados e
JOIN Departamentos d ON e.ID_Departamento = d.ID_Departamento
JOIN Asignaciones a ON e.ID_Empleado = a.ID_Empleado AND a.Es_Actual = TRUE
JOIN Puestos p ON a.ID_Puesto = p.ID_Puesto
ORDER BY d.Nombre, e.Apellidos, e.Nombre;

-- 2. Listado de puestos vacantes activos
SELECT 
    v.ID_Vacante,
    p.Titulo AS Puesto,
    d.Nombre AS Departamento,
    v.Fecha_Publicacion,
    v.Fecha_Limite,
    v.Numero_Posiciones,
    v.Estado,
    v.Descripcion_Adicional
FROM Vacantes v
JOIN Puestos p ON v.ID_Puesto = p.ID_Puesto
JOIN Departamentos d ON v.ID_Departamento = d.ID_Departamento
WHERE v.Estado IN ('Abierta', 'En Proceso')
ORDER BY v.Fecha_Limite;

-- 3. Candidatos por estado de aplicación
SELECT 
    a.Estado,
    COUNT(*) AS Total_Candidatos
FROM Aplicaciones a
GROUP BY a.Estado
ORDER BY 
    CASE a.Estado
        WHEN 'Pendiente' THEN 1
        WHEN 'Revisada' THEN 2
        WHEN 'Entrevista' THEN 3
        WHEN 'Oferta' THEN 4
        WHEN 'Contratado' THEN 5
        WHEN 'Rechazado' THEN 6
    END;

-- 4. Proyectos activos con sus equipos
SELECT 
    p.ID_Proyecto,
    p.Nombre AS Proyecto,
    p.Estado,
    p.Fecha_Inicio,
    p.Fecha_Fin_Estimada,
    d.Nombre AS Departamento,
    CONCAT(e.Nombre, ' ', e.Apellidos) AS Gerente,
    COUNT(ap.ID_Empleado) AS Tamaño_Equipo
FROM Proyectos p
JOIN Departamentos d ON p.ID_Departamento = d.ID_Departamento
JOIN Empleados e ON p.ID_Gerente = e.ID_Empleado
JOIN Asignaciones_Proyecto ap ON p.ID_Proyecto = ap.ID_Proyecto
WHERE p.Estado IN ('Planificado', 'En Progreso')
GROUP BY p.ID_Proyecto, p.Nombre, p.Estado, p.Fecha_Inicio, p.Fecha_Fin_Estimada, d.Nombre, e.Nombre, e.Apellidos
ORDER BY p.Fecha_Fin_Estimada;

-- 5. Detalle de miembros de un proyecto específico
SELECT 
    p.Nombre AS Proyecto,
    CONCAT(e.Nombre, ' ', e.Apellidos) AS Empleado,
    ap.Rol,
    ap.Horas_Asignadas,
    d.Nombre AS Departamento,
    pu.Titulo AS Puesto_Actual
FROM Asignaciones_Proyecto ap
JOIN Proyectos p ON ap.ID_Proyecto = p.ID_Proyecto
JOIN Empleados e ON ap.ID_Empleado = e.ID_Empleado
JOIN Departamentos d ON e.ID_Departamento = d.ID_Departamento
JOIN Asignaciones a ON e.ID_Empleado = a.ID_Empleado AND a.Es_Actual = TRUE
JOIN Puestos pu ON a.ID_Puesto = pu.ID_Puesto
WHERE p.ID_Proyecto = 3 -- Cambiar según el proyecto que se quiera consultar
ORDER BY ap.Horas_Asignadas DESC;

-- 6. Historial de puestos de un empleado
SELECT 
    CONCAT(e.Nombre, ' ', e.Apellidos) AS Empleado,
    p.Titulo AS Puesto,
    a.Fecha_Inicio,
    a.Fecha_Fin,
    CASE 
        WHEN a.Es_Actual = TRUE THEN 'Actual'
        ELSE 'Anterior'
    END AS Estado
FROM Asignaciones a
JOIN Empleados e ON a.ID_Empleado = e.ID_Empleado
JOIN Puestos p ON a.ID_Puesto = p.ID_Puesto
WHERE e.ID_Empleado = 6 -- Cambiar según el empleado que se quiera consultar
ORDER BY a.Fecha_Inicio DESC;

-- 7. Distribución de empleados por nivel de experiencia
SELECT 
    p.Nivel_Experiencia,
    COUNT(*) AS Total_Empleados,
    ROUND(AVG(e.Salario), 2) AS Salario_Promedio
FROM Empleados e
JOIN Asignaciones a ON e.ID_Empleado = a.ID_Empleado AND a.Es_Actual = TRUE
JOIN Puestos p ON a.ID_Puesto = p.ID_Puesto
GROUP BY p.Nivel_Experiencia
ORDER BY 
    CASE p.Nivel_Experiencia
        WHEN 'Junior' THEN 1
        WHEN 'Semi-Senior' THEN 2
        WHEN 'Senior' THEN 3
        WHEN 'Experto' THEN 4
    END;

-- 8. Carga de trabajo por empleado (horas asignadas a proyectos)
SELECT 
    CONCAT(e.Nombre, ' ', e.Apellidos) AS Empleado,
    d.Nombre AS Departamento,
    pu.Titulo AS Puesto,
    SUM(ap.Horas_Asignadas) AS Total_Horas_Asignadas,
    COUNT(DISTINCT ap.ID_Proyecto) AS Numero_Proyectos
FROM Empleados e
LEFT JOIN Asignaciones_Proyecto ap ON e.ID_Empleado = ap.ID_Empleado
JOIN Departamentos d ON e.ID_Departamento = d.ID_Departamento
JOIN Asignaciones a ON e.ID_Empleado = a.ID_Empleado AND a.Es_Actual = TRUE
JOIN Puestos pu ON a.ID_Puesto = pu.ID_Puesto
GROUP BY e.ID_Empleado, e.Nombre, e.Apellidos, d.Nombre, pu.Titulo
ORDER BY Total_Horas_Asignadas DESC;

-- 9. Análisis de vacantes y aplicaciones
SELECT 
    v.ID_Vacante,
    p.Titulo AS Puesto,
    d.Nombre AS Departamento,
    v.Estado AS Estado_Vacante,
    v.Numero_Posiciones,
    COUNT(a.ID_Aplicacion) AS Total_Aplicaciones,
    SUM(CASE WHEN a.Estado = 'Entrevista' THEN 1 ELSE 0 END) AS En_Entrevista,
    SUM(CASE WHEN a.Estado = 'Oferta' THEN 1 ELSE 0 END) AS Con_Oferta,
    SUM(CASE WHEN a.Estado = 'Contratado' THEN 1 ELSE 0 END) AS Contratados
FROM Vacantes v
JOIN Puestos p ON v.ID_Puesto = p.ID_Puesto
JOIN Departamentos d ON v.ID_Departamento = d.ID_Departamento
LEFT JOIN Aplicaciones a ON v.ID_Vacante = a.ID_Vacante
GROUP BY v.ID_Vacante, p.Titulo, d.Nombre, v.Estado, v.Numero_Posiciones
ORDER BY Total_Aplicaciones DESC;

-- 10. Estructura jerárquica de la empresa (jefes y subordinados)
SELECT 
    CONCAT(jefe.Nombre, ' ', jefe.Apellidos) AS Supervisor,
    dep.Nombre AS Departamento,
    p_jefe.Titulo AS Puesto_Supervisor,
    CONCAT(e.Nombre, ' ', e.Apellidos) AS Subordinado,
    p_sub.Titulo AS Puesto_Subordinado
FROM Empleados e
JOIN Empleados jefe ON e.ID_Supervisor = jefe.ID_Empleado
JOIN Departamentos dep ON jefe.ID_Departamento = dep.ID_Departamento
JOIN Asignaciones a_jefe ON jefe.ID_Empleado = a_jefe.ID_Empleado AND a_jefe.Es_Actual = TRUE
JOIN Puestos p_jefe ON a_jefe.ID_Puesto = p_jefe.ID_Puesto
JOIN Asignaciones a_sub ON e.ID_Empleado = a_sub.ID_Empleado AND a_sub.Es_Actual = TRUE
JOIN Puestos p_sub ON a_sub.ID_Puesto = p_sub.ID_Puesto
ORDER BY dep.Nombre, jefe.Apellidos, jefe.Nombre, e.Apellidos, e.Nombre;