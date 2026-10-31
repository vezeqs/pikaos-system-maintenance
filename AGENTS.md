# AGENTS.md

PikaOS System Maintenance is a single bash script that updates, repairs and
cleans PikaOS, a Debian Sid-based distribution with its own apt repositories,
keyring and Flatpak setup. It prints a preview and changes nothing until the
user answers `y`. There is no build step and no dependency beyond bash and apt.

## Entry points

| Question | File |
| --- | --- |
| The maintenance script | `pikaos-system-maintenance.sh` |
| PikaOS identity/keyring regression test | `tests/identity.sh` |
| Checks | `make check` |
| Screenshots | `assets/preview.png`, `assets/upgrade.png` |

## Invariants

- Nothing mutating runs before the `[y/N]` prompt returns `y`.
- `--dry-run` prints every mutating command and executes none.
- PikaOS is identified by `ID=pika` or `ID=pikaos`; both are valid.
- The PikaOS keyring is the file `/etc/apt/keyrings/pika-keyring.gpg.key`, with
  the `pika-keyring` package as a fallback.
- Config files are kept: apt and dpkg both get `--force-confdef --force-confold`.
- Without `-y`, the script refuses to run when stdin is not a terminal.

## Commands

```bash
make check    # bash -n, shellcheck, smoke tests, identity test, assets
make lint     # bash -n + shellcheck
make test     # smoke and regression tests
```

The real proof is a container run:

```bash
podman run --rm -v "$PWD:/repo:ro,Z" debian:sid \
  bash /repo/pikaos-system-maintenance.sh --dry-run
```

## Sharp edges

- PikaOS reports `ID=pika`, not `pikaos`. An equality check against `pikaos`
  warns on every real PikaOS machine.
- The keyring is a file downloaded by the PikaOS setup scripts. A
  `dpkg-query` check for a `pika-keyring` package warns on every real machine.
- `autoremove --purge` deletes the config files of removed packages. The README
  says so; do not quietly drop `--purge`.
- `dpkg --configure -a` can prompt for a conffile without
  `--force-confdef --force-confold`, which would hang `--yes`.
- The repo/keyring checks were also run against the PikaOS base container,
  where they pass. A plain Debian Sid container still warns, which is expected.

## Definition of done

- [ ] `make check` passes.
- [ ] The change has a test in `tests/` that fails without it.
- [ ] `README.md` still matches behaviour.
- [ ] `CHANGELOG.md` has an entry for user-visible changes.
- [ ] No secrets, no `rm -rf`, no new dependency.

## Do not touch

- `LICENSE`.
- `assets/*.png` by hand; they are captures of a real run.
- Formatting of unrelated files.
