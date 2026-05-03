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

    reg [WIDTH-1:0] key_in1, key_in2;
    reg decrypt1, decrypt2;
    reg V_buf;
    reg [31:0] L_buf, R_buf;
    reg [31:0] L [16:0];
    reg [31:0] R [16:0];
    reg [16:0] V;
    wire [47:0] K [15:0];
    wire [63:0] ip_out;
    wire [63:0] ip_inv_out;
    wire [31:0] f_out [15:0];
    
    IP ip(.in(idata), .out(ip_out));
    IP_inv ip_inv(.in({R[16], L[16]}), .out(ip_inv_out));

    key_scheduler #(.ROUND(4'd0)) ks0 (.key_in(key_in1), .decrypt(decrypt1), .K_out(K[0]));
    key_scheduler #(.ROUND(4'd1)) ks1 (.key_in(key_in1), .decrypt(decrypt1), .K_out(K[1]));
    key_scheduler #(.ROUND(4'd2)) ks2 (.key_in(key_in1), .decrypt(decrypt1), .K_out(K[2]));
    key_scheduler #(.ROUND(4'd3)) ks3 (.key_in(key_in1), .decrypt(decrypt1), .K_out(K[3]));
    key_scheduler #(.ROUND(4'd4)) ks4 (.key_in(key_in1), .decrypt(decrypt1), .K_out(K[4]));
    key_scheduler #(.ROUND(4'd5)) ks5 (.key_in(key_in1), .decrypt(decrypt1), .K_out(K[5]));
    key_scheduler #(.ROUND(4'd6)) ks6 (.key_in(key_in1), .decrypt(decrypt1), .K_out(K[6]));
    key_scheduler #(.ROUND(4'd7)) ks7 (.key_in(key_in1), .decrypt(decrypt1), .K_out(K[7]));
    key_scheduler #(.ROUND(4'd8)) ks8 (.key_in(key_in2), .decrypt(decrypt2), .K_out(K[8]));
    key_scheduler #(.ROUND(4'd9)) ks9 (.key_in(key_in2), .decrypt(decrypt2), .K_out(K[9]));
    key_scheduler #(.ROUND(4'd10)) ks10 (.key_in(key_in2), .decrypt(decrypt2), .K_out(K[10]));
    key_scheduler #(.ROUND(4'd11)) ks11 (.key_in(key_in2), .decrypt(decrypt2), .K_out(K[11]));
    key_scheduler #(.ROUND(4'd12)) ks12 (.key_in(key_in2), .decrypt(decrypt2), .K_out(K[12]));
    key_scheduler #(.ROUND(4'd13)) ks13 (.key_in(key_in2), .decrypt(decrypt2), .K_out(K[13]));
    key_scheduler #(.ROUND(4'd14)) ks14 (.key_in(key_in2), .decrypt(decrypt2), .K_out(K[14]));
    key_scheduler #(.ROUND(4'd15)) ks15 (.key_in(key_in2), .decrypt(decrypt2), .K_out(K[15]));

    f f0 (.R(R[0]), .K(K[0]), .out(f_out[0]));
    f f1 (.R(R[1]), .K(K[1]), .out(f_out[1]));
    f f2 (.R(R[2]), .K(K[2]), .out(f_out[2]));
    f f3 (.R(R[3]), .K(K[3]), .out(f_out[3]));
    f f4 (.R(R[4]), .K(K[4]), .out(f_out[4]));
    f f5 (.R(R[5]), .K(K[5]), .out(f_out[5]));
    f f6 (.R(R[6]), .K(K[6]), .out(f_out[6]));
    f f7 (.R(R[7]), .K(K[7]), .out(f_out[7]));
    f f8 (.R(R[8]), .K(K[8]), .out(f_out[8]));
    f f9 (.R(R[9]), .K(K[9]), .out(f_out[9]));
    f f10(.R(R[10]), .K(K[10]), .out(f_out[10]));
    f f11(.R(R[11]), .K(K[11]), .out(f_out[11]));
    f f12(.R(R[12]), .K(K[12]), .out(f_out[12]));
    f f13(.R(R[13]), .K(K[13]), .out(f_out[13]));
    f f14(.R(R[14]), .K(K[14]), .out(f_out[14]));
    f f15(.R(R[15]), .K(K[15]), .out(f_out[15]));

    integer i;
    always @(posedge clk or posedge reset) begin        
        if(reset) begin
            V[16:0] <= 17'b0;
            odata <= 64'b0;
            valid_out <= 1'b0;            
            L[0] <= 32'b0; R[0] <= 32'b0;
            L[0] <= 32'b0; R[0] <= 32'b0;
            L[1] <= 32'b0; R[1] <= 32'b0;
            L[2] <= 32'b0; R[2] <= 32'b0;
            L[3] <= 32'b0; R[3] <= 32'b0;
            L[4] <= 32'b0; R[4] <= 32'b0;
            L[5] <= 32'b0; R[5] <= 32'b0;
            L[6] <= 32'b0; R[6] <= 32'b0;
            L[7] <= 32'b0; R[7] <= 32'b0;
            L[8] <= 32'b0; R[8] <= 32'b0;
            L[9] <= 32'b0; R[9] <= 32'b0;
            L[10] <= 32'b0; R[10] <= 32'b0;
            L[11] <= 32'b0; R[11] <= 32'b0;
            L[12] <= 32'b0; R[12] <= 32'b0;
            L[13] <= 32'b0; R[13] <= 32'b0;
            L[14] <= 32'b0; R[14] <= 32'b0;
            L[15] <= 32'b0; R[15] <= 32'b0;
            R[16] <= 32'b0; L[16] <= 32'b0;
        end
        else begin
            key_in1 <= key_in;
            key_in2 <= key_in;
            decrypt1 <= decrypt;
            decrypt2 <= decrypt;
            V_buf <= valid_in;
            L_buf <= ip_out[63:32];
            R_buf <= ip_out[31:0];

            L[0][31:0] <= L_buf;
            R[0][31:0] <= R_buf;
            V[0] <= V_buf;

            L[1] <= R[0];       R[1] <= L[0] ^ f_out[0];        V[1] <= V[0];
            L[2] <= R[1];       R[2] <= L[1] ^ f_out[1];        V[2] <= V[1];
            L[3] <= R[2];       R[3] <= L[2] ^ f_out[2];        V[3] <= V[2];
            L[4] <= R[3];       R[4] <= L[3] ^ f_out[3];        V[4] <= V[3];
            L[5] <= R[4];       R[5] <= L[4] ^ f_out[4];        V[5] <= V[4];
            L[6] <= R[5];       R[6] <= L[5] ^ f_out[5];        V[6] <= V[5];
            L[7] <= R[6];       R[7] <= L[6] ^ f_out[6];        V[7] <= V[6];
            L[8] <= R[7];       R[8] <= L[7] ^ f_out[7];        V[8] <= V[7];
            L[9] <= R[8];       R[9] <= L[8] ^ f_out[8];        V[9] <= V[8];
            L[10] <= R[9];      R[10] <= L[9] ^ f_out[9];       V[10] <= V[9];
            L[11] <= R[10];     R[11] <= L[10]^ f_out[10];      V[11] <= V[10];
            L[12] <= R[11];     R[12] <= L[11]^ f_out[11];      V[12] <= V[11];
            L[13] <= R[12];     R[13] <= L[12]^ f_out[12];      V[13] <= V[12];
            L[14] <= R[13];     R[14] <= L[13]^ f_out[13];      V[14] <= V[13];
            L[15] <= R[14];     R[15] <= L[14]^ f_out[14];      V[15] <= V[14];

            L[16] <= R[15];
            R[16] <= L[15] ^ f_out[15];
            V[16] <= V[15];

            odata <= ip_inv_out;
            valid_out <= V[16];
        end
    end
    
endmodule