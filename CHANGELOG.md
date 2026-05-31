# CHANGELOG — DOSHorse_X86

## v0.0.4-Felsenstein — 2026-06-01

Cross-platform Makefile (Tracks B + C uit v0.0.6 combined-scope).

### Toegevoegd in Makefile
- **Platform-detection** via `UNAME_S` met `ifeq`/`ifneq`-takken:
  - `Darwin` → `build-macos-sdl2` + brew-deps (bewezen)
  - `Linux` → `build-sdl2` + apt-deps (Ubuntu/Debian)
  - `MINGW*` / `MSYS*` / `CYGWIN*` → `build-mingw-sdl2` + pacman-deps (MSYS2)
- **Platform-bewuste vars**: `BUILD_SCRIPT`, `BINARY_SRC` (`.exe` op Windows), `DEPS_TOOL`, `DEPS_LIST` per platform
- **`platform-info` target** — print detected platform + script-keuze (diagnose)
- **`deps-check` uitgebreid** — werkt nu voor brew/apt/pacman
- **`build` target** — exit met fout op unsupported platform, helder error-bericht
- Help-output toont nu platform-support-matrix (✓/⚠ per platform)

### Bewezen
- **macOS**: regression-getest, alle bestaande targets werken identiek aan v0.0.3 (platform-info → Darwin x86_64 → macOS → build-macos-sdl2; deps-check toont 10/10 ✓)

### Niet getest (gedocumenteerd untested)
- **Linux**: code-pad aanwezig, geen Linux-host beschikbaar in deze sessie. Apt-deps overgenomen uit dosbox-x' BUILD.md §"Ubuntu 20.04/20.10". Build-script `build-sdl2` bestaat in upstream.
- **Windows MinGW**: code-pad aanwezig, geen Windows-host. Pacman-deps overgenomen uit dosbox-x' BUILD.md §MinGW. Build-script `build-mingw-sdl2` bestaat in upstream.

### Codenaam-rationale
**Felsenstein** = Lee Felsenstein (1976-1981) — ontwerper van de Osborne 1, de **eerste commercieel succesvolle portable computer**. Past bij cross-platform Makefile-uitbreiding: één codebase, meerdere targets, en Felsenstein bewees als eerste dat het kón.

### Niet uitgevoerd (v0.0.7+)
- Linux/Windows native build-test (vereist host of CI)
- Universal binary macOS (vereist Apple Silicon host)
- Eigen C-source koppeling met dosbox-x' internal state (huidige build gebruikt Core's API maar nog niet als runtime-link target)

## v0.0.3-Noyce — 2026-06-01

Wrapper-pipeline uitgebreid met patch-applicatie (B: wrapper + branding-patch).

### Toegevoegd in Makefile
- **`apply-patches`** target — roept `core/tools/apply-patches.sh` aan vóór compile
- **`clean-patches`** target — `git checkout .` in submodule om patches te reverten
- **Default `make`** keten gewijzigd: `apply-patches → build → install → smoke` (was: `build → install → smoke`)
- Help-output bijgewerkt

### Bewezen
- Smoke-test #3 (BUILD_LOG.md #3): make-keten met patch werkt end-to-end, binary's `--version` toont **"DOSHorse version 0.0.3-Canion (forked from upstream below)"** vóór upstream's "DOSBox-X version ..." string

### Niet uitgevoerd (v0.0.4+)
- Linux/Windows build-support
- Eigen C-source in `src/` (Public API impl uit Core consumeren)
- Universal binary
- Run-test met echte DOS-image

### Codenaam-rationale
**Noyce** = Robert Noyce (Intel co-founder, 1968) — co-uitvinder van de geïntegreerde-circuit + Intel-Founder die de x86-toekomst mogelijk maakte. Past bij DOSHorse_X86's **eerste echt-gebrand werkende build**: we hebben nu een DOSHorse-binary op x86 (de chip die Noyce/Faggin hielpen maken).

## v0.0.2-Sams — 2026-06-01

Eerste werkende build-wrapper (approach A: wrapper-only, geen source-patches in dosbox-x).

- **Submodule add**: `core/` → [cpaglebbeek/DOSHorse_Core](https://github.com/cpaglebbeek/DOSHorse_Core) (DOSHorse_Core v0.0.2-Dean) met `--depth 1` shallow
- **Nested submodule**: `core/upstream/dosbox-x/` via `git submodule update --init --recursive` (pinned `4a95241b` zoals in Core)
- **Makefile** met targets: `deps-check`, `build`, `install`, `smoke`, `clean`, `clean-build`, `version`, `help`
- **BUILD.md** met quick-start + targets-overzicht + branding-noot + platform-status-tabel
- **`.gitignore`** uitgebreid voor `dist/` (build-output)

Standaard `make` = `build` + `install` + `smoke`: roept `core/upstream/dosbox-x/build-macos-sdl2` aan, kopieert binary naar `dist/doshorse-x86`, runt `--version` smoke-test.

**Branding-noot:** binary rapporteert nog `DOSBox-X version ...` (upstream-versie-string). Bestandsnaam is `doshorse-x86` (via install-copy). Source-branding patches komen v0.0.5+.

**Codenaam Sams** = Phil Sams (Phoenix Technologies) — pionier van de clean-room BIOS-implementatie. Past bij "wrapper-only" approach: we bouwen onze DOSHorse-laag bovenop dosbox-x **zonder** de upstream-code te raken, analoog aan hoe Phoenix Technologies een PC-compatible BIOS bouwde zonder IBM's source aan te raken — beide enable downstream-distributie zonder upstream-juridische conflicten.

Géén C++/Kotlin source in deze release — Makefile + docs only. Public API headers (`include/doshorse/`) komen v0.0.5; eigen source-patches voor branding komen v0.0.6+.

## v0.0.1-Bradley — 2026-05-31

Skeleton via `newp "DOS Emulator"`.

- README + CLAUDE + ARCHITECTURE + LICENSE (AGPL-3.0) + VERSION + prompts/
- Geen code-import
- Geen build-config (gepland v0.0.2)

Vernoemd naar David Bradley, IBM PC BIOS-schrijver en uitvinder van Ctrl-Alt-Del — past bij low-level native build.
