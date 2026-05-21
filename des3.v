module des3 #(
	parameter WIDTH = 64
) (clk, reset, idata, key1, key2, key3, decrypt, valid_in, odata, valid_out);

	input clk;
	input reset;
	input [WIDTH-1:0] idata;
	input [WIDTH-1:0] key1, key2, key3;
	input decrypt;
	input valid_in;
	output [WIDTH-1:0] odata;
	output valid_out;

	wire [WIDTH-1:0] encrypt1_odata;
	wire [WIDTH-1:0] decrypt2_odata;
	wire encrypt1_valid_out;
	wire decrypt2_valid_out;
	wire [WIDTH-1:0] stage1_key;
	wire [WIDTH-1:0] stage3_key;

	assign stage1_key = decrypt ? key3 : key1;
	assign stage3_key = decrypt ? key1 : key3;

	feistel_algo #(.WIDTH(WIDTH)) encrypt1 
	(.clk(clk),
	 .reset(reset), 
	 .idata(idata), 
	 .key_in(stage1_key), 
	 .decrypt(decrypt), 
	 .valid_in(valid_in), 
	 .odata(encrypt1_odata), 
	 .valid_out(encrypt1_valid_out));

	feistel_algo #(.WIDTH(WIDTH)) decrypt2 
	(.clk(clk),
	 .reset(reset),
	 .idata(encrypt1_odata),
	 .key_in(key2),
	 .decrypt(!decrypt),
	 .valid_in(encrypt1_valid_out),
	 .odata(decrypt2_odata),
	 .valid_out(decrypt2_valid_out));
	
	feistel_algo #(.WIDTH(WIDTH)) encrypt3 
	(.clk(clk),
	 .reset(reset),
	 .idata(decrypt2_odata), 
	 .key_in(stage3_key), 
	 .decrypt(decrypt), 
	 .valid_in(decrypt2_valid_out), 
	 .odata(odata), 
	 .valid_out(valid_out));
  
endmodule
