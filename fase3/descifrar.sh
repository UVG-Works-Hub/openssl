#!/bin/bash
#
# descifrar.sh
#
# This script:
#   1) Decrypts an AES key (aes_key_cifrada.bin) with an RSA private key.
#   2) Decrypts the message (mensaje_cifrado.bin) using the now-decrypted AES key.
#
# Usage:
#   1) Make sure you have openssl installed.
#   2) Place this script in the same directory as your .pem keys and .bin files.
#   3) chmod +x descifrar.sh
#   4) ./descifrar.sh
#

# ----- CONFIGURABLE FILE NAMES -----
# CAMBIAR ACA
PRIVATE_KEY="diego_privado.pem"              # TODO: Cambiar esta
AES_KEY_ENCRYPTED="aes_key_diego_cifrada.bin"      # TODO: Cambiar esta
AES_KEY_DECRYPTED="aes_key_diego_descifrada.txt"   # TODO: Cambiar esta
MESSAGE_ENCRYPTED="mensaje_cifrado.bin"
MESSAGE_DECRYPTED="diego_descifrado.txt"   # TODO: Cambiar esta

# ----- STEP 1: Decrypt the AES key with the RSA private key -----
echo "1) Decrypting AES key with RSA private key..."
openssl rsautl -decrypt \
  -inkey "../fase1/${PRIVATE_KEY}" \
  -in "../fase2/${AES_KEY_ENCRYPTED}" \
  -out "${AES_KEY_DECRYPTED}"

if [ $? -ne 0 ]; then
  echo "Error: Failed to decrypt AES key."
  exit 1
fi
echo "   Done. AES key written to ${AES_KEY_DECRYPTED}"

# ----- STEP 2: Decrypt the message using the decrypted AES key -----
echo "2) Decrypting the message with AES key..."
openssl enc -aes-256-cbc -d \
  -in "../fase2/${MESSAGE_ENCRYPTED}" \
  -out "${MESSAGE_DECRYPTED}" \
  -pass file:"${AES_KEY_DECRYPTED}"

if [ $? -ne 0 ]; then
  echo "Error: Failed to decrypt message."
  exit 1
fi

echo "   Done. Decrypted message is in ${MESSAGE_DECRYPTED}"
