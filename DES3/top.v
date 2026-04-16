module top();
    reg clk;
    reg reset;
    reg [63:0] idata;
    reg [63:0] key1, key2, key3;
    reg valid_in;
    wire [63:0] odata;
    wire valid_out;

    reg [63:0] memory_idata [0:0];
    reg [63:0] memory_key [0:2];
    integer outfile;
    integer i;

initial begin
        $readmemh("idata.txt", memory_idata);
        $readmemh("key123.txt", memory_key);
        outfile = $fopen("output.txt", "w");

        clk = 0;
        reset = 1;
        valid_in = 0; // Khởi tạo bằng 0
        
        // Gán dữ liệu sẵn sàng
        idata = memory_idata[0];  
        key1 = memory_key[0];
        key2 = memory_key[1];
        key3 = memory_key[2];

        // Chờ 2 chu kỳ clock rồi mới nhả reset
        repeat(2) @(posedge clk);
        reset = 0;

        // Bật valid_in đúng 1 chu kỳ clock
        @(posedge clk);
        valid_in = 1;
        @(posedge clk);
        valid_in = 0;

        // Chờ kết quả
        wait(valid_out);
        
        // Chờ thêm một chút để odata ổn định hoàn toàn
        #5; 
        $fwrite(outfile, "%h", odata);
        $fclose(outfile);
        $finish;
    end

    always begin
        #10
        clk = ~clk;
    end

    des3 des3_inst(
        .clk(clk), 
        .reset(reset), 
        .idata(idata), 
        .key1(key1), 
        .key2(key2), 
        .key3(key3), 
        .valid_in(valid_in), 
        .odata(odata), 
        .valid_out(valid_out)
    );

endmodule
