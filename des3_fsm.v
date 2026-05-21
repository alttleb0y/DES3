// des3_fsm.v
// FSM controller wrapper cho des3.v
// Luồng: input -> FSM -> des3 (pipeline) -> output
//
// States:
//   IDLE    : chờ start, valid_in = 0
//   RUNNING : chuyển tiếp start làm valid_in; pipeline nhận nhiều block liên tiếp

module des3_fsm #(
    parameter WIDTH = 64
)(
    input  wire             clk,
    input  wire             reset,

    // --- User interface ---
    input  wire [WIDTH-1:0] idata,
    input  wire [WIDTH-1:0] key1,
    input  wire [WIDTH-1:0] key2,
    input  wire [WIDTH-1:0] key3,
    input  wire             decrypt,
    input  wire             start,   // pulse 1 cycle để nạp block mới

    output wire [WIDTH-1:0] odata,   // trực tiếp từ des3
    output wire             done     // trực tiếp từ des3 valid_out
);

    // -------------------------------------------------------
    // State encoding
    // -------------------------------------------------------
    localparam IDLE    = 1'b0;
    localparam RUNNING = 1'b1;

    reg state;

    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else if (start)
            state <= RUNNING;
    end

    // -------------------------------------------------------
    // valid_in: chỉ cho qua khi có start pulse
    // -------------------------------------------------------
    wire core_valid_in = start;

    // -------------------------------------------------------
    // des3 core instance — output nối thẳng ra port
    // -------------------------------------------------------
    des3 #(.WIDTH(WIDTH)) u_des3 (
        .clk      (clk),
        .reset    (reset),
        .idata    (idata),
        .key1     (key1),
        .key2     (key2),
        .key3     (key3),
        .decrypt  (decrypt),
        .valid_in (core_valid_in),
        .odata    (odata),
        .valid_out(done)
    );

endmodule
