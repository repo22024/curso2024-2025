🛒 Caso Práctico 2: Sistema de Gestión de Compras para GlobalMart Ltda.

📄 Descripción del Caso
En GlobalMart Ltda., una empresa líder en el sector de distribución y venta de productos, estamos comprometidos con la eficiencia y la transparencia en nuestras operaciones de compras. Con el objetivo de optimizar nuestros procesos y garantizar un mejor control sobre nuestras actividades de adquisición, buscamos implementar un sistema de gestión de compras integral.
Actualmente, enfrentamos desafíos como:
Falta de integración entre proveedores, productos y pedidos.
Dificultad para rastrear el historial de compras y el estado de los pedidos.
Gestión manual de proveedores y productos, lo que genera errores y retrasos.
Este sistema nos permitirá centralizar y automatizar la información relacionada con proveedores, productos y pedidos, mejorando así nuestra eficiencia operativa y la toma de decisiones.

🎯 Objetivo
Diseñar e implementar un sistema de gestión de compras que administre eficientemente la información sobre:
Proveedores: Datos de contacto, productos suministrados y condiciones de pago.
Productos: Detalles de inventario, precios y categorías.
Pedidos: Registro de compras, estado de los pedidos y relación con proveedores y productos.

🛠️ Instrucciones para los Analistas
### 1. 🔍 Identificación de Entidades y Atributos
Identifiquen las entidades clave que deben formar parte del sistema. Estas entidades deben incluir, como mínimo:
Proveedores: Información de contacto y productos suministrados.
Productos: Detalles de inventario y precios.
Pedidos: Registro de compras y estado de los pedidos.
Asegúrense de definir los atributos relevantes para cada entidad.

### 2. 🔗 Relaciones entre Entidades
Analicen y definan las relaciones entre las entidades:
Proveedor → Producto: Un proveedor puede suministrar varios productos (relación uno a muchos).
Producto → Pedido: Un producto puede estar en varios pedidos (relación uno a muchos).

### 3. 📊 Diseño del Modelo Conceptual
Utilicen herramientas como Draw.io, Lucidchart o MySQL Workbench para crear un diagrama Entidad-Relación (ER) que represente las entidades, atributos y relaciones identificadas.

### 4. 💻 Implementación en MySQL
🛒 Modelo Relacional Propuesto
Entidades y Atributos
1. Proveedores
2. Productos
3. Pedidos

🔗 Relaciones
Proveedor → Producto: Uno a Muchos
(Un proveedor puede suministrar varios productos, pero cada producto pertenece a un solo proveedor.)

Producto → Pedido: Uno a Muchos
(Un producto puede estar en varios pedidos, pero cada pedido corresponde a un solo producto.)

## Una vez definido el modelo conceptual, implementen el modelo relacional en MySQL. Incluyan:
Scripts de creación de tablas.
Inserción de datos de prueba.
Consultas SQL para obtener información relevante (por ejemplo, listado de empleados por departamento, puestos vacantes, etc.).

### 5. ✨ Ampliación del Sistema
Propongan y desarrollen al menos dos funcionalidades adicionales que mejoren el sistema. Algunas ideas:
Implementación de vistas para simplificar consultas frecuentes.
Creación de triggers para actualizar automáticamente el inventario después de un pedido.
Generación de informes de compras mensuales por proveedor.

### 6. 📝 Documentación
Deberab Elaborar un informe técnico, tienen las instrucciones en el readme de la carpeta 

