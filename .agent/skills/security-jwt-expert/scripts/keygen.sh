#!/usr/bin/env bash
set -euo pipefail

# Generación de llaves para JWT (defensivo)
#
# Requisitos:
#   - OpenSSL instalado
#
# Uso:
#   bash scripts/keygen.sh rsa   # genera RSA 2048
#   bash scripts/keygen.sh ec    # genera EC P-256
#
# Salida:
#   - private.pem  (mantener en secreto; idealmente KMS/Vault/HSM)
#   - public.pem   (para verificadores / JWKS)

MODE="${1:-rsa}"

if [[ "$MODE" == "rsa" ]]; then
  echo "[INFO] Generando RSA 2048..."
  openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out private.pem
  openssl pkey -in private.pem -pubout -out public.pem
  echo "[OK] RSA listo: private.pem / public.pem"
elif [[ "$MODE" == "ec" ]]; then
  echo "[INFO] Generando EC P-256..."
  openssl ecparam -name prime256v1 -genkey -noout -out private.pem
  openssl ec -in private.pem -pubout -out public.pem
  echo "[OK] EC listo: private.pem / public.pem"
else
  echo "[ERROR] Modo no soportado: $MODE. Usa 'rsa' o 'ec'."
  exit 2
fi

echo
echo "[INFO] Consejo: mueve private.pem a un almacén seguro (KMS/Vault/HSM) y publica solo public.pem/JWKS."
