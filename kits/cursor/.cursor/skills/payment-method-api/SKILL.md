---
name: payment-method-api
description: Estilo y arquitectura del proyecto PaymentMethodAPI (ServiceStack, RavenDB, StructureMap). Usar al escribir o refactorizar código de ese dominio de métodos de pago.
---

# Proyecto PaymentMethodAPI - Guía de Estilo y Arquitectura

Esta habilidad define las reglas y patrones que deben seguirse al escribir o refactorizar código de PaymentMethodAPI.

## 1. Arquitectura General
- **Framework base:** ServiceStack (los servicios heredan de `LeapfactorService`).
- **Inyección de Dependencias (DI):** StructureMap. Toda nueva dependencia se registra en `AppHost.cs`.
- **Persistencia:** RavenDB (NoSQL) con Unit of Work y repositorios (DAOs).

## 2. Patrones de Diseño de Capas
- **Capa de Servicios de API (`Services/`):**
  - Exponen los endpoints en clases que heredan de `LeapfactorService`.
  - Protegidos con atributos como `[NumiAuthorization]`.
  - Los métodos gestionan los verbos HTTP (`Get`, `Post`, `Put`, `Delete`).
  - Intercambian DTOs (`Request` y `Response` en `Contracts`).
- **Capa de Acceso a Datos (`Persistance/`):**
  - DAOs que heredan de `DAO<T>` o usan `IUnitOfWorkFactory`.
  - Transacciones RavenDB dentro de `using (var uow = _unitOfWorkFactory.GetUnitOfWork())`.
  - Persisten objetos Vista/Modelo (ej. `PaymentMethodView`).
- **Capa de Negocios (`Business/` y `Manager/`):**
  - La lógica (validación, procesamiento) vive en Managers (ej. `PaymentMethodManager`) o Validadores (ej. `CardValidator`), no en controladores asíncronos.
- **Integraciones (`Integration/` y `Connected Services/`):**
  - Comunicación con terceros (TabaPay, Plaid) en componentes dedicados.
  - **Providers (`*Provider`):** conectividad con la API de un tercero (ej. `ITabaPayProvider`). Van en `Integration/Providers/` y se registran en el IoC.
  - Sin lógica de negocio principal en los Providers: formatear, enviar y recibir datos.

## 3. Ubicación de Objetos
- **API (`Services/`):**
  - Requests en `Contracts/Requests/` (o `Legacy/Requests/`).
  - Responses en `Contracts/Responses/` (o `Legacy/Responses/`), con enumeradores de estado (ej. `Status = ResultStatus.Succeeded`).
- **Negocio (`Business/` y `Manager/`):**
  - Tipos primitivos, enumeradores o modelos de dominio (`Contracts/Model/`).
  - Resultados complejos como *Result* en el mismo sub-namespace (ej. `CardValidationResult.cs` en `Business/`). Nunca reutilizar Requests/Responses del API de Front.
- **Persistencia (`Persistance/`):**
  - Entidades tipo Vista solo en `Views/` (ej. `PaymentMethodView.cs`).

## 4. Manejo de Estado
- Servicios **stateless**.
- Escritura consolidada al final: `uow.Session.SaveChanges()`.

## 5. Convenciones de Nomenclatura
- **Interfaces:** PascalCase con prefijo `I` (ej. `IUnitOfWorkFactory`).
- **Clases, métodos y propiedades públicas:** PascalCase.
- **Campos privados:** camelCase con `_` (ej. `_paymentMethodDao`).
- **Parámetros y locales:** camelCase.

## 6. Estilo General
- **Logging:** `ILog` inyectado. Formato al inicio de métodos clave: `_log.Debug($"Namespace.Clase.Metodo {JsonConvert.SerializeObject(request)}")`.
- **Errores:** en flujos comunes, respuesta con flag de estado; no excepciones crudas.
- **Eventos:** `IEventsEmitter` para eventos asíncronos.
- **DI:** cualquier inyección nueva se registra en `AppHost.cs`.

## Definition of Done
- [ ] Capas respetadas (Service / Manager / DAO / Provider).
- [ ] DI registrada en `AppHost.cs`.
- [ ] `SaveChanges` al cerrar el UoW de escritura.

## Errores comunes
- Lógica de negocio en el Provider.
- Usar Request/Response de API dentro de Business.
- Transacción RavenDB sin `using` de UoW.
