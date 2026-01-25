#include <stddef.h>

void __aeabi_memclr(void *dest, size_t n) {
    unsigned char *pdest = (unsigned char *)dest;
    while (n--) {
        *pdest++ = 0;
    }
}

void __aeabi_memmove(void *dest, const void *src, size_t n) {
    // TODO: needs to be implemented
}

int putchar( int ch ) {
    return ch;
}
