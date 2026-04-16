module key_scheduler #(
    parameter WIDTH = 64
)(
    feistel_state, key_in, decrypt, K_out
);
    input [WIDTH-1:0] key_in;
    input [3:0] feistel_state;
    input decrypt;
    output reg [47:0] K_out;
    
    reg [4:0] shift;
    wire [27:0] C0, D0;
    wire [55:0] CD;

    assign C0 = {
        key_in[63-(57-1)], key_in[63-(49-1)], key_in[63-(41-1)], key_in[63-(33-1)],
        key_in[63-(25-1)], key_in[63-(17-1)], key_in[63-(9-1)],
        key_in[63-(1-1)],  key_in[63-(58-1)], key_in[63-(50-1)], key_in[63-(42-1)],
        key_in[63-(34-1)], key_in[63-(26-1)], key_in[63-(18-1)],
        key_in[63-(10-1)], key_in[63-(2-1)],  key_in[63-(59-1)], key_in[63-(51-1)],
        key_in[63-(43-1)], key_in[63-(35-1)], key_in[63-(27-1)],
        key_in[63-(19-1)], key_in[63-(11-1)], key_in[63-(3-1)],  key_in[63-(60-1)],
        key_in[63-(52-1)], key_in[63-(44-1)], key_in[63-(36-1)]
    };
 
    assign D0 = {
        key_in[63-(63-1)], key_in[63-(55-1)], key_in[63-(47-1)], key_in[63-(39-1)],
        key_in[63-(31-1)], key_in[63-(23-1)], key_in[63-(15-1)],
        key_in[63-(7-1)],  key_in[63-(62-1)], key_in[63-(54-1)], key_in[63-(46-1)],
        key_in[63-(38-1)], key_in[63-(30-1)], key_in[63-(22-1)],
        key_in[63-(14-1)], key_in[63-(6-1)],  key_in[63-(61-1)], key_in[63-(53-1)],
        key_in[63-(45-1)], key_in[63-(37-1)], key_in[63-(29-1)],
        key_in[63-(21-1)], key_in[63-(13-1)], key_in[63-(5-1)],  key_in[63-(28-1)],
        key_in[63-(20-1)], key_in[63-(12-1)], key_in[63-(4-1)]
    };

    always @(*) begin
        if(!decrypt) begin
            case(feistel_state)
                4'd0: shift = 5'd1;
                4'd1: shift = 5'd2;
                4'd2: shift = 5'd4;
                4'd3: shift = 5'd6;
                4'd4: shift = 5'd8;
                4'd5: shift = 5'd10;
                4'd6: shift = 5'd12;
                4'd7: shift = 5'd14;
                4'd8: shift = 5'd15;
                4'd9: shift = 5'd17;
                4'd10: shift = 5'd19;
                4'd11: shift = 5'd21;
                4'd12: shift = 5'd23;
                4'd13: shift = 5'd25;
                4'd14: shift = 5'd27;
                4'd15: shift = 5'd28;
                default: shift = 5'd0;
            endcase
        end
        else begin
            case(feistel_state)
                4'd0: shift = 5'd28;
                4'd1: shift = 5'd27;
                4'd2: shift = 5'd25;
                4'd3: shift = 5'd23;
                4'd4: shift = 5'd21;
                4'd5: shift = 5'd19;
                4'd6: shift = 5'd17;
                4'd7: shift = 5'd15;
                4'd8: shift = 5'd14;
                4'd9: shift = 5'd12;
                4'd10: shift = 5'd10;
                4'd11: shift = 5'd8;
                4'd12: shift = 5'd6;
                4'd13: shift = 5'd4;
                4'd14: shift = 5'd2;
                4'd15: shift = 5'd1;
                default: shift = 5'd0;
            endcase
        end
    end

    wire [27:0] Cn, Dn;
    assign Cn = (C0 << shift) | (C0 >> (28 - shift));
    assign Dn = (D0 << shift) | (D0 >> (28 - shift));

    assign CD = {Cn[27:0], Dn[27:0]};

    always @(*) begin
        K_out = {
            CD[56-14], CD[56-17], CD[56-11], CD[56-24], CD[56-1],  CD[56-5],
            CD[56-3],  CD[56-28], CD[56-15], CD[56-6],  CD[56-21], CD[56-10],
            CD[56-23], CD[56-19], CD[56-12], CD[56-4],  CD[56-26], CD[56-8],
            CD[56-16], CD[56-7],  CD[56-27], CD[56-20], CD[56-13], CD[56-2],
            CD[56-41], CD[56-52], CD[56-31], CD[56-37], CD[56-47], CD[56-55],
            CD[56-30], CD[56-40], CD[56-51], CD[56-45], CD[56-33], CD[56-48],
            CD[56-44], CD[56-49], CD[56-39], CD[56-56], CD[56-34], CD[56-53],
            CD[56-46], CD[56-42], CD[56-50], CD[56-36], CD[56-29], CD[56-32]
        };
    end
endmodule