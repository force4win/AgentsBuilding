# Política de testing

Durante la implementación de una feature de negocio, prioriza que compile y sea correcto. Los tests de negocio llegan al final del roadmap.

## Fase de implementación (~80%)

- No escribas suites unitarias/integración de la feature de negocio todavía.
- Valida con compilación, tipos y una prueba manual breve si aplica.
- La estructura puede cambiar; no ancles tests a APIs inestables.

## Fase de testing (~90% del roadmap)

Empieza cuando el flujo núcleo está estable. Entonces:

1. Detecta cómo corre la suite en **este** repo (no inventes el comando).
2. Cubre el camino feliz y 1-2 fallos de negocio.
3. Añade tests de borde solo si el riesgo lo justifica.

## Excepción (no se postergan)

Escribe tests **ya** si el cambio toca autenticación, autorización, JWT, validación de entrada o control de acceso.

## No aplicar

- Proyectos cuyo Definition of Done del usuario pide tests desde el primer commit: respeta al usuario.
- Regresiones que estás arreglando: un test que reproduce el bug **sí** va primero.
