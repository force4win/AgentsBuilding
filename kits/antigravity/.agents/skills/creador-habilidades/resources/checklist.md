# Lista de Verificación de Nueva Habilidad

Antes de dar por creada una habilidad:

- [ ] La carpeta existe en `skills/<nombre-habilidad>` del kit activo (`.agents`, `.cursor` o `.opencode`) o en `agent/skills/` si se edita este repo.
- [ ] El nombre de la carpeta coincide con `name` del frontmatter.
- [ ] `name` es kebab-case: `^[a-z0-9]+(-[a-z0-9]+)*$`.
- [ ] `SKILL.md` tiene frontmatter YAML con `name` y `description`.
- [ ] `description` incluye qué hace y cuándo usarla (máx. 1024 caracteres).
- [ ] El contenido de `SKILL.md` está en español.
- [ ] No hay errores de sintaxis en el Markdown.
- [ ] Se incluyeron resources o scripts necesarios.
- [ ] Si se editó `agent/`, se regeneraron los kits con `scripts/pack-kits.ps1`.
- [ ] Se notificó al usuario la nueva capacidad y cómo invocarla.
