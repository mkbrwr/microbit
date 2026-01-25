int main(void);

extern unsigned char __stack[];
extern char __bss_start;
extern char __bss_end;

void __reset(void) {
    // Zero BSS using actual linker-provided bounds
    char *bss = &__bss_start;
    while (bss < &__bss_end) {
        *bss++ = 0;
    }
    main();
}

void hardfault_handler(void) {
    __asm volatile (
           "mrs r0, msp\n"       // Get Main Stack Pointer
           "ldr r1, [r0, #24]\n" // Get stacked PC (offset 24 = 0x18)
           "bkpt #0\n"           // Breakpoint - inspect r1 for faulting PC
    );
    while(1);
}

void *__vectors[] __attribute((section(".vectors"))) = {
    __stack,                    /* -16 */
    __reset,
    0,
    hardfault_handler,
    hardfault_handler,          /* -12 */
    hardfault_handler,
    hardfault_handler,
    0
};
