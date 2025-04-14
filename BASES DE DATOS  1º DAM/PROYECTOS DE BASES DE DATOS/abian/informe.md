## 1. Portada
![portada](./capturas/carrentalx.png)

## 2. Índice

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

## 4. Análisis del Enunciado
Tras revisar el caso planteado por CarRentalX, se identifican los siguientes aspectos clave:

🛠️ Problema actual
Ineficiencia en la gestión manual: La actual gestión manual de los procesos provoca una serie de ineficiencias, como retrasos en la actualización de la información, posibles errores humanos en las reservas, falta de control en el estado de los vehículos y, en general, dificultades para tomar decisiones rápidas y basadas en datos.

Falta de centralización: Actualmente, los datos de los clientes, vehículos, reservas, empleados y sucursales se gestionan de manera separada, lo que impide una visión clara y unificada de la operación. Esto podría resultar en duplicación de esfuerzos y falta de visibilidad en tiempo real.

🎯 Objetivo principal
Desarrollo de un sistema de gestión integral: El objetivo principal es diseñar e implementar una plataforma digital que centralice toda la información de la empresa, agilice la gestión de las reservas, y facilite la administración de los vehículos, clientes, sucursales y empleados.

Automatización y optimización: Implementar soluciones que automaticen tareas repetitivas, como la actualización de la disponibilidad de los vehículos.

🧩 Entidades principales
Las entidades clave que forman la base del sistema de gestión son:

Clientes: Almacenar datos detallados sobre los clientes, como su nombre, información de contacto, tipo de carnet y sus reservas

Vehículos: Contendrá información técnica sobre cada vehículo (modelo, tipo de combustible, matrícula, color), su estado (disponible, no disponible) y su precio. La disponibilidad de los vehículos será crítica para la gestión de las reservas.

Reservas: Esta entidad gestionará la información relacionada con el alquiler de vehículos, incluyendo las fechas de inicio y finalización, quien lo ha alquilado y su estado (en curso, pendiente, confirmada, finalizada).

Sucursales: Se debe registrar información acerca de las ubicaciones físicas de la empresa y los datos de contacto.

Empleados: Información sobre el personal de la empresa, sus roles y la asignación a sucursales específicas, lo que facilita la gestión operativa.

⚙️ Requisitos funcionales
Los requisitos funcionales identificados incluyen:

Gestión integral de recursos: Se requiere un sistema que permita gestionar de manera eficiente a los clientes, vehículos, reservas, sucursales y empleados.

Gestión avanzada de reservas: El sistema debe ser capaz de crear, modificar y cancelar reservas, permitiendo el seguimiento del estado de las mismas (por ejemplo, confirmar disponibilidad de vehículos en tiempo real).

Generación de informes detallados:

🚗 Vehículos más alquilados: Informes sobre los vehículos más populares entre los clientes, lo que puede ayudar a optimizar el inventario.

👤 Clientes más frecuentes: Identificación de los clientes más recurrentes para diseñar estrategias de fidelización.

💰 Ingresos mensuales por sucursal: Reportes financieros que permitan a la gerencia evaluar el rendimiento económico de cada sucursal.