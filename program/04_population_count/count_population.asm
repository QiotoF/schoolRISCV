	li t1, 0x667
	li t3, 0x1
	li s0, 0x0
loop:   andi t2, t1, 0x1
	add s0, s0, t2
	srl t1, t1, t3
	bnez t1, loop
