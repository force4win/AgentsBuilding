"""Ejemplo FastAPI: verificación JWT RS256 con PyJWT.

Requisitos:
  pip install fastapi uvicorn pyjwt[crypto]

Ejecutar:
  uvicorn main:app --reload
"""
from __future__ import annotations
import os
from fastapi import FastAPI, Depends, HTTPException, Header
import jwt

ISSUER = os.getenv("JWT_ISSUER", "https://auth.tu-dominio.com")
AUDIENCE = os.getenv("JWT_AUDIENCE", "https://api.tu-dominio.com")
PUBLIC_KEY_PATH = os.getenv("JWT_PUBLIC_KEY", "./public.pem")

with open(PUBLIC_KEY_PATH, "rb") as f:
    PUBLIC_KEY = f.read()

app = FastAPI()

def require_user(authorization: str = Header(default="")):
    if not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="missing_token")
    token = authorization.split(" ", 1)[1]

    try:
        payload = jwt.decode(
            token,
            PUBLIC_KEY,
            algorithms=["RS256"],
            issuer=ISSUER,
            audience=AUDIENCE,
            options={
                "require": ["exp", "iss", "aud", "sub"],
                "verify_iat": False,
            },
            leeway=60,
        )
    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="token_expired")
    except Exception:
        raise HTTPException(status_code=401, detail="invalid_token")

    # Autorización real por scope/permissions:
    # if "read:orders" not in payload.get("scope","").split():
    #     raise HTTPException(status_code=403, detail="insufficient_scope")

    return payload

@app.get("/me")
def me(user=Depends(require_user)):
    return {"sub": user.get("sub"), "aud": user.get("aud"), "scope": user.get("scope")}
