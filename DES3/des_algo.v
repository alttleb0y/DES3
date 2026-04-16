module des_algo #(
    parameter WIDTH = 64
)(
    clk, reset, des_state, idata, odata
);
    input clk;
	 input reset;
    input [1:0] des_state;
    input [WIDTH-1:0] idata;
    output [WIDTH-1:0] odata;

    always@(posedge clk or posedge reset) begin
        if (reset) begin
            
        end else begin
            case(des_state)
				2'b00: begin
					// DES stage 1 E
				end
				2'b01: begin
                    // DES stage 2 D
				end
				2'b10: begin
					// DES stage 3 E
				end
			endcase
        end
    end
endmodule