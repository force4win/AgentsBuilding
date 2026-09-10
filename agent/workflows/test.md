---
description: Ejecuta la suite del repo, interpreta fallos y propone el arreglo mínimo.
---

# Tests
Activación: `/test`

## Pasos
1. Detecta el comando real del repo (`package.json`, `pom.xml`, `*.csproj`, `pytest.ini`, Makefile, CI). No inventes el runner.
2. Ejecuta el menor conjunto útil (test del módulo tocado; suite completa solo si el usuario lo pide o el módulo es transversal).
3. Si falla: reproduce, aísla, propone el **arreglo mínimo**. No refactorices de paso.
4. Si la política de testing dice que aún no toca tests de negocio, dilo y limita a auth/regresión o a lo que el usuario pidió.
5. Resume: cuántos pasaron, cuáles fallaron, qué cambiaste (si el usuario pidió arreglo).
