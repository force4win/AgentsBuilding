---
name: creador-habilidades
description: Capacidad para crear otras habilidades en idioma español siguiendo los estándares de Antigravity.
---

# Creador de Habilidades en Español

Esta habilidad te permite generar nuevas capacidades (habilidades) para el workspace de manera estructurada y coherente, utilizando el idioma español para todas las instrucciones y documentación interna.

## Cuándo usar esta habilidad
- Cuando el usuario solicite una nueva funcionalidad que requiera un conjunto complejo de instrucciones o scripts.
- Cuando quieras organizar mejor un flujo de trabajo repetitivo en el workspace.

## Estructura de una Habilidad
Cada habilidad debe residir en su propia carpeta dentro de `.agent/skills/` y contener los siguientes elementos:

1. **SKILL.md** (Obligatorio): El archivo principal con el frontmatter de YAML y las instrucciones.
2. **resources/** (Opcional): Plantillas, listas de verificación o archivos estáticos.
3. **scripts/** (Opcional): Scripts de automatización que la habilidad puede ejecutar.
4. **examples/** (Opcional): Ejemplos de uso.

## Proceso de Creación
Cuando se te pida crear una habilidad:
1. **Definir el Nombre**: Debe ser descriptivo y usar `kebab-case` (ej. `analizador-seguridad`).
2. **Crear Directorio**: `mkdir .agent/skills/<nombre-habilidad>`.
3. **Generar SKILL.md**:
   - Usa un encabezado YAML con `name` (el mismo del directorio) y `description` (breve y clara).
   - Escribe las instrucciones en español, de forma clara y procesal.
4. **Agregar Recursos**: Si es necesario, utiliza la subcarpeta `resources/`.

## Reglas de Oro
- **Idioma**: Siempre usa español para el contenido de `SKILL.md`.
- **Claridad**: Las instrucciones deben ser pasos accionables.
- **Auto-documentación**: Si incluyes scripts, asegúrate de que tengan un comando `--help`.
