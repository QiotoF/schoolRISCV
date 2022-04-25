/*
 * schoolRISCV - small RISC-V CPU 
 *
 * originally based on Sarah L. Harris MIPS CPU 
 *                   & schoolMIPS project
 * 
 * Copyright(c) 2017-2020 Stanislav Zhelnio 
 *                        Aleksandr Romanov 
 */ 

`timescale 1 ns / 100 ps

`include "sr_cpu.vh"
`include "zbb.vh"

`ifndef SIMULATION_CYCLES
    `define SIMULATION_CYCLES 120
`endif

module sm_testbench;

    // simulation options
    parameter Tt     = 20;

    reg         clk;
    reg         rst_n;
    reg  [ 4:0] regAddr;
    wire        cpuClk;

    // ***** DUT start ************************

    sm_top sm_top
    (
        .clkIn     ( clk     ),
        .rst_n     ( rst_n   ),
        .clkDevide ( 4'b0    ),
        .clkEnable ( 1'b1    ),
        .clk       ( cpuClk  ),
        .regAddr   ( 5'b0    ),
        .regData   (         )
    );

    defparam sm_top.sm_clk_divider.bypass = 1;

    // ***** DUT  end  ************************

`ifdef ICARUS
    //iverilog memory dump init workaround
    initial $dumpvars;
    genvar k;
    for (k = 0; k < 32; k = k + 1) begin
        initial $dumpvars(0, sm_top.sm_cpu.rf.rf[k]);
    end
`endif

    // simulation init
    initial begin
        clk = 0;
        forever clk = #(Tt/2) ~clk;
    end

    initial begin
        rst_n   = 0;
        repeat (4)  @(posedge clk);
        rst_n   = 1;
    end

    task disasmInstr;

        reg [ 6:0] cmdOp;
        reg [ 4:0] rd;
        reg [ 2:0] cmdF3;
        reg [ 4:0] rs1;
        reg [ 4:0] rs2;
        reg [ 6:0] cmdF7;
        reg [31:0] immI;
        reg signed [31:0] immB;
        reg [31:0] immU;
        reg [4:0]  shamt;

    begin
        cmdOp = sm_top.sm_cpu.cmdOp;
        rd    = sm_top.sm_cpu.rd;
        cmdF3 = sm_top.sm_cpu.cmdF3;
        rs1   = sm_top.sm_cpu.rs1;
        rs2   = sm_top.sm_cpu.rs2;
        cmdF7 = sm_top.sm_cpu.cmdF7;
        immI  = sm_top.sm_cpu.immI;
        immB  = sm_top.sm_cpu.immB;
        immU  = sm_top.sm_cpu.immU;
        shamt = immI[4:0];

        $write("   ");
        casex( { immI, cmdF7, cmdF3, cmdOp } )
            default :                                $write ("new/unknown");
            { `ZBBIMMI_X, `RVF7_ADD,  `RVF3_ADD,  `RVOP_ADD  } : $write ("add   $%1d, $%1d, $%1d", rd, rs1, rs2);
            { `ZBBIMMI_X, `RVF7_OR,   `RVF3_OR,   `RVOP_OR   } : $write ("or    $%1d, $%1d, $%1d", rd, rs1, rs2);
            { `ZBBIMMI_X, `RVF7_SRL,  `RVF3_SRL,  `RVOP_SRL  } : $write ("srl   $%1d, $%1d, $%1d", rd, rs1, rs2);
            { `ZBBIMMI_X, `RVF7_SLTU, `RVF3_SLTU, `RVOP_SLTU } : $write ("sltu  $%1d, $%1d, $%1d", rd, rs1, rs2);
            { `ZBBIMMI_X, `RVF7_SUB,  `RVF3_SUB,  `RVOP_SUB  } : $write ("sub   $%1d, $%1d, $%1d", rd, rs1, rs2);

            { `ZBBIMMI_X, `RVF7_ANY,  `RVF3_ADDI, `RVOP_ADDI } : $write ("addi  $%1d, $%1d, 0x%8h",rd, rs1, immI);
            { `ZBBIMMI_X, `RVF7_ANY,  `RVF3_ANY,  `RVOP_LUI  } : $write ("lui   $%1d, 0x%8h",      rd, immU);

            { `ZBBIMMI_X, `RVF7_ANY,  `RVF3_BEQ,  `RVOP_BEQ  } : $write ("beq   $%1d, $%1d, 0x%8h (%1d)", rs1, rs2, immB, immB);
            { `ZBBIMMI_X, `RVF7_ANY,  `RVF3_BNE,  `RVOP_BNE  } : $write ("bne   $%1d, $%1d, 0x%8h (%1d)", rs1, rs2, immB, immB);

            { `ZBBIMMI_X, `ZBBF7_ANDN, `ZBBF3_ANDN, `ZBBOP_ANDN } : $write ("andn $%1d, $%1d, $%1d", rd, rs1, rs2);
            { `ZBBIMMI_X, `ZBBF7_ORN,  `ZBBF3_ORN,  `ZBBOP_ORN  } : $write ("orn  $%1d, $%1d, $%1d", rd, rs1, rs2);
            { `ZBBIMMI_X, `ZBBF7_XNOR, `ZBBF3_XNOR, `ZBBOP_XNOR } : $write ("xnor $%1d, $%1d, $%1d", rd, rs1, rs2);

            { `ZBBIMMI_CLZ, `ZBBF7_X,  `ZBBF3_CLZ,  `ZBBOP_CLZ }  : $write ("clz $%1d, $%1d", rd, rs1);
            { `ZBBIMMI_CTZ, `ZBBF7_X,  `ZBBF3_CTZ,  `ZBBOP_CTZ }  : $write ("ctz $%1d, $%1d", rd, rs1);

            { `ZBBIMMI_CPOP, `ZBBF7_X, `ZBBF3_CPOP, `ZBBOP_CPOP } : $write ("cpop $%1d, $%1d", rd, rs1);

            { `ZBBIMMI_X, `ZBBF7_MAX,  `ZBBF3_MAX,  `ZBBOP_MAX }  : $write ("max  $%1d, $%1d, $%1d", rd, rs1, rs2);
            { `ZBBIMMI_X, `ZBBF7_MAXU, `ZBBF3_MAXU, `ZBBOP_MAXU } : $write ("maxu  $%1d, $%1d, $%1d", rd, rs1, rs2);
            { `ZBBIMMI_X, `ZBBF7_MIN,  `ZBBF3_MIN,  `ZBBOP_MIN }  : $write ("min  $%1d, $%1d, $%1d", rd, rs1, rs2);
            { `ZBBIMMI_X, `ZBBF7_MINU, `ZBBF3_MINU, `ZBBOP_MINU } : $write ("minu  $%1d, $%1d, $%1d", rd, rs1, rs2);

            { `ZBBIMMI_SEXTB, `ZBBF7_X,`ZBBF3_SEXTB,`ZBBOP_SEXTB} : $write ("sext.b $%1d, $%1d", rd, rs1);
            { `ZBBIMMI_SEXTH, `ZBBF7_X,`ZBBF3_SEXTH,`ZBBOP_SEXTH} : $write ("sext.h $%1d, $%1d", rd, rs1);
            { `ZBBIMMI_ZEXTH, `ZBBF7_X,`ZBBF3_ZEXTH,`ZBBOP_ZEXTH} : $write ("zext.h $%1d, $%1d", rd, rs1);

            { `ZBBIMMI_X, `ZBBF7_ROL,  `ZBBF3_ROL,  `ZBBOP_ROL  } : $write ("rol $%1d, $%1d, $%1d", rd, rs1, rs2);
            { `ZBBIMMI_X, `ZBBF7_ROR,  `ZBBF3_ROR,  `ZBBOP_ROR  } : $write ("ror $%1d, $%1d, $%1d", rd, rs1, rs2);
            { `ZBBIMMI_X, `ZBBF7_RORI, `ZBBF3_RORI, `ZBBOP_RORI } : $write ("rori $%1d, $%1d, %1d", rd, rs1, shamt);

            { `ZBBIMMI_ORCB, `ZBBF7_X, `ZBBF3_ORCB, `ZBBOP_ORCB } : $write ("orc.b $%1d, $%1d", rd, rs1);

            { `ZBBIMMI_REV8, `ZBBF7_X, `ZBBF3_REV8, `ZBBOP_REV8 } : $write ("rev8 $%1d, $%1d", rd, rs1);

        endcase
    end
    endtask


    //simulation debug output
    integer cycle; initial cycle = 0;

    always @ (posedge clk)
    begin
        $write ("%5d  pc = %2h instr = %h   a0 = %1d", 
                  cycle, sm_top.sm_cpu.pc, sm_top.sm_cpu.instr, sm_top.sm_cpu.rf.rf[10]);

        disasmInstr();

        $write("\n");

        cycle = cycle + 1;

        if (cycle > `SIMULATION_CYCLES)
        begin
            cycle = 0;
            $display ("Timeout");
            $stop;
        end
    end

endmodule
