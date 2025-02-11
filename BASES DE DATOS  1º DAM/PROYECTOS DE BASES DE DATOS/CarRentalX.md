# 📋 Enunciado: Sistema de Gestión de Alquiler de Coches para CarRentalX 🚗

## 📄 Descripción del Caso

Estimado Equipo de Analistas,  

En **CarRentalX**, una empresa líder en el sector de alquiler de coches, estamos comprometidos con la excelencia en nuestro servicio y la satisfacción del cliente. Con el objetivo de mejorar nuestra eficiencia operativa y proporcionar una experiencia de alquiler más fluida, estamos buscando implementar un **sistema de gestión de alquiler de coches** completo.  

Actualmente, manejamos una gran cantidad de información de manera manual, lo que genera retrasos en los procesos de reserva, devolución y facturación. Para solucionar esto, necesitamos un sistema que nos permita gestionar de manera eficiente:  
- **👤 Clientes**: Información personal y preferencias.  
- **🚗 Vehículos**: Detalles técnicos, disponibilidad y estado.  
- **📅 Reservas**: Fechas, duración, costos y vehículos asociados.  
- **🏢 Sucursales**: Ubicaciones donde se realizan los alquileres.  
- **👨‍💼 Empleados**: Personal encargado de gestionar las operaciones.  

Además, el sistema debe ser capaz de generar informes sobre:  
- 🚗 Vehículos más alquilados.  
- 👤 Clientes frecuentes.  
- 💰 Ingresos mensuales por sucursal.  

---

## 🛠️ Instrucciones para los Analistas

### 1. **🔍 Identificación de Entidades y Atributos**  
   Utilizando la descripción del caso, identifiquen las **entidades clave** que deben formar parte del sistema. Estas entidades deben incluir, como mínimo:  
   - **👤 Clientes**: Información personal (nombre, DNI, dirección, teléfono, email).  
   - **🚗 Vehículos**: Detalles técnicos (marca, modelo, año, matrícula, tipo de combustible, estado).  
   - **📅 Reservas**: Fechas de inicio y fin, costo total, estado de la reserva.  
   - **🏢 Sucursales**: Ubicación (nombre, dirección, teléfono).  
   - **👨‍💼 Empleados**: Información del personal (nombre, cargo, sucursal asignada).  

   Asegúrense de definir los **atributos** relevantes para cada entidad.  

### 2. **🔗 Relaciones entre Entidades**  
   Determinen cómo se relacionan las entidades entre sí. Por ejemplo:  
   - Un **👤 cliente** realiza una o varias **📅 reservas**.  
   - Una **📅 reserva** está asociada a un **🚗 vehículo** y una **🏢 sucursal**.  
   - Un **👨‍💼 empleado** gestiona las reservas en una **🏢 sucursal**.  

### 3. **✨ Ampliación del Sistema**  
   Propongan y desarrollen al menos **dos funcionalidades adicionales** que mejoren el sistema. Algunas ideas:  
   - Implementación de **vistas** para simplificar consultas frecuentes.  
   - Creación de **triggers** para actualizar automáticamente el estado de los vehículos después de una reserva.  
   - Generación de informes de ingresos mensuales por sucursal.  

### 4. **📝 Documentación**  
  📝 Documentación Deberan Elaborar un informe técnico, tienen las instrucciones en el readme de la carpeta
