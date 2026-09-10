---
description: Sistema de diseno Frutiger Aero para UI frontend
globs: **/*.{css,scss,html,tsx,jsx,vue,svelte}
---
# Guía Maestra de Diseño y Sistema de Diseño UI/UX: Frutiger Aero
**Versión:** 1.0  
**Audiencia:** Diseñadores UI/UX, Diseñadores Visuales, Desarrolladores Frontend (Web, Desktop & Mobile)  
**Objetivo:** Proporcionar una especificación técnica exhaustiva y accionable para construir interfaces digitales basadas en la estética visual y principios de interacción del movimiento **Frutiger Aero** (era c. 2004–2013), adaptadas a los estándares de desarrollo y pantallas modernas.

---

## 1. Manifiesto y Filosofía Frutiger Aero

Frutiger Aero no es simplemente "retro". Representa el optimismo tecnológico de mediados de los años 2000: una visión utópica donde la tecnología de punta convive armónicamente con la naturaleza, la ecología, el agua, la luminosidad y la atmósfera terrestre.

### 1.1 Pilares Fundamentales
1. **Biofilia y Futurismo Positivo:** Integración constante de motivos naturales: praderas verdes hiperreales, cielos despejados, nubes cúmulo, destellos solares (*lens flares*), burbujas de agua, gotas microscópicas y follaje de alta definición.
2. **Skeuomorfismo Translúcido (Glassmorphism Orgánico):** Los elementos emulan materiales físicos reales, en especial vidrio soplado, cristal acrílico pulido, plexiglás y agua contenida en superficies con grosor, refracción y destellos.
3. **Hiper-brillo y Dimensionalidad:** Acabados brillantes (*glossy*), biseles acentuados, sombras de contacto con peso real, y reflejos horizontales especulares (el clásico brillo de cápsula / botón de píldora de gel).
4. **Espacios Abiertos y Frescura Atmosférica:** Fondos que transmiten aire fresco, profundidad de campo, fluidez hidráulica y aire limpio.
5. **Tipografía Humanista Limpia:** Legibilidad geométrica o humanista con suavizado nítido (*ClearType*), sin aristas toscas ni serifas rígidas.

---

## 2. Paleta Cromática y Tokens de Color

El esquema Frutiger Aero se fundamenta en tonalidades acuáticas, celestes, verdes clorofila y acentos radiantes sobre bases traslúcidas.

### 2.1 Colores Primarios y Atmosféricos

| Token | Nombre | Hex | HSL | Propósito / Uso |
| :--- | :--- | :--- | :--- | :--- |
| `--color-sky-zenith` | Cyan Cielo Cenital | `#00A3E0` | `196°, 100%, 44%` | Cabeceras principales, bordes de acento de ventanas, foco activo |
| `--color-sky-horizon` | Azul Claro Atmósfera | `#72C7F7` | `201°, 90%, 71%` | Fondos de barra de tareas, tarjetas activas, gradientes superiores |
| `--color-aqua-marine` | Turquesa Fluido | `#00E5FF` | `186°, 100%, 50%` | Destellos activos, botones secundarios luminosos, halos de hover |
| `--color-nature-leaf` | Verde Clorofila | `#54C21B` | `99°, 75%, 43%` | Acciones positivas (Call-to-Action primarios, botones "Descargar/Guardar") |
| `--color-nature-lime` | Verde Lima Radiante | `#99E343` | `88°, 75%, 57%` | Destellos superiores en botones de éxito, indicadores de estado online |
| `--color-deep-ocean` | Azul Abisal Base | `#0A2540` | `210°, 73%, 15%` | Texto de alto contraste, barras oscuras de herramientas o docks |

### 2.2 Superficies de Vidrio y Translúcidos

| Token | Propósito | Valores CSS recomendados |
| :--- | :--- | :--- |
| `--glass-base` | Superficie de ventana flotante | `rgba(255, 255, 255, 0.45)` |
| `--glass-highlight` | Borde de refracción superior | `rgba(255, 255, 255, 0.85)` |
| `--glass-shadow` | Borde de sombra inferior | `rgba(0, 40, 80, 0.25)` |
| `--glass-inner-glow` | Resplandor perimetral interno | `inset 0 1px 0 rgba(255, 255, 255, 0.9)` |
| `--glass-dark-tint` | Vidrio ahumado / barra de control | `rgba(15, 32, 50, 0.55)` |

### 2.3 Gradientes Clásicos y Fórmulas CSS

#### Botón de Píldora / Gelatinoso Clásico (Glossy Gel Button)
```css
.fa-button-glossy {
  background: linear-gradient(
    to bottom,
    #b4e391 0%,
    #61c419 49%,
    #4ea810 50%,
    #7cd426 100%
  );
  border: 1px solid #3d880d;
  box-shadow: 
    inset 0 1px 1px rgba(255, 255, 255, 0.85),
    inset 0 -1px 2px rgba(0, 0, 0, 0.2),
    0 2px 5px rgba(0, 0, 0, 0.25);
  border-radius: 9999px; /* Forma de píldora */
}
```

#### Ventana Aero Glass (Aero Glass Window Panel)
```css
.fa-window-glass {
  background: linear-gradient(
    135deg,
    rgba(255, 255, 255, 0.55) 0%,
    rgba(225, 245, 255, 0.35) 45%,
    rgba(180, 220, 255, 0.25) 100%
  );
  backdrop-filter: blur(12px) saturate(160%);
  -webkit-backdrop-filter: blur(12px) saturate(160%);
  border: 1px solid rgba(255, 255, 255, 0.65);
  box-shadow: 
    0 10px 30px rgba(0, 50, 100, 0.2),
    inset 0 1px 2px rgba(255, 255, 255, 0.95);
  border-radius: 12px;
}
```

---

## 3. Tipografía y Microtipografía

El estilo depende críticamente de familias tipográficas sans-serif humanistas con curvas suaves, alturas de x generosas y máxima legibilidad en interfaces complejas.

### 3.1 Familias Tipográficas

1. **Primarias del Ecosistema Original:**
   - **Segoe UI** (Windows Vista / 7)
   - **Frutiger** (Adrian Frutiger, raíz directa del movimiento)
   - **Lucida Grande** (Mac OS X Tiger / Snow Leopard)
   - **Calibri** o **Corbel** (Interfaces de productividad)
2. **Alternativas Modernas y Web Fonts (Google Fonts / Libres):**
   - **Inter** (configurada con suavizado alto)
   - **Noto Sans** / **Open Sans** (con proporciones humanistas)
   - **Ubuntu Sans** (curvatura orgánica muy compatible)

### 3.2 Escala Tipográfica y Efectos de Texto
En Frutiger Aero, el texto suele contar con sutiles sombras de resplandor para garantizar legibilidad contra fondos de cristal o degradados claros:

* **Text Glow (Sobre fondos de cristal/degradados de cielo):**
  ```css
  text-shadow: 0 1px 2px rgba(255, 255, 255, 0.8), 0 0 6px rgba(255, 255, 255, 0.5);
  color: #1a3248;
  ```
* **Texto Inset / Grabado (En superficies sólidas o barras de herramientas metálicas/plásticas pulidas):**
  ```css
  color: #2b3b4c;
  text-shadow: 0 1px 0 rgba(255, 255, 255, 0.9);
  ```

---

## 4. Skeuomorfismo y Anatomía Visual de Componentes

### 4.1 La Técnica del Doble Brillo ("Specular Split Highlight")
El sello indiscutible del acabado Frutiger Aero es el reflejo con corte horizontal o elíptico en la mitad superior de contenedores y botones:
* **Construcción:** La mitad superior (0% a 50%) cuenta con un gradiente blanco translúcido (`rgba(255, 255, 255, 0.6)` a `rgba(255, 255, 255, 0.15)`).
* En el 50.1%, ocurre un salto visual brusco a un tono base más saturado, imitando la refracción de una gota de resina o una cápsula acrílica pulida.

### 4.2 Botones y Estados de Interacción

| Estado | Tratamiento Visual | Comportamiento |
| :--- | :--- | :--- |
| **Default** | Bisel visible, gradiente en 2 etapas, borde exterior oscuro con borde interior blanco (`box-shadow: inset 0 1px ...`). | Apariencia sólida y lustrosa. |
| **Hover** | Incremento de saturación (+15%), halo externo de resplandor (`box-shadow: 0 0 12px rgba(0, 229, 255, 0.7)`), animación de destello lineal. | Se siente reactivo y con energía interna. |
| **Active / Pressed** | Gradiente invertido (más oscuro arriba, claro abajo), sombra interior (`inset 0 3px 5px rgba(0,0,0,0.35)`), desplazamiento de 1px hacia abajo. | Sensación de compresión mecánica real. |
| **Disabled** | Opacidad 50%, gradiente monocromático plateado mate (`#e0e0e0` a `#bcbcbc`), sin destellos ni sombras. | Superficie inerte sin luz. |

### 4.3 Campos de Entrada (Inputs, Textareas, Selects)
* **Forma:** Esquinas suavemente redondeadas (`border-radius: 4px` a `6px`).
* **Fondo:** Blanco brillante con sutil degradado descendente (sombra interior leve en el borde superior: `inset 0 1px 3px rgba(0,0,0,0.2)`).
* **Foco:** Borde coloreado en cian brillante con resplandor pulsante suave:
  ```css
  border-color: #00a3e0;
  box-shadow: 0 0 8px rgba(0, 163, 224, 0.6), inset 0 1px 1px rgba(0,0,0,0.1);
  ```

### 4.4 Iconografía Frutiger Aero
Los iconos no son glifos planos vectoriales mono-línea; son objetos 3D renderizados con micro-detalles:
* **Perspectiva:** Proyección axonométrica isométrica o vista frontal con ángulo de 15° hacia abajo.
* **Texturas y Materiales:**
  * Metales cromados pulidos con reflejos de horizonte cielo/tierra.
  * Vidrio con burbujas de aire internas y cáusticas de refracción.
  * Hojas verdes naturales con gotas de rocío hiperdetalladas.
  * Discos compactos (CD/DVD) con reflejos holográficos arcoíris.
* **Iluminación:** Fuente de luz universal ubicada en la esquina superior izquierda (`10:30 AM`), produciendo sombras arrojadas suaves hacia abajo a la derecha.

---

## 5. Microinteracciones, Física y Animación

Las animaciones Frutiger Aero no son secas ni puramente utilitarias; simulan fluidos incompresibles, rebote elástico orgánico y luminosidad reactiva.

### 5.1 Fórmulas de Transición y Curvas de Aceleración
* **Rebote Elástico (Componentes flotantes, diálogos modales):**
  ```css
  cubic-bezier(0.34, 1.56, 0.64, 1) /* Overshoot orgánico */
  ```
* **Fluidez Acuática (Transiciones de hover y apertura de menús):**
  ```css
  cubic-bezier(0.25, 0.8, 0.25, 1)
  ```
* **Duración promedio:** 250ms a 400ms. Evitar animaciones ultrarrápidas (<150ms) que eliminan la sensación de masa y lustre.

### 5.2 Efectos Dinámicos Característicos
1. **Shimmer / Rayo de Luz en Hover:** Un gradiente lineal diagonal semitransparente que viaja de izquierda a derecha a lo largo del componente al pasar el cursor:
   ```css
   @keyframes fa-shimmer {
     0% { transform: translateX(-100%) rotate(25deg); }
     100% { transform: translateX(200%) rotate(25deg); }
   }
   ```
2. **Ondulaciones de Agua (Water Ripples):** Al presionar botones principales o hacer tap en móvil, emitir una onda expansiva translúcida concéntrica.
3. **Pulsación de "Respiración" (Aero Breathe):** Botones en estado primario o llamadas de atención que aumentan y reducen suavemente el radio de su `box-shadow` lumínico en un ciclo sinusoidal de 3 segundos.

---

## 6. Adaptación por Plataformas: Desktop, Web y Mobile

### 6.1 Desktop (Windows, macOS, Linux Apps)
* **Barra de Título y Ventanas:**
  * Uso intensivo de cromo acrílico translúcido en la barra superior y bordes laterales.
  * Botones de control de ventana con acabado de semáforo de caramelo brillante (rojo, amarillo, verde o el clásico botón azul/rojo con bisel de cristal de Vista/7).
* **Barras de Estado y Menús:**
  * Gradientes metálicos sutiles con textura de aluminio cepillado suave o acrílico ahumado.
  * Separadores en bajorrelieve (línea blanca inferior con línea gris oscura superior: `1px solid #c0c0c0; box-shadow: 0 1px 0 #ffffff;`).

### 6.2 Web (Sitios Web, Web Apps, Paneles SaaS)
* **Optimización de Rendimiento (`backdrop-filter`):**
  * El desenfoque en tiempo real es costoso en hardware modesto. Aplicar `backdrop-filter: blur()` únicamente en barras de navegación pegajosas (`sticky/fixed`) y modales.
  * Para fondos complejos, utilizar archivos WebP/AVIF pre-renderizados con la composición fotográfica de césped/cielo y aplicar paneles de cristal CSS por encima.
* **Layouts Estructurados:**
  * Contenedores con márgenes generosos, tarjetas elevadas con sombras compuestas multidireccionales (`0 4px 6px rgba(0,0,0,0.1), 0 10px 25px rgba(0,70,120,0.15)`).

### 6.3 Mobile (iOS & Android / PWA)
* **Touch Targets y Ergonomía:**
  * Mínimo de 48x48 dp para todos los controles táctiles.
  * En mobile, las texturas skeumórficas deben equilibrarse con alta legibilidad bajo luz solar directa: incrementar el contraste del texto sobre cristales (`font-weight: 600`).
* **Barras de Navegación Inferiores (Dock Style):**
  * Estilo repisa de cristal o dock translúcido con reflejos especulares en la base de la pantalla, emulando los docks clásicos de Mac OS X Leopard o iOS 4-6.

---

## 7. Biblioteca de Recursos Gráficos y Assets

Para construir una interfaz Frutiger Aero coherente, el diseñador debe disponer o crear los siguientes paquetes de assets:

1. **Texturas y Patrones:**
   * Textura de burbujas flotantes en canal alfa (.PNG transparente o .SVG).
   * Destellos de lente (*lens flares*) radiales y anamórficos limpios (sin grano ni distorsión grunge).
   * Fondos panorámicos de alta definición: colinas verdes onduladas (estilo Bliss), nubes cúmulo en cielo azul zafiro, superficies de agua con cáusticas de luz de piscina.
2. **Efectos de Cursor y Sonidos UI:**
   * Cursors translúcidos con colas suaves o animación de reloj de arena / círculo giratorio acuático.
   * Efectos sonoros orgánicos: clics de gotas de agua ("droplet pop"), campanas cristalinas (*wind chimes* tenues) en notificaciones, soplos de viento suave en transiciones.

---

## 8. Anti-Patrones: Qué EVITAR Absolutamente

Para no romper la estética ni degradar la experiencia de usuario:

* ❌ **Flat Design / Minimalismo Monocromático:** Prohibido el uso de rectángulos planos de un solo color sólido sin sombras ni gradientes.
* ❌ **Neumorfismo puro (Soft UI monótono):** El neumorfismo suele ser gris, opaco y plano; Frutiger Aero es vibrante, translúcido, brillante y policromático.
* ❌ **Cyberpunk / Dark Grunge:** Cero cables oxidados, glitch art, grano sucio, aberración cromática agresiva o interfaces nocturnas distópicas. Frutiger Aero es limpio, ecológico y optimista.
* ❌ **Bordes completamente afilados (0px) o hiper-redondeados sin jerarquía:** Todos los rectángulos deben tener filetes suaves de radio (`4px` a `12px`), salvo los botones tipo píldora.
* ❌ **Tipografías Monoespaciadas o Serifas Clásicas en UI General:** Evitar tipografías mecánicas tipo terminal de comandos o tipografías de imprenta antigua (Times New Roman) en elementos de control.

---

## 9. Checklist de Aprobación para Diseñadores (QA Checklist)

Antes de entregar pantallas a desarrollo o validar un flujo, verificar:

- [ ] **Luz Coherente:** ¿Todos los reflejos y sombras provienen de la misma dirección cenital/superior izquierda?
- [ ] **Efecto de Cristal Legible:** ¿Los textos sobre paneles translúcidos cumplen con ratio de contraste WCAG AA (mínimo 4.5:1) mediante sombreado o tinte de fondo?
- [ ] **Bisel y Profundidad:** ¿Cada botón o elemento cliqueable aparenta tener relieve físico que invite a ser presionado?
- [ ] **Paleta Biófila:** ¿Existe presencia armónica de tonos celestes, acuáticos y verdes naturales?
- [ ] **Detalle en Hover:** ¿Cada elemento interactivo reacciona con un incremento de luminosidad o resplandor acuático?
