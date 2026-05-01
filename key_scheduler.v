module key_scheduler #(
    parameter WIDTH = 64,
    parameter [3:0] ROUND = 4'd0 // Chuyển state thành parameter
)(
    input [WIDTH-1:0] key_in,
    input decrypt,
    output [47:0] K_out
);
    // 1. Tính toán giá trị shift cố định cho Round này tại thời điểm biên dịch
    localparam [4:0] SHIFT_ENC = (ROUND == 0)  ? 5'd1  : (ROUND == 1)  ? 5'd2  :
                                 (ROUND == 2)  ? 5'd4  : (ROUND == 3)  ? 5'd6  :
                                 (ROUND == 4)  ? 5'd8  : (ROUND == 5)  ? 5'd10 :
                                 (ROUND == 6)  ? 5'd12 : (ROUND == 7)  ? 5'd14 :
                                 (ROUND == 8)  ? 5'd15 : (ROUND == 9)  ? 5'd17 :
                                 (ROUND == 10) ? 5'd19 : (ROUND == 11) ? 5'd21 :
                                 (ROUND == 12) ? 5'd23 : (ROUND == 13) ? 5'd25 :
                                 (ROUND == 14) ? 5'd27 : 5'd28;

    localparam [4:0] SHIFT_DEC = (ROUND == 0)  ? 5'd28 : (ROUND == 1)  ? 5'd27 :
                                 (ROUND == 2)  ? 5'd25 : (ROUND == 3)  ? 5'd23 :
                                 (ROUND == 4)  ? 5'd21 : (ROUND == 5)  ? 5'd19 :
                                 (ROUND == 6)  ? 5'd17 : (ROUND == 7)  ? 5'd15 :
                                 (ROUND == 8)  ? 5'd14 : (ROUND == 9)  ? 5'd12 :
                                 (ROUND == 10) ? 5'd10 : (ROUND == 11) ? 5'd8  :
                                 (ROUND == 12) ? 5'd6  : (ROUND == 13) ? 5'd4  :
                                 (ROUND == 14) ? 5'd2  : 5'd1;

    // 2. PC-1: Hoán vị này cố định cho mọi round
    wire [27:0] C0, D0;
    assign C0 = {key_in[7],  key_in[15], key_in[23], key_in[31], key_in[39], key_in[47], key_in[55],
                 key_in[63], key_in[6],  key_in[14], key_in[22], key_in[30], key_in[38], key_in[46],
                 key_in[54], key_in[62], key_in[5],  key_in[13], key_in[21], key_in[29], key_in[37],
                 key_in[45], key_in[53], key_in[61], key_in[4],  key_in[12], key_in[20], key_in[28]};

    assign D0 = {key_in[1],  key_in[9],  key_in[17], key_in[25], key_in[33], key_in[41], key_in[49],
                 key_in[57], key_in[2],  key_in[10], key_in[18], key_in[26], key_in[34], key_in[42],
                 key_in[50], key_in[58], key_in[3],  key_in[11], key_in[19], key_in[27], key_in[35],
                 key_in[43], key_in[51], key_in[59], key_in[36], key_in[44], key_in[52], key_in[60]};
                 
    // 3. Thực hiện dịch bit (Hard-wired)
    // Vì SHIFT_ENC/DEC là hằng số, phép dịch này KHÔNG TỐN LOGIC (chỉ nối dây)
    wire [27:0] Cn_enc = (C0 << SHIFT_ENC) | (C0 >> (28 - SHIFT_ENC));
    wire [27:0] Dn_enc = (D0 << SHIFT_ENC) | (D0 >> (28 - SHIFT_ENC));
    wire [27:0] Cn_dec = (C0 << SHIFT_DEC) | (C0 >> (28 - SHIFT_DEC));
    wire [27:0] Dn_dec = (D0 << SHIFT_DEC) | (D0 >> (28 - SHIFT_DEC));

    // Chọn kết quả dựa trên tín hiệu decrypt (Chỉ tốn 1 MUX 2:1 cực nhanh)
    wire [55:0] CD = decrypt ? {Cn_dec, Dn_dec} : {Cn_enc, Dn_enc};

    // 4. PC-2: Hoán vị nén (Hard-wired)
    assign K_out = {
        CD[42], CD[39], CD[45], CD[32], CD[55], CD[51],
        CD[53], CD[28], CD[41], CD[50], CD[35], CD[46],
        CD[33], CD[37], CD[44], CD[52], CD[30], CD[48],
        CD[40], CD[49], CD[29], CD[36], CD[43], CD[54],
        CD[15], CD[4],  CD[25], CD[19], CD[9],  CD[1],
        CD[26], CD[16], CD[5],  CD[11], CD[23], CD[8],
        CD[12], CD[7],  CD[17], CD[0],  CD[22], CD[3],
        CD[10], CD[14], CD[6],  CD[20], CD[27], CD[24]
    };

endmodule
