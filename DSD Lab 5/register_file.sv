module register_file(input logic clk, rst,
	input logic[4:0] A1, A2, A3, // A1, A2 are read addresses, A3 is a write address 
	input logic[31:0] WD3, // write port 
	input logic WE3, //write enable 
	output logic[31:0] RD1,
	output logic[31:0] RD2,
	output logic[31:0] prode
);

	logic [31:0] rf_regs [0:31]; // defined as an array of type reg[31:0] and then an array of 32 of those with name rf_regs
	assign prode = rf_regs[1];	
	// synchronous write -- x0 stays zero which means waddr = 
	always_ff@(posedge clk or negedge rst) begin
		if (!rst) for(int i=0;i<32;i=i+1) rf_regs[i] = i;
		if (WE3) rf_regs[A3] <= WD3; 
	end
	//async read data
assign RD1=(A1 == 0) ? 0 : rf_regs[A1]; // can't use = instead of 
assign RD2=(A2 == 0) ? 0 : rf_regs[A2];
//	assign RD2 = rf_regs[A1];
endmodule
