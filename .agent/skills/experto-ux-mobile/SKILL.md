---
name: experto-ux-mobile
description: Experto en UX/UI especializado en crear interfaces móviles amigables desde web HTML. Transforma diseños web convencionales en experiencias táctiles premium, usables y responsivas con jerarquía visual optimizada.
---

# Experto en Experiencia de Usuario (UX) e Interfaces (UI) para Dispositivos Móviles

Esta habilidad está diseñada para guiar la transformación de cualquier interfaz web (HTML/CSS) en una experiencia "Mobile First" de alta calidad, asegurando que el resultado sea usable en teléfonos celulares y se adapte elegantemente a portátiles (responsivo).

## Objetivo General
Transformar componentes web de escritorio en interfaces móviles táctiles, intuitivas y estéticamente superiores, aplicando principios modernos de diseño, medidas estándar y buenas prácticas de interacción.

## Estrategia de Transformación (Instrucciones)

1. **Jerarquización Mobile-First**: 
   - No intentes "encoger" el diseño de escritorio. Rediseña priorizando la pantalla pequeña primero.
   - Elimina elementos no críticos para reducir el ruido visual.
   - Aplica una sola columna para el flujo principal de contenido.

2. **Adaptación de Componentes**:
   - **Navegación**: Sustituye barras de menú superiores extensas por un "Menú de Hamburguesa" o una "Bottom Navigation Bar" (Barra de Navegación Inferior) para facilitar el acceso con el pulgar.
   - **Tablas**: Convierte tablas de datos horizontales en "Cards" (tarjetas) individuales o listas expandibles.
   - **Botones y Acciones**: Convierte botones pequeños de texto en botones de ancho completo (100% width) con altura mínima de 48px para facilitar el toque.
   - **Formularios**: Usa etiquetas (labels) arriba de los campos o etiquetas flotantes. Evita los diseños de dos columnas en formularios.

3. **Optimización Táctil y Espaciado**:
   - **Áreas de Toque**: Todos los elementos interactivos deben tener un área mínima de 44x44px (o 48x48px recomendados).
   - **Gutter (Márgenes)**: Usa márgenes laterales estándar de 16px o 20px para separar el contenido del borde físico de la pantalla.
   - **Grid de 8px**: Alinea todos los espacios (padding, margins) en múltiplos de 8px (8, 16, 24, 32...) para lograr una armonía visual profesional.

4. **Escalabilidad y Responsividad**:
   - Usa unidades relativas (`rem`, `em`, `%`, `vh`, `vw`) en lugar de `px` fijos.
   - Implementa Media Queries estratégicos (breakpoints: 640px, 768px, 1024px) para añadir columnas o expandir el layout al pasar de móvil a tablet/laptop.

## Referencias Técnicas y Medidas

| Elemento | Medida Recomendada | Justificación |
| :--- | :--- | :--- |
| **Viewport Meta** | `width=device-width, initial-scale=1` | Imprescindible para el escalado inicial. |
| **Cuerpo de Texto** | 16px a 18px | Legibilidad óptima sin zoom. |
| **Títulos (H1)** | 24px a 32px | Impacto visual sin ocupar toda la pantalla inicial. |
| **Altura de Botón** | 48px a 56px | Altura ideal para el pulgar humano. |
| **Radio de Borde** | 12px a 24px | Estética moderna y suavizada (Glassmorphism). |
| **Z-Index Modales** | 1000+ | Asegurar que los diálogos móviles floten sobre todo. |

## Formas e Interacciones

### 1. Retroalimentación Visual (Feedback):
- **Estados Activos**: Al tocar un elemento, debe cambiar levemente de color o escala (ej. `transform: scale(0.97)`).
- **Transiciones**: Usa `ease-in-out` con duraciones cortas (200ms - 300ms) para cambios de estado o navegación.
- **Carga (Skeleton UI)**: Prefiere esqueletos de carga en lugar de spinners para mejorar la percepción de velocidad.

### 2. Gestos y Patrones:
- **Bottom Sheets**: Para filtros o menús de opciones rápidas, usa hojas que se deslizan desde la parte inferior.
- **Sticky Header/Footer**: Mantén la navegación crítica o el botón de acción principal (CTA) siempre visible o anclado al fondo.
- **Zonas de Calor**: Coloca las acciones más frecuentes en la parte inferior media de la pantalla ("Zona del Pulgar").

## Buenas Prácticas (Do's & Don'ts)

✅ **SÍ (Hacer):**
- Usar **Lazy Loading** para imágenes.
- Asegurar que los inputs disparen el teclado correcto (ej. `type="number"` para telefónos).
- Probar el diseño con una mano (usabilidad de pulgar).
- Usar iconos claros con etiquetas de texto si el significado es ambiguo.

❌ **NO (No hacer):**
- **Hover Crítico**: No dependas del estado `:hover` para mostrar información vital (en móvil no existe el puntero flotante).
- **Pop-ups Invasivos**: Evita los modales que bloquean toda la pantalla sin una opción clara y grande de cierre.
- **Texto en Imágenes**: El texto debe ser real para permitir el redimensionado y la accesibilidad.
- **Zoom Forzado**: Bloquear el zoom del usuario (`user-scalable=no`) suele ser una mala práctica de accesibilidad, a menos que la aplicación sea muy específica.

## Ejemplos de Implementación

### Ejemplo: Conversión de Menú
**Web Escritorio:** `Inicio | Productos | Servicios | Contacto` (Fila horizontal).
**Móvil Premium:** Botón flotante o barra inferior fija con 4 iconos y etiquetas cortos.

### Ejemplo: Card de Producto
**Web Escritorio:** Imagen a la izquierda, texto a la derecha. (2 columnas).
**Móvil Premium:** Imagen arriba (aspect-ratio 16/9 o 4/5), texto abajo ocupando el 100% del ancho, botón de compra redondeado y prominente.
