---
description: Syncs the agent with the current project state, MD files, and context.
---
# Resume Development (Universal)
Activation: Manual (/InitIAproject)

## Steps
1. **Initial**: idnetificar si el archivo `AlvWasHere.md` existe; Si el archivo existe; decir que existe y no hacer nada mas; de lo contrario continuar creando una carpeta llamada `.alvhere` y todo lo demas que creemos lo hagamos dentro de esta carpeta
2. **ScanFiles**: Si el archivo `AlvWasHere.md` no existe: vamos a crearlo con la fecha actual e inicializacion 
3. **CreateReadMe**: leer el contenido del proyecto, todo el codigo y archivos "humanreadable" y crear un archivo `README.md` en la raiz del proyecto; con las generalidades del proyecto e instrucciones relevantes
4. **CreateContext** Crear archivos como `guideLines.md`, `handoff.md`, `PROJECT_CONTEXT.md`, `task.md`;  hay que crearlos dentro de la carpeta `.alvhere`
5. **Project Status Report**: Summarize for the user:
   - What is the current goal.
   - What was the last thing implemented.
   - What is the next logical task in the roadmap.