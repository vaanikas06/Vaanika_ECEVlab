module data_memory(
	input logic clk,rst, 
	input logic[31:0] A, // address 
	input logic[31:0] WD, //input data 
	
	input logic WE, // enable input 
	output logic[31:0] RD, 
	output logic[31:0] prode // to check the data in the data memory 
);
	logic[31:0] mem[0:255];
	assign prode = mem[1];
	
	always_ff@(posedge clk or negedge rst)
	begin
		if(!rst) begin
			for(int i = 0; i <256; i++) mem[i] <= i; 
		end
		if (WE) mem[A] <= WD //async write 
	end
	// async read? 
	assign RD = mem[A]; 
endmodule 