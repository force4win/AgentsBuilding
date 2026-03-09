# Plantilla rápida de threat modeling (para features de auth/JWT)

## 1. Alcance
- Feature:
- Componentes:
- Datos sensibles:
- Actores (usuarios, admin, servicios):

## 2. Supuestos
- Transporte (TLS/mTLS):
- Almacenamiento de tokens:
- Rotación/revocación:
- Controles existentes:

## 3. Amenazas (lista corta)
- Token theft (XSS / malware / logs)
- Replay (captura de token)
- Privilege escalation (scope/role manipulation)
- Confusión de audience/issuer
- Key compromise (private key leak)
- Brute force / credential stuffing
- SSRF hacia metadata/JWKS (si aplica)

## 4. Controles
- Preventivos:
- Detectivos:
- Correctivos:

## 5. Tests
- Unit:
- Integration:
- Abuse cases:

## 6. Observabilidad
- Logs:
- Métricas:
- Alertas:
