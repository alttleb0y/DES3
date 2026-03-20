module S(in, out);
    input [47:0] in;
    output [31:0] out;

    wire [5:0] S_in[7:0];
    wire [3:0] S_out[7:0];

    assign S_in[0] = in[47:42];
    assign S_in[1] = in[41:36];
    assign S_in[2] = in[35:30];
    assign S_in[3] = in[29:24];
    assign S_in[4] = in[23:18];
    assign S_in[5] = in[17:12];
    assign S_in[6] = in[11:6];
    assign S_in[7] = in[5:0];

    S1 iS1(.in(S_in[0]), .out(S_out[0]));
    S2 iS2(.in(S_in[1]), .out(S_out[1]));
    S3 iS3(.in(S_in[2]), .out(S_out[2]));
    S4 iS4(.in(S_in[3]), .out(S_out[3]));
    S5 iS5(.in(S_in[4]), .out(S_out[4]));
    S6 iS6(.in(S_in[5]), .out(S_out[5]));
    S7 iS7(.in(S_in[6]), .out(S_out[6]));
    S8 iS8(.in(S_in[7]), .out(S_out[7]));

    assign out = {S_out[0], S_out[1], S_out[2], S_out[3], S_out[4], S_out[5], S_out[6], S_out[7]};
endmodule