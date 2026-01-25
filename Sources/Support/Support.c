#include <stdint.h>
#include <stddef.h>

int putchar(int ch) {
    return ch;
}

void __aeabi_memmove(void *dest, const void *src, size_t n) {
    uint8_t *d = (uint8_t *)dest;
    const uint8_t *s = (const uint8_t *)src;

    if (d == s || n == 0) {
        return;
    }

    if (d < s) {
        while (n--) {
            *d++ = *s++;
        }
    } else {
        d += n;
        s += n;
        while (n--) {
            *--d = *--s;
        }
    }
}

// Second half of the RAM
char *heapptr = (char*)0x20010000;

/*
 posix_memalign() allocates size bytes and places the address of
 the allocated memory in *memptr.  The address of the allocated
 memory will be a multiple of alignment, which must be a power of
 two and a multiple of sizeof(void *).  This address can later be
 successfully passed to free(3).  If size is 0, then the value
 placed in *memptr is either NULL or a unique pointer value.
*/

int posix_memalign(void **memptr, size_t alignment, size_t size) {
    uintptr_t addr = (uintptr_t)heapptr;
    addr = (addr + alignment - 1) & ~(alignment - 1);
    *memptr = (void*)addr;
    heapptr = (char*)(addr + size);
    return 0;
}

/*
 The free() function shall cause the space pointed to by ptr to be
 deallocated; that is, made available for further allocation. If
 ptr is a null pointer, no action shall occur. Otherwise, if the
 argument does not match a pointer earlier returned by a function
 in POSIX.1‐2008 that allocates memory as if by malloc(), or if the
 space has been deallocated by a call to free() or realloc(), the
 behavior is undefined.

 Any use of a pointer that refers to freed space results in
 undefined behavior.
*/

void free(void *ptr) {
    // Never free
}
