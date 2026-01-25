MEMORY {
    FLASH   (rx)  : ORIGIN = 0x00000000,      LENGTH = 512K
    RAM     (rwx) : ORIGIN = 0x20000000,      LENGTH = 64K /* Full RAM is 128K */
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

    /DISCARD/ : { *(.swift_modhash*), *(.swift_ast) }
    /* ARM metadata sections */
    /DISCARD/ : { *(.ARM.attributes*) *(.ARM.exidx) }
    /DISCARD/ : { *(.got) }

    /* ELF metadata sections */
    .symtab   : { *(.symtab) }
    .strtab   : { *(.strtab) }
    .shstrtab : { *(.shstrtab) }

    /* DWARF debug sections */
    .debug_abbrev     0 : { *(.debug_abbrev) }
    .debug_addr       0 : { *(.debug_addr) }
    .debug_aranges    0 : { *(.debug_aranges) }
    .debug_frame      0 : { *(.debug_frame) }
    .debug_info       0 : { *(.debug_info) }
    .debug_line       0 : { *(.debug_line) }
    .debug_line_str   0 : { *(.debug_line_str) }
    .debug_loc        0 : { *(.debug_loc) }
    .debug_loclists   0 : { *(.debug_loclists) }
    .debug_macinfo    0 : { *(.debug_macinfo) }
    .debug_macro      0 : { *(.debug_macro) }
    .debug_names      0 : { *(.debug_names) }
    .debug_pubnames   0 : { *(.debug_pubnames) }
    .debug_pubtypes   0 : { *(.debug_pubtypes) }
    .debug_ranges     0 : { *(.debug_ranges) }
    .debug_rnglists   0 : { *(.debug_rnglists) }
    .debug_str        0 : { *(.debug_str) }
    .debug_str_offsets 0 : { *(.debug_str_offsets) }
    .debug_types      0 : { *(.debug_types) }

    .comment  : { *(.comment) }

    __stack = ORIGIN(RAM) + LENGTH(RAM);
}
