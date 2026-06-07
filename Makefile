.PHONY: dev debug macos-debug macos-release test analyze

dev:
	./scripts/dev_macos.sh

debug: dev

macos-debug: dev

macos-release:
	flutter build macos --release

test:
	flutter test

analyze:
	flutter analyze
