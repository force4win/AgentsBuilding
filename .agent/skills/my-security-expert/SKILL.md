 ---
name: security-jwt-expert
description: >
  Proporciona experiencia en seguridad de aplicaciones y manejo de JWT (JSON Web Tokens),
  incluyendo generación, validación, almacenamiento seguro, mejores prácticas y defensa
  contra ataques comunes. Use cuando se trabaja en autenticación, autorización o
  revisión de seguridad de APIs y sistemas con tokens.
---

# Seguridad y JWT — Guía del Experto

## 📌 Contexto: ¿Cuándo usar este skill?
- Al diseñar o revisar sistemas de autenticación con JWT.
- Cuando se integran APIs REST, microservices o Single Page Apps (SPA).
- Cuando se requiere mejorar seguridad en flujo de login y control de roles.
- Cuando se revisa código para evitar ataques comunes (XSS, CSRF, replays, token leakage).

## 🧱 Conceptos Fundamentales

### Qué es JWT
1. **JSON Web Token (JWT)**: Token compacto, firmado digitalmente que representa una identidad o permiso.
2. Tiene 3 partes: `header`, `payload` y `signature`.
3. Usos típicos: autenticación sin estado (stateless), autorización entre servicios.

### Componentes
- **Encabezado (Header):** Algoritmo y tipo de token.
- **Carga útil (Payload):** Claims (iss, sub, aud, exp, iat, roles).
- **Firma (Signature):** Firma HMAC o asimétrica para verificar integridad.

## 🔐 Mejores prácticas de seguridad con JWT

### ✔️ Firma y Algoritmos
- Siempre usar **algoritmos seguros**: `RS256` o `ES256` preferidos; evitar `none` o algos débiles.
- Mantener claves privadas en bóvedas seguras y rotar periódicamente.

### ✔️ Validación completa
- Verificar **firma**, **expiración** (`exp`), **emisor** (`iss`), **audiencia** (`aud`), **no antes de (`nbf`)`.
- Implementar **listas de revocación** para tokens que necesitan invalidarse antes de su expiración.

### ✔️ Control de permisos
- No confiar solo en `roles` del JWT; aplicar **verificación de permiso en backend**.
- Los scopes deben ser lo más específicos posible para prevenir escalaciones.

### ✔️ Almacenamiento seguro
- Para **web clients**: usar cookies `HttpOnly` y `Secure`.
- Para SPA/móviles: usar almacenamiento cifrado seguro del dispositivo; evitar almacenamiento local simple.

### ✔️ Evitar ataques comunes
- **XSS**: prevenir mediante políticas CSP, sanitización, protección de cookies.
- **CSRF**: tokens anti-CSRF cuando se envíen JWT en cookies.
- **Replay**: implementar nonces o listas de uso único cuando corresponda.

## 🧰 Tests y Validaciones automáticas

### JWT Unit Tests
- Probar firma inválida, expiración, issuer mismatches y aud mismatches.
- Probar defensa contra tokens manipulados.
- Simular ataques comunes (XSS/CSRF) y validar bloqueo.

## 🧪 Ejemplo de uso de JWT en código

### Node.js — Express con JWT

```js
import jwt from 'jsonwebtoken';

const signToken = (payload, privateKey, options) => {
  return jwt.sign(payload, privateKey, {
    algorithm: 'RS256',
    expiresIn: '15m',
    issuer: 'https://tu-dominio.com',
    audience: 'https://api-v1',
    ...options
  });
};

const verifyToken = (token, publicKey) => {
  try {
    return jwt.verify(token, publicKey, {
      algorithms: ['RS256'],
      issuer: 'https://tu-dominio.com',
      audience: 'https://api-v1'
    });
  } catch (e) {
    throw new Error('Token inválido o expirado');
  }
};