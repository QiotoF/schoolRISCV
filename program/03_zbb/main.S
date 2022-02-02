            .text

start:      addi x5, zero, 0xA8
            addi x6, zero, 0xF1
            andn x7, x5, x6
            orn  x9, x5, x6
            xnor x10,x5, x6
            clz  x8,  x7
            ctz  x11, x7