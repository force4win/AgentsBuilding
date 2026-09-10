#!/usr/bin/env python3
"""JWT Inspector (defensivo)

Decodifica un JWT (sin verificar firma por defecto) y emite advertencias de seguridad.
Opcionalmente intenta verificar firma si se proveen llaves y están disponibles librerías.

Uso:
  python scripts/jwt_inspector.py --token <JWT>
  python scripts/jwt_inspector.py --token <JWT> --expected-iss https://issuer --expected-aud api://v1
  python scripts/jwt_inspector.py --token <JWT> --jwks jwks.json     (solo para leer kid/alg y dar hints)
  python scripts/jwt_inspector.py --token <JWT> --public-key pub.pem --alg RS256  (verificación básica si 'cryptography' está disponible)

Notas:
- Este script está pensado para revisión rápida y auditoría local.
- No reemplaza la validación estricta en runtime de tu backend/gateway.
"""

from __future__ import annotations
import argparse
import base64
import json
import sys
import time
from dataclasses import dataclass
from typing import Any, Dict, Optional, Tuple

def _b64url_decode(data: str) -> bytes:
    pad = '=' * (-len(data) % 4)
    return base64.urlsafe_b64decode(data + pad)

def decode_jwt_parts(token: str) -> Tuple[Dict[str, Any], Dict[str, Any], str]:
    parts = token.split('.')
    if len(parts) != 3:
        raise ValueError("Formato inválido: JWT debe tener 3 partes separadas por '.'")
    header_b, payload_b, sig_b = parts
    header = json.loads(_b64url_decode(header_b))
    payload = json.loads(_b64url_decode(payload_b))
    return header, payload, sig_b

def warn(msg: str) -> None:
    print(f"[WARN] {msg}")

def info(msg: str) -> None:
    print(f"[INFO] {msg}")

def ok(msg: str) -> None:
    print(f"[OK] {msg}")

def check_claims(payload: Dict[str, Any], expected_iss: Optional[str], expected_aud: Optional[str], clock_skew: int) -> None:
    now = int(time.time())
    exp = payload.get("exp")
    nbf = payload.get("nbf")
    iat = payload.get("iat")
    iss = payload.get("iss")
    aud = payload.get("aud")

    if exp is None:
        warn("No hay claim 'exp' (expiración). Recomendado: access tokens siempre con expiración corta.")
    else:
        try:
            exp_i = int(exp)
            if now > exp_i + clock_skew:
                warn(f"Token expirado. exp={exp_i}, now={now}, skew={clock_skew}s")
            else:
                ok(f"exp presente y aún válido (considerando skew={clock_skew}s).")
        except Exception:
            warn(f"'exp' no es entero: {exp!r}")

    if nbf is not None:
        try:
            nbf_i = int(nbf)
            if now + clock_skew < nbf_i:
                warn(f"Token aún no es válido por 'nbf'. nbf={nbf_i}, now={now}")
            else:
                ok("nbf presente y consistente (considerando skew).")
        except Exception:
            warn(f"'nbf' no es entero: {nbf!r}")

    if iat is None:
        warn("No hay claim 'iat' (issued at). No es obligatorio, pero útil para auditoría/detección.")
    else:
        try:
            iat_i = int(iat)
            if iat_i > now + clock_skew:
                warn(f"'iat' en el futuro. iat={iat_i}, now={now}")
            else:
                ok("iat presente y consistente (considerando skew).")
        except Exception:
            warn(f"'iat' no es entero: {iat!r}")

    if expected_iss:
        if iss != expected_iss:
            warn(f"issuer mismatch. esperado iss={expected_iss!r}, recibido iss={iss!r}")
        else:
            ok("iss coincide con el esperado.")
    elif iss is None:
        warn("No hay claim 'iss'. Recomendado validar issuer.")

    if expected_aud:
        # aud puede ser str o lista
        aud_ok = False
        if isinstance(aud, str):
            aud_ok = (aud == expected_aud)
        elif isinstance(aud, list):
            aud_ok = (expected_aud in aud)
        if not aud_ok:
            warn(f"audience mismatch. esperado aud contiene {expected_aud!r}, recibido aud={aud!r}")
        else:
            ok("aud coincide con el esperado.")
    elif aud is None:
        warn("No hay claim 'aud'. Recomendado validar audiencia para evitar confusión de tokens.")

    if payload.get("jti") is None:
        warn("No hay 'jti'. Si necesitas revocación o anti-replay, añade jti y valida contra denylist/reuse.")
    if payload.get("sub") is None:
        warn("No hay 'sub'. Identidad del sujeto ausente; evita usar email como sub si puede cambiar.")

def check_header(header: Dict[str, Any]) -> None:
    alg = header.get("alg")
    typ = header.get("typ")
    kid = header.get("kid")

    if alg is None:
        warn("Header sin 'alg'. Esto es sospechoso; el verificador debe fijar algoritmos permitidos.")
    else:
        if alg.lower() == "none":
            warn("alg='none' detectado. Debe rechazarse SIEMPRE.")
        elif alg in {"HS256", "HS384", "HS512"}:
            warn(f"alg={alg} (HMAC). Asegúrate de que el secreto esté bien gestionado y NO se comparta ampliamente.")
        elif alg in {"RS256", "RS384", "RS512", "ES256", "ES384", "ES512"}:
            ok(f"alg={alg} (recomendado). Asegúrate de fijarlo explícitamente en el verificador.")
        else:
            warn(f"alg={alg} no reconocido comúnmente. Verifica soporte y riesgos.")

    if typ and str(typ).upper() not in {"JWT", "AT+JWT"}:
        warn(f"typ={typ!r} no estándar (no necesariamente malo, pero revisa compatibilidad).")

    if kid is None:
        warn("No hay 'kid'. En rotación de llaves (JWKS) es muy útil tener 'kid' estable por clave.")
    else:
        ok("kid presente.")

def load_json(path: str) -> Dict[str, Any]:
    with open(path, "r", encoding="utf-8") as f:
        return json.load(f)

def try_verify(token: str, alg: str, public_key_pem: str, expected_iss: Optional[str], expected_aud: Optional[str]) -> None:
    try:
        import jwt  # PyJWT
    except Exception:
        warn("No se pudo importar PyJWT. Verificación de firma deshabilitada. (pip install pyjwt[crypto])")
        return

    options = {
        "require": [],
        "verify_signature": True,
        "verify_exp": True,
        "verify_nbf": True,
        "verify_iat": False,
        "verify_aud": expected_aud is not None,
        "verify_iss": expected_iss is not None,
    }

    kwargs = {"algorithms": [alg], "options": options}
    if expected_iss:
        kwargs["issuer"] = expected_iss
    if expected_aud:
        kwargs["audience"] = expected_aud

    try:
        with open(public_key_pem, "rb") as f:
            key = f.read()
        decoded = jwt.decode(token, key, **kwargs)
        ok("Firma verificada correctamente con PyJWT.")
        info(f"Claims verificados: {list(decoded.keys())}")
    except Exception as e:
        warn(f"Fallo al verificar firma/claims con PyJWT: {e}")

def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--token", required=True, help="JWT completo (header.payload.signature)")
    ap.add_argument("--expected-iss", help="Issuer esperado (iss)")
    ap.add_argument("--expected-aud", help="Audience esperado (aud)")
    ap.add_argument("--clock-skew", type=int, default=60, help="Tolerancia en segundos para reloj (default: 60)")
    ap.add_argument("--jwks", help="Ruta a jwks.json (para inspección y hints)")
    ap.add_argument("--public-key", help="Ruta a llave pública PEM (para verificación opcional)")
    ap.add_argument("--alg", help="Algoritmo esperado para verificación opcional (RS256/ES256...)")
    args = ap.parse_args()

    try:
        header, payload, sig = decode_jwt_parts(args.token)
    except Exception as e:
        print(f"[ERROR] {e}", file=sys.stderr)
        return 2

    print("=== HEADER ===")
    print(json.dumps(header, indent=2, ensure_ascii=False, sort_keys=True))
    print("\n=== PAYLOAD ===")
    print(json.dumps(payload, indent=2, ensure_ascii=False, sort_keys=True))
    print("\n=== CHECKS ===")
    check_header(header)
    check_claims(payload, args.expected_iss, args.expected_aud, args.clock_skew)

    if args.jwks:
        try:
            jwks = load_json(args.jwks)
            keys = jwks.get("keys", [])
            info(f"JWKS cargado: {len(keys)} claves.")
            kid = header.get("kid")
            if kid:
                matches = [k for k in keys if k.get("kid") == kid]
                if not matches:
                    warn(f"kid={kid!r} no encontrado en JWKS.")
                else:
                    ok(f"kid={kid!r} encontrado en JWKS (posible verificación remota).")
        except Exception as e:
            warn(f"No se pudo leer JWKS: {e}")

    if args.public_key and args.alg:
        info("Intentando verificación opcional de firma (si PyJWT está disponible)...")
        try_verify(args.token, args.alg, args.public_key, args.expected_iss, args.expected_aud)
    elif args.public_key or args.alg:
        warn("Para verificación opcional, provee ambos: --public-key y --alg")

    return 0

if __name__ == "__main__":
    raise SystemExit(main())
