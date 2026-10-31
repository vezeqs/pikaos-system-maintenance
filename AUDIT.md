# Audit — 2026-10-30

Scope: `pikaos-system-maintenance.sh`, `README.md`, `assets/`, plus the tests and
CI added by this audit.

Baseline before changes:

```console
$ bash -n pikaos-system-maintenance.sh
(no output, pass)
$ shellcheck -x -S warning pikaos-system-maintenance.sh
(no output, rc=0)
$ make check
make: *** No rule to make target 'check'.  Stop.
```

History read: `4f68454` initial release. Pull requests: none. There is no
`origin` remote, so `gh pr list` has nothing to read.

Findings: 6 (6 fixed, 1 of them not reproduced).

## F1 — PikaOS reports ID=pika, the script demanded pikaos (High)

**Claim:** the script warns only when it is not running on PikaOS.
**Evidence:** PikaOS compatibility scripts normalize `pika` to `pikaos`
(`DISTRO=$(echo "$ID" | tr ...); if [ "$DISTRO" = "pika" ]; then
DISTRO="pikaos"`). The script compared `${ID}` to `pikaos` with `!=`, so every
real PikaOS machine would get "This does not look like PikaOS".
**Cause:** the check assumed the marketing name is the `ID`.
**Fix:** accept both `pika` and `pikaos`. `tests/identity.sh` fails if the
equality check returns.
**Status:** fixed, test `tests/identity.sh`.

## F2 — The keyring is a file, not a package (High)

**Claim:** the script checks that the PikaOS keyring is installed.
**Evidence:** PikaOS `setup.sh` downloads
`/etc/apt/keyrings/pika-keyring.gpg.key` and points `Signed-By` at it. The
DistroWatch PikaOS package list contains no `pika-keyring` package.
**Cause:** the check assumed a package name.
**Fix:** check the keyring file, with the package as a fallback.
`tests/identity.sh` pins the path.
**Status:** fixed, test `tests/identity.sh`.

## F3 — dpkg configure can prompt in --yes mode (Medium, suspected)

**Evidence:** `apt-get` calls pass `--force-confdef --force-confold`, but
`dpkg --configure -a` did not. dpkg's conffile prompt is not debconf, so
`DEBIAN_FRONTEND=noninteractive` does not suppress it.
**Status:** suspected. A half-configured package with a modified conffile was
not built as a fixture. Fixed defensively by passing the same two flags to
dpkg; not runtime-reproduced.

## F4 — No tests, CI or Makefile (Medium)

**Evidence:** `ls Makefile tests` returned nothing.
**Fix:** `Makefile`, `tests/`, and a GitHub Actions check workflow.
**Status:** fixed, `make check` passes.

## F5 — README repeated the wrong keyring claim (Low)

**Evidence:** the README said `pika-keyring` was a package and that the script
checks it. Both were wrong.
**Fix:** README now names the keyring file and the `pika`/`pikaos` IDs.
**Status:** fixed, test `tests/docs.sh` and `tests/identity.sh`.

## F6 — README had no way to verify its claims (Low)

**Fix:** added "Verify it yourself" and "Limits".
**Status:** fixed, test `tests/docs.sh`.
