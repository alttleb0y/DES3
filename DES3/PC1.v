module PC1 (
    input [63:0] in,
    output [55:0] out
);
    // C0: bit chuẩn 57, 49, 41, 33, 25, 17, 9
    assign out[55] = in[7];  // 57
    assign out[54] = in[15]; // 49
    assign out[53] = in[23]; // 41
    assign out[52] = in[31]; // 33
    assign out[51] = in[39]; // 25
    assign out[50] = in[47]; // 17
    assign out[49] = in[55]; // 9

    // C0 tiếp: bit chuẩn 1, 58, 50, 42, 34, 26, 18
    assign out[48] = in[63]; // 1
    assign out[47] = in[6];  // 58
    assign out[46] = in[14]; // 50
    assign out[45] = in[22]; // 42
    assign out[44] = in[30]; // 34
    assign out[43] = in[38]; // 26
    assign out[42] = in[46]; // 18

    // C0 tiếp: bit chuẩn 10, 2, 59, 51, 43, 35, 27
    assign out[41] = in[54]; // 10
    assign out[40] = in[62]; // 2
    assign out[39] = in[5];  // 59
    assign out[38] = in[13]; // 51
    assign out[37] = in[21]; // 43
    assign out[36] = in[29]; // 35
    assign out[35] = in[37]; // 27

    // C0 tiếp: bit chuẩn 19, 11, 3, 60, 52, 44, 36
    assign out[34] = in[45]; // 19
    assign out[33] = in[53]; // 11
    assign out[32] = in[61]; // 3
    assign out[31] = in[4];  // 60
    assign out[30] = in[12]; // 52
    assign out[29] = in[20]; // 44
    assign out[28] = in[28]; // 36

    // D0: bit chuẩn 63, 55, 47, 39, 31, 23, 15
    assign out[27] = in[1];  // 63
    assign out[26] = in[9];  // 55
    assign out[25] = in[17]; // 47
    assign out[24] = in[25]; // 39
    assign out[23] = in[33]; // 31
    assign out[22] = in[41]; // 23
    assign out[21] = in[49]; // 15

    // D0 tiếp: bit chuẩn 7, 62, 54, 46, 38, 30, 22
    assign out[20] = in[57]; // 7
    assign out[19] = in[2];  // 62
    assign out[18] = in[10]; // 54
    assign out[17] = in[18]; // 46
    assign out[16] = in[26]; // 38
    assign out[15] = in[34]; // 30
    assign out[14] = in[42]; // 22

    // D0 tiếp: bit chuẩn 14, 6, 61, 53, 45, 37, 29
    assign out[13] = in[50]; // 14
    assign out[12] = in[58]; // 6
    assign out[11] = in[3];  // 61
    assign out[10] = in[11]; // 53
    assign out[9] = in[19];  // 45
    assign out[8] = in[27];  // 37
    assign out[7] = in[35];  // 29

    // D0 tiếp: bit chuẩn 21, 13, 5, 28, 20, 12, 4
    assign out[6] = in[43];  // 21
    assign out[5] = in[51];  // 13
    assign out[4] = in[59];  // 5
    assign out[3] = in[36];  // 28
    assign out[2] = in[44];  // 20
    assign out[1] = in[52];  // 12
    assign out[0] = in[60];  // 4
endmodule