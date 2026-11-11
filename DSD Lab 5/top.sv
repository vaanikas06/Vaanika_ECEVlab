module top(
    input logic clk, rst,
    input logic[2:0] sw, // 0 idle, 1 add, 2 sub, 3 lw, 4 sw
    output logic[31:0] ALUResult,
    output logic[31:0] RD1, RD2,
    output logic[31:0] prode_register_file,
    output logic[31:0] prode_data_memory,
    output logic[6:0] hex0, hex1, hex2, // prode_register_file (ones, tens, hundreds)
    output logic[6:0] hex3, hex4, hex5  // prode_data_memory (ones, tens, hundreds)
);

// in-lab, board number 542: first digit = 5, last digit = 2
logic[31:0] inst_0 = 32'b0;
logic[31:0] inst_1 = 32'b100100_00010_00101_00001_0000_0000_000; // add rf[2] + rf[5] -> rf[1] (7)
logic[31:0] inst_2 = 32'b101100_00101_00011_01010_0000_0000_000; // sub rf[5] - rf[3] -> rf[10] (2)
logic[31:0] inst_3 = 32'b010101_00000_00001_0000_0000_0000_0101; // lw dm[0+5] -> rf[1] (5)
logic[31:0] inst_4 = 32'b010100_00000_00010_0000_0000_0000_0010; // sw rf[2] -> dm[0+2] (2)
logic[31:0] inst_ex;

assign inst_ex = (sw==1) ? inst_1 :
                 (sw==2) ? inst_2 :
                 (sw==3) ? inst_3 :
                 (sw==4) ? inst_4 : inst_0;

// op = {RegDst, ALUSrc, ALUControl[2:0], MemtoReg}
logic RegDst, ALUSrc, MemtoReg, MemWrite, RegWrite;
logic[2:0] ALUControl;
assign RegDst     = inst_ex[31];
assign ALUSrc     = inst_ex[30];
assign ALUControl = inst_ex[29:27];
assign MemtoReg   = inst_ex[26];
assign MemWrite   = (inst_ex[31:26] == 6'b010100); // sw is the only store
assign RegWrite   = ~MemWrite;
logic[4:0] WriteReg;
logic[31:0] SignImm, SrcB, dm_RD, Result;
logic[31:0] prode10, rf_disp;

sign_extend se(.Imm(inst_ex[15:0]), .SignImm(SignImm));

MUX_RegDst m_rd(.RegDst(RegDst), .rt(inst_ex[20:16]), .rd(inst_ex[15:11]), .WriteReg(WriteReg));

register_file  r_f(.clk(clk), .rst(rst),
    .A1(inst_ex[25:21]), .A2(inst_ex[20:16]), .A3(WriteReg),
    .WD3(Result),
    .WE3(RegWrite),
    .RD1(RD1), .RD2(RD2),
    .prode(prode_register_file),
    .prode10(prode10)
);

MUX_ALUSrc m_as(.ALUSrc(ALUSrc), .RD2(RD2), .SignImm(SignImm), .SrcB(SrcB));

ALU t1(.SrcA(RD1), .SrcB(SrcB), .ALUControl(ALUControl), .ALUResult(ALUResult));

data_memory d_m(.clk(clk), .rst(rst),
    .A(ALUResult), .WD(RD2), .WE(MemWrite),
    .RD(dm_RD),
    .prode(prode_data_memory)
);

MUX_MemtoReg m_mr(.MemtoReg(MemtoReg), .ALUResult(ALUResult), .RD(dm_RD), .MemtoReg_out(Result));

// sub result lives in rf[10], everything else shows rf[1]
assign rf_disp = (sw==2) ? prode10 : prode_register_file;

display t2(.data_in(rf_disp), .hex0(hex0), .hex1(hex1), .hex2(hex2));
display t3(.data_in(prode_data_memory), .hex0(hex3), .hex1(hex4), .hex2(hex5));

endmodule
