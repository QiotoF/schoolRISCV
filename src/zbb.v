`include "zbb.vh"

module zbb (
    input [31:0] din_rs1,
    input [31:0] din_rs2,
    input [6:0] cmdOp,
    input [2:0] cmdF3,
    input [6:0] cmdF7,
    output reg [31:0] dout_rd,
    output isZbbInstr
);

    reg isZbb = 1'b1;
    assign isZbbInstr = isZbb;

    wire [31:0] andn = din_rs1 & ~din_rs2;

    always @ (*) begin
        casez( {cmdF7, cmdF3, cmdOp} )
            { `ZBBF7_ANDN, `ZBBF3_ANDN, `ZBBOP_ANDN } : dout_rd = andn;
            default : isZbb = 1'b0;
        endcase
    end

endmodule
