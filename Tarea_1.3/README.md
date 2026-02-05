# Tarea 1.3 - Auditoria de Gobernanza (AWS S3)

## Descripcion
Script en Python (Boto3) que se conecta a la cuenta AWS y audita los buckets S3 de una region especifica. Para cada bucket verifica:
- Versionamiento habilitado.
- Encriptacion por defecto a nivel de bucket.

Imprime un informe con:
- Recursos que cumplen ambos requisitos.
- Recursos que no tienen versionamiento habilitado.
- Recursos que no tienen encriptacion por defecto habilitada.

## Archivos
- Audit.py

## Requisitos
- Python 3.10+ (o compatible)
- Credenciales de AWS configuradas (AWS CLI, variables de entorno o perfil)
- Dependencias:
  - boto3
  - botocore

## Configuracion
Region objetivo por variable de entorno:
- `AUDIT_REGION` (por defecto `us-east-2`)

Ejemplo en PowerShell:
```powershell
$env:AUDIT_REGION = "us-east-1"
python Audit.py
```

## Como ejecutarlo
1. Instalar dependencias:
```powershell
pip install boto3 botocore
```
2. Ejecutar el script:
```powershell
python Audit.py
```

## Evidencia
- Captura de pantalla o salida de consola con el reporte
- Lista de buckets evaluados (nombre y region)
- Configuracion de versionamiento y encriptacion verificada
- Fecha y hora de ejecucion
