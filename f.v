module f( input [31:0] R, input [47:0] K, output [31:0] out ); 
    wire [47:0] exp_out; 
    wire [47:0] xored; 
    wire [31:0] s_out; 
    wire [31:0] p_out; 
    
    expand e (.in(R), .out(exp_out)); 
    assign xored = exp_out ^ K; 
    sbox_array s (.in(xored), .out(s_out));
    p_perm p (.in(s_out), .out(p_out)); 
    assign out = p_out; 
endmodule
