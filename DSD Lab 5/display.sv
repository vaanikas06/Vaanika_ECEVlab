module seg7(
	input logic[3:0] d,
	output logic[6:0] seg // active low, seg[0] = a ... seg[6] = g
);
	always_comb begin
		case (d)
			4'd0: seg = 7'b1000000;
			4'd1: seg = 7'b1111001;
			4'd2: seg = 7'b0100100;
			4'd3: seg = 7'b0110000;
			4'd4: seg = 7'b0011001;
			4'd5: seg = 7'b0010010;
			4'd6: seg = 7'b0000010;
			4'd7: seg = 7'b1111000;
			4'd8: seg = 7'b0000000;
			4'd9: seg = 7'b0010000;
			default: seg = 7'b1111111;
		endcase
	end
endmodule

module display(
	input logic[31:0] data_in,
	output logic[6:0] hex0, hex1, hex2 // ones, tens, hundreds
);
	logic[9:0] v;
	logic[3:0] ones, tens, hund;

	assign v = data_in[9:0];
	assign ones = v % 10;
	assign tens = (v / 10) % 10;
	assign hund = (v / 100) % 10;

	seg7 s0(.d(ones), .seg(hex0));
	seg7 s1(.d(tens), .seg(hex1));
	seg7 s2(.d(hund), .seg(hex2));
endmodule
