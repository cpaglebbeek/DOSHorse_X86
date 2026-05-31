# DOSHorse_X86 build-wrapper
# v0.0.2-Sams — eerste werkende build-wrapper (A: wrapper-only, geen source-patches)
#
# Roept upstream dosbox-x' ./build-macos-sdl2 aan via Core-submodule
# en kopieert resultaat naar dist/doshorse-x86.

DOSBOX_DIR := core/upstream/dosbox-x
BUILD_SCRIPT := build-macos-sdl2
BINARY_SRC := $(DOSBOX_DIR)/src/dosbox-x
BINARY_OUT := dist/doshorse-x86
BREW_DEPS := autoconf automake nasm glfw glew fluid-synth libslirp libpcap pkg-config sdl2_net

UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

.PHONY: all help deps-check build install smoke clean clean-build version

all: build install smoke

help:
	@echo "DOSHorse_X86 v0.0.2-Sams build-wrapper"
	@echo ""
	@echo "Targets:"
	@echo "  make deps-check  Verify Homebrew dependencies (macOS only)"
	@echo "  make build       Compile dosbox-x via core/upstream/dosbox-x/$(BUILD_SCRIPT)"
	@echo "  make install     Copy built binary to $(BINARY_OUT)"
	@echo "  make smoke       Run $(BINARY_OUT) --version (verifies install)"
	@echo "  make clean       Remove dist/"
	@echo "  make clean-build Run dosbox-x' make clean inside submodule"
	@echo "  make version     Show DOSHorse_X86 version (VERSION file)"
	@echo ""
	@echo "Host detected: $(UNAME_S) $(UNAME_M)"

version:
	@cat VERSION

deps-check:
ifeq ($(UNAME_S),Darwin)
	@echo "Checking Homebrew deps for macOS..."
	@for p in $(BREW_DEPS); do \
		brew list --formula "$$p" >/dev/null 2>&1 && echo "  ✓ $$p" || echo "  ✗ $$p (run: brew install $$p)"; \
	done
else
	@echo "deps-check only implemented for macOS in v0.0.2; Linux/Win comes v0.0.3+"
endif

build:
ifeq ($(UNAME_S),Darwin)
	@echo "Building dosbox-x via $(DOSBOX_DIR)/$(BUILD_SCRIPT)..."
	@test -d $(DOSBOX_DIR) || (echo "ERROR: $(DOSBOX_DIR) not found. Did you 'git submodule update --init --recursive'?" && exit 1)
	@cd $(DOSBOX_DIR) && ./$(BUILD_SCRIPT)
	@test -f $(BINARY_SRC) && echo "✓ Build succeeded: $(BINARY_SRC)" || (echo "✗ Build failed" && exit 1)
else
	@echo "Build only implemented for macOS in v0.0.2; Linux/Win comes v0.0.3+"
	@exit 1
endif

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
