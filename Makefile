.PHONY: help clean deps build run test analyze format appimage portable migrate scrape

# Default target
help:
	@echo "╔═══════════════════════════════════════════════════════════════╗"
	@echo "║          Forsaken Emulator - Development Commands             ║"
	@echo "╚═══════════════════════════════════════════════════════════════╝"
	@echo ""
	@echo "🏗️  BUILD COMMANDS:"
	@echo "  make build          - Build Linux release"
	@echo "  make build-debug    - Build Linux debug"
	@echo "  make portable       - Build portable Linux bundle with libs"
	@echo "  make appimage       - Build AppImage package"
	@echo ""
	@echo "🚀 RUN COMMANDS:"
	@echo "  make run            - Run app in debug mode"
	@echo "  make run-release    - Run app in release mode"
	@echo ""
	@echo "🧪 TEST & QUALITY:"
	@echo "  make test           - Run all tests"
	@echo "  make test-coverage  - Run tests with coverage"
	@echo "  make analyze        - Run static analysis"
	@echo "  make format         - Format all Dart code"
	@echo "  make format-check   - Check code formatting"
	@echo ""
	@echo "📦 DEPENDENCIES:"
	@echo "  make deps           - Install Flutter dependencies"
	@echo "  make clean          - Clean build artifacts"
	@echo "  make clean-all      - Deep clean (Flutter + deps)"
	@echo ""
	@echo "🎮 MEDIA MANAGEMENT:"
	@echo "  make migrate        - Run media migration script"
	@echo "  make scrape         - Run media scraper script"
	@echo ""
	@echo "📚 DOCUMENTATION:"
	@echo "  make docs           - Show documentation links"
	@echo ""

# Build targets
build:
	@echo "🔨 Building Linux release..."
	fvm flutter build linux --release

build-debug:
	@echo "🔨 Building Linux debug..."
	fvm flutter build linux --debug

portable:
	@echo "📦 Building portable Linux bundle..."
	@bash scripts/build/build_linux_portable.sh

appimage:
	@echo "📦 Building AppImage..."
	@bash scripts/build/build_appimage.sh

# Run targets
run:
	@echo "🚀 Running in debug mode..."
	fvm flutter run -d linux

run-release:
	@echo "🚀 Running in release mode..."
	fvm flutter run -d linux --release

# Test targets
test:
	@echo "🧪 Running tests..."
	fvm flutter test

test-coverage:
	@echo "🧪 Running tests with coverage..."
	fvm flutter test --coverage

# Quality targets
analyze:
	@echo "🔍 Running static analysis..."
	fvm flutter analyze

format:
	@echo "✨ Formatting code..."
	dart format -o write .

format-check:
	@echo "✨ Checking code formatting..."
	dart format --set-exit-if-changed .

# Dependency targets
deps:
	@echo "📦 Installing dependencies..."
	fvm flutter pub get

clean:
	@echo "🧹 Cleaning build artifacts..."
	fvm flutter clean

clean-all: clean
	@echo "🧹 Deep cleaning..."
	rm -rf .dart_tool
	rm -rf build
	rm -rf .flutter-plugins
	rm -rf .flutter-plugins-dependencies
	@make deps

# Media management
migrate:
	@echo "📦 Running media migration..."
	@echo "Usage: cd scripts/media-migration && ./migrate_media.py <platform> [--dry-run]"
	@cd scripts/media-migration && ./migrate_media.py --help

scrape:
	@echo "🌐 Running media scraper..."
	@echo "Usage: cd scripts/media-scraper && ./scrape_with_env.sh <platform> [options]"
	@cd scripts/media-scraper && ./scrape_with_env.sh --help

# Documentation
docs:
	@echo "📚 Documentation Links:"
	@echo ""
	@echo "Main documentation:"
	@echo "  - README.md"
	@echo "  - QUICK_LINKS.md"
	@echo "  - TESTING_NEEDED.md"
	@echo ""
	@echo "Scripts documentation:"
	@echo "  - scripts/README.md"
	@echo "  - scripts/media-migration/README.md"
	@echo "  - scripts/media-scraper/README.md"
	@echo ""
	@echo "Development:"
	@echo "  - AGENTS.md"
	@echo "  - docs/TODO.md"
	@echo ""
