---
name: creador-habilidades
description: Crea otras habilidades (SKILL.md) en español, con nombre kebab-case y frontmatter válido para Antigravity, Cursor y OpenCode. Usar cuando el usuario pida una skill, habilidad o capacidad nueva.
---

# Creador de Habilidades en Español

Genera habilidades nuevas de forma estructurada. El contenido de `SKILL.md` va en español.

## Dónde crearlas
Detecta el kit del workspace y escribe ahí:

| Señal en la raíz | Destino |
|---|---|
| `.agents/skills/` o `.agent/skills/` | Antigravity |
| `.cursor/skills/` | Cursor |
| `.opencode/skills/` | OpenCode |
| Este repo (`agent/skills/` existe) | `agent/skills/` y luego regenerar kits con `scripts/pack-kits.ps1` |

## Estructura
Cada habilidad es una carpeta cuyo nombre coincide con `name` del frontmatter:

1. **SKILL.md** (obligatorio): YAML + instrucciones.
2. **resources/** (opcional): plantillas y checklists.
3. **scripts/** (opcional): automatización con `--help`.
4. **examples/** (opcional): ejemplos de uso.

## Frontmatter (obligatorio)
```yaml
---
name: nombre-de-la-habilidad
description: Qué hace y cuándo usarla (máx. 1024 caracteres).
---
```

`name` debe cumplir `^[a-z0-9]+(-[a-z0-9]+)*$` (minúsculas, números, un solo guion entre segmentos) y ser idéntico al nombre de la carpeta.

## Proceso
1. Definir el nombre en kebab-case.
2. Crear el directorio en la carpeta de skills detectada.
3. Generar `SKILL.md` en español, con pasos accionables.
4. Añadir `resources/` si hace falta. Plantilla: [template_skill.md](resources/template_skill.md).
5. Validar con [checklist.md](resources/checklist.md).

## Reglas
- Español en el cuerpo de `SKILL.md`.
- Descripción en tercera persona, con QUÉ y CUÁNDO.
- Sin campos extra innecesarios (`triggers`, `version`) que rompan validadores.
- Si hay scripts, documentar `--help`.
