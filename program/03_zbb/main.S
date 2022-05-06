            .text

start:      lui x1, 0xB92F0
            li  x2, 0x04A1
            or  x1, x1, x2   ## x1 = 0xB92F04A1

            lui x2, 0x40AC0
            li  x3, 0x8810
            or  x2, x2, x3   ##  x2 = 0x40AC8810
                             ## ~x2 = 0xBF5377EF

            ## x3 = x1 andn x2
            ## expected 0xb90304a1 
            ## CORRECT
            andn x3, x1, x2

            ## x4 = x1 orn x2
            ## expected 0xbf7f77ef 
            ## CORRECT
            orn  x4, x1, x2

            ## x5 = x1 xnor x2
            ## expected 0x067c734f 
            ## CORRECT
            xnor x5, x1, x2

            lui x6, 0x1d     ## x6 = 0x1d000

            ## x7 = clz(x6) 
            ## expected 0xf 
            ## CORRECT
            clz x7, x6       

            ## x8 = ctz(x6)
            ## expected 0xc
            ## CORRECT
            ctz x8, x6

            ## x9 = cpop(x1)
            ## expected 0xe
            ## CORRECT
            cpop x9, x1

            ## x10 = max(x1, x2)
            ## expected 0x40AC8810 
            ## CORRECT
            max  x10, x1, x2

            ## x11 = maxu(x1, x2) 
            ## expected 0xB92F04A1 
            ## CORRECT
            maxu x11, x1, x2

            ## x12 = min(x1, x2)  
            ## expected 0xB92F04A1 
            ## CORRECT
            min  x12, x1, x2

            ## x13 = minu(x1, x2)
            ## expected 0x40AC8810)
            ## CORRECT
            minu x13, x1, x2

            ## sign-extend least significant byte
            ## expected 0xffffffa1
            ## CORRECT
            sext.b x14, x1  

            ## sign-extend least significant half-word
            ## expected 0x4a1
            ## CORRECT
            sext.h x15, x1

            ## zero-extend least significant half-word
            ## expected 0x4a1
            ## CORRECT
            zext.h x16, x1

            ## rotate x1 left by x17
            ## expected 0x25e09437
            ## CORRECT
            li  x17, 0x5
            rol x18, x1, x17

            ## rotate x1 right by x17
            ## expected 0xdc97825
            ## CORRECT
            ror x19, x1, x17

            ## rotate x1 right by immediate
            ## expected 0xdc97825
            ## CORRECT
            rori x20, x1, 0x5

            ## bitwise OR-Combine
            ## expected 0x00FFFF00
            ## CORRECT
            orc.b x21, x6

            ## bit-reverse x1
            ## expected 0xa1042fb9
            ## CORRECT
            rev8 x22, x1



