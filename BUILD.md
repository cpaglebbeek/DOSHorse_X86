# Building DOSHorse_X86

> **v0.0.2-Sams** — eerste werkende build-wrapper (Approach A: wrapper-only, geen source-patches in dosbox-x). Source-branding (binary-naam in `--version`, `doshorse-x86` ipv `dosbox-x` intern) komt v0.0.5+ wanneer patch-discipline + Public API headers er zijn.

## Status per platform (v0.0.4)

| Platform | Status | Notitie |
|---|---|---|
| macOS Intel x86_64 | ✅ Bewezen v0.0.3 + v0.0.5 smoke-tests | `./build-macos-sdl2`, ~10 min, binary 22 MB |
| macOS Apple Silicon arm64 | ⏳ Code-pad aanwezig, niet getest op host | Universal-binary vereist M-chip host (per upstream BUILD.md) |
| Linux Ubuntu/Debian | ⚠ Code-pad aanwezig (v0.0.4), niet lokaal getest | `./build-sdl2` + apt-deps; eerste lokale build verifieert |
| Linux Fedora/RHEL | ⚠ Code-pad aanwezig (v0.0.4), niet lokaal getest | `./build-sdl2` + dnf-deps; zie §Fedora |
| Windows MinGW (MSYS2) | ⚠ Code-pad aanwezig (v0.0.4), niet lokaal getest | `./build-mingw-sdl2` + pacman-deps; eerste lokale build verifieert |
| Windows Visual Studio | ❌ Niet door Makefile gedekt | dosbox-x heeft `vs/` Visual Studio solution; gebruik die direct |

## Quick-start (alle platforms — Makefile detecteert automatisch)

```bash
# Clone met submodules (3 niveaus: X86 → core → upstream/dosbox-x)
git clone --recursive https://github.com/cpaglebbeek/DOSHorse_X86.git
cd DOSHorse_X86

# Toon wat de Makefile detecteert
make platform-info

# Check deps (brew/apt/pacman afhankelijk van host)
make deps-check

# Install ontbrekende deps via je package-manager (zie §Per-platform deps)

# Build + install + smoke-test
make
```

Verwachte uitvoer eindigt met:
```
✓ Installed: dist/doshorse-x86 (22M)
Smoke-test: dist/doshorse-x86 --version
DOSHorse version 0.0.3-Canion (forked from upstream below)
DOSBox-X version 2026.05.02 SDL2, ...
```

## Per-platform deps

### macOS (Homebrew)
```bash
brew install autoconf automake nasm glfw glew fluid-synth libslirp libpcap pkg-config sdl2_net
```

### Linux Ubuntu/Debian (apt)
```bash
sudo apt install automake gcc g++ make libncurses-dev nasm \
    libsdl-net1.2-dev libsdl2-net-dev libpcap-dev libslirp-dev \
    fluidsynth libfluidsynth-dev libavformat-dev libavcodec-dev \
    libswscale-dev libfreetype-dev libxkbfile-dev libxrandr-dev
```

### Linux Fedora/RHEL (dnf)
```bash
sudo dnf group install "C Development Tools and Libraries"
sudo dnf install SDL_net-devel SDL2_net-devel libxkbfile-devel \
    ncurses-devel libpcap-devel libslirp-devel libpng-devel \
    fluidsynth-devel freetype-devel nasm
```
**Noot:** Op Fedora gebruikt de Makefile alleen `dpkg`-detectie voor `deps-check`; controleer handmatig of bovenstaande dnf-packages aanwezig zijn.

### Windows MSYS2 + MinGW64 (pacman)
```bash
# In MSYS2 MinGW64-shell:
pacman -S git make mingw-w64-x86_64-toolchain \
    mingw-w64-x86_64-libslirp mingw-w64-x86_64-libtool \
    mingw-w64-x86_64-nasm autoconf automake mingw-w64-x86_64-ncurses
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
