# CLAUDE.md — DOSHorse_X86

> Sub-repo. Globale regels: `Meta_Master/CLAUDE.md`. Ecosysteem-regels: `Meta_DOSHorse/CLAUDE.md`. Hier alleen X86-specifiek.

## Rol

Native desktop-variant Linux/Windows/macOS. Prio 1 voor eerste runnable build.

## Codename

v0.0.1 = Bradley. Pool: `Meta_DOSHorse/CLAUDE.md`.

## Regels

- Build-output (binaries, installers) NIET committen — alleen build-scripts en config.
- Release-binaries naar GitHub Releases (later: ook spiegel naar `horsecloud55.ddns.net/DOSHorse/downloads/x86/`).
- dosbox-x patches gaan in `DOSHorse_Core`, niet hier. Hier alleen X86-specifieke glue (packaging, installer-scripts, native UI).
