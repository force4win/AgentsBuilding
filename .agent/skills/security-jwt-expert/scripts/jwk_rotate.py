#!/usr/bin/env python3
"""JWKS generator/rotator (defensivo)

Genera un archivo JWKS (JSON Web Key Set) a partir de una llave pública RSA o EC PEM.
Asigna `kid` determinista (hash corto) para facilitar rotación.

Requisitos:
- Este script NO genera llaves; para eso usa `scripts/keygen.sh` (OpenSSL).
- Verificación/parseo de PEM requiere 'cryptography'. Si no está, el script explica alternativas.

Uso:
  python scripts/jwk_rotate.py --public-key public.pem --out jwks.json --use sig --alg RS256
  python scripts/jwk_rotate.py --public-key ec_public.pem --out jwks.json --use sig --alg ES256

Notas:
- En producción, considera que el emisor publique JWKS en una URL estable y cacheable.
- Mantén al menos 2 claves activas durante transición (actual + anterior).
"""
from __future__ import annotations
import argparse, base64, hashlib, json, sys
from typing import Dict, Any

def b64u(b: bytes) -> str:
    return base64.urlsafe_b64encode(b).rstrip(b"=").decode("ascii")

def kid_from_jwk(jwk: Dict[str, Any]) -> str:
    # kid determinista aproximado: hash de campos estables
    material = json.dumps({k: jwk.get(k) for k in sorted(jwk.keys()) if k in {"kty","crv","x","y","n","e"}}, separators=(",",":"), sort_keys=True).encode("utf-8")
    h = hashlib.sha256(material).digest()
    return b64u(h[:12])  # 96-bit

def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--public-key", required=True, help="Ruta a llave pública PEM")
    ap.add_argument("--out", required=True, help="Ruta de salida JWKS (json)")
    ap.add_argument("--use", default="sig", help="Uso (default: sig)")
    ap.add_argument("--alg", required=True, help="Algoritmo (RS256/ES256...)")
    args = ap.parse_args()

    try:
        from cryptography.hazmat.primitives import serialization
        from cryptography.hazmat.primitives.asymmetric import rsa, ec
    except Exception:
        print("[ERROR] Falta dependencia 'cryptography'. Instala con: pip install cryptography", file=sys.stderr)
        print("        Alternativa: genera JWKS con tu KMS/Vault o librería del framework.", file=sys.stderr)
        return 2

    with open(args.public_key, "rb") as f:
        pem = f.read()

    pub = serialization.load_pem_public_key(pem)
    jwk: Dict[str, Any] = {"use": args.use, "alg": args.alg}

    if isinstance(pub, rsa.RSAPublicKey):
        nums = pub.public_numbers()
        jwk.update({
            "kty": "RSA",
            "n": b64u(nums.n.to_bytes((nums.n.bit_length()+7)//8, "big")),
            "e": b64u(nums.e.to_bytes((nums.e.bit_length()+7)//8, "big")),
        })
    elif isinstance(pub, ec.EllipticCurvePublicKey):
        nums = pub.public_numbers()
        crv_map = {
            "secp256r1": "P-256",
            "secp384r1": "P-384",
            "secp521r1": "P-521",
        }
        curve_name = pub.curve.name
        jwk.update({
            "kty": "EC",
            "crv": crv_map.get(curve_name, curve_name),
            "x": b64u(nums.x.to_bytes((nums.x.bit_length()+7)//8, "big")),
            "y": b64u(nums.y.to_bytes((nums.y.bit_length()+7)//8, "big")),
        })
    else:
        print("[ERROR] Tipo de llave pública no soportado.", file=sys.stderr)
        return 2

    jwk["kid"] = kid_from_jwk(jwk)

    jwks = {"keys": [jwk]}
    with open(args.out, "w", encoding="utf-8") as f:
        json.dump(jwks, f, indent=2, ensure_ascii=False, sort_keys=True)

    print(f"[OK] JWKS generado en {args.out}")
    print(f"     kid={jwk['kid']}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
