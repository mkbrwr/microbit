SWIFT := ~/.swiftly/bin/swift
OBJCOPY := /opt/homebrew/opt/binutils/bin/objcopy
TARGET := armv7em-none-none-eabi

.PHONY: build
build:
	@echo "compiling..."
	$(SWIFT) build \
		--configuration release \
		--verbose \
		--toolset toolset.json \
		--triple $(TARGET) \

	@echo "making HEX..."
	$(OBJCOPY) -O ihex .build/release/microbit a.hex

.PHONY: flash
flash:
	@echo "flashing..."
	@pyocd flash a.hex
