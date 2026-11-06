module ALU(
	input logic[31:0] SrcA, 
	input logic[31:0] SrcB, 
	input logic[2:0] ALUControl,
	output logic[31:0] ALUResult
	);
	
	always @(*) begin
		if (ALUControl == 3'b010) // add 
			ALUResult = SrcA + SrcB; 
		else // sub
			ALUResult = SrcA - SrcB; 
	end 
	
	
	endmodule