# Prueba Técnica Cloud Engineer

## Introducción
Esta prueba evalúa la capacidad para diseñar, implementar y auditar controles de gobernanza en la nube.
El escenario considera una aplicación web global que gestiona información sensible (PII) y consume un modelo de IA vía API, con un enfoque **multi-nube a nivel conceptual (AWS y GCP)** y **ejecución práctica en AWS**.

El objetivo es demostrar criterio en gobierno de nube, seguridad, operación e infraestructura como código, combinando diseño teórico con implementación real.

---

## Entregables

- **Tarea 1:** Documento de estrategia de gobernanza y diseño (enfoque multi-cloud).
- **Tarea 1.2:** Implementación práctica de Infraestructura como Código (Terraform) para un bucket S3 seguro en AWS.
- **Tarea 1.3:** Script en Python (Boto3) para auditoría de gobernanza sobre buckets S3.

---

## Implementación práctica
La solución **no se quedó en un enfoque teórico**.  
Las tareas técnicas fueron **implementadas y ejecutadas en una cuenta real de AWS**, incluyendo:

- Creación de recursos mediante Terraform.
- Validación de controles de seguridad (versionamiento, encriptación, acceso restringido).
- Ejecución real del script de auditoría utilizando credenciales AWS y el SDK Boto3.
- Verificación de resultados tanto por consola como por AWS CLI.

Esto permite demostrar la viabilidad y funcionamiento real de los controles propuestos.

---

## Nota
Se utilizó IA como apoyo para:
- Redacción y mejora de documentación (`README.md`).
- Comprensión de conceptos específicos de Terraform y Python durante el desarrollo.

Las decisiones de diseño, la implementación de infraestructura y la ejecución de los scripts fueron realizadas y validadas manualmente en un entorno real de AWS.
