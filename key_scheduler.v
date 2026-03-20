module key_scheduler #(
    parameter WIDTH = 64;
)(
    feistel_state, idata, odata
);
    input [WIDTH-1:0] idata;
    input [3:0] feistel_state;
    output [47:0] odata;
    
    wire [27:0] C0, D0;

    PC1 iPC1(.idata(idata), .odata(PC1_data));
    assign C0 = PC1_data[55:28];
    assign D0 = PC1_data[27:0];

    PC2 iPC2(.C({C0[27-feistel_state:0], C0[27:27-feistel_state+1]}), .D(D0), .odata(odata));
    assign odata = PC2_data;

endmodule