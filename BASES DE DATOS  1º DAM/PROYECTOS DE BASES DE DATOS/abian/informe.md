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

# 9. Ampliación de la base de datos

## Creación de tabla de pagos

```sql
### Tabla de pagos

CREATE TABLE pagos (
  idPago INT PRIMARY KEY AUTO_INCREMENT,
  idReserva INT NOT NULL,
  fechaPago DATE NOT NULL,
  metodoPago VARCHAR(50),         
  cantidad DECIMAL(10, 2) NOT NULL,
  estadoPago VARCHAR(20),        
  FOREIGN KEY (idReserva) REFERENCES reservas(idReserva)
);
```

## Creación de tabla de mantenimientos

```sql
CREATE TABLE mantenimientos (
  idMantenimiento INT PRIMARY KEY AUTO_INCREMENT,
  idVehiculo INT NOT NULL,
  fecha DATE NOT NULL,
  tipo VARCHAR(100),               
  costo DECIMAL(10, 2),
  descripcion TEXT,
  FOREIGN KEY (idVehiculo) REFERENCES vehiculos(idVehiculo)
);
```

## Inserción de datos en la tabla de pagos

```sql
INSERT INTO pagos VALUES
(DEFAULT, 1, '2025-04-01', 'tarjeta', 100.50, 'pagado'),
(DEFAULT, 2, '2025-04-02', 'efectivo', 150.00, 'pagado'),
(DEFAULT, 3, '2025-04-03', 'transferencia', 200.75, 'pendiente'),
(DEFAULT, 4, '2025-04-04', 'tarjeta', 120.00, 'pagado');
```

## Inserción de datos en la tabla de mantenimientos

```sql
INSERT INTO mantenimientos  VALUES
(DEFAULT, 1, '2025-04-01', 'cambio aceite', 30.00, 'Cambio de aceite y filtros'),
(DEFAULT, 2, '2025-04-02', 'revisión frenos', 50.00, 'Revisión de frenos y pastillas'),
(DEFAULT, 3, '2025-04-03', 'reemplazo llanta', 80.00, 'Reemplazo de llanta dañada'),
(DEFAULT, 4, '2025-04-04', 'alineación ruedas', 40.00, 'Alineación y balanceo de ruedas');
```