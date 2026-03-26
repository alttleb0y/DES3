module key_scheduler #(
    parameter WIDTH = 64
)(
    feistel_state, idata, odata
);
    input [WIDTH-1:0] idata;
    input [3:0] feistel_state;
    output [47:0] odata;
    
    wire [55:0] oPC1_data;
    wire [55:0] iPC2_data;
    wire [47:0] oPC2_data;
    wire [5:0] shift_amt;
    wire [27:0] C, D;

    function [27:0] rol28;
        input [27:0] x;
        input [5:0] s;
        begin
            // rotate-left on 28-bit ring
            rol28 = (x << s) | (x >> (28 - s));
        end
    endfunction

    PC1 iPC1(.in(idata), .out(oPC1_data));

    always @(*) begin
        case(feistel_state)
            4'd0: shift_amt = 6'd1;
            4'd1: shift_amt = 6'd2;
            4'd2: shift_amt = 6'd4;
            4'd3: shift_amt = 6'd6;
            4'd4: shift_amt = 6'd8;
            4'd5: shift_amt = 6'd10;
            4'd6: shift_amt = 6'd12;
            4'd7: shift_amt = 6'd14;
            4'd8: shift_amt = 6'd15;
            4'd9: shift_amt = 6'd17;
            4'd10: shift_amt = 6'd19;
            4'd11: shift_amt = 6'd21;
            4'd12: shift_amt = 6'd23;
            4'd13: shift_amt = 6'd25;
            4'd14: shift_amt = 6'd27;
            default: shift_amt = 6'd28;
        endcase
    end

    assign C = rol28(oPC1_data[55:28], shift_amt);
    assign D = rol28(oPC1_data[27:0], shift_amt);

    assign iPC2_data = {C, D};
    PC2 iPC2(.in(iPC2_data), .out(oPC2_data));
    assign odata = oPC2_data;

endmodule

