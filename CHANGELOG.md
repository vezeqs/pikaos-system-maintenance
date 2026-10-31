# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.2] - 2026-10-30

### Fixed
- Fixed: a failed Flatpak update check is now reported instead of printed as zero apps.

## [0.1.1] - 2026-10-30

### Fixed
- PikaOS reports `ID=pika`; the script only accepted `pikaos`, so it warned on
  every real PikaOS run. It now accepts both.
- The keyring check looked for a `pika-keyring` package. PikaOS installs
  `/etc/apt/keyrings/pika-keyring.gpg.key`, and that package is not in the
  PikaOS package list, so the check warned on every real run. It now checks the
  file, with the package as a fallback.
- `dpkg --configure -a` now gets `--force-confdef --force-confold`, matching the
  apt calls. This is hardening: conffile prompts happen at unpack, not at
  configure, so it was not a reproduced bug.

### Added
- `Makefile`, `tests/` and a GitHub Actions check workflow.
- `tests/identity.sh` pins the `pika`/`pikaos` IDs and the keyring path.
- README sections for verification and limits.

## [0.1.0] - 2026-10-30

### Added
- Initial release for PikaOS (Debian Sid based).
- Checks that the pika-os.com apt source and `pika-keyring` are present, warning instead of failing.
- Preview of the apt full-upgrade, autoremove and Flatpak updates before the confirmation prompt.
- Repair steps: `dpkg --configure -a` and `apt-get --fix-broken install`.
- Full upgrade, Flatpak update, `autoremove --purge`, `autoclean`.
- Reboot detection through `/var/run/reboot-required`.
- `-y/--yes`, `-n/--dry-run` and `-h/--help`.
