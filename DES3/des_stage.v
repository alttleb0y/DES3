module des_stage(clk, reset, des_state, feistel_state, DONE);
    input clk;
    input reset;
    
    output reg [1:0] des_state;      // Biến đếm 3 nhịp (00, 01, 10)
    output wire [3:0] feistel_state; // CHÚ Ý: Dùng 'wire' vì tín hiệu này nối trực tiếp từ module con ra
    output reg DONE;                 // Cờ báo hiệu xong toàn bộ 3DES

    wire round_done; // Sợi dây nội bộ để nhận tiếng "bíp" từ máy đếm Feistel

    // =====================================================================
    // 1. KHỞI TẠO MODULE CON (BẮT BUỘC ĐẶT Ở NGOÀI KHỐI ALWAYS)
    // =====================================================================
    feistel_stage u_feistel(
        .clk(clk),
        .reset(reset),
        .feistel_stage(feistel_state), // Nối đầu ra của con thẳng ra ngoài
        .round_done(round_done)        // Bắt sợi dây báo hiệu vào biến round_done
    );

    // =====================================================================
    // 2. MÁY TRẠNG THÁI CỦA DES (CHỈ NGHE TÍN HIỆU VÀ ĐẾM)
    // =====================================================================
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            des_state <= 2'b00;
            DONE <= 1'b0;
        end 
        else if (!DONE) begin
            // Chỉ làm việc khi sợi dây round_done giật lên mức 1 (Feistel đếm xong 16 vòng)
            if (round_done == 1'b1) begin
                if (des_state == 2'b10) begin
                    DONE <= 1'b1; // Xong giai đoạn 3 (E2) -> Báo Done toàn hệ thống
                end else begin
                    des_state <= des_state + 1'b1; // Tăng trạng thái DES lên
                end
            end
            // Nếu round_done == 0 thì des_state đứng im, chờ Feistel đếm tiếp.
        end
    end

endmodule