`timescale 1ns/1ps

module des3_pipeline_tb;
    localparam NUM_INPUTS = 4;
    localparam WAIT_CYCLES = 90;

    reg clk;
    reg reset;
    reg [63:0] idata;
    reg [63:0] key1, key2, key3;
    reg decrypt;
    reg start;
    wire [63:0] odata;
    wire done;

    localparam [63:0] KEY1 = 64'h576D5A24D0E7493A;
    localparam [63:0] KEY2 = 64'h4F3FC2A81707AC64;
    localparam [63:0] KEY3 = 64'h6F295595C05ED7FB;

    reg [63:0] test_data [0:NUM_INPUTS-1];
    reg [63:0] test_output [0:NUM_INPUTS-1];

    integer clk_count;
    integer output_count;
    integer pass_count;
    integer fail_count;
    integer i;

    initial clk = 0;
    always #10 clk = ~clk;

    always @(posedge clk) begin
        if (reset)
            clk_count <= 0;
        else
            clk_count <= clk_count + 1;
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

    always @(posedge clk) begin
        if (!reset && done) begin
            if (output_count < NUM_INPUTS) begin
                if (odata === test_output[output_count]) begin
                    $display("CLK %0d | Output[%0d] PASS: got %h expected %h",
                             clk_count, output_count, odata, test_output[output_count]);
                    pass_count = pass_count + 1;
                end else begin
                    $display("CLK %0d | Output[%0d] FAIL: got %h expected %h",
                             clk_count, output_count, odata, test_output[output_count]);
                    fail_count = fail_count + 1;
                end
            end else begin
                $display("CLK %0d | WARNING: unexpected extra output %h", clk_count, odata);
            end
            output_count = output_count + 1;
        end
    end

    initial begin
        test_data[0] = 64'h35A2F80F51564C52;  test_output[0] = 64'hAE32960F482A7362;
        test_data[1] = 64'h0123456789ABCDEF;  test_output[1] = 64'h8D09591CBDEC06BE;
        test_data[2] = 64'hFEDCBA9876543210;  test_output[2] = 64'hC2C29F8A82D0C084;
        test_data[3] = 64'hAABBCCDDEEFF0011;  test_output[3] = 64'hEC5E2747D7594392;

        clk_count = 0;
        output_count = 0;
        pass_count = 0;
        fail_count = 0;

        idata = 64'b0;
        key1 = KEY1;
        key2 = KEY2;
        key3 = KEY3;
        decrypt = 0;
        start = 0;
        reset = 1;

        $display("=== des3_fsm pipeline test: %0d back-to-back inputs ===", NUM_INPUTS);
        $display("mode=encrypt");
        $display("KEY1=%h", KEY1);
        $display("KEY2=%h", KEY2);
        $display("KEY3=%h", KEY3);
        $display("");

        repeat (3) @(posedge clk);
        reset = 0;
        @(negedge clk);

        for (i = 0; i < NUM_INPUTS; i = i + 1) begin
            idata = test_data[i];
            start = 1;
            $display("CLK %0d | Input[%0d] submitted: %h", clk_count, i, idata);
            @(posedge clk);
            @(negedge clk);
        end

        start = 0;
        idata = 64'b0;

        repeat (WAIT_CYCLES) @(posedge clk);

        $display("");
        $display("=== Summary ===");
        $display("Inputs submitted : %0d", NUM_INPUTS);
        $display("Outputs received : %0d", output_count);
        $display("PASS             : %0d", pass_count);
        $display("FAIL             : %0d", fail_count);
        if (fail_count == 0 && output_count == NUM_INPUTS)
            $display("RESULT: ALL PASS");
        else
            $display("RESULT: SOME FAILURES");

        $finish;
    end
endmodule
