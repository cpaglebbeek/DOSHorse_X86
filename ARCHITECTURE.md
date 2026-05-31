# ARCHITECTURE — DOSHorse_X86

> Skeleton-fase. Volledige decompositie volgt v0.0.2.

## Doel

Native desktop DOSHorse op Linux + Windows + macOS, eerste runnable variant.

## Geplande structuur (v0.0.2+)

```
DOSHorse_X86/
├── core/                  # git submodule -> DOSHorse_Core
├── platform/
│   ├── linux/             # AppImage + .deb + Flatpak
│   ├── windows/           # .msi via WiX of NSIS
│   └── macos/             # .dmg + codesigning
├── ui/                    # UI-stack (keuze open beslispunt O2)
├── packaging/             # CPack + per-platform installer config
└── CMakeLists.txt
```

## Open beslispunten

| # | Vraag | Wanneer |
|---|-------|---------|
| X1 | UI-stack: dosbox-x' SDL-menu houden, Qt6, GTK4, of Dear ImGui? | v0.0.3 |
| X2 | macOS universal binary: Lipo bij build of dual-CI? | v0.0.4 |
| X3 | Windows: code-signing certificate (Sectigo/SSL.com) of self-signed? | v0.0.4 |
