👩‍💼 Caso Práctico 1: Sistema de Gestión de Empleados para TechSolutions Inc.

📄 Descripción del Caso
Estimado Equipo de Analistas,
En TechSolutions Inc., estamos comprometidos con la eficiencia y la organización en la gestión de nuestros recursos humanos. 🙌 Como parte de nuestros esfuerzos continuos por mejorar, buscamos implementar un sistema de gestión de empleados que nos permita administrar de manera más efectiva la información de nuestros empleados, departamentos y puestos de trabajo.
Actualmente, enfrentamos desafíos como:
Falta de integración entre la información de empleados, departamentos y puestos.
Dificultad para acceder a datos históricos y actualizados sobre la estructura organizacional.
Gestión manual de nóminas, evaluaciones y asignaciones de roles, lo que genera errores y retrasos.
Este sistema nos permitirá centralizar y automatizar la información relacionada con empleados, departamentos y puestos de trabajo, mejorando así nuestra eficiencia operativa y la toma de decisiones.

🎯 Objetivo
Diseñar e implementar un sistema de gestión de empleados que administre eficientemente la información sobre:
Empleados: Datos personales, roles y evaluaciones.
Departamentos: Estructura organizacional y asignación de empleados.
Puestos de trabajo: Descripción de roles, salarios y responsabilidades.

🛠️ Instrucciones para los Analistas
### 1. 🔍 Identificación de Entidades y Atributos
Identifiquen las entidades clave que deben formar parte del sistema. Estas entidades deben incluir, como mínimo:
Empleados: Información personal, roles y evaluaciones.
Departamentos: Estructura organizacional y asignación de empleados.
Puestos de trabajo: Descripción de roles, salarios y responsabilidades.
Asegúrense de definir los atributos relevantes para cada entidad.

### 2. 🔗 Relaciones entre Entidades
Analicen y definan las relaciones entre las entidades:
Empleado → Departamento: Un empleado pertenece a un departamento (relación muchos a uno).
Empleado → Puesto: Un empleado tiene un puesto de trabajo (relación muchos a uno).
Departamento → Puesto: Un departamento puede tener varios puestos de trabajo (relación uno a muchos).

### 3. 📊 Diseño del Modelo Conceptual
Utilicen herramientas como Draw.io, Lucidchart o MySQL Workbench para crear un diagrama Entidad-Relación (ER) que represente las entidades, atributos y relaciones identificadas.

### 4. 💻 Implementación en MySQL
Una vez definido el modelo conceptual, implementen el modelo relacional en MySQL. Incluyan:
Scripts de creación de tablas.
Inserción de datos de prueba.
Consultas SQL para obtener información relevante (por ejemplo, listado de empleados por departamento, puestos vacantes, etc.).

### 5. ✨ Ampliación del Sistema
Propongan y desarrollen al menos dos funcionalidades adicionales que mejoren el sistema. Algunas ideas:
Implementación de vistas para simplificar consultas frecuentes.
Creación de triggers para actualizar automáticamente el salario promedio por departamento.
Generación de informes de evaluación de desempeño por empleado.

### 6. 📝 Documentación
Deberan Elaborar un informe técnico, tienen las instrucciones en el readme de la carpeta
