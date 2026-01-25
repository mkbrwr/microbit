int main(void);

extern unsigned char __stack[];
extern char *heapptr;

void __reset(void)
{
    for (int i = 0; i < 64 * 1024; i++) {
        *(heapptr + i) = 0;
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
