module top();
    reg clk;
    reg reset;
    reg [63:0] idata;
    reg [63:0] key1, key2, key3;
    reg valid_in;
    wire [63:0] odata;
    wire valid_out;

    reg [63:0] memory_idata [0:0];
    reg [63:0] memory_key [0:2];
    integer outfile;
    integer i;

    initial begin
        $monitor("At time %t: odata = %b, valid_out = %b", $time, odata, valid_out);
        // File I/O and $readmemh must be INSIDE initial block
        $readmemb("idata.txt", memory_idata);
        $readmemb("key123.txt", memory_key);
        outfile = $fopen("output.txt", "w");

        $display("Initial idata: %b", memory_idata[0]);
        $display("Initial key1: %b", memory_key[0]);
        $display("Initial key2: %b", memory_key[1]);
        $display("Initial key3: %b", memory_key[2]);
		
        clk = 0;
        reset = 1;
        idata = memory_idata[0];  
        key1 = memory_key[0];
        key2 = memory_key[1];
        key3 = memory_key[2];
        valid_in = 1'b1;
        #10
        reset = 0;
        #5
        valid_in = 1'b0;
        wait(valid_out);
        $fwrite(outfile, "%b", odata);
        $fclose(outfile);
        $finish;
    end

    always begin
        #10
        clk = ~clk;
    end

    des3 des3_inst(
        .clk(clk), 
        .reset(reset), 
        .idata(idata), 
        .key1(key1), 
        .key2(key2), 
        .key3(key3), 
        .valid_in(valid_in), 
        .odata(odata), 
        .valid_out(valid_out)
    );

endmodule
