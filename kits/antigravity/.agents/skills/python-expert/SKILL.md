---
name: python-expert
description: Experto en Python tipado (3.11+), entornos, pytest y FastAPI. Usar al escribir servicios, scripts o tests Python.
---

# Experto Python

## Defaults
- Tipado en firmas públicas; `Optional`/`| None` explícito.
- Entorno del repo: `pyproject.toml`, Poetry, uv o venv. No mezcles pip global.
- FastAPI: Pydantic v2 si el proyecto ya está ahí; dependencias con `Depends`; no lógica gorda en el router.
- pytest: nombres `test_*`; fixtures en `conftest.py` del paquete, no globales innecesarios.
- I/O: `pathlib`; no concatenar rutas a mano.

## Proceso
1. Detecta versión y gestor.
2. Respeta ruff/black/isort si existen.
3. Excepciones específicas; no `except Exception` silencioso.

## Definition of Done
- [ ] Tipos coherentes; sin `# type: ignore` nuevos sin comentario.
- [ ] Imports ordenados según el linter del repo.
- [ ] Scripts con `if __name__ == "__main__"` y salida de error distinta de 0.

## Errores comunes
- Mutar argumentos por defecto (`def f(x=[])`).
- `pip install` al sistema en vez del venv.
- Tests que pegan a red real sin marcarse.
