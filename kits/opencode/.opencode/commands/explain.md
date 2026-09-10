---
description: Mapa mental o resumen de un componente, símbolo o archivo.
---

# Explicar componente
Activación: `/explain`

Si el usuario pasó un archivo o símbolo, úsalo. Si no, usa el archivo activo.

## Pasos
1. **Grafo:** localiza el símbolo con `search_graph` / `get_code_snippet`. Dependencias con `trace_path`. No leas el árbol entero.
2. **Lectura puntual:** abre solo los archivos que el grafo señaló (y el archivo activo).
3. **Resumen:** 1-2 frases de qué hace.
4. **Flujo de datos:** entradas, transformaciones, salidas.
5. **Integración:** quién lo llama y a qué llama.
6. **Salida:** informe en Markdown, en español.
