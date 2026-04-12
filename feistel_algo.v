module feistel_algo #(
    parameter WIDTH = 64
)(
    clk, reset, idata, key_in, decrypt, valid_in, odata, valid_out
);
    input clk;
    input reset;
    input [WIDTH-1:0] idata;
    input [WIDTH-1:0] key_in;
    input decrypt;
    input valid_in;
    output reg [WIDTH-1:0] odata;
    output reg valid_out;

    reg [31:0] L [15:0];
    reg [31:0] R [15:0];
    reg [17:0] V;
    wire [47:0] K [15:0];
    wire [63:0] ip_out;
    wire [63:0] ip_inv_out;
    wire [31:0] f_out [15:0];
    
    IP ip(.in(idata), .out(ip_out));
    IP_inv ip_inv(.in({R[15], L[15]}), .out(ip_inv_out));
    
    generate
        genvar g;
        for(g = 0; g < 16; g++) begin : key_gen
            key_scheduler ks(.feistel_state(g[3:0]), .key_in(key_in), .decrypt(decrypt), .K_out(K[g]));
            f f_inst (.R(R[g]), .K(K[g]), .out(f_out[g]));
        end
    endgenerate

    integer i;
    always @(posedge clk or posedge reset) begin
        if(reset) begin
            V[17:0] <= 18'b0;
            odata <= 64'b0;
            valid_out <= 1'b0;
            for(i = 0; i < 16; i = i + 1) begin : pipeline_reset
                L[i] <= 32'b0;
                R[i] <= 32'b0;
            end
        end
        else begin
            L[0][31:0] <= ip_out[63:32];
            R[0][31:0] <= ip_out[31:0];
            V[0] <= valid_in;

            for(i = 1; i < 16; i = i + 1) begin : pipeline_compute
                L[i] <= R[i-1];
                R[i] <= L[i-1] ^ f_out[i-1];
                V[i] <= V[i-1];
            end

            odata <= ip_inv_out;
            valid_out <= V[15];
        end
    end
    
endmodule