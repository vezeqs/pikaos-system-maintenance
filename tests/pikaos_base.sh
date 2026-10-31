#!/usr/bin/env bash
set -euo pipefail

repo=$(cd "$(dirname "$0")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

printf 'ID=pika\nID_LIKE=debian\nVERSION_ID="4.0"\nNAME="PikaOS"\n' > "$tmp/os-release"

out=$(podman run --rm -v "$repo:/repo:ro,Z" -v "$tmp/os-release:/etc/os-release:ro,Z" \
  ghcr.io/pikaos-linux/pika-base-debian-container:latest \
  bash /repo/pikaos-system-maintenance.sh -y --dry-run 2>&1)

grep -q 'PikaOS repository is configured' <<<"$out"
grep -q 'PikaOS keyring is present' <<<"$out"
if grep -q 'does not look like PikaOS' <<<"$out"; then
  echo "ID=pika was rejected" >&2
  exit 1
fi

echo "ok PikaOS base container"
