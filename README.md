# DOSHorse_X86

> **Status:** v0.0.1-Bradley skeleton. Géén code-import in deze fase. **Prio 1** voor eerste runnable.

Native desktop-variant van DOSHorse voor Linux + Windows + macOS. Consumeert `DOSHorse_Core` als git-submodule (vanaf v0.0.2).

## Doel

Eerste runnable van het DOSHorse-ecosysteem. dosbox-x compileert al natively → de eerste build is technisch laagdrempelig: importeer Core, build, brand.

## Platforms

- **Linux** — AppImage + .deb + Flatpak (Flatpak deelt config met SteamDeck-variant)
- **Windows** — portable .zip + .msi installer
- **macOS** — .dmg met universal binary (x86_64 + Apple Silicon)

## Codenaam

v0.0.1 = **Bradley** (David Bradley, IBM PC BIOS-schrijver, uitvinder van Ctrl-Alt-Del). Past bij low-level native build.

Pool-bron: `Meta_DOSHorse/CLAUDE.md` (niet dupliceren).

## Upstream

[joncampbell123/dosbox-x](https://github.com/joncampbell123/dosbox-x) via `DOSHorse_Core` (v0.0.2+).

## Build (gepland, v0.0.2+)

```
cmake -S . -B build -DDOSHORSE_TARGET=x86
cmake --build build
```

## Status

| Component | Status |
|-----------|--------|
| Skeleton | ✓ |
| Core-submodule | open (v0.0.2) |
| CMake build | open |
| Linux AppImage | open |
| Windows installer | open |
| macOS dmg | open |
| UI-stack keuze (SDL-menu vs Qt6/GTK4/ImGui) | open beslispunt O2 |
