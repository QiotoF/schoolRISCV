`include "zbb.vh"

module zbb (
    input [31:0] din_rs1,
    input [31:0] din_rs2,
    input [6:0] cmdOp,
    input [2:0] cmdF3,
    input [6:0] cmdF7,
    output reg [31:0] dout_rd,
    output reg isZbbInstr,
    output reg regWrite
);
    wire [31:0] andn = din_rs1 & ~din_rs2;

    reg [31:0] clz;
    reg oneMet;

    integer i;

    always @ (*) begin
        isZbbInstr = 1'b1;
        regWrite = 1'b1;
        oneMet = 1'b0;
    
        clz = 32'b0;
        for (i = 31; i >= 0; i = i - 1)
            if (!oneMet & !din_rs1[i]) clz = clz + 1;
            else oneMet = 1'b1;

        casez( {cmdF7, cmdF3, cmdOp} )
            { `ZBBF7_ANDN, `ZBBF3_ANDN, `ZBBOP_ANDN } : dout_rd = andn;
            { `ZBBF7_CLZ,  `ZBBF3_CLZ,  `ZBBOP_CLZ  } : dout_rd = clz;
            default : begin isZbbInstr = 1'b0; regWrite = 1'b0; end
        endcase
    end

endmodule
