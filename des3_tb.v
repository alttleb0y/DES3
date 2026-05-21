`timescale 1ns/1ps

module des3_tb();
    reg clk;
    reg reset;
    reg [63:0] idata;
    reg [63:0] key1, key2, key3;
    reg [63:0] plaintext;
    reg [63:0] ciphertext;
    reg [63:0] decrypted_text;
    reg decrypt;
    reg start;
    wire [63:0] odata;
    wire done;

    reg [63:0] memory_idata [0:0];
    reg [63:0] memory_key [0:2];
    integer outfile;
    integer clk_count;
    integer rr;

    reg printed_e1_in, printed_d2_in, printed_e3_in;
    reg printed_e1_out, printed_d2_out, printed_e3_out;

    initial begin
        $readmemh("idata.txt", memory_idata);
        $readmemh("key123.txt", memory_key);
        outfile = $fopen("output.txt", "w");

        clk = 0;
        reset = 1;
        decrypt = 0;
        start = 0;
        clk_count = 0;

        printed_e1_in = 0;
        printed_d2_in = 0;
        printed_e3_in = 0;
        printed_e1_out = 0;
        printed_d2_out = 0;
        printed_e3_out = 0;

        plaintext = memory_idata[0];
        idata = plaintext;
        key1 = memory_key[0];
        key2 = memory_key[1];
        key3 = memory_key[2];

        $display("mode: encrypt");
        $display("idata: %h", idata);
        $display("key1:  %h", key1);
        $display("key2:  %h", key2);
        $display("key3:  %h", key3);

        repeat (3) @(posedge clk);
        reset = 0;
        @(negedge clk);

        start = 1;
        @(posedge clk);
        @(negedge clk);
        start = 0;

        wait (done);
        ciphertext = odata;
        $display("encrypt final out: %h", ciphertext);

        wait (!done);
        @(negedge clk);

        printed_e1_in = 0;
        printed_d2_in = 0;
        printed_e3_in = 0;
        printed_e1_out = 0;
        printed_d2_out = 0;
        printed_e3_out = 0;

        decrypt = 1;
        idata = ciphertext;

        $display("");
        $display("mode: decrypt");
        $display("idata(ciphertext): %h", idata);

        start = 1;
        @(posedge clk);
        @(negedge clk);
        start = 0;

        wait (done);
        decrypted_text = odata;
        $display("decrypt final out: %h", decrypted_text);

        if (decrypted_text === plaintext)
            $display("DECRYPT PASS: recovered plaintext %h", plaintext);
        else
            $display("DECRYPT FAIL: got %h expected %h", decrypted_text, plaintext);

        $fwrite(outfile, "encrypt=%h\ndecrypt=%h", ciphertext, decrypted_text);
        $fclose(outfile);
        $finish;
    end

    always #10 clk = ~clk;

    always @(posedge clk) begin
        if (reset)
            clk_count <= 0;
        else
            clk_count <= clk_count + 1;
    end

    always @(posedge clk) begin
        if (!printed_e1_in && des3_fsm_inst.u_des3.encrypt1.V[0]) begin
            printed_e1_in <= 1'b1;
            $display("CLK %0d | encrypt1 in: ip_out=%h L0=%h R0=%h K1=%h",
                     clk_count, des3_fsm_inst.u_des3.encrypt1.ip.out,
                     des3_fsm_inst.u_des3.encrypt1.L[0],
                     des3_fsm_inst.u_des3.encrypt1.R[0],
                     des3_fsm_inst.u_des3.encrypt1.K[0]);
        end

        for (rr = 1; rr <= 16; rr = rr + 1) begin
            if (des3_fsm_inst.u_des3.encrypt1.V[rr]) begin
                $display("CLK %0d | encrypt1 round %0d: L=%h R=%h",
                         clk_count, rr,
                         des3_fsm_inst.u_des3.encrypt1.L[rr],
                         des3_fsm_inst.u_des3.encrypt1.R[rr]);
            end
        end

        if (!printed_e1_out && des3_fsm_inst.u_des3.encrypt1.valid_out) begin
            printed_e1_out <= 1'b1;
            $display("CLK %0d | encrypt1 out: %h",
                     clk_count, des3_fsm_inst.u_des3.encrypt1.odata);
        end
    end

    always @(posedge clk) begin
        if (!printed_d2_in && des3_fsm_inst.u_des3.decrypt2.V[0]) begin
            printed_d2_in <= 1'b1;
            $display("CLK %0d | decrypt2 in: ip_out=%h L0=%h R0=%h K1(dec)=%h",
                     clk_count, des3_fsm_inst.u_des3.decrypt2.ip.out,
                     des3_fsm_inst.u_des3.decrypt2.L[0],
                     des3_fsm_inst.u_des3.decrypt2.R[0],
                     des3_fsm_inst.u_des3.decrypt2.K[0]);
        end

        for (rr = 1; rr <= 16; rr = rr + 1) begin
            if (des3_fsm_inst.u_des3.decrypt2.V[rr]) begin
                $display("CLK %0d | decrypt2 round %0d: L=%h R=%h",
                         clk_count, rr,
                         des3_fsm_inst.u_des3.decrypt2.L[rr],
                         des3_fsm_inst.u_des3.decrypt2.R[rr]);
            end
        end

        if (!printed_d2_out && des3_fsm_inst.u_des3.decrypt2.valid_out) begin
            printed_d2_out <= 1'b1;
            $display("CLK %0d | decrypt2 out: %h",
                     clk_count, des3_fsm_inst.u_des3.decrypt2.odata);
        end
    end

    always @(posedge clk) begin
        if (!printed_e3_in && des3_fsm_inst.u_des3.encrypt3.V[0]) begin
            printed_e3_in <= 1'b1;
            $display("CLK %0d | encrypt3 in: ip_out=%h L0=%h R0=%h K1=%h",
                     clk_count, des3_fsm_inst.u_des3.encrypt3.ip.out,
                     des3_fsm_inst.u_des3.encrypt3.L[0],
                     des3_fsm_inst.u_des3.encrypt3.R[0],
                     des3_fsm_inst.u_des3.encrypt3.K[0]);
        end

        for (rr = 1; rr <= 16; rr = rr + 1) begin
            if (des3_fsm_inst.u_des3.encrypt3.V[rr]) begin
                $display("CLK %0d | encrypt3 round %0d: L=%h R=%h",
                         clk_count, rr,
                         des3_fsm_inst.u_des3.encrypt3.L[rr],
                         des3_fsm_inst.u_des3.encrypt3.R[rr]);
            end
        end

        if (!printed_e3_out && des3_fsm_inst.u_des3.encrypt3.valid_out) begin
            printed_e3_out <= 1'b1;
            $display("CLK %0d | encrypt3 out: %h",
                     clk_count, des3_fsm_inst.u_des3.encrypt3.odata);
        end
    end

    des3_fsm #(.WIDTH(64)) des3_fsm_inst (
        .clk(clk),
        .reset(reset),
        .idata(idata),
        .key1(key1),
        .key2(key2),
        .key3(key3),
        .decrypt(decrypt),
        .start(start),
        .odata(odata),
        .done(done)
    );
endmodule
