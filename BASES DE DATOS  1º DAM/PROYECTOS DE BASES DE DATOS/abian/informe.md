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

# 6. Modelo relacional

![Modelo relacional](./capturas/modelo.relacional.png)