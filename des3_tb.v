module des3_tb();
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
    integer r;
    integer rr;
    integer clk_count;  // clock cycle counter
    reg printed_e1_in, printed_d2_in, printed_e3_in;
    reg printed_e1_out, printed_d2_out, printed_e3_out;

initial begin
        $readmemh("idata.txt", memory_idata);
        $readmemh("key123.txt", memory_key);
        outfile = $fopen("output.txt", "w");

        clk = 0;
        reset = 1;
        valid_in = 0;
        clk_count = 0;
        printed_e1_in = 0;
        printed_d2_in = 0;
        printed_e3_in = 0;
        printed_e1_out = 0;
        printed_d2_out = 0;
        printed_e3_out = 0;
        
        idata = memory_idata[0];  
        key1 = memory_key[0];
        key2 = memory_key[1];
        key3 = memory_key[2];
        $display("idata: %h", idata);
        $display("key1: %h", key1);
        $display("key2: %h", key2);
        $display("key3: %h", key3);

        repeat(2) @(posedge clk);
        reset = 0;
        @(posedge clk);
        
        valid_in = 1;
        @(posedge clk);
        valid_in = 0;
        repeat(70) begin
            @(posedge clk);
        end
        
        $fwrite(outfile, "%h", odata);
        $fclose(outfile);
        $finish;
    end

    // clock toggle + counter
    always begin
        #10 clk = ~clk;
    end

    always @(posedge clk) begin
        clk_count <= clk_count + 1;
    end

    // print pipeline state every rising edge
    always @(posedge clk) begin
        if (!printed_e1_in && des3_inst.encrypt1.V[0]) begin
            printed_e1_in <= 1'b1;
            $display("CLK %0d | encrypt1 in: ip_out=%h L0=%h R0=%h K1=%h",
                     clk_count, des3_inst.encrypt1.ip.out,
                     des3_inst.encrypt1.L[0], des3_inst.encrypt1.R[0],
                     des3_inst.encrypt1.K[0]);
        end

        if (!printed_d2_in && des3_inst.decrypt2.V[0]) begin
            printed_d2_in <= 1'b1;
            $display("CLK %0d | decrypt2 in: ip_out=%h L0=%h R0=%h K1(dec)=%h",
                     clk_count, des3_inst.decrypt2.ip.out,
                     des3_inst.decrypt2.L[0], des3_inst.decrypt2.R[0],
                     des3_inst.decrypt2.K[0]);
        end

        if (!printed_e3_in && des3_inst.encrypt3.V[0]) begin
            printed_e3_in <= 1'b1;
            $display("CLK %0d | encrypt3 in: ip_out=%h L0=%h R0=%h K1=%h",
                     clk_count, des3_inst.encrypt3.ip.out,
                     des3_inst.encrypt3.L[0], des3_inst.encrypt3.R[0],
                     des3_inst.encrypt3.K[0]);
        end

        if (!printed_e1_out && des3_inst.encrypt1.valid_out) begin
            printed_e1_out <= 1'b1;
            $display("=== encrypt1 rounds 1..16 ===");
            for (rr = 1; rr < 16; rr = rr + 1) begin
                $display("encrypt1 round %0d: L=%h R=%h", 
                        rr, des3_inst.encrypt1.L[rr], des3_inst.encrypt1.R[rr]);
            end
            $display("encrypt1 round 16: L=%h R=%h", des3_inst.encrypt1.L16, des3_inst.encrypt1.R16);
            $display("encrypt1 out: %h", des3_inst.encrypt1.odata);
        end

        if (!printed_d2_out && des3_inst.decrypt2.valid_out) begin
            printed_d2_out <= 1'b1;
            $display("=== decrypt2 rounds 1..16 ===");
            for (rr = 1; rr < 16; rr = rr + 1) begin
                $display("decrypt2 round %0d: L=%h R=%h", 
                        rr, des3_inst.decrypt2.L[rr], des3_inst.decrypt2.R[rr]);
            end
            $display("decrypt2 round 16: L=%h R=%h", des3_inst.decrypt2.L16, des3_inst.decrypt2.R16);
            $display("decrypt2 out: %h", des3_inst.decrypt2.odata);
        end

        if (!printed_e3_out && des3_inst.encrypt3.valid_out) begin
            printed_e3_out <= 1'b1;
            $display("=== encrypt3 rounds 1..16 ===");
            for (rr = 1; rr < 16; rr = rr + 1) begin
                $display("encrypt3 round %0d: L=%h R=%h", 
                        rr, des3_inst.encrypt3.L[rr], des3_inst.encrypt3.R[rr]);
            end
            $display("encrypt3 round 16: L=%h R=%h", des3_inst.encrypt3.L16, des3_inst.encrypt3.R16);
            $display("encrypt3 out: %h", des3_inst.encrypt3.odata);
        end
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
