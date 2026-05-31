---
date: 2026-05-31
repo: DOSHorse_X86
status: done
resume: ""
session: newp DOS Emulator — cross-repo verwijzing
agent: Claude Opus 4.7 (1M context)
---

# Newp DOS Emulator — DOSHorse_X86 cross-repo verwijzing

Dit is een **pointer-stub** voor het cross-repo prompt-protocol (Meta_Master/CLAUDE.md §Prompt Sessie Documentatie §Wanneer §4).

## Master sessie-MD

**Volledige sessie:** [`Meta_DOSHorse/prompts/2026-05-31_newp_dos_emulator.md`](https://github.com/cpaglebbeek/Meta_DOSHorse/blob/main/prompts/2026-05-31_newp_dos_emulator.md)

## Wat is hier vastgelegd (DOSHorse_X86-specifiek)

- v0.0.1-Bradley (David Bradley, IBM PC BIOS-schrijver + Ctrl-Alt-Del) — past bij low-level native build
- Rol: **Variant 1 (prio 1)** — native desktop Linux/Windows/macOS (dosbox-x compileert al → eerste runnable laagdrempelig)
- Skeleton-fase: README + CLAUDE + ARCHITECTURE + CHANGELOG + LICENSE (AGPL-3.0) + VERSION + .gitignore — géén code-import
- Open beslispunten in `ARCHITECTURE.md`: X1 (UI-stack SDL/Qt6/GTK4/ImGui), X2 (macOS universal binary), X3 (Windows code-signing)

## Volgende sessie

v0.0.2-import: Core-submodule + eerste runnable X86-build op Linux (AppImage) als snelste pad naar werkende DOSHorse.
