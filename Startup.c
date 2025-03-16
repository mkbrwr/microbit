int main(void);

void start(void)
{
    main();                    
    while (1) {};
}

void __reset(void)
{
    start();
}

extern unsigned char __stack[];

void *vector_table[] __attribute((section(".vectors"))) = {
    __stack,
    __reset,
    0
};