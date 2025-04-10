USE carrentalx;
### 1. Listar todos los clientes con su información personal.
SELECT * 
FROM clientes;

### 2. Buscar un cliente por su DNI, nombre o email.
SELECT * 
FROM clientes
WHERE email = "juan.perez@gmail.com";

### 3. Contar cuántos clientes hay registrados.
SELECT COUNT(*) 
FROM clientes;

### 4. Obtener los clientes que han realizado al menos una reserva.
SELECT DISTINCT idClientes 
FROM clientes
JOIN reservas 
ON clientes.idClientes = reservas.clientes_idClientes;

### 5. Listar los clientes con más reservas realizadas.
SELECT idClientes, nombre, COUNT(idReserva) 
FROM clientes
JOIN reservas 
ON clientes.idClientes = reservas.clientes_idClientes
GROUP BY clientes.idClientes DESC;

### 6. Listar todos los vehículos con sus detalles técnicos.
SELECT * FROM vehiculos;

### 7. Buscar un vehículo cuya matrícula empiece por 1.
 SELECT * FROM vehiculos
 WHERE matricula 
 LIKE ("1%");
 
### 8. Contar cuántos vehículos hay de cada tipo de combustible.
SELECT idVehiculos, tipoCombustible, COUNT(tipoCombustible) 
FROM vehiculos 
GROUP BY tipoCombustible;

### 9. Obtener los vehículos disponibles en una sucursal específica.
SELECT * 
FROM vehiculos 
WHERE disponibilidad = "SI";

### 10. Obtener los ingresos de los vehiculos ordenados de manera descendente.
SELECT idVehiculos, modelo, SUM(reservas.costeTotal) 
FROM vehiculos 
JOIN reservas 
ON vehiculos.idVehiculos = reservas.vehiculos_idVehiculos
GROUP BY vehiculos.idVehiculos DESC;

### 11. Obtener todas las reservas realizadas con fechas de inicio y fin.
SELECT *
FROM reservas
WHERE fechaInicioReserva != "" 
AND fechaFinReserva != "";

### 12. Contar cuántas reservas hay en cada estado (pendiente, en curso, finalizado, anulado).
SELECT idReserva, estado, COUNT(estado) 
FROM reservas 
GROUP BY estado;

### 13. Obtener las reservas pendientes en este momento.
SELECT *
FROM reservas 
WHERE estado = "pendiente";

### 14. Calcular el ingreso total generado por todas las reservas.
SELECT SUM(reservas.costeTotal)
FROM reservas 
WHERE estado != "anulado" AND estado != "pendiente";

### 15. Contar cuántas reservas se han realizado por mes/año.
SELECT DAY(fechaInicioReserva) AS dia,  
COUNT(*) AS num_reservas
FROM reservas
GROUP BY dia;

### 16. Listar todas las sucursales con su información.
SELECT * FROM sucursal;

### 17. Contar cuántos vehículos hay en cada sucursal.
SELECT sucursal.idSucursal, sucursal.nombre, COUNT(vehiculos.idVehiculos) 
FROM sucursal
LEFT JOIN vehiculos ON sucursal.idSucursal = vehiculos.sucursal_idSucursal
GROUP BY sucursal.idSucursal, sucursal.nombre;

### 18. Determinar qué sucursal ha generado más ingresos en reservas.
SELECT sucursal.idSucursal, sucursal.nombre, SUM(reservas.costeTotal) 
FROM sucursal
JOIN reservas ON sucursal.idSucursal = reservas.vehiculos_idSucursal
JOIN vehiculos ON sucursal.idSucursal = vehiculos.sucursal_idSucursal
WHERE reservas.estado = 'enCurso' OR reservas.estado = 'finalizado'
GROUP BY sucursal.idSucursal;

### 19. Listar los empleados asignados a cada sucursal.
SELECT idEmpleados, nombre, sucursal_idSucursal 
FROM empleados;

### 20. Identificar sucursales con reservas registradas para el 10 de marzo de 2025.
SELECT * FROM reservas 
WHERE fechaInicioReserva
LIKE ("%2025-03-10%");

### 21. Lista todos los empleados.
SELECT * 
FROM empleados;

### 22. Listar todos los empleados con su cargo y sucursal asignada.
SELECT nombre, cargo, sucursal_idSucursal FROM empleados;

### 23. Buscar empleados por nombre.
SELECT * 
FROM empleados
WHERE nombre = "Pedro";

### 24. Contar cuántos empleados hay en cada sucursal.
SELECT empleados.sucursal_idSucursal, COUNT(idEmpleados) 
FROM empleados 
GROUP BY empleados.sucursal_idSucursal;

### 25. Identificar la dirección de la sucursal a la que pertenece un empleado.
SELECT empleados.nombre, sucursal.nombre 
FROM sucursal 
JOIN empleados ON sucursal.idSucursal = empleados.sucursal_idSucursal
WHERE empleados.idEmpleados = 2;

