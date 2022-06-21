# schoolRISCV Zbb - Basic Bit Manipulation Unit extension added

[Original schoolRISCV project](https://github.com/zhelnio/schoolRISCV)

This project adds the Basic Bit Manipulation Unit (BBMU) to the schoolRISCV CPU. The BBMU implements the [Zbb extension](https://github.com/riscv/riscv-bitmanip/releases/download/1.0.0/bitmanip-1.0.0.pdf) of the RISC-V Instruction Set Architecture.

The picture below illustrates the modified datapath of the schoolRISCV core.
![schoolRISCV](https://user-images.githubusercontent.com/27900888/174551696-2ef58b53-098f-41be-b09c-2fedb775acb9.jpg)

The BBMU supports following instructions:
- andn, orn, xnor
- clz, ctz
- cpop
- max, maxu, min, minu
- sext.b, sext.h, zext.h
- rol, ror, rori
- orc.b
- rev8

The benchmarks directory contains a set of small benchmark programs that can be compiled with *-march=rv32i_zbb* compiler option to demonstrate real world applications of basic bit manipulation instructions.

## RARS

The project includes modifications to the [RARS open-source Assembler and Runtime Simulator](https://github.com/TheThirdOne/rars) which is used in the schoolRISCV project to convert assembly code to low-level machine code. Modifications include adding Zbb instructions support.
