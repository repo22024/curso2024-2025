# 1. Portada
![portada](./capturas/carrentalx.png)

# 2. Índice

3. Introduccion
4. Análisis del enunciado
5. Modelo conceptual
6. Modelo relacional
7. Implementación en MySQL
8. Consultas propuestas
9. Ampliación de base de datos
10. Vistas y triggers
11. Conclusión

## 3. Introducción
El presente informe tiene como objetivo analizar y diseñar un sistema de gestión para la empresa **CarRentalX**, dedicada al alquiler de coches. La empresa busca modernizar sus procesos, actualmente manuales, para optimizar la gestión de clientes, vehículos, reservas, sucursales y empleados. Este documento ofrece una visión estructurada del sistema requerido, identificando las entidades clave, sus relaciones y posibles mejoras mediante funcionalidades adicionales.

# 4. Análisis del Enunciado

## 🛠️ Problemas Detectados

### Ineficiencia en la gestión manual
La gestión actual provoca retrasos, errores humanos, falta de control sobre el estado de los vehículos y dificultad para tomar decisiones rápidas.

### Falta de centralización
La información se encuentra dispersa, dificultando la visibilidad global de la operación, duplicando esfuerzos y limitando el acceso en tiempo real a los datos.

## 🎯 Objetivo Principal

- Diseñar un sistema de gestión integral que unifique la información de:
  - Clientes
  - Vehículos
  - Reservas
  - Sucursales
  - Empleados

- Automatizar tareas repetitivas, como:
  - La actualización de disponibilidad de vehículos.
  - La generación de informes.

## 🧩 Entidades Principales

- **Clientes**  
  Datos personales, tipo de carnet y su historial de reservas.

- **Vehículos**  
  Información técnica (modelo, matrícula, color, combustible), estado (disponible/no disponible) y precio.

- **Reservas**  
  Registro de alquileres, incluyendo fechas, cliente asociado y estado (pendiente, en curso, finalizada).

- **Sucursales**  
  Ubicación y datos de contacto de cada sede.

- **Empleados**  
  Información personal, rol y asignación a sucursales.

## ⚙️ Requisitos Funcionales

- **Gestión integral de recursos**  
  Administración de clientes, vehículos, reservas, sucursales y empleados desde una única plataforma.

- **Gestión avanzada de reservas**  
  Crear, modificar y cancelar reservas con verificación de disponibilidad en tiempo real.

- **Generación de informes personalizados**, como:

  - 🚗 **Vehículos más alquilados**  
    Ayuda a optimizar el inventario.

  - 👤 **Clientes más frecuentes**  
    Facilita estrategias de fidelización.

  - 💰 **Ingresos mensuales por sucursal**  
    Información financiera clave para la toma de decisiones.


 # 7. Implementación en MySQL

## 1. Creación de tablas

```sql
-- MySQL Workbench Synchronization
-- Generated: 2025-04-11 12:45
-- Model: New Model
-- Version: 1.0
-- Project: Name of the project
-- Author: Yo

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `CarRentalX` DEFAULT CHARACTER SET utf8 ;

CREATE TABLE IF NOT EXISTS `CarRentalX`.`clientes` (
  `idCliente` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `apellidos` VARCHAR(45) NOT NULL,
  `dni` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `telefono` INT(10) NOT NULL,
  `tipoCarnet` SET('A', 'B', 'C', 'D', 'E', 'AM', 'A1', 'A2', 'B1', 'C1', 'D1', 'BE', 'C1E', 'CE', 'D1E', 'DE') NOT NULL,
  PRIMARY KEY (`idCliente`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `CarRentalX`.`reservas` (
  `idReserva` INT(11) NOT NULL AUTO_INCREMENT,
  `fechaInicioReserva` DATETIME NOT NULL,
  `fechaFinReserva` DATETIME NOT NULL,
  `estado` ENUM("pendiente", "enCurso", "finalizado", "anulado") NOT NULL,
  `idCliente` INT(11) NOT NULL,
  `idVehiculo` INT(11) NOT NULL,
  PRIMARY KEY (`idReserva`),
  INDEX `fk_reservas_clientes_idx` (`idCliente` ASC),
  INDEX `fk_reservas_vehiculos1_idx` (`idVehiculo` ASC),
  CONSTRAINT `fk_reservas_clientes`
    FOREIGN KEY (`idCliente`)
    REFERENCES `CarRentalX`.`clientes` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_reservas_vehiculos1`
    FOREIGN KEY (`idVehiculo`)
    REFERENCES `CarRentalX`.`vehiculos` (`idVehiculo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `CarRentalX`.`vehiculos` (
  `idVehiculo` INT(11) NOT NULL AUTO_INCREMENT,
  `matricula` VARCHAR(9) NOT NULL,
  `modelo` VARCHAR(45) NOT NULL,
  `año` SMALLINT(4) NOT NULL,
  `color` VARCHAR(45) NULL DEFAULT NULL,
  `tipoCombustible` SET("gasolina", "diesel", "electrico", "hibrido", "gas", "hidrogeno") NOT NULL,
  `precio` DOUBLE NOT NULL DEFAULT 150.00,
  `disponibilidad` ENUM("SI", "NO") NOT NULL,
  `idSucursal` INT(11) NOT NULL,
  PRIMARY KEY (`idVehiculo`),
  INDEX `fk_vehiculos_sucursales1_idx` (`idSucursal` ASC),
  CONSTRAINT `fk_vehiculos_sucursales1`
    FOREIGN KEY (`idSucursal`)
    REFERENCES `CarRentalX`.`sucursales` (`idSucursal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `CarRentalX`.`sucursales` (
  `idSucursal` INT(11) NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(45) NOT NULL,
  `direccion` VARCHAR(45) NOT NULL,
  `telefono` INT(10) NOT NULL,
  `correo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idSucursal`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `CarRentalX`.`empleados` (
  `idEmpleado` INT(11) NOT NULL AUTO_INCREMENT,
  `cargo` VARCHAR(45) NOT NULL,
  `nombre` VARCHAR(45) NOT NULL,
  `apellidos` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `telefono` INT(10) NOT NULL,
  `idSucursal` INT(11) NOT NULL,
  PRIMARY KEY (`idEmpleado`),
  INDEX `fk_empleados_sucursales1_idx` (`idSucursal` ASC),
  CONSTRAINT `fk_empleados_sucursales1`
    FOREIGN KEY (`idSucursal`)
    REFERENCES `CarRentalX`.`sucursales` (`idSucursal`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

```

# 2. Inserción de datos de prueba

## Insertar datos de clientes
``` sql
INSERT INTO clientes 

VALUES   

(DEFAULT, 'Juan', 'Pérez', '12345678A', 'juan.perez@gmail.com', 612345678, 'A'),  

(DEFAULT, 'Ana', 'García', '87654321B', 'ana.garcia@gmail.com', 623456789, 'B'),  

(DEFAULT, 'Carlos', 'López', '11223344C', 'carlos.lopez@gmail.com', 634567890, 'C'), 

(DEFAULT, 'Manuel', 'Jiménez', '3215678A', 'manuel.jimenez@gmail.com', 652145423, 'A,B');
```
## Insertar datos de sucursal
``` sql
INSERT INTO sucursales 

VALUES  

(DEFAULT, 'Sucursal Central', 'Calle Mayor 123', 912345678, 'central@gmail.com'), 

(DEFAULT, 'Sucursal Norte', 'Calle Norte 456', 923456789, 'norte@gmail.com'), 

(DEFAULT, 'Sucursal Sur', 'Calle Sur 789', 934567890, 'sur@gmail.com'); 
```
## Insertar datos de vehículos
``` sql
INSERT INTO vehiculos 

VALUES  

(DEFAULT, '1234ABC', 'Ford Fiesta', 2020, 'Rojo', 'gasolina', 100.5, 'SI', 1), 

(DEFAULT, '5678DEF', 'BMW X5', 2019, 'Azul', 'diesel', 250.75, 'NO', 2), 

(DEFAULT, '9101GHI', 'Tesla Model 3', 2021, 'Negro', 'electrico', 500.0, 'SI', 3), 

(DEFAULT, '123ABC', 'Toyota Corolla', 2020, 'Rojo', 'gasolina', 35.99, 'SI', 1), 

(DEFAULT, '456DEF', 'Ford Focus', 2021, 'Azul', 'gasolina,diesel', 40.50, 'SI', 2);
```
## Insertar datos de reservas
``` sql
INSERT INTO reservas 

VALUES  

(DEFAULT, '2025-03-10 10:00:00', '2025-03-12 10:00:00', 'pendiente', 1, 1), 

(DEFAULT, '2025-03-10 12:00:00', '2025-03-12 10:00:00', 'pendiente', 1, 1), 

(DEFAULT, '2025-03-15 12:00:00', '2025-03-18 12:00:00', 'enCurso', 2, 2), 

(DEFAULT, '2025-03-20 09:00:00', '2025-03-22 09:00:00', 'finalizado', 3, 3), 

(DEFAULT,'2025-03-24 19:00:00', '2025-03-28 09:00:00', 'anulado', 3, 3);
```
## Insertar datos de empleados
``` sql
INSERT INTO empleados 

VALUES  

(DEFAULT, 'Gerente', 'María', 'Martínez', 'maria.martinez@gmail.com', 611223344, 1), 

(DEFAULT, 'Asesor', 'Pedro', 'Gómez', 'pedro.gomez@gmail.com', 622334455, 2), 

(DEFAULT, 'Recepcionista', 'Lucía', 'Sánchez', 'lucia.sanchez@gmail.com', 633445566, 3) 
```