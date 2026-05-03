// Avalon-MM Slave Wrapper for des3
// Memory Map (word-addressed, 32-bit data bus):
//   0x0 : idata_lo   [31:0]   (R/W)
//   0x1 : idata_hi   [63:32]  (R/W)
//   0x2 : key1_lo    [31:0]   (R/W)
//   0x3 : key1_hi    [63:32]  (R/W)
//   0x4 : key2_lo    [31:0]   (R/W)
//   0x5 : key2_hi    [63:32]  (R/W)
//   0x6 : key3_lo    [31:0]   (R/W)
//   0x7 : key3_hi    [63:32]  (R/W)
//   0x8 : control    [0]      (R/W) write 1 to pulse valid_in 1 cycle
//   0x9 : odata_lo   [31:0]   (R)
//   0xA : odata_hi   [63:32]  (R)
//   0xB : status     [0]      (R) valid_out (latched, clears on read)

module des3_avalon #(
    parameter WIDTH = 64
)(
    input  wire        clk,
    input  wire        reset,

    input  wire [3:0]  avs_address,
    input  wire        avs_write,
    input  wire [31:0] avs_writedata,
    output reg  [31:0] avs_readdata
);

    reg [63:0] reg_idata;
    reg [63:0] reg_key1;
    reg [63:0] reg_key2;
    reg [63:0] reg_key3;
    reg        reg_valid_in;

    reg [63:0] reg_odata;
    reg        reg_valid_out;

    wire [63:0] odata;
    wire        valid_out;

    des3 #(.WIDTH(WIDTH)) u_des3 (
        .clk      (clk),
        .reset    (reset),
        .idata    (reg_idata),
        .key1     (reg_key1),
        .key2     (reg_key2),
        .key3     (reg_key3),
        .valid_in (reg_valid_in),
        .odata    (odata),
        .valid_out(valid_out)
    );
	 
	 // Write logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg_idata     <= 64'b0;
            reg_key1      <= 64'b0;
            reg_key2      <= 64'b0;
            reg_key3      <= 64'b0;
            reg_valid_in  <= 1'b0;
            reg_odata     <= 64'b0;
            reg_valid_out <= 1'b0;
        end
        else begin
            if (valid_out) begin
                reg_odata     <= odata;
                reg_valid_out <= 1'b1;
            end
				
            if (avs_write && avs_address == 4'h8)
                reg_valid_in <= avs_writedata[0];
            else
                reg_valid_in <= 1'b0;
					 
            if (avs_write) begin
                case (avs_address)
                    4'h0: reg_idata[31:0]  <= avs_writedata;
                    4'h1: reg_idata[63:32] <= avs_writedata;
                    4'h2: reg_key1[31:0]   <= avs_writedata;
                    4'h3: reg_key1[63:32]  <= avs_writedata;
                    4'h4: reg_key2[31:0]   <= avs_writedata;
                    4'h5: reg_key2[63:32]  <= avs_writedata;
                    4'h6: reg_key3[31:0]   <= avs_writedata;
                    4'h7: reg_key3[63:32]  <= avs_writedata;
                    default: ;
                endcase
            end
        end
    end

    // Read logic
    always @(*) begin
        case (avs_address)
            4'h0:    avs_readdata = reg_idata[31:0];
            4'h1:    avs_readdata = reg_idata[63:32];
            4'h2:    avs_readdata = reg_key1[31:0];
            4'h3:    avs_readdata = reg_key1[63:32];
            4'h4:    avs_readdata = reg_key2[31:0];
            4'h5:    avs_readdata = reg_key2[63:32];
            4'h6:    avs_readdata = reg_key3[31:0];
            4'h7:    avs_readdata = reg_key3[63:32];
            4'h8:    avs_readdata = {31'b0, reg_valid_in};
            4'h9:    avs_readdata = reg_odata[31:0];
            4'hA:    avs_readdata = reg_odata[63:32];
            4'hB:    avs_readdata = {31'b0, reg_valid_out};
            default: avs_readdata = 32'b0;
        endcase
    end

endmodule
