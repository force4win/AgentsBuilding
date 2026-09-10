---
description: DRY, responsabilidad unica, nombres claros y funciones pequenas
alwaysApply: true
---
# Patrones de código limpio

Prioriza un cambio pequeño, legible y mantenible.

## DRY

Si la misma lógica aparece **tres o más** veces, extrae una función. No extraigas a la segunda copia.

```text
# Incorrecto: tres bloques idénticos de parseo de fecha
# Correcto: una función parseDate(input) y tres llamadas
```

## Responsabilidad única

Una función hace una cosa. Si el nombre necesita «y», sepárala.

```text
# Incorrecto: saveUserAndSendEmailAndLog()
# Correcto: saveUser(); enqueueWelcomeEmail();
```

## Nombres

Descriptivos. Una letra solo en índices de bucle cortos (`i`, `j`).

```text
# Incorrecto: const d = load(); const x = d.t;
# Correcto: const invoice = loadInvoice(); const total = invoice.total;
```

## Tamaño

Funciones de lógica preferiblemente bajo ~40 líneas. Si crecen, extrae pasos con nombres que expliquen el «qué».

## No aplicar

- Micro-extracciones que empeoran la lectura.
- Refactors masivos no pedidos (ver `scope-discipline`).
