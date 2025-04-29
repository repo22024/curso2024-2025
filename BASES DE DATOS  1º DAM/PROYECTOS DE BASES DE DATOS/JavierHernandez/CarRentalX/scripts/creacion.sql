-- Script de Creación de Tablas para CarRentalX

-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS CarRentalX;
USE CarRentalX;

-- Tabla Clientes
CREATE TABLE IF NOT EXISTS Clientes (
    ID_Cliente INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    DNI VARCHAR(10) UNIQUE NOT NULL,
    Direccion VARCHAR(200) NOT NULL,
    Telefono VARCHAR(15) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Fecha_Registro DATE NOT NULL
);

-- Tabla Sucursales
CREATE TABLE IF NOT EXISTS Sucursales (
    ID_Sucursal INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Direccion VARCHAR(200) NOT NULL,
    Telefono VARCHAR(15) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Horario_Apertura TIME NOT NULL,
    Horario_Cierre TIME NOT NULL
);

-- Tabla Empleados
CREATE TABLE IF NOT EXISTS Empleados (
    ID_Empleado INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    DNI VARCHAR(10) UNIQUE NOT NULL,
    Cargo VARCHAR(50) NOT NULL,
    Telefono VARCHAR(15) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    ID_Sucursal INT NOT NULL,
    FOREIGN KEY (ID_Sucursal) REFERENCES Sucursales(ID_Sucursal)
);

-- Tabla Vehículos
CREATE TABLE IF NOT EXISTS Vehiculos (
    ID_Vehiculo INT AUTO_INCREMENT PRIMARY KEY,
    Matricula VARCHAR(10) UNIQUE NOT NULL,
    Marca VARCHAR(50) NOT NULL,
    Modelo VARCHAR(50) NOT NULL,
    Anio INT NOT NULL,
    Tipo_Combustible ENUM('Gasolina', 'Diesel', 'Eléctrico', 'Híbrido') NOT NULL,
    Estado ENUM('Disponible', 'Alquilado', 'Mantenimiento') NOT NULL DEFAULT 'Disponible',
    Precio_Diario DECIMAL(10, 2) NOT NULL,
    ID_Sucursal INT NOT NULL,
    FOREIGN KEY (ID_Sucursal) REFERENCES Sucursales(ID_Sucursal)
);

-- Tabla Reservas
CREATE TABLE IF NOT EXISTS Reservas (
    ID_Reserva INT AUTO_INCREMENT PRIMARY KEY,
    Fecha_Inicio DATE NOT NULL,
    Fecha_Fin DATE NOT NULL,
    Costo_Total DECIMAL(10, 2) NOT NULL,
    Estado_Reserva ENUM('Pendiente', 'Activa', 'Completada', 'Cancelada') NOT NULL DEFAULT 'Pendiente',
    ID_Cliente INT NOT NULL,
    ID_Vehiculo INT NOT NULL,
    ID_Empleado INT NOT NULL,
    ID_Sucursal INT NOT NULL,
    FOREIGN KEY (ID_Cliente) REFERENCES Clientes(ID_Cliente),
    FOREIGN KEY (ID_Vehiculo) REFERENCES Vehiculos(ID_Vehiculo),
    FOREIGN KEY (ID_Empleado) REFERENCES Empleados(ID_Empleado),
    FOREIGN KEY (ID_Sucursal) REFERENCES Sucursales(ID_Sucursal),
    CHECK (Fecha_Fin >= Fecha_Inicio)
);