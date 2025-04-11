#include <stddef.h>

void __aeabi_memclr(void *dest, size_t n) {
    unsigned char *pdest = (unsigned char *)dest;
    while (n--) {
        *pdest++ = 0;
    }
}
