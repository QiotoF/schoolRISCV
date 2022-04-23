            .text

start:      lui x1, 0xB92F0
            li  x2, 0x04A1
            or  x1, x1, x2  ## x1 = 0xB92F04A1

            lui x2, 0x40AC0
            li  x3, 0x8810
            or  x2, x2, x3  ##  x2 = 0x40AC8810
                            ## ~x2 = 0xBF5377EF

            andn x3, x1, x2 ## x3 = x1 andn x2 (expected 0xb90304a1)
