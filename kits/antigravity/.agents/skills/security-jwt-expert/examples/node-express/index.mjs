/**
 * Ejemplo Express: emisión y verificación JWT (RS256) + buenas prácticas.
 * - Fija algoritmos permitidos
 * - Valida iss/aud/exp
 * - Evita enviar tokens en querystring
 *
 * Requisitos: npm i jsonwebtoken
 */
import fs from "node:fs";
import express from "express";
import jwt from "jsonwebtoken";

const app = express();
app.use(express.json());

const ISSUER = "https://auth.tu-dominio.com";
const AUDIENCE = "https://api.tu-dominio.com";
const PRIVATE_KEY = fs.readFileSync("./private.pem");
const PUBLIC_KEY = fs.readFileSync("./public.pem");

function signAccessToken({ sub, scope, tenant_id }) {
  return jwt.sign(
    { sub, scope, tenant_id },
    PRIVATE_KEY,
    {
      algorithm: "RS256",
      expiresIn: "10m",
      issuer: ISSUER,
      audience: AUDIENCE,
      // jti debería ser único por token si quieres revocación/anti-replay
    }
  );
}

function authMiddleware(req, res, next) {
  const auth = req.headers.authorization || "";
  const token = auth.startsWith("Bearer ") ? auth.slice(7) : null;
  if (!token) return res.status(401).json({ error: "missing_token" });

  try {
    const payload = jwt.verify(token, PUBLIC_KEY, {
      algorithms: ["RS256"],
      issuer: ISSUER,
      audience: AUDIENCE,
      clockTolerance: 60, // skew
    });

    // Autorización real: verifica scope/permissions según endpoint
    req.user = payload;
    next();
  } catch (e) {
    return res.status(401).json({ error: "invalid_token" });
  }
}

app.post("/login", (req, res) => {
  // Validar credenciales + MFA + rate limiting
  const token = signAccessToken({ sub: "user_123", scope: "read:orders", tenant_id: "t_1" });
  res.json({ access_token: token, token_type: "Bearer", expires_in: 600 });
});

app.get("/me", authMiddleware, (req, res) => {
  res.json({ sub: req.user.sub, scope: req.user.scope, tenant_id: req.user.tenant_id });
});

app.listen(3000, () => console.log("API on :3000"));
