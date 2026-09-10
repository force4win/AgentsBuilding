# Development Policy: Late Testing (Always On)
Description: Prioritizes feature completion and structural integrity over early testing.

## Rules
1. **No Early Tests**: No escribas tests unitarios o de integración durante la fase inicial de una feature de negocio.
2. **Compilation Focus**: En implementación, la validación mínima es que el código **compile y sea sintácticamente correcto**.
3. **Refactoring Tolerance**: La estructura puede ser fluida durante el primer 80% del proyecto.
4. **Final Testing Phase**: Los tests de negocio se escriben cuando la funcionalidad núcleo está estable y el roadmap está ~90% completo.
5. **Excepción de seguridad:** Sí escribe tests cuando el cambio cubre autenticación, autorización, JWT, validación de entrada o control de acceso. Esos tests no se postergan.
