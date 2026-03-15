# Desktop UI Development in Go

## Wails (Go + Web)
- **Choice**: Best for modern, rich UIs using web technologies (React, Vue, Angular, Svelte).
- **Architecture**:
  - `main.go`: Application initialization.
  - `app.go`: Methods exported to the frontend.
  - `frontend/`: Web project (JS/TS/CSS).
- **Communication**: Use `runtime.EventsEmit` and `runtime.EventsOn` for bi-directional messaging or call bound methods directly from JS.
- **Packaging**: Use `wails build` for cross-platform executables.
- **Optimization**: Minify assets and use WebGL for graphics-heavy apps.

## Fyne (Native Go UI)
- **Choice**: Best for native apps without web overhead, or when you want 100% Go logic.
- **Layouts**: Use `container.NewVBox`, `container.NewGridWithColumns`.
- **Widgets**: `widget.NewButton`, `widget.NewLabel`, `widget.NewEntry`.
- **Styling**: Limited to Fyne's theme engine, but customizable via custom themes.
- **Lifecycle**: `myApp.Run()` blocks; use goroutines for background tasks and `canvas.Refresh()` to update UI.

## Gio (Immediate Mode)
- **Choice**: Advanced graphics, games, or high-performance UIs.
- **Concept**: Immediate mode GUI (re-drawn every frame).
- **Best for**: Performance-critical desktop/mobile apps.
