-- Script de Inserción de Datos para TechSolutions Inc.
USE TechSolutions;

-- Inserción de datos en la tabla Departamentos
INSERT INTO Departamentos (Nombre, Descripcion, Ubicacion, Presupuesto_Anual, Fecha_Creacion)
VALUES
('Desarrollo de Software', 'Departamento encargado del desarrollo de aplicaciones', 'Planta 2, Edificio A', 500000.00, '2020-01-15'),
('Recursos Humanos', 'Gestión del personal y contrataciones', 'Planta 1, Edificio B', 250000.00, '2020-01-15'),
('Marketing', 'Estrategias de mercado y publicidad', 'Planta 3, Edificio A', 350000.00, '2020-02-10'),
('Finanzas', 'Gestión económica y contabilidad', 'Planta 1, Edificio A', 300000.00, '2020-01-20'),
('Operaciones', 'Gestión de infraestructura y operaciones', 'Planta 2, Edificio B', 400000.00, '2020-03-05');

-- Inserción de datos en la tabla Puestos
INSERT INTO Puestos (Titulo, Descripcion, Nivel_Experiencia, Salario_Minimo, Salario_Maximo)
VALUES
('Desarrollador Frontend', 'Especialista en interfaces de usuario', 'Junior', 30000.00, 45000.00),
('Desarrollador Backend', 'Especialista en lógica de servidor', 'Semi-Senior', 35000.00, 55000.00),
('Analista de RRHH', 'Gestión de procesos de selección', 'Junior', 28000.00, 40000.00),
('Especialista en Marketing Digital', 'Gestión de campañas online', 'Senior', 40000.00, 60000.00),
('Contador', 'Gestión contable y fiscal', 'Semi-Senior', 35000.00, 50000.00),
('Gerente de Proyecto', 'Coordinación de equipos y proyectos', 'Senior', 50000.00, 75000.00),
('Administrador de Sistemas', 'Gestión de infraestructura IT', 'Senior', 45000.00, 65000.00),
('Director de Departamento', 'Gestión estratégica departamental', 'Experto', 70000.00, 100000.00);

-- Inserción de datos en la tabla Empleados
-- Nota: Primero insertamos los directores (sin supervisor) y luego el resto de empleados
INSERT INTO Empleados (Nombre, Apellidos, Email, Telefono, Fecha_Contratacion, Salario, ID_Departamento, ID_Supervisor)
VALUES
-- Directores (sin supervisor inicialmente)
('Carlos', 'Rodríguez Gómez', 'carlos.rodriguez@techsolutions.com', '612345678', '2020-01-20', 90000.00, 1, NULL),
('Ana', 'Martínez López', 'ana.martinez@techsolutions.com', '623456789', '2020-01-25', 85000.00, 2, NULL),
('Miguel', 'González Pérez', 'miguel.gonzalez@techsolutions.com', '634567890', '2020-02-15', 88000.00, 3, NULL),
('Laura', 'Sánchez Martín', 'laura.sanchez@techsolutions.com', '645678901', '2020-02-20', 87000.00, 4, NULL),
('Javier', 'Fernández Ruiz', 'javier.fernandez@techsolutions.com', '656789012', '2020-03-10', 89000.00, 5, NULL);

-- Ahora actualizamos los supervisores de los directores (todos reportan al director de Desarrollo)
UPDATE Empleados SET ID_Supervisor = 1 WHERE ID_Empleado IN (2, 3, 4, 5);

-- Resto de empleados
INSERT INTO Empleados (Nombre, Apellidos, Email, Telefono, Fecha_Contratacion, Salario, ID_Departamento, ID_Supervisor)
VALUES
-- Desarrollo de Software
('Pablo', 'García Navarro', 'pablo.garcia@techsolutions.com', '667890123', '2020-04-10', 42000.00, 1, 1),
('María', 'López Torres', 'maria.lopez@techsolutions.com', '678901234', '2020-04-15', 40000.00, 1, 1),
('David', 'Martín Serrano', 'david.martin@techsolutions.com', '689012345', '2020-05-05', 38000.00, 1, 1),

-- Recursos Humanos
('Elena', 'Pérez Castro', 'elena.perez@techsolutions.com', '690123456', '2020-04-20', 35000.00, 2, 2),
('Roberto', 'Díaz Moreno', 'roberto.diaz@techsolutions.com', '601234567', '2020-05-10', 32000.00, 2, 2),

-- Marketing
('Sofía', 'Ruiz Jiménez', 'sofia.ruiz@techsolutions.com', '612345670', '2020-04-25', 45000.00, 3, 3),
('Alejandro', 'Torres Vega', 'alejandro.torres@techsolutions.com', '623456780', '2020-05-15', 42000.00, 3, 3),

-- Finanzas
('Carmen', 'Moreno Gil', 'carmen.moreno@techsolutions.com', '634567800', '2020-04-30', 40000.00, 4, 4),
('Daniel', 'Jiménez Ortega', 'daniel.jimenez@techsolutions.com', '645678900', '2020-05-20', 38000.00, 4, 4),

-- Operaciones
('Lucía', 'Vega Sanz', 'lucia.vega@techsolutions.com', '656789000', '2020-05-01', 43000.00, 5, 5),
('Sergio', 'Ortega Blanco', 'sergio.ortega@techsolutions.com', '667890100', '2020-05-25', 41000.00, 5, 5);

-- Inserción de datos en la tabla Asignaciones (puestos de los empleados)
INSERT INTO Asignaciones (ID_Empleado, ID_Puesto, Fecha_Inicio, Fecha_Fin, Es_Actual)
VALUES
-- Directores
(1, 8, '2020-01-20', NULL, TRUE),
(2, 8, '2020-01-25', NULL, TRUE),
(3, 8, '2020-02-15', NULL, TRUE),
(4, 8, '2020-02-20', NULL, TRUE),
(5, 8, '2020-03-10', NULL, TRUE),

-- Desarrollo de Software
(6, 2, '2020-04-10', NULL, TRUE), -- Backend Senior
(7, 1, '2020-04-15', NULL, TRUE), -- Frontend
(8, 1, '2020-05-05', NULL, TRUE), -- Frontend

-- Recursos Humanos
(9, 3, '2020-04-20', NULL, TRUE), -- Analista RRHH
(10, 3, '2020-05-10', NULL, TRUE), -- Analista RRHH

-- Marketing
(11, 4, '2020-04-25', NULL, TRUE), -- Marketing Digital
(12, 4, '2020-05-15', NULL, TRUE), -- Marketing Digital

-- Finanzas
(13, 5, '2020-04-30', NULL, TRUE), -- Contador
(14, 5, '2020-05-20', NULL, TRUE), -- Contador

-- Operaciones
(15, 7, '2020-05-01', NULL, TRUE), -- Administrador Sistemas
(16, 7, '2020-05-25', NULL, TRUE); -- Administrador Sistemas

-- Inserción de datos en la tabla Proyectos
INSERT INTO Proyectos (Nombre, Descripcion, Fecha_Inicio, Fecha_Fin_Estimada, Fecha_Fin_Real, Presupuesto, Estado, ID_Departamento, ID_Gerente)
VALUES
('Desarrollo App Móvil', 'Aplicación móvil para gestión de clientes', '2021-01-10', '2021-06-30', '2021-07-15', 120000.00, 'Completado', 1, 1),
('Rediseño Web Corporativa', 'Actualización de la web de la empresa', '2021-03-15', '2021-08-30', NULL, 80000.00, 'En Progreso', 3, 3),
('Implementación ERP', 'Sistema de planificación de recursos empresariales', '2021-05-01', '2022-02-28', NULL, 200000.00, 'En Progreso', 5, 5),
('Campaña Marketing Q3', 'Campaña publicitaria tercer trimestre', '2021-07-01', '2021-09-30', '2021-09-25', 50000.00, 'Completado', 3, 3),
('Optimización Procesos RRHH', 'Mejora de procesos de selección y onboarding', '2021-06-15', '2021-12-15', NULL, 75000.00, 'En Progreso', 2, 2);

-- Inserción de datos en la tabla Asignaciones_Proyecto
INSERT INTO Asignaciones_Proyecto (ID_Proyecto, ID_Empleado, Rol, Horas_Asignadas, Fecha_Asignacion)
VALUES
-- Proyecto 1: Desarrollo App Móvil
(1, 1, 'Gerente de Proyecto', 400, '2021-01-10'),
(1, 6, 'Desarrollador Backend', 800, '2021-01-15'),
(1, 7, 'Desarrollador Frontend', 800, '2021-01-15'),
(1, 15, 'Soporte Técnico', 200, '2021-01-20'),

-- Proyecto 2: Rediseño Web Corporativa
(2, 3, 'Gerente de Proyecto', 300, '2021-03-15'),
(2, 8, 'Desarrollador Frontend', 600, '2021-03-20'),
(2, 11, 'Especialista UX/UI', 500, '2021-03-20'),
(2, 12, 'Especialista SEO', 400, '2021-04-01'),

-- Proyecto 3: Implementación ERP
(3, 5, 'Gerente de Proyecto', 500, '2021-05-01'),
(3, 6, 'Desarrollador Backend', 700, '2021-05-10'),
(3, 15, 'Administrador de Sistemas', 600, '2021-05-10'),
(3, 16, 'Soporte Infraestructura', 600, '2021-05-15'),
(3, 13, 'Consultor Financiero', 300, '2021-06-01'),

-- Proyecto 4: Campaña Marketing Q3
(4, 3, 'Gerente de Proyecto', 200, '2021-07-01'),
(4, 11, 'Especialista Marketing Digital', 400, '2021-07-05'),
(4, 12, 'Analista de Mercado', 350, '2021-07-05'),

-- Proyecto 5: Optimización Procesos RRHH
(5, 2, 'Gerente de Proyecto', 300, '2021-06-15'),
(5, 9, 'Analista de Procesos', 500, '2021-06-20'),
(5, 10, 'Especialista en Selección', 500, '2021-06-20');

-- Inserción de datos en la tabla Vacantes
INSERT INTO Vacantes (ID_Puesto, ID_Departamento, Fecha_Publicacion, Fecha_Limite, Estado, Numero_Posiciones, Descripcion_Adicional)
VALUES
(1, 1, '2021-08-01', '2021-09-15', 'Abierta', 2, 'Se requiere experiencia en React y Angular'),
(2, 1, '2021-08-05', '2021-09-20', 'Abierta', 1, 'Conocimientos en Node.js y bases de datos NoSQL'),
(3, 2, '2021-07-15', '2021-08-30', 'En Proceso', 1, 'Experiencia en procesos de selección IT'),
(7, 5, '2021-07-20', '2021-09-10', 'Abierta', 1, 'Certificación en AWS o Azure'),
(4, 3, '2021-06-10', '2021-07-31', 'Cerrada', 1, 'Experiencia en campañas SEM y SEO');

-- Inserción de datos en la tabla Candidatos
INSERT INTO Candidatos (Nombre, Apellidos, Email, Telefono, CV_URL, Fecha_Aplicacion, Estado)
VALUES
('Raúl', 'Hernández Soto', 'raul.hernandez@email.com', '612345987', 'https://cvs.techsolutions.com/raul_hernandez.pdf', '2021-08-05', 'En Revisión'),
('Isabel', 'Gómez Martín', 'isabel.gomez@email.com', '623456098', 'https://cvs.techsolutions.com/isabel_gomez.pdf', '2021-08-10', 'Entrevista'),
('Alberto', 'Serrano Vega', 'alberto.serrano@email.com', '634567109', 'https://cvs.techsolutions.com/alberto_serrano.pdf', '2021-07-20', 'Oferta'),
('Cristina', 'Blanco Ruiz', 'cristina.blanco@email.com', '645678210', 'https://cvs.techsolutions.com/cristina_blanco.pdf', '2021-07-25', 'Entrevista'),
('Jorge', 'Navarro Gil', 'jorge.navarro@email.com', '656789321', 'https://cvs.techsolutions.com/jorge_navarro.pdf', '2021-06-15', 'Contratado'),
('Marta', 'Castro Díaz', 'marta.castro@email.com', '667890432', 'https://cvs.techsolutions.com/marta_castro.pdf', '2021-08-15', 'Recibido');

-- Inserción de datos en la tabla Aplicaciones
INSERT INTO Aplicaciones (ID_Candidato, ID_Vacante, Fecha_Aplicacion, Estado, Notas)
VALUES
(1, 1, '2021-08-05', 'Revisada', 'Buen perfil técnico, pendiente prueba técnica'),
(2, 1, '2021-08-10', 'Entrevista', 'Primera entrevista programada para el 25/08'),
(3, 3, '2021-07-20', 'Oferta', 'Oferta enviada, pendiente respuesta'),
(4, 4, '2021-07-25', 'Entrevista', 'Segunda entrevista programada para el 10/08'),
(5, 5, '2021-06-15', 'Contratado', 'Incorporación el 01/08/2021'),
(6, 2, '2021-08-15', 'Pendiente', 'Pendiente revisión de CV');