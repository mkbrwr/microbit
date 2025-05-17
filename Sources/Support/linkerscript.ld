MEMORY {
    FLASH   (rx)  : ORIGIN = 0x00000000,      LENGTH = 512K
    RAM     (rwx) : ORIGIN = 0x20000000,      LENGTH = 128K
}

SECTIONS {
    .text ALIGN(16) : SUBALIGN(16) {
        KEEP(*(.vectors))
        *(.text*)
        *(.rodata*)
        . = ALIGN(4);
        __etext = .;
    } > FLASH

    .data : AT (LOADADDR(.text) + SIZEOF(.text)) {
        __data_start = .;
        *(.data*)
        . = ALIGN(4);
        __data_end = .;
    } > RAM

    .bss : {
        __bss_start = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        __bss_end = .;
        __end = .;
    } > RAM

    /DISCARD/ : { *(.swift_modhash*) }
    /* ARM metadata sections */
    /DISCARD/ : { *(.ARM.attributes*) *(.ARM.exidx) }

    /* ELF metadata sections */
    .symtab   : { *(.symtab) }
    .strtab   : { *(.strtab) }
    .shstrtab : { *(.shstrtab) }
    .debug    : { *(.debug*) }
    .comment  : { *(.comment) }

    __stack = ORIGIN(RAM) + LENGTH(RAM);
}
