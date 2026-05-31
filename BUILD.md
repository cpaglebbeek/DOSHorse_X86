# Building DOSHorse_X86

> **v0.0.2-Sams** — eerste werkende build-wrapper (Approach A: wrapper-only, geen source-patches in dosbox-x). Source-branding (binary-naam in `--version`, `doshorse-x86` ipv `dosbox-x` intern) komt v0.0.5+ wanneer patch-discipline + Public API headers er zijn.

## Status per platform (v0.0.2)

| Platform | Status | Notitie |
|---|---|---|
| macOS Intel x86_64 | ✅ Werkt (bewezen v0.0.3 smoke-test) | `./build-macos-sdl2` via wrapper |
| macOS Apple Silicon arm64 | ⏳ Verwacht-werkend, niet getest op host | Universal-binary vereist M-chip host (per upstream BUILD.md) |
| Linux | ❌ Niet geïmplementeerd in Makefile | v0.0.3+ |
| Windows | ❌ Niet geïmplementeerd in Makefile | v0.0.4+ |

## Quick-start (macOS)

```bash
# Clone met submodules
git clone --recursive https://github.com/cpaglebbeek/DOSHorse_X86.git
cd DOSHorse_X86

# Check Homebrew deps
make deps-check

# Eventueel ontbrekende installeren
brew install autoconf automake nasm glfw glew fluid-synth libslirp libpcap pkg-config sdl2_net

# Build + install + smoke-test
make
```

Verwachte uitvoer eindigt met:
```
✓ Installed: dist/doshorse-x86 (22M)
Smoke-test: dist/doshorse-x86 --version
DOSBox-X version 2026.05.02 SDL2, ...
```

## Makefile-targets

| Target | Wat |
|---|---|
| `make` of `make all` | build + install + smoke (volledige keten) |
| `make deps-check` | Homebrew package-status zonder install |
| `make build` | Roep `core/upstream/dosbox-x/build-macos-sdl2` aan |
| `make install` | Kopieer binary naar `dist/doshorse-x86` |
| `make smoke` | Run `dist/doshorse-x86 --version` |
| `make clean` | Verwijder `dist/` |
| `make clean-build` | Roep `make clean` aan in dosbox-x submodule |
| `make version` | Toon DOSHorse_X86-versie uit `VERSION` |
| `make help` | Toon hulp |

## Branding-noot (v0.0.2)

In deze release rapporteert de binary nog `DOSBox-X version 2026.05.02 SDL2` — upstream's eigen versie-string. Dat is **bewust** (wrapper-only). Bestandsnaam is wel `doshorse-x86` (via `make install`-copy). Echte branding komt v0.0.5.

## Build-tijd

Eerste build op host-Mac (Intel, macOS 26.3): **~9.5 min** (v0.0.3 smoke-test). Incremental rebuilds via `make build` zijn aanzienlijk sneller (upstream's eigen depbase).

## Architectuur-noot

Submodule-keten:
```
DOSHorse_X86
  └─ core/                       (DOSHorse_Core, submodule)
       └─ upstream/dosbox-x/     (joncampbell123/dosbox-x, nested submodule)
```

Clone moet `--recursive` zijn om alle drie de niveaus mee te krijgen.

## Bekende warnings (niet-blokkerend)

- Diverse `unused parameter` / `unused function` warnings — upstream code
- `output_direct3d11.o has no symbols` — DirectX 11 stub op macOS
- macOS deployment-target (10.13) vs Apple SDK 26.0 mismatch-warnings — upstream-script-instelling
- Homebrew dylib versies (14.0) > deployment target (10.13) — werkt runtime op huidig systeem

Zie `Meta_DOSHorse/docs/BUILD_LOG.md` voor volledige analyse.
