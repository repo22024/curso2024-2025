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

# 8. Consultas propuestas

```sql
## 1. Listar todos los clientes con su información personal.
SELECT * 
FROM clientes;

## 2. Buscar un cliente por su DNI, nombre o email.
SELECT * 
FROM clientes
WHERE email = "juan.perez@gmail.com";

## 3. Contar cuántos clientes hay registrados.
SELECT COUNT(*) AS cantidad_clientes
FROM clientes;

## 4. Obtener los clientes que han realizado al menos una reserva.
SELECT DISTINCT clientes.idCliente , clientes.nombre
FROM clientes
JOIN reservas 
ON clientes.idCliente = reservas.idCliente;

## 5. Listar los clientes de mayor a menor reservas realizadas
SELECT clientes.idCliente, clientes.nombre, COUNT(reservas.idReserva) AS cantidad_reservas
FROM clientes
JOIN reservas ON clientes.idCliente = reservas.idCliente
GROUP BY clientes.idCliente, clientes.nombre
ORDER BY cantidad_reservas DESC;

## 6. Listar todos los vehículos con sus detalles técnicos.
SELECT * FROM vehiculos;

## 7. Buscar un vehículo cuya matrícula empiece por 1.
 SELECT * FROM vehiculos
 WHERE matricula 
 LIKE ("1%");
 
## 8. Vehículos más alquilados (se cuentan los estados finalizados o en curso de las reservas)
SELECT vehiculos.idVehiculo, vehiculos.modelo, COUNT(reservas.idReserva) AS cantidad_alquileres
FROM reservas
JOIN vehiculos ON reservas.idVehiculo = vehiculos.idVehiculo
WHERE reservas.estado IN ('enCurso', 'finalizado')
GROUP BY vehiculos.idVehiculo
ORDER BY cantidad_alquileres DESC;
    
## 9. Obtener los vehículos disponibles en una sucursal específica.
SELECT * 
FROM vehiculos 
WHERE disponibilidad = "SI";

## 10. Contar cuántos vehículos hay de cada tipo de combustible.
SELECT tipoCombustible, COUNT(tipoCombustible) 
FROM vehiculos 
GROUP BY tipoCombustible;

## 11. Obtener todas las reservas realizadas con fechas de inicio y fin.
SELECT *
FROM reservas
WHERE fechaInicioReserva != "" 
AND fechaFinReserva != "";

## 12. Contar cuántas reservas hay en cada estado (pendiente, en curso, finalizado, anulado).
SELECT idReserva, estado, COUNT(estado) 
FROM reservas 
GROUP BY estado;

## 13. Obtener las reservas pendientes en este momento.
SELECT *
FROM reservas 
WHERE estado = "pendiente";

## 14. Contar el número de vehículos reservados en estado "enCurso"
SELECT DISTINCT vehiculos.idVehiculo, vehiculos.modelo
FROM reservas 
JOIN vehiculos ON reservas.idVehiculo = vehiculos.idVehiculo
WHERE reservas.estado = 'enCurso';

## 15. Contar cuántas reservas se han realizado por mes/año.
SELECT DAY(fechaInicioReserva) AS dia,  
COUNT(*) AS num_reservas
FROM reservas
GROUP BY dia;

## 16. Listar todas las sucursales con su información.
SELECT * FROM sucursales;

## 17. Contar cuántos vehículos hay en cada sucursal.
SELECT sucursales.idSucursal, sucursales.nombre, COUNT(vehiculos.idVehiculo) 
FROM sucursales
LEFT JOIN vehiculos ON sucursales.idSucursal = vehiculos.idSucursal
GROUP BY sucursales.idSucursal, sucursales.nombre;

## 18. Determinar qué sucursal ha generado más ingresos en reservas.
SELECT sucursales.idSucursal, sucursales.nombre, SUM(vehiculos.precio) AS total_ingresos
FROM sucursales
JOIN vehiculos ON sucursales.idSucursal = vehiculos.idSucursal
JOIN reservas ON vehiculos.idVehiculo = reservas.idVehiculo
WHERE reservas.estado IN ('enCurso', 'finalizado')
GROUP BY sucursales.idSucursal;

## 19. Listar los empleados asignados a cada sucursal.
SELECT empleados.idEmpleado, empleados.nombre, empleados.apellidos, sucursales.nombre AS nombre_sucursal
FROM empleados
JOIN sucursales ON empleados.idSucursal = sucursales.idSucursal;

## 20. Identificar sucursales con reservas registradas para el 10 de marzo de 2025.
SELECT * FROM reservas 
WHERE fechaInicioReserva
LIKE ("%2025-03-10%");

## 21. Lista todos los empleados.
SELECT * 
FROM empleados;

## 22. Listar todos los empleados con su cargo y sucursal asignada.
SELECT empleados.nombre, empleados.cargo, sucursales.nombre AS nombre_sucursal
FROM empleados
JOIN sucursales ON empleados.idSucursal = sucursales.idSucursal;

## 23. Buscar empleados por nombre.
SELECT * 
FROM empleados
WHERE nombre = "Pedro";

## 24. Contar cuántos empleados hay en cada sucursal.
SELECT sucursales.nombre AS nombre_sucursal, COUNT(empleados.idEmpleado) AS empleados_por_sucursal
FROM empleados
JOIN sucursales ON empleados.idSucursal = sucursales.idSucursal
GROUP BY sucursales.idSucursal;

## 25. Identificar la dirección de la sucursal a la que pertenece un empleado.
SELECT empleados.nombre, sucursales.nombre 
FROM sucursales
JOIN empleados ON sucursales.idSucursal = empleados.idSucursal
WHERE empleados.idEmpleado = 2;
```