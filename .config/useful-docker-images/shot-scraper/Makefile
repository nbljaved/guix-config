DOCKER := $(shell command -v docker 2>/dev/null || echo podman)

.PHONY: all build skill check

all: build skill check

build:
	# Build shot-scraper image
	$(DOCKER) build -t shot-scraper .
	@echo ""

skill:
	# Add screenshot skill to Claude Code
	mkdir -p $(HOME)/.claude/skills/screenshot
	ln -sf $(HOME)/guix-config/.config/useful-docker-images/shot-scraper/claude-skills/shot-scraper.md $(HOME)/.claude/skills/screenshot/SKILL.md
	@echo ""

check:
	@if command -v shot-scraper >/dev/null 2>&1; then \
		echo "✓ shot-scraper is available on PATH"; \
		shot-scraper --version; \
	else \
		echo "✗ shot-scraper is not available on PATH"; \
		echo "Add the following to your shell configuration:"; \
		echo "export PATH=\"\$$PATH:\$$HOME/guix-config/.config/useful-docker-images/shot-scraper/bin\""; \
		exit 1; \
	fi
