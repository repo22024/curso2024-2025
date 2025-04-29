-- Script de Ampliación para TechSolutions Inc.
USE TechSolutions;

-- 1. Ampliación de la estructura de datos

-- Tabla para gestionar habilidades técnicas
CREATE TABLE IF NOT EXISTS Habilidades (
    ID_Habilidad INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL UNIQUE,
    Categoria ENUM('Técnica', 'Blanda', 'Idioma', 'Certificación') NOT NULL,
    Descripcion TEXT
);

-- Tabla para relacionar empleados con habilidades
CREATE TABLE IF NOT EXISTS Habilidades_Empleado (
    ID_Empleado INT NOT NULL,
    ID_Habilidad INT NOT NULL,
    Nivel ENUM('Básico', 'Intermedio', 'Avanzado', 'Experto') NOT NULL,
    Fecha_Adquisicion DATE,
    Certificado BOOLEAN DEFAULT FALSE,
    URL_Certificado VARCHAR(255),
    PRIMARY KEY (ID_Empleado, ID_Habilidad),
    FOREIGN KEY (ID_Empleado) REFERENCES Empleados(ID_Empleado),
    FOREIGN KEY (ID_Habilidad) REFERENCES Habilidades(ID_Habilidad)
);

-- Tabla para gestionar evaluaciones de desempeño
CREATE TABLE IF NOT EXISTS Evaluaciones (
    ID_Evaluacion INT AUTO_INCREMENT PRIMARY KEY,
    ID_Empleado INT NOT NULL,
    ID_Evaluador INT NOT NULL,
    Fecha_Evaluacion DATE NOT NULL,
    Periodo VARCHAR(50) NOT NULL,
    Puntuacion_Global DECIMAL(3, 2) NOT NULL,
    Comentarios TEXT,
    Objetivos_Proximos TEXT,
    FOREIGN KEY (ID_Empleado) REFERENCES Empleados(ID_Empleado),
    FOREIGN KEY (ID_Evaluador) REFERENCES Empleados(ID_Empleado)
);

-- Tabla para detalles de evaluación por competencias
CREATE TABLE IF NOT EXISTS Detalles_Evaluacion (
    ID_Detalle INT AUTO_INCREMENT PRIMARY KEY,
    ID_Evaluacion INT NOT NULL,
    Competencia VARCHAR(100) NOT NULL,
    Puntuacion DECIMAL(3, 2) NOT NULL,
    Comentario TEXT,
    FOREIGN KEY (ID_Evaluacion) REFERENCES Evaluaciones(ID_Evaluacion)
);

-- Tabla para gestionar formación y capacitación
CREATE TABLE IF NOT EXISTS Formacion (
    ID_Formacion INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(200) NOT NULL,
    Descripcion TEXT,
    Tipo ENUM('Curso', 'Taller', 'Seminario', 'Conferencia', 'Certificación') NOT NULL,
    Proveedor VARCHAR(100),
    Duracion INT, -- En horas
    Costo DECIMAL(10, 2),
    URL_Informacion VARCHAR(255)
);

-- Tabla para relacionar empleados con formaciones
CREATE TABLE IF NOT EXISTS Formacion_Empleado (
    ID_Empleado INT NOT NULL,
    ID_Formacion INT NOT NULL,
    Fecha_Inicio DATE NOT NULL,
    Fecha_Fin DATE,
    Estado ENUM('Pendiente', 'En Curso', 'Completado', 'Cancelado') NOT NULL DEFAULT 'Pendiente',
    Calificacion VARCHAR(20),
    Comentarios TEXT,
    PRIMARY KEY (ID_Empleado, ID_Formacion),
    FOREIGN KEY (ID_Empleado) REFERENCES Empleados(ID_Empleado),
    FOREIGN KEY (ID_Formacion) REFERENCES Formacion(ID_Formacion)
);

-- Tabla para gestionar entrevistas
CREATE TABLE IF NOT EXISTS Entrevistas (
    ID_Entrevista INT AUTO_INCREMENT PRIMARY KEY,
    ID_Aplicacion INT NOT NULL,
    Tipo ENUM('Telefónica', 'Técnica', 'RRHH', 'Final') NOT NULL,
    Fecha DATETIME NOT NULL,
    ID_Entrevistador INT NOT NULL,
    Duracion INT, -- En minutos
    Resultado ENUM('Pendiente', 'Aprobado', 'Rechazado', 'En Consideración') NOT NULL DEFAULT 'Pendiente',
    Comentarios TEXT,
    Siguiente_Paso VARCHAR(100),
    FOREIGN KEY (ID_Aplicacion) REFERENCES Aplicaciones(ID_Aplicacion),
    FOREIGN KEY (ID_Entrevistador) REFERENCES Empleados(ID_Empleado)
);

-- 2. Procedimientos almacenados

-- Procedimiento para registrar una nueva vacante
DELIMITER //
CREATE PROCEDURE registrar_vacante(
    IN p_id_puesto INT,
    IN p_id_departamento INT,
    IN p_fecha_limite DATE,
    IN p_numero_posiciones INT,
    IN p_descripcion_adicional TEXT
)
BEGIN
    INSERT INTO Vacantes (
        ID_Puesto,
        ID_Departamento,
        Fecha_Publicacion,
        Fecha_Limite,
        Estado,
        Numero_Posiciones,
        Descripcion_Adicional
    ) VALUES (
        p_id_puesto,
        p_id_departamento,
        CURDATE(),
        p_fecha_limite,
        'Abierta',
        p_numero_posiciones,
        p_descripcion_adicional
    );
    
    SELECT LAST_INSERT_ID() AS ID_Vacante;
END //
DELIMITER ;

-- Procedimiento para registrar un nuevo candidato y su aplicación
DELIMITER //
CREATE PROCEDURE registrar_candidato_aplicacion(
    IN p_nombre VARCHAR(50),
    IN p_apellidos VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_telefono VARCHAR(15),
    IN p_cv_url VARCHAR(255),
    IN p_id_vacante INT
)
BEGIN
    DECLARE v_id_candidato INT;
    
    -- Verificar si el candidato ya existe
    SELECT ID_Candidato INTO v_id_candidato
    FROM Candidatos
    WHERE Email = p_email
    LIMIT 1;
    
    -- Si no existe, crear nuevo candidato
    IF v_id_candidato IS NULL THEN
        INSERT INTO Candidatos (
            Nombre,
            Apellidos,
            Email,
            Telefono,
            CV_URL,
            Fecha_Aplicacion,
            Estado
        ) VALUES (
            p_nombre,
            p_apellidos,
            p_email,
            p_telefono,
            p_cv_url,
            CURDATE(),
            'Recibido'
        );
        
        SET v_id_candidato = LAST_INSERT_ID();
    END IF;
    
    -- Verificar si ya existe una aplicación para esta vacante
    IF NOT EXISTS (SELECT 1 FROM Aplicaciones WHERE ID_Candidato = v_id_candidato AND ID_Vacante = p_id_vacante) THEN
        -- Crear la aplicación
        INSERT INTO Aplicaciones (
            ID_Candidato,
            ID_Vacante,
            Fecha_Aplicacion,
            Estado,
            Notas
        ) VALUES (
            v_id_candidato,
            p_id_vacante,
            CURDATE(),
            'Pendiente',
            'Aplicación recibida a través del sistema'
        );
        
        SELECT 'Candidato y aplicación registrados correctamente' AS Mensaje;
    ELSE
        SELECT 'El candidato ya ha aplicado a esta vacante' AS Mensaje;
    END IF;
END //
DELIMITER ;

-- Procedimiento para programar una entrevista
DELIMITER //
CREATE PROCEDURE programar_entrevista(
    IN p_id_aplicacion INT,
    IN p_tipo ENUM('Telefónica', 'Técnica', 'RRHH', 'Final'),
    IN p_fecha DATETIME,
    IN p_id_entrevistador INT,
    IN p_duracion INT
)
BEGIN
    -- Registrar la entrevista
    INSERT INTO Entrevistas (
        ID_Aplicacion,
        Tipo,
        Fecha,
        ID_Entrevistador,
        Duracion,
        Resultado,
        Comentarios
    ) VALUES (
        p_id_aplicacion,
        p_tipo,
        p_fecha,
        p_id_entrevistador,
        p_duracion,
        'Pendiente',
        'Entrevista programada'
    );
    
    -- Actualizar el estado de la aplicación
    UPDATE Aplicaciones
    SET Estado = 'Entrevista'
    WHERE ID_Aplicacion = p_id_aplicacion;
    
    SELECT CONCAT('Entrevista programada para el ', DATE_FORMAT(p_fecha, '%d/%m/%Y %H:%i')) AS Mensaje;
END //
DELIMITER ;

-- 3. Funciones

-- Función para calcular la antigüedad de un empleado en años
DELIMITER //
CREATE FUNCTION antiguedad_empleado(p_id_empleado INT) 
RETURNS DECIMAL(5, 2)
DETERMINISTIC
BEGIN
    DECLARE v_fecha_contratacion DATE;
    DECLARE v_antiguedad DECIMAL(5, 2);
    
    SELECT Fecha_Contratacion INTO v_fecha_contratacion
    FROM Empleados
    WHERE ID_Empleado = p_id_empleado;
    
    SET v_antiguedad = DATEDIFF(CURDATE(), v_fecha_contratacion) / 365.25;
    
    RETURN ROUND(v_antiguedad, 2);
END //
DELIMITER ;

-- Función para calcular el promedio de evaluaciones de un empleado
DELIMITER //
CREATE FUNCTION promedio_evaluaciones(p_id_empleado INT) 
RETURNS DECIMAL(3, 2)
DETERMINISTIC
BEGIN
    DECLARE v_promedio DECIMAL(3, 2);
    
    SELECT AVG(Puntuacion_Global) INTO v_promedio
    FROM Evaluaciones
    WHERE ID_Empleado = p_id_empleado;
    
    RETURN COALESCE(v_promedio, 0);
END //
DELIMITER ;

-- 4. Eventos programados

-- Evento para cerrar vacantes expiradas
DELIMITER //
CREATE EVENT IF NOT EXISTS cerrar_vacantes_expiradas
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_DATE + INTERVAL 1 DAY
DO
BEGIN
    UPDATE Vacantes
    SET Estado = 'Cerrada'
    WHERE 
        Estado = 'Abierta' 
        AND Fecha_Limite < CURDATE();
    
    -- Registrar en log
    INSERT INTO Log_Sistema (Tipo, Mensaje, Fecha)
    VALUES ('Vacantes', CONCAT('Se cerraron ', ROW_COUNT(), ' vacantes expiradas'), NOW());
END //
DELIMITER ;

-- Tabla para log del sistema
CREATE TABLE IF NOT EXISTS Log_Sistema (
    ID_Log INT AUTO_INCREMENT PRIMARY KEY,
    Tipo VARCHAR(50) NOT NULL,
    Mensaje TEXT NOT NULL,
    Fecha DATETIME NOT NULL
);

-- Evento para notificar evaluaciones pendientes
DELIMITER //
CREATE EVENT IF NOT EXISTS notificar_evaluaciones_pendientes
ON SCHEDULE EVERY 3 MONTH
STARTS '2023-01-01'
DO
BEGIN
    -- Insertar en tabla de notificaciones
    INSERT INTO Notificaciones (Tipo, Destinatario, Asunto, Mensaje, Fecha_Creacion)
    SELECT 
        'Evaluación',
        e.ID_Empleado,
        'Evaluación de desempeño pendiente',
        CONCAT('Se requiere programar evaluación para el empleado ', e.Nombre, ' ', e.Apellidos),
        NOW()
    FROM Empleados e
    WHERE 
        e.ID_Empleado NOT IN (
            SELECT ID_Empleado 
            FROM Evaluaciones 
            WHERE YEAR(Fecha_Evaluacion) = YEAR(CURDATE()) AND 
                  QUARTER(Fecha_Evaluacion) = QUARTER(CURDATE())
        );
END //
DELIMITER ;

-- Tabla para notificaciones
CREATE TABLE IF NOT EXISTS Notificaciones (
    ID_Notificacion INT AUTO_INCREMENT PRIMARY KEY,
    Tipo VARCHAR(50) NOT NULL,
    Destinatario INT NOT NULL,
    Asunto VARCHAR(200) NOT NULL,
    Mensaje TEXT NOT NULL,
    Fecha_Creacion DATETIME NOT NULL,
    Leida BOOLEAN DEFAULT FALSE,
    Fecha_Lectura DATETIME,
    FOREIGN KEY (Destinatario) REFERENCES Empleados(ID_Empleado)
);