module feistel_stage(clk, reset, des_stage, feistel_stage); 
    input clk;
    input reset;
    input [1:0] des_stage;
    output reg [2:0] feistel_stage;

    reg IDLE, RUN, DONE;

    always @(posedge clk) begin
        if (reset) begin
            feistel_stage <= 3'b000;
            IDLE <= 0;
            RUN <= 0;
            DONE <= 0;
        end 
        else begin
            case(feistel_stage)
                3'b000: begin
                    IDLE <= 1;
                    RUN <= 0;
                    DONE <= 0;
                    feistel_stage <= feistel_stage + 1;
                end
                3'b111: begin
                    IDLE <= 0;
                    RUN <= 0;
                    DONE <= 1;
                    des_stage <= des_stage + 1;
                    feistel_stage <= 3'b000;
                end
                default: begin
                    IDLE <= 0;
                    RUN <= 1;
                    DONE <= 0;
                    feistel_stage <= feistel_stage + 1;
                end
            endcase
        end
    end
endmodule