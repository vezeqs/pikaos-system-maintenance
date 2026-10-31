#!/usr/bin/env bash
set -euo pipefail
repo=$(cd "$(dirname "$0")/.." && pwd)
mock=$(mktemp -d); trap 'rm -rf "$mock"' EXIT
cat > "$mock/flatpak" <<'MOCK'
#!/usr/bin/env bash
case "$*" in
  *remote-ls*) echo "no remote configured" >&2; exit 1 ;;
esac
exit 0
MOCK
chmod +x "$mock/flatpak"
out=$(printf 'n\n' | script -qec "podman run --rm -it -v $repo:/repo:ro,Z -v $mock:/mock:ro,Z debian:sid bash -c 'PATH=/mock:\$PATH bash /repo/pikaos-system-maintenance.sh'" /dev/null 2>&1)
grep -q 'Could not check Flatpak updates' <<<"$out"
if grep -q 'Flatpak apps to update: .*0' <<<"$out"; then echo "failed Flatpak preview reported as zero" >&2; exit 1; fi
echo "ok Flatpak preview failure is reported"
