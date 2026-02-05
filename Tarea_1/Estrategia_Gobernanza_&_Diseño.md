# Prueba Tecnica Cloud Engineer – Gobierno de Nube

**Escenario:** Aplicación web global que gestiona PII y consume un modelo de IA preentrenado vía API.  

**Enfoque:**  
- **Tarea 1:** Consideraciones de gobernanza con enfoque **multi-cloud (AWS y GCP)**.  
- **Tareas 2 y 3:** Implementación práctica y auditoría realizadas en **AWS**.
---

## 1) Consideraciones de Gobernanza Clave

### Seguridad
En este escenario lo mas critico es proteger la PII y aislar produccion desde el dia 1.

- **Clasificacion de datos:** Marcar PII y aplicar controles segun la etiqueta.
- **Cifrado por defecto:** En transito y en reposo.  
  - AWS: KMS + Secrets Manager  
  - GCP: Cloud KMS + Secret Manager
- **Separacion de ambientes:** Proyectos/cuentas separados para `dev / qa / prod`.
- **Red y exposicion:** Subredes privadas, egress controlado y exposicion solo via WAF/LB.
- **Logs y auditoria:**  
  - AWS: CloudTrail + CloudWatch  
  - GCP: Cloud Audit Logs + Cloud Logging

### Cumplimiento
- **Minimizacion:** No almacenar ni enviar mas datos de los necesarios.
- **Trazabilidad:** Evidencia clara de quien accede y que cambia.
- **Retencion y borrado:** Politicas definidas y borrado seguro (lifecycle).
- **Residencia de datos:** Limitar regiones si hay restricciones regulatorias.

### Costos (FinOps)
- **Tagging obligatorio:** `Environment, ProjectName, DataClassification, Owner`.
- **Presupuestos y alertas:**  
  - AWS Budgets  
  - GCP Budgets
- **Plantillas reutilizables:** Infraestructura estandar para evitar sprawl.

### Operaciones
- **Infraestructura como código:** Terraform + PRs.
- **Controles preventivos/detectivos:** Politicas y auditoria continua.  
  - AWS: SCPs + Config  
  - GCP: Organization Policies + Security Command Center
- **Backups y recuperación:** Estrategia y pruebas de restore.

**Controles recomendados (mínimo viable)**
- Landing zone con guardrails básicos.
- Cifrado, logging y tagging como requisitos de entrada.
- Revision de arquitectura antes de prod.

---

## 2) Estrategia IAM (mínimo privilegio)

### Principios
- Minimo privilegio, roles por función, acceso temporal.
- Evitar llaves estaticas; preferir SSO/federación.

### Roles sugeridos
- **Dev:** Lectura en observabilidad y no‑prod. Deploys vía pipeline.
- **Ops/SRE:** Operación con auditoria; break‑glass solo con aprobacion.
- **Workload:** Permisos minimos y secretos gestionados.

### Controles
- Politicas por plantilla y revisiones periodicas.
- Rotación y revision de accesos.
- Alertas ante cambios sensibles.

---

## 3) Optimización de Costos (FinOps)

- Tagging desde el dia 1 y enforcement.
- Presupuesto por ambiente con alertas 50/80/100%.
- Right sizing temprano para evitar sobrecosto.
- Ambientes efimeros para pruebas (auto‑destroy).
- Revision de costos quincenal o mensual.

---

## 4) Gobernanza del modelo de IA (endpoint de terceros)

### Riesgos principales
1. **Fuga de PII hacia el modelo** (prompts, logs, respuestas).
2. **Consumo no controlado** (abuso, costos, dependencia).

### Mitigaciones
- **No enviar PII:** Enmascarar o tokenizar si se requiere analisis.
- **Acceso restringido:** Roles de workload y secretos gestionados.
- **Rate limits y cuotas:** Por app/ambiente.
- **Observabilidad:** Metricas y logs sin PII.
- **Gestión de cambios:** Versionado, pruebas y rollback.

---

## 5) DevSecOps en CI/CD

- **SAST:** Escaneo antes de merge a main.
- **IaC scanning:** Validar Terraform y politicas antes de plan/apply.
- **Secret scanning:** Bloquear pipeline si hay llaves/tokens.
- **Dependency/Container scanning:** Vulnerabilidades en dependencias e imagenes.
- **Gates por ambiente:** Deploy a prod solo con rama protegida y approvals.
