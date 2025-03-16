SWIFT_TOOLCHAIN := ~/Developer/swift-6.1-DEVELOPMENT-SNAPSHOT-2025-03-03-a-debian12/usr/bin
SWIFT := $(SWIFT_TOOLCHAIN)/swift
SWIFTC := $(SWIFT_TOOLCHAIN)/swiftc
CLANG := $(SWIFT_TOOLCHAIN)/clang
OBJCOPY := objcopy

TARGET := armv7em-none-none-eabi

.PHONY: build
build:
	@echo "compiling..."
	$(SWIFT) build \
		--configuration release \
		--verbose \
		--triple $(TARGET) \
		-Xcc -ffreestanding \
		-Xswiftc -Xfrontend -Xswiftc -disable-stack-protector

	$(CLANG) -target $(TARGET) -c Startup.c -o .build/Startup.o

	$(CLANG) -target $(TARGET) -c Support.c -o .build/Support.o

	@echo "linking..."
	$(CLANG) -v -target $(TARGET) -fuse-ld=lld -nostdlib -static \
    -Wl,-e,vector_table -Wl,--gc-sections -Wl,-T,linkerscript.ld \
	.build/Startup.o \
	.build/Support.o \
    .build/release/libmicrobit.a \
    -o a.elf

	@echo "making HEX..."
	objcopy -O ihex a.elf a.hex


.PHONY: flash
flash:
	@echo "flashing..."
	@mv a.hex /media/mykhailo/MICROBIT

.PHONY: run
run: build flash

.PHONY: clean
clean:
	@echo "cleaning..."
	@$(SWIFT) package clean
	@rm -f a.elf
	@rm -rf .build
