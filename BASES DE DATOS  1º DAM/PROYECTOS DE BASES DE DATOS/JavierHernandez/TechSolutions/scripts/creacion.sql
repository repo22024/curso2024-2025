-- Script de Creación de Tablas para TechSolutions Inc.

-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS TechSolutions;
USE TechSolutions;

-- Tabla Departamentos
CREATE TABLE IF NOT EXISTS Departamentos (
    ID_Departamento INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion TEXT,
    Ubicacion VARCHAR(100),
    Presupuesto_Anual DECIMAL(12, 2),
    Fecha_Creacion DATE NOT NULL
);

-- Tabla Empleados
CREATE TABLE IF NOT EXISTS Empleados (
    ID_Empleado INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Telefono VARCHAR(15),
    Fecha_Contratacion DATE NOT NULL,
    Salario DECIMAL(10, 2) NOT NULL,
    ID_Departamento INT NOT NULL,
    ID_Supervisor INT,
    FOREIGN KEY (ID_Departamento) REFERENCES Departamentos(ID_Departamento),
    FOREIGN KEY (ID_Supervisor) REFERENCES Empleados(ID_Empleado)
);

-- Tabla Puestos
CREATE TABLE IF NOT EXISTS Puestos (
    ID_Puesto INT AUTO_INCREMENT PRIMARY KEY,
    Titulo VARCHAR(100) NOT NULL,
    Descripcion TEXT,
    Nivel_Experiencia ENUM('Junior', 'Semi-Senior', 'Senior', 'Experto') NOT NULL,
    Salario_Minimo DECIMAL(10, 2) NOT NULL,
    Salario_Maximo DECIMAL(10, 2) NOT NULL,
    CHECK (Salario_Maximo > Salario_Minimo)
);

-- Tabla Asignaciones (relación entre Empleados y Puestos)
CREATE TABLE IF NOT EXISTS Asignaciones (
    ID_Asignacion INT AUTO_INCREMENT PRIMARY KEY,
    ID_Empleado INT NOT NULL,
    ID_Puesto INT NOT NULL,
    Fecha_Inicio DATE NOT NULL,
    Fecha_Fin DATE,
    Es_Actual BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (ID_Empleado) REFERENCES Empleados(ID_Empleado),
    FOREIGN KEY (ID_Puesto) REFERENCES Puestos(ID_Puesto),
    CHECK (Fecha_Fin IS NULL OR Fecha_Fin >= Fecha_Inicio)
);

-- Tabla Proyectos
CREATE TABLE IF NOT EXISTS Proyectos (
    ID_Proyecto INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion TEXT,
    Fecha_Inicio DATE NOT NULL,
    Fecha_Fin_Estimada DATE NOT NULL,
    Fecha_Fin_Real DATE,
    Presupuesto DECIMAL(12, 2) NOT NULL,
    Estado ENUM('Planificado', 'En Progreso', 'Completado', 'Cancelado') NOT NULL DEFAULT 'Planificado',
    ID_Departamento INT NOT NULL,
    ID_Gerente INT NOT NULL,
    FOREIGN KEY (ID_Departamento) REFERENCES Departamentos(ID_Departamento),
    FOREIGN KEY (ID_Gerente) REFERENCES Empleados(ID_Empleado),
    CHECK (Fecha_Fin_Estimada >= Fecha_Inicio),
    CHECK (Fecha_Fin_Real IS NULL OR Fecha_Fin_Real >= Fecha_Inicio)
);

-- Tabla Asignaciones_Proyecto (empleados asignados a proyectos)
CREATE TABLE IF NOT EXISTS Asignaciones_Proyecto (
    ID_Asignacion_Proyecto INT AUTO_INCREMENT PRIMARY KEY,
    ID_Proyecto INT NOT NULL,
    ID_Empleado INT NOT NULL,
    Rol VARCHAR(100) NOT NULL,
    Horas_Asignadas INT NOT NULL,
    Fecha_Asignacion DATE NOT NULL,
    FOREIGN KEY (ID_Proyecto) REFERENCES Proyectos(ID_Proyecto),
    FOREIGN KEY (ID_Empleado) REFERENCES Empleados(ID_Empleado),
    UNIQUE (ID_Proyecto, ID_Empleado)
);

-- Tabla Vacantes
CREATE TABLE IF NOT EXISTS Vacantes (
    ID_Vacante INT AUTO_INCREMENT PRIMARY KEY,
    ID_Puesto INT NOT NULL,
    ID_Departamento INT NOT NULL,
    Fecha_Publicacion DATE NOT NULL,
    Fecha_Limite DATE NOT NULL,
    Estado ENUM('Abierta', 'En Proceso', 'Cerrada', 'Cancelada') NOT NULL DEFAULT 'Abierta',
    Numero_Posiciones INT NOT NULL DEFAULT 1,
    Descripcion_Adicional TEXT,
    FOREIGN KEY (ID_Puesto) REFERENCES Puestos(ID_Puesto),
    FOREIGN KEY (ID_Departamento) REFERENCES Departamentos(ID_Departamento),
    CHECK (Fecha_Limite >= Fecha_Publicacion)
);

-- Tabla Candidatos
CREATE TABLE IF NOT EXISTS Candidatos (
    ID_Candidato INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Telefono VARCHAR(15),
    CV_URL VARCHAR(255),
    Fecha_Aplicacion DATE NOT NULL,
    Estado ENUM('Recibido', 'En Revisión', 'Entrevista', 'Oferta', 'Contratado', 'Rechazado') NOT NULL DEFAULT 'Recibido'
);

-- Tabla Aplicaciones (relación entre Candidatos y Vacantes)
CREATE TABLE IF NOT EXISTS Aplicaciones (
    ID_Aplicacion INT AUTO_INCREMENT PRIMARY KEY,
    ID_Candidato INT NOT NULL,
    ID_Vacante INT NOT NULL,
    Fecha_Aplicacion DATE NOT NULL,
    Estado ENUM('Pendiente', 'Revisada', 'Entrevista', 'Oferta', 'Contratado', 'Rechazado') NOT NULL DEFAULT 'Pendiente',
    Notas TEXT,
    FOREIGN KEY (ID_Candidato) REFERENCES Candidatos(ID_Candidato),
    FOREIGN KEY (ID_Vacante) REFERENCES Vacantes(ID_Vacante),
    UNIQUE (ID_Candidato, ID_Vacante)
);