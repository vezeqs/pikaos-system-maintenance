#!/usr/bin/env bash
set -euo pipefail

script=${1:-./pikaos-system-maintenance.sh}

grep -q 'pika|pikaos' "$script"
grep -q 'pika-keyring.gpg.key' "$script"
if grep -q "ID:-} != pikaos" "$script"; then
  echo "PikaOS reports ID=pika; an equality check against pikaos rejects it" >&2
  exit 1
fi

echo "ok PikaOS identity and keyring path"
