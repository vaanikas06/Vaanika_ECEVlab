module MUX_RegDst(
	input logic RegDst,
	input logic[4:0] rt, // inst[20:16]
	input logic[4:0] rd, // inst[15:11]
	output logic[4:0] WriteReg
);
	assign WriteReg = RegDst ? rd : rt;
endmodule