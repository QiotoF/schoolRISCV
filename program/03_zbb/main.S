            .text

start:      lui x1, 0xB92F0
            li  x2, 0x04A1
            or  x1, x1, x2   ## x1 = 0xB92F04A1

            lui x2, 0x40AC0
            li  x3, 0x8810
            or  x2, x2, x3   ##  x2 = 0x40AC8810
                             ## ~x2 = 0xBF5377EF

            andn x3, x1, x2  ## x3 = x1 andn x2 (expected 0xb90304a1) CORRECT

            orn  x4, x1, x2  ## x4 = x1 orn x2 (expected 0xbf7f77ef) CORRECT

            xnor x5, x1, x2  ## x5 = x1 xnor x2 (expected 0x067c734f) CORRECT

            lui x6, 0x1d     ## x6 = 0x1d000

            clz x7, x6       ## x7 = clz(x6) (expected 0xf) CORRECT

            ctz x8, x6       ## x8 = ctz(x6) (expected 0xc) INCORRECT actual value = 0xd

            cpop x9, x1      ## x9 = cpop(x1) (expected 0xe) INCORRECT acutual value = 0x0

            
