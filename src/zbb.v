`include "zbb.vh"

module zbb (
    input [31:0] din_rs1,
    input [31:0] din_rs2,
    input [6:0]  cmdOp,
    input [2:0]  cmdF3,
    input [6:0]  cmdF7,
    input [11:0] immI,
    output reg [31:0] dout_rd,
    output reg isZbbInstr,
    output reg regWrite
);
    wire [31:0] andn = din_rs1 & ~din_rs2;
    wire [31:0] orn  = din_rs1 | ~din_rs2;
    wire [31:0] xnor_ = ~din_rs1 ^ din_rs2;

    // max min
    wire aLargerB = $signed(din_rs1) > $signed(din_rs2);
    wire [31:0] max = aLargerB ? din_rs1 : din_rs2;
    wire [31:0] min = aLargerB ? din_rs2 : din_rs1;

    // maxu minu
    wire aLargerBUnsigned = din_rs1 > din_rs2;
    wire [31:0] maxu = aLargerBUnsigned ? din_rs1 : din_rs2;
    wire [31:0] minu = aLargerBUnsigned ? din_rs2 : din_rs1;

    // sext.b
    wire [31:0] sextB = { {24{ din_rs1[7] }}, din_rs1[7:0] };

    // sext.h
    wire [31:0] sextH = { {16{ din_rs1[15] }}, din_rs1[15:0] };

    // zext.h
    wire [31:0] zextH = { {16{ 1'b0 }}, din_rs1[15:0] };

    // rol ror
    wire [4:0] shamt = din_rs2[4:0];
    wire [63:0] rolTemp = { din_rs1, din_rs1 } << shamt;
    wire [31:0] rol = rolTemp[63:32];
    wire [63:0] rorTemp = { din_rs1, din_rs1 } >> shamt;
    wire [31:0] ror = rorTemp[31:0];

    // rori
    wire [4:0] shamtImm = immI[4:0];
    wire [63:0] rorImmTemp = { din_rs1, din_rs1 } >> shamt;
    wire [31:0] rori = rorImmTemp[31:0];

    reg [31:0] clz;
    reg clzOneMet;
    reg [31:0] ctz;
    reg ctzOneMet;

    reg [7:0] popCount;

    integer i;

    always @ (*) begin
        isZbbInstr = 1'b1;
        regWrite   = 1'b1;
        clzOneMet  = 1'b0;
        ctzOneMet  = 1'b0;
    
        clz = 32'b0;
        for (i = 31; i >= 0; i = i - 1)
            if (!clzOneMet & !din_rs1[i]) clz = clz + 1;
            else clzOneMet = 1'b1;
        
        ctz = 32'b0;
        for (i = 0; i < 32; i = i + 1)
            if (!ctzOneMet & !din_rs1[i]) ctz = ctz + 1;
            else ctzOneMet = 1'b1;

        popCount = 0;
        for (i = 0; i < 32; i = i + 1)
            popCount = popCount + din_rs1[i];

        casex( {immI, cmdF7, cmdF3, cmdOp} )
            { `ZBBIMMI_X, `ZBBF7_ANDN, `ZBBF3_ANDN, `ZBBOP_ANDN } : dout_rd = andn;
            { `ZBBIMMI_X, `ZBBF7_ORN,  `ZBBF3_ORN,  `ZBBOP_ORN  } : dout_rd = orn;
            { `ZBBIMMI_X, `ZBBF7_XNOR, `ZBBF3_XNOR, `ZBBOP_XNOR } : dout_rd = xnor_;
            { `ZBBIMMI_CLZ, `ZBBF7_X,  `ZBBF3_CLZ,  `ZBBOP_CLZ }  : dout_rd = clz;
            { `ZBBIMMI_CTZ, `ZBBF7_X,  `ZBBF3_CTZ,  `ZBBOP_CTZ }  : dout_rd = ctz;
            { `ZBBIMMI_CPOP, `ZBBF7_X, `ZBBF3_CPOP, `ZBBOP_CPOP } : dout_rd = popCount;
            { `ZBBIMMI_X, `ZBBF7_MAX,  `ZBBF3_MAX,  `ZBBOP_MAX }  : dout_rd = max;
            { `ZBBIMMI_X, `ZBBF7_MAXU, `ZBBF3_MAXU, `ZBBOP_MAXU } : dout_rd = maxu;
            { `ZBBIMMI_X, `ZBBF7_MIN,  `ZBBF3_MIN,  `ZBBOP_MIN }  : dout_rd = min;
            { `ZBBIMMI_X, `ZBBF7_MINU, `ZBBF3_MINU, `ZBBOP_MINU } : dout_rd = minu;
            { `ZBBIMMI_SEXTB, `ZBBF7_X,`ZBBF3_SEXTB,`ZBBOP_SEXTB} : dout_rd = sextB;
            { `ZBBIMMI_SEXTH, `ZBBF7_X,`ZBBF3_SEXTH,`ZBBOP_SEXTH} : dout_rd = sextH;
            { `ZBBIMMI_ZEXTH, `ZBBF7_X,`ZBBF3_ZEXTH,`ZBBOP_ZEXTH} : dout_rd = zextH;
            { `ZBBIMMI_X, `ZBBF7_ROL,  `ZBBF3_ROL,  `ZBBOP_ROL  } : dout_rd = rol;
            { `ZBBIMMI_X, `ZBBF7_ROR,  `ZBBF3_ROR,  `ZBBOP_ROR  } : dout_rd = ror;
            { `ZBBIMMI_X, `ZBBF7_RORI, `ZBBF3_RORI, `ZBBOP_RORI } : dout_rd = rori;

            default : begin isZbbInstr = 1'b0; regWrite = 1'b0; end
        endcase
    end

endmodule
