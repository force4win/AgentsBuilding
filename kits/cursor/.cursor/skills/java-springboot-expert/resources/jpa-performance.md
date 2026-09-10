# JPA/Hibernate: performance y patrones

## Anti-patrones frecuentes
- N+1 queries por relaciones LAZY en serialización JSON
- Exponer entidades directamente en controllers
- Transacciones largas con lógica pesada

## Técnicas
- Proyecciones (interfaces/DTO) para lecturas
- `@EntityGraph` o fetch joins donde aplique
- Batch fetching (`hibernate.default_batch_fetch_size`)
- Índices en columnas de búsqueda
- Paginación con `Slice` cuando no necesitas total count

## Concurrencia
- `@Version` (optimistic locking) para updates concurrentes
