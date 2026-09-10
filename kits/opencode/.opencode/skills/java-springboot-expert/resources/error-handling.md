# Manejo consistente de errores (REST)

## Objetivo
- Respuestas predecibles para clientes
- Mensajes seguros (sin filtrar detalles internos)
- Trazabilidad (correlation id)

## Recomendación
- Implementar `@ControllerAdvice` con:
  - `MethodArgumentNotValidException` → 400
  - `ConstraintViolationException` → 400
  - `EntityNotFoundException` / `NoSuchElementException` → 404
  - `AccessDeniedException` → 403
  - `AuthenticationException` → 401
  - fallback → 500

## Esquema sugerido (Problem Details)
- `type`, `title`, `status`, `detail`, `instance`
- `errors[]` para campos (opcional)
