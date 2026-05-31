# DOSHorse_X86 build-wrapper
# v0.0.4-Felsenstein — cross-platform Makefile (macOS bewezen; Linux/Windows untested)
#
# Lineage:
#   v0.0.2-Sams       — wrapper-only macOS
#   v0.0.3-Noyce      — + apply-patches + branding (macOS bewezen)
#   v0.0.4-Felsenstein — + Linux (./build-sdl2) + Windows MinGW (./build-mingw-sdl2)
#                        Codename eert Lee Felsenstein (Osborne 1 portable, eerste cross-platform PC).
#
# Roept upstream dosbox-x' platform-specifiek build-script aan via Core-submodule
# en kopieert resultaat naar dist/doshorse-x86. Vóór compile worden
# patches uit core/patches/ toegepast via core/tools/apply-patches.sh.

CORE_DIR := core
DOSBOX_DIR := $(CORE_DIR)/upstream/dosbox-x
PATCH_SCRIPT := $(CORE_DIR)/tools/apply-patches.sh
BINARY_OUT := dist/doshorse-x86

UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

# Platform-detection → kies juiste dosbox-x build-script
ifeq ($(UNAME_S),Darwin)
    BUILD_SCRIPT := build-macos-sdl2
    BINARY_SRC := $(DOSBOX_DIR)/src/dosbox-x
    PLATFORM_LABEL := macOS
    DEPS_TOOL := brew
    DEPS_LIST := autoconf automake nasm glfw glew fluid-synth libslirp libpcap pkg-config sdl2_net
else ifeq ($(UNAME_S),Linux)
    BUILD_SCRIPT := build-sdl2
    BINARY_SRC := $(DOSBOX_DIR)/src/dosbox-x
    PLATFORM_LABEL := Linux
    DEPS_TOOL := apt
    DEPS_LIST := automake gcc g++ make libncurses-dev nasm libsdl-net1.2-dev libsdl2-net-dev libpcap-dev libslirp-dev fluidsynth libfluidsynth-dev libavformat-dev libavcodec-dev libswscale-dev libfreetype-dev libxkbfile-dev libxrandr-dev
else ifneq (,$(findstring MINGW,$(UNAME_S))$(findstring MSYS,$(UNAME_S))$(findstring CYGWIN,$(UNAME_S)))
    BUILD_SCRIPT := build-mingw-sdl2
    BINARY_SRC := $(DOSBOX_DIR)/src/dosbox-x.exe
    PLATFORM_LABEL := Windows-MinGW
    DEPS_TOOL := pacman
    DEPS_LIST := git make mingw-w64-x86_64-toolchain mingw-w64-x86_64-libslirp mingw-w64-x86_64-libtool mingw-w64-x86_64-nasm autoconf automake mingw-w64-x86_64-ncurses
else
    BUILD_SCRIPT := /UNSUPPORTED/
    BINARY_SRC := /UNSUPPORTED/
    PLATFORM_LABEL := UNSUPPORTED-$(UNAME_S)
    DEPS_TOOL := unknown
    DEPS_LIST :=
endif

.PHONY: all help deps-check apply-patches build install smoke clean clean-build clean-patches version platform-info

help:
	@echo "DOSHorse_X86 v0.0.4-Felsenstein build-wrapper"
	@echo ""
	@echo "Targets:"
	@echo "  make platform-info  Show detected platform + build-script choice"
	@echo "  make deps-check     Verify deps (brew/apt/pacman per platform)"
	@echo "  make apply-patches  Apply core/patches/*.patch to upstream/dosbox-x/"
	@echo "  make build          Compile dosbox-x via $(DOSBOX_DIR)/$(BUILD_SCRIPT)"
	@echo "  make install        Copy built binary to $(BINARY_OUT)"
	@echo "  make smoke          Run $(BINARY_OUT) --version (verifies install + branding)"
	@echo "  make clean          Remove dist/"
	@echo "  make clean-build    Run dosbox-x' make clean inside submodule"
	@echo "  make clean-patches  Revert all patches (git checkout in submodule)"
	@echo "  make version        Show DOSHorse_X86 version (VERSION file)"
	@echo ""
	@echo "Default 'make' runs: apply-patches → build → install → smoke"
	@echo ""
	@echo "Platform support (v0.0.4):"
	@echo "  ✓ macOS Intel x86_64    — bewezen smoke-test #3 (v0.0.3)"
	@echo "  ⚠ macOS Apple Silicon   — verwacht, niet getest (universal build vereist M-chip host)"
	@echo "  ⚠ Linux (Ubuntu/Debian) — code-pad aanwezig, niet lokaal getest"
	@echo "  ⚠ Windows MinGW (MSYS2) — code-pad aanwezig, niet lokaal getest"
	@echo ""
	@echo "Host detected: $(UNAME_S) $(UNAME_M) → $(PLATFORM_LABEL)"

platform-info:
	@echo "Host:          $(UNAME_S) $(UNAME_M)"
	@echo "Platform:      $(PLATFORM_LABEL)"
	@echo "Build script:  $(DOSBOX_DIR)/$(BUILD_SCRIPT)"
	@echo "Binary src:    $(BINARY_SRC)"
	@echo "Binary out:    $(BINARY_OUT)"
	@echo "Deps tool:     $(DEPS_TOOL)"

version:
	@cat VERSION

deps-check:
ifeq ($(UNAME_S),Darwin)
	@echo "Checking Homebrew deps for macOS..."
	@for p in $(DEPS_LIST); do \
		brew list --formula "$$p" >/dev/null 2>&1 && echo "  ✓ $$p" || echo "  ✗ $$p (run: brew install $$p)"; \
	done
else ifeq ($(UNAME_S),Linux)
	@echo "Checking apt deps for Linux..."
	@for p in $(DEPS_LIST); do \
		dpkg -s "$$p" >/dev/null 2>&1 && echo "  ✓ $$p" || echo "  ✗ $$p (run: sudo apt install $$p)"; \
	done
	@echo ""
	@echo "Note: Fedora users use dnf-list (see BUILD.md §Fedora). Other distros: zie BUILD.md."
else ifneq (,$(findstring MINGW,$(UNAME_S))$(findstring MSYS,$(UNAME_S))$(findstring CYGWIN,$(UNAME_S)))
	@echo "Checking pacman deps for MSYS2/MinGW..."
	@for p in $(DEPS_LIST); do \
		pacman -Q "$$p" >/dev/null 2>&1 && echo "  ✓ $$p" || echo "  ✗ $$p (run: pacman -S $$p)"; \
	done
else
	@echo "Platform $(UNAME_S) not supported by Makefile in v0.0.4."
	@echo "Supported: macOS (Darwin), Linux, Windows (MinGW via MSYS2)."
	@exit 1
endif

apply-patches:
	@test -x $(PATCH_SCRIPT) || (echo "ERROR: $(PATCH_SCRIPT) not found or not executable. Did you 'git submodule update --init --recursive'?" && exit 1)
	@$(PATCH_SCRIPT)

build:
	@if [ "$(BUILD_SCRIPT)" = "/UNSUPPORTED/" ]; then \
		echo "ERROR: Platform $(UNAME_S) is not supported by Makefile in v0.0.4."; \
		echo "Supported: macOS (Darwin), Linux, Windows (MinGW via MSYS2)."; \
		exit 1; \
	fi
	@echo "Building dosbox-x for $(PLATFORM_LABEL) via $(DOSBOX_DIR)/$(BUILD_SCRIPT)..."
	@test -d $(DOSBOX_DIR) || (echo "ERROR: $(DOSBOX_DIR) not found. Did you 'git submodule update --init --recursive'?" && exit 1)
	@test -x $(DOSBOX_DIR)/$(BUILD_SCRIPT) || (echo "ERROR: $(DOSBOX_DIR)/$(BUILD_SCRIPT) not found or not executable." && exit 1)
	@cd $(DOSBOX_DIR) && ./$(BUILD_SCRIPT)
	@test -f $(BINARY_SRC) && echo "✓ Build succeeded: $(BINARY_SRC)" || (echo "✗ Build failed (no binary at $(BINARY_SRC))" && exit 1)

install: $(BINARY_OUT)

$(BINARY_OUT): $(BINARY_SRC)
	@mkdir -p dist
	@cp $(BINARY_SRC) $(BINARY_OUT)
	@chmod +x $(BINARY_OUT)
	@echo "✓ Installed: $(BINARY_OUT) ($$(du -h $(BINARY_OUT) | cut -f1))"

smoke: $(BINARY_OUT)
	@echo "Smoke-test: $(BINARY_OUT) --version"
	@./$(BINARY_OUT) --version | head -3

clean:
	rm -rf dist/

clean-build:
	@test -d $(DOSBOX_DIR) && cd $(DOSBOX_DIR) && (test -f Makefile && make clean || echo "(no Makefile yet — nothing to clean)") || true

clean-patches:
	@test -d $(DOSBOX_DIR) && cd $(DOSBOX_DIR) && git checkout . && echo "✓ All patches reverted (git checkout in $(DOSBOX_DIR))" || true
