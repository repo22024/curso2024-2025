-- Script de Inserción de Datos para CarRentalX
USE CarRentalX;

-- Inserción de datos en la tabla Sucursales
INSERT INTO Sucursales (Nombre, Direccion, Telefono, Email, Horario_Apertura, Horario_Cierre) VALUES
('CarRentalX Madrid Centro', 'Calle Gran Vía 42, Madrid', '912345678', 'madrid.centro@carrentalx.com', '08:00:00', '20:00:00'),
('CarRentalX Barcelona', 'Avenida Diagonal 123, Barcelona', '932345678', 'barcelona@carrentalx.com', '08:00:00', '20:00:00'),
('CarRentalX Valencia', 'Calle Colón 55, Valencia', '962345678', 'valencia@carrentalx.com', '08:30:00', '20:30:00'),
('CarRentalX Sevilla', 'Avenida de la Constitución 20, Sevilla', '952345678', 'sevilla@carrentalx.com', '08:30:00', '20:30:00'),
('CarRentalX Bilbao', 'Gran Vía 15, Bilbao', '942345678', 'bilbao@carrentalx.com', '09:00:00', '21:00:00');

-- Inserción de datos en la tabla Empleados
INSERT INTO Empleados (Nombre, Apellidos, DNI, Cargo, Telefono, Email, ID_Sucursal) VALUES
('Juan', 'García Pérez', '12345678A', 'Gerente', '611111111', 'juan.garcia@carrentalx.com', 1),
('María', 'López Sánchez', '23456789B', 'Recepcionista', '622222222', 'maria.lopez@carrentalx.com', 1),
('Carlos', 'Martínez Gómez', '34567890C', 'Asistente', '633333333', 'carlos.martinez@carrentalx.com', 1),
('Laura', 'Fernández Ruiz', '45678901D', 'Gerente', '644444444', 'laura.fernandez@carrentalx.com', 2),
('Pedro', 'Sánchez Vidal', '56789012E', 'Recepcionista', '655555555', 'pedro.sanchez@carrentalx.com', 2),
('Ana', 'Rodríguez Torres', '67890123F', 'Gerente', '666666666', 'ana.rodriguez@carrentalx.com', 3),
('Miguel', 'González Navarro', '78901234G', 'Gerente', '677777777', 'miguel.gonzalez@carrentalx.com', 4),
('Lucía', 'Díaz Moreno', '89012345H', 'Gerente', '688888888', 'lucia.diaz@carrentalx.com', 5);

-- Inserción de datos en la tabla Clientes
INSERT INTO Clientes (Nombre, Apellidos, DNI, Direccion, Telefono, Email, Fecha_Registro) VALUES
('Antonio', 'Gómez Fernández', '11223344J', 'Calle Mayor 10, Madrid', '611223344', 'antonio.gomez@email.com', '2023-01-15'),
('Elena', 'Martín Sanz', '22334455K', 'Avenida Libertad 25, Barcelona', '622334455', 'elena.martin@email.com', '2023-02-20'),
('Javier', 'Ruiz Ortega', '33445566L', 'Plaza España 5, Valencia', '633445566', 'javier.ruiz@email.com', '2023-03-10'),
('Carmen', 'Sanz López', '44556677M', 'Calle Real 30, Sevilla', '644556677', 'carmen.sanz@email.com', '2023-04-05'),
('David', 'Torres Vega', '55667788N', 'Avenida Principal 15, Bilbao', '655667788', 'david.torres@email.com', '2023-05-12'),
('Sofía', 'Navarro Gil', '66778899P', 'Calle Nueva 8, Madrid', '666778899', 'sofia.navarro@email.com', '2023-06-18'),
('Pablo', 'Moreno Castro', '77889900Q', 'Avenida Central 22, Barcelona', '677889900', 'pablo.moreno@email.com', '2023-07-25'),
('Marta', 'Castro Ramos', '88990011R', 'Plaza Mayor 7, Valencia', '688990011', 'marta.castro@email.com', '2023-08-30'),
('Jorge', 'Ramos Ortiz', '99001122S', 'Calle Principal 18, Sevilla', '699001122', 'jorge.ramos@email.com', '2023-09-14'),
('Lucía', 'Ortiz Serrano', '00112233T', 'Avenida Norte 33, Bilbao', '600112233', 'lucia.ortiz@email.com', '2023-10-22');

-- Inserción de datos en la tabla Vehículos
INSERT INTO Vehiculos (Matricula, Marca, Modelo, Anio, Tipo_Combustible, Estado, Precio_Diario, ID_Sucursal) VALUES
('1234ABC', 'Toyota', 'Corolla', 2022, 'Gasolina', 'Disponible', 45.00, 1),
('2345BCD', 'Volkswagen', 'Golf', 2021, 'Diesel', 'Disponible', 50.00, 1),
('3456CDE', 'Ford', 'Focus', 2022, 'Gasolina', 'Disponible', 48.00, 1),
('4567DEF', 'Renault', 'Clio', 2021, 'Diesel', 'Disponible', 40.00, 2),
('5678EFG', 'Seat', 'Ibiza', 2022, 'Gasolina', 'Disponible', 42.00, 2),
('6789FGH', 'Peugeot', '208', 2021, 'Diesel', 'Disponible', 45.00, 3),
('7890GHI', 'Citroën', 'C3', 2022, 'Gasolina', 'Disponible', 43.00, 3),
('8901HIJ', 'Opel', 'Corsa', 2021, 'Diesel', 'Disponible', 41.00, 4),
('9012IJK', 'Fiat', '500', 2022, 'Gasolina', 'Disponible', 38.00, 4),
('0123JKL', 'Hyundai', 'i20', 2021, 'Diesel', 'Disponible', 44.00, 5),
('1234KLM', 'Kia', 'Rio', 2022, 'Gasolina', 'Disponible', 46.00, 5),
('2345LMN', 'Tesla', 'Model 3', 2022, 'Eléctrico', 'Disponible', 80.00, 1),
('3456MNO', 'Toyota', 'Prius', 2021, 'Híbrido', 'Disponible', 55.00, 2),
('4567NOP', 'BMW', 'Serie 3', 2022, 'Diesel', 'Disponible', 75.00, 3),
('5678OPQ', 'Mercedes', 'Clase A', 2021, 'Gasolina', 'Disponible', 78.00, 4);

-- Inserción de datos en la tabla Reservas
INSERT INTO Reservas (Fecha_Inicio, Fecha_Fin, Costo_Total, Estado_Reserva, ID_Cliente, ID_Vehiculo, ID_Empleado, ID_Sucursal) VALUES
('2023-11-01', '2023-11-05', 225.00, 'Completada', 1, 1, 2, 1),
('2023-11-10', '2023-11-15', 300.00, 'Completada', 2, 4, 5, 2),
('2023-11-20', '2023-11-25', 240.00, 'Completada', 3, 6, 6, 3),
('2023-12-01', '2023-12-03', 123.00, 'Completada', 4, 8, 7, 4),
('2023-12-10', '2023-12-15', 230.00, 'Completada', 5, 10, 8, 5),
('2023-12-20', '2023-12-27', 315.00, 'Completada', 6, 2, 2, 1),
('2024-01-05', '2024-01-10', 210.00, 'Completada', 7, 5, 5, 2),
('2024-01-15', '2024-01-20', 215.00, 'Completada', 8, 7, 6, 3),
('2024-01-25', '2024-01-30', 205.00, 'Completada', 9, 9, 7, 4),
('2024-02-01', '2024-02-05', 220.00, 'Activa', 10, 11, 8, 5),
('2024-02-10', '2024-02-15', 400.00, 'Activa', 1, 12, 2, 1),
('2024-02-20', '2024-02-25', 275.00, 'Pendiente', 2, 13, 5, 2),
('2024-03-01', '2024-03-05', 375.00, 'Pendiente', 3, 14, 6, 3),
('2024-03-10', '2024-03-15', 390.00, 'Pendiente', 4, 15, 7, 4);