# OAuth2 / OIDC vs “usar JWT”

- OAuth2 es un marco de autorización (scopes, grants).
- OIDC añade identidad (ID token) sobre OAuth2.
- JWT es un formato de token (puede ser access token, ID token, etc.)

Buenas prácticas:
- Si hay SSO / terceros: usar OIDC/OAuth2.
- Los access tokens pueden ser JWT, pero no es obligatorio.
- Separar “identidad” (ID token) de “autorización” (access token).
