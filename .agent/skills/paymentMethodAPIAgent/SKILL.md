---
name: Estilo de Proyecto PaymentMethodAPI
description: Reglas de arquitectura, convenciones de nomenclatura y patrones de diseño para el proyecto PaymentMethodAPI.
---

# Proyecto PaymentMethodAPI - Guía de Estilo y Arquitectura

Esta habilidad (skill) define las reglas estrictas y los patrones específicos que deben ser leídos y seguidos como contexto obligatorio cada vez que se te pida escribir o refactorizar código en este proyecto.

## 1. Arquitectura General
- **Framework base:** ServiceStack (los servicios heredan de `LeapfactorService`).
- **Inyección de Dependencias (DI):** Se utiliza StructureMap. Toda nueva dependencia debe registrarse en la configuración del contenedor en `AppHost.cs`.
- **Persistencia de Datos:** Se utiliza RavenDB (NoSQL). El acceso a datos se maneja a través de un patrón de Unit of Work y Repositorios (DAOs).

## 2. Patrones de Diseño de Capas
- **Capa de Servicios de API (`Services/`):**
  - Exponen los endpoints en clases que heredan de `LeapfactorService`.
  - Protegidos con atributos como `[NumiAuthorization]`.
  - Los métodos gestionan los verbos HTTP (`Get`, `Post`, `Put`, `Delete`).
  - Intercambian DTOs (`Request` y `Response` definidos en la carpeta `Contracts`).
- **Capa de Acceso a Datos (`Persistance/`):**
  - Implementada mediante DAOs (Data Access Objects) que heredan de `DAO<T>` o emplean un `IUnitOfWorkFactory`.
  - Las transacciones con RavenDB deben estar rodeadas de un bloque `using (var uow = _unitOfWorkFactory.GetUnitOfWork())`.
  - Persisten objetos de tipo Vista/Modelo (ej. `PaymentMethodView`).
- **Capa de Negocios (`Business/` y `Manager/`):**
  - La lógica principal (validación, procesamiento) no debe recidir en los controladores asíncronos sino en clases como Managers (ej. `PaymentMethodManager`) o Validadores (ej. `CardValidator`).
- **Integraciones (`Integration/` y `Connected Services/`):**
  - La comunicación con sistemas externos (ej. TabaPay, Plaid) se abstrae usando Proveedores/Servicios propios (ej. `ITabaPayProvider`).

## 3. Manejo de Estado
- Los servicios son **stateless** (sin estado local). 
- Todo el manejo transaccional de escritura a la base de datos se consolida guardando los cambios del Unit of Work al finalizar la interacción: `uow.Session.SaveChanges()`.

## 4. Convenciones de Nomenclatura
- **Interfaces:** PascalCase prefijado por `I` (ej. `IUnitOfWorkFactory`, `IPaymentMethodDAO`).
- **Clases, Métodos y Propiedades Públicas:** PascalCase (ej. `GetPaymentMethodResponse`, `PaymentMethodService`).
- **Campos privados (y dependencias inyectadas):** camelCase con el prefijo guion bajo `_` (ej. `_paymentMethodDao`, `_log`, `_settings`).
- **Parámetros y variables locales:** camelCase (ej. `request`, `paymentMethodId`).

## 5. Estilo General del Código
- **Logging:** Utilizar la dependencia inyectada de tipada abstracta `ILog` (implementación de NumiLogManager). Formato sugerido al inicio de métodos clave: `_log.Debug($"Namespace.Clase.Metodo {JsonConvert.SerializeObject(request)}")`.
- **Manejo de Errores y Respuestas:** En flujos de negocio comunes no se recomienda soltar excepciones rudas. Los servicios de ServiceStack típicamente construyen una respuesta que contiene una bandera de estado (ej. `Status = ResultStatus.Failed`).
- **Eventos de Dominio:** Usar `IEventsEmitter` para disparar eventos asíncronos de negocio paralelos (ej. `_eventsEmitter.PaymentMethodCreated(paymentMethod)`).
- **Refactorización e Implementación:** No mezclar inyección de componentes nuevos; en su lugar, respetar la segregación de interfaces del proyecto y agregar cualquier dependencia nueva en el contenedor central de `AppHost.cs`.
