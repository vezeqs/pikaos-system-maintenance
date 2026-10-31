# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-10-30

### Added
- Initial release for PikaOS (Debian Sid based).
- Checks that the pika-os.com apt source and `pika-keyring` are present, warning instead of failing.
- Preview of the apt full-upgrade, autoremove and Flatpak updates before the confirmation prompt.
- Repair steps: `dpkg --configure -a` and `apt-get --fix-broken install`.
- Full upgrade, Flatpak update, `autoremove --purge`, `autoclean`.
- Reboot detection through `/var/run/reboot-required`.
- `-y/--yes`, `-n/--dry-run` and `-h/--help`.
