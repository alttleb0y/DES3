module des_algo #(
    parameter WIDTH = 64;
)(
    clk, reset, idata, odata
);
    input clk;
    input [WIDTH-1:0] idata;
    output [WIDTH-1:0] odata;

    wire [WIDTH/2-1:0] L0, R0, L1, R1, L2, R2, L3, R3, L4, R4, L5, R5, L6, R6, L7, R7,
                        L8, R8, L9, R9, L10, R10, L11, R11, L12, R12, L13, R13, L14, R14, L15, R15;

    always@(posedge clk or posedge reset) begin
        if (reset) begin
            
        end else begin
            case(feistel_state)
				3'b000: begin
					IP iIP(.in(idata), .out(IP_data));
                    assign L0 <= IP_data[63:32];
                    assign R0 <= IP_data[31:0];
				end
				3'b001: begin
                    // Feistel stage 2
				end
				3'b111: begin
					// DONE
				end
			endcase
        end
    end
endmodule