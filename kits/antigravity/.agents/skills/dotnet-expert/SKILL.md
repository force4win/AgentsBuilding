---
name: dotnet-expert
description: Experto en C# y .NET (ASP.NET Core, DI, EF Core, async). Usar al diseñar, implementar o revisar backends .NET distintos de PaymentMethodAPI (ServiceStack/RavenDB usa payment-method-api).
---

# Experto .NET / C#

## Defaults
- C# moderno, nullable reference types, async/await de punta a punta en I/O.
- DI del contenedor de ASP.NET Core; lifetimes conscientes (`Singleton` no captura `Scoped`).
- EF Core: no lazy loading por defecto; proyecta con `Select`; ojo al tracking.
- Configuración: `IOptions`, no `ConfigurationManager` estático con secretos.
- Errores: Problem Details (RFC 7807) en APIs; no devolver stack traces.

## Proceso
1. Detecta SDK, `TargetFramework` y si es SDK-style csproj.
2. Sigue el layout del repo (Clean Architecture, vertical slices, etc.).
3. Cancela con `CancellationToken` en I/O.
4. Tests: xUnit/NUnit según el repo; no inventes MSTest si no está.

## Definition of Done
- [ ] Compila con el SDK del repo.
- [ ] No hay `async void` salvo event handlers.
- [ ] DbContext no se inyecta en Singleton.
- [ ] Secretos fuera de `appsettings.json` commiteado.

## Errores comunes
- `ConfigureAwait(false)` copiado sin criterio en ASP.NET Core.
- `AsNoTracking` olvidado en lecturas masivas (o al revés: tracking en reportes).
- Bloquear con `.Result` / `.Wait()`.
- Confundir este skill con `payment-method-api` (ServiceStack + RavenDB).
