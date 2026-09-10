# Gestión de claves (JWT)

## Objetivos
- Confidencialidad: private keys nunca salen del almacén seguro.
- Integridad: rotación, control de acceso, auditoría.
- Disponibilidad: estrategia de despliegue sin downtime.

## Recomendaciones
- KMS/Vault/HSM para llaves privadas.
- Rotación programada + rotación por incidente.
- `kid` único y estable.
- Publicación JWKS con caching:
  - Cache-Control apropiado
  - tolerancia a propagación
- Mantener dos llaves activas durante transición.

## Incidente
- Si se filtra private key:
  1) rotar inmediatamente
  2) revocar sesiones (refresh) si aplica
  3) publicar nuevo JWKS (y retirar el viejo)
  4) investigar alcance (logs, repos, backups)
