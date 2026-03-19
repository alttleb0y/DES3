module fsm_3des(clk, reset, des_stage, feistel_stage); 
    input clk;
    input reset;
    output reg [1:0] des_stage;
    output reg [2:0] feistel_stage;

    reg IDLE, RUN, DONE;

    always @(posedge clk) begin
        if (reset) begin
            des_stage <= 2'b00;
            IDLE <= 0;
            RUN <= 0;
            DONE <= 0;
        end else begin
            case(des_stage) 
                2'b00: begin
                    case(feistel_stage)
                        feistel_stage fsm0(.clk(clk), .reset(reset), .des_stage(des_stage), .feistel_stage(feistel_stage));
                    endcase
                end
                2'b01: begin
                    case(feistel_stage)
                        feistel_stage fsm1(.clk(clk), .reset(reset), .des_stage(des_stage), .feistel_stage(feistel_stage));
                    endcase
                end
                2'b10: begin
                    case(feistel_stage)
                        feistel_stage fsm2(.clk(clk), .reset(reset), .des_stage(des_stage), .feistel_stage(feistel_stage));
                    endcase
                end
            endcase
        end
    end
endmodule
