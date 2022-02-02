            .text

start:      addi x5, zero, 0xA8
            addi x6, zero, 0xF1
            andn x7, x5, x6
            clz  x8, x7