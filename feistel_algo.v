module feistel_algo #(
    parameter WIDTH = 64;
)(
    clk, feistel_state, ldata, rdata, odata
);
    input [WIDTH/2-1:0] ldata, rdata;
    input clk;
    input [3:0] feistel_state;
    output [WIDTH/2-1:0] odata;
    
    wire [WIDTH/2-1:0] L0, R0, L1, R1, L2, R2, L3, R3, L4, R4, L5, R5, L6, R6, L7, R7,
                        L8, R8, L9, R9, L10, R10, L11, R11, L12, R12, L13, R13, L14, R14, L15, R15;

    key_scheduler iKS(.feistel_state(feistel_state), .idata({L0, R0}), .odata(K));
    always @(posedge clk) begin
        case(feistel_state)
            4'b0000 : begin
                IP iIP(.idata({ldata, rdata}), .odata({L0, R0}));
                E iE(.in(R0), .out(R0_E));
                S iS(.in(R0_E ^ K), .out(S_out));
                P iP(.in(S_out), .out(P_out));
                assign R1 = L0 ^ P_out;
                assign L1 = R0;
            end
        endcase
    end
endmodule