module des3 #(
	parameter WIDTH = 64;
) (
	idata, reset, odata
);
	input [WIDTH-1:0] idata;
	input reset;
	output [WIDTH-1:0] odata;

	reg [2:0] feistel_state;
    reg [1:0] des_state;
    reg [WIDTH-1:0] IP_data;
	wire clk;
	
	
	des_stage des_stage0(.clk(clk), .reset(reset), .des_stage(des_state), .feistel_stage(feistel_state));

    assign des_state = 2'b00;
    assign feistel_state = 4'b0000;
    assign IP_data = WIDTH'b0;

	always@(posedge clk or posedge reset) begin
		if (reset) begin
			
		end 
		else begin
			
		end
	end
    
	assign odata = IP_inv_data;
  
endmodule