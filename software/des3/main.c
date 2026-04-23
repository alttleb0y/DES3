#include <io.h>
#include <stdio.h>
#include <stdint.h>
#include "system.h"

void main() {
    uint64_t idata1, idata2, odata, key1, key2, key3;
    uint32_t valid_out;

    idata1 = 0x0123456789ABCDEF;
    idata2 = 0x23456789ABCDEF01;
    key1   = 0x0123456789ABCDEF;
    key2   = 0x23456789ABCDEF01;
    key3   = 0x456789ABCDEF0123;

    while(1) {
        // data 1
        IOWR(A_3DES_0_BASE, 0, (uint32_t)(idata1 & 0xFFFFFFFF));
        IOWR(A_3DES_0_BASE, 1, (uint32_t)(idata1 >> 32));
        IOWR(A_3DES_0_BASE, 2, (uint32_t)(key1 & 0xFFFFFFFF));
        IOWR(A_3DES_0_BASE, 3, (uint32_t)(key1 >> 32));
        IOWR(A_3DES_0_BASE, 4, (uint32_t)(key2 & 0xFFFFFFFF));
        IOWR(A_3DES_0_BASE, 5, (uint32_t)(key2 >> 32));
        IOWR(A_3DES_0_BASE, 6, (uint32_t)(key3 & 0xFFFFFFFF));
        IOWR(A_3DES_0_BASE, 7, (uint32_t)(key3 >> 32));
        IOWR(A_3DES_0_BASE, 8, 1);

        // data 2
        IOWR(A_3DES_0_BASE, 0, (uint32_t)(idata2 & 0xFFFFFFFF));
        IOWR(A_3DES_0_BASE, 1, (uint32_t)(idata2 >> 32));
        IOWR(A_3DES_0_BASE, 8, 1);

        // wait for output
        valid_out = IORD(A_3DES_0_BASE, 11);
        if(valid_out) {
            odata  = (uint64_t)IORD(A_3DES_0_BASE, 9);
            odata |= (uint64_t)IORD(A_3DES_0_BASE, 10) << 32;
            printf("Output: %016llX\n", odata);
        }
    }
}
