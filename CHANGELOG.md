# CHANGELOG — DOSHorse_X86

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
