module Flags(input clk, rst, Z, OV, N, input[1:0] Mode, input [1:0] Update, output reg z, ov, n);

//two sets of flags, one used in interruption handler and one used in user
//mode
//Flags used in interruption handler will be reset when mode resume to user

reg Z_I, O_I, N_I, Z_U, O_U, N_U;

// update flags
	always @(posedge clk, posedge rst) begin
		if (rst | ~|Mode) begin
			Z_I <= 0;
			O_I <= 0;
			N_I <= 0;
			Z_U <= 0;
			O_U <= 0;
			N_U <= 0;
		end
		else if (Mode == 2'b01) begin
			Z_U <= (Update[1])? Z: Z_U;
			O_U <= (Update[0])? OV: O_U;
			N_U <= (Update[0])? N: N_U ;
			Z_I <= 0;
			O_I <= 0;
			N_I <= 0;
		end
		else begin
			Z_U <= Z_U;
			O_U <= O_U;
			N_U <= N_U;
			Z_I <= (Update[1])? Z: Z_I;
			O_I <= (Update[0])? OV: O_I;
			N_I <= (Update[0])? N: N_I ;
		end
	end

// Output flags
always @(posedge clk, posedge rst) begin
	if (rst| ~|Mode) begin
		z <= 0;
		ov <= 0;
		n <= 0;
	end
	else if (Mode == 2'b01) begin
		z <= Z_U;
		ov <= O_U;
		n <= N_U;
	end
	else begin
		z <= Z_I;
		ov <= O_I;
		n <= N_I;
	end
end
endmodule
