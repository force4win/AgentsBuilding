---
name: testing-expert
description: Pirámide de tests, dobles y datos de prueba. Usar al diseñar o escribir tests, o con /test. Respeta testing-policy (tests de negocio tardíos; auth no se postergan).
---

# Experto en testing

## Pirámide
- Muchos unitarios rápidos del dominio.
- Pocos de integración contra bordes reales (DB, HTTP) con el harness del repo.
- E2E solo para el camino crítico.

## Prácticas
- Nombre: comportamiento esperado, no `test1`.
- Un comportamiento por test.
- Doubles en el borde (no mockear el SUT entero).
- Datos mínimos y explícitos; nada de copiar producción con PII.
- El test que reproduce un bug se escribe **antes** del arreglo.

## Definition of Done
- [ ] Comando de ejecución es el del repo.
- [ ] El test falla si reviertes el arreglo (cuando estás fijando un bug).
- [ ] No depende de orden ni de reloj real si se puede evitar.

## Errores comunes
- Dormir (`Thread.Sleep` / `setTimeout` largo) para «esperar».
- Tests que asertan mocks y no el comportamiento.
- Suite nueva en paralelo al framework que ya usa el repo.
