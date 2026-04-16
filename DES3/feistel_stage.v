module feistel_stage(clk, reset, feistel_stage, round_done); 
    input clk;
    input reset;
    output reg [3:0] feistel_stage; // Sửa thành 4-bit (0-15) để đếm đủ 16 vòng
    output reg round_done;          // Cờ báo hiệu đã chạy xong 16 vòng

    // ... (bỏ các biến IDLE, RUN, DONE nếu không thực sự dùng để điều khiển mạch ngoài)

    always @(posedge clk) begin
        if (reset) begin
            feistel_stage <= 4'd0;
            round_done <= 1'b0;
        end 
        else begin
            if (feistel_stage == 4'd15) begin
                feistel_stage <= 4'd0; // Reset lại vòng lặp
                round_done <= 1'b1;    // Bật cờ báo hiệu đã xong 16 vòng
            end else begin
                feistel_stage <= feistel_stage + 1'b1;
                round_done <= 1'b0;    // Tắt cờ đi
            end
        end
    end
endmodule