module register_file_tb;
    reg [3:0] read_address_a;
    reg [3:0] read_address_b;
    reg [3:0] write_address;
    reg [15:0] write_data;
    reg write_enable;
    reg clk;
    reg rst;
    reg load_constant_low;
    reg load_constant_high;
    reg [7:0] constant_low;
    reg [7:0] constant_high;

    wire [15:0] read_data_a;
    wire [15:0] read_data_b;

    register_file uut (
        .clk(clk),
        .rst(rst),
        .load_constant_low(load_constant_low),
        .load_constant_high(load_constant_high),
        .constant_low(constant_low),
        .constant_high(constant_high),
        .read_address_a(read_address_a),
        .read_address_b(read_address_b),
        .write_address(write_address),
        .write_data(write_data),
        .write_enable(write_enable),
        .read_data_a(read_data_a),
        .read_data_b(read_data_b)
    );

    always #5 clk = ~clk; // Clock generation

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        write_enable = 0;
        load_constant_low = 0;
        load_constant_high = 0;
        constant_low = 8'h00;
        constant_high = 8'h00;
        read_address_a = 4'b0000;
        read_address_b = 4'b0000;
        write_address = 4'b0000;
        write_data = 16'h0000;

        // Reset the register file
        #12 rst = 0;

        // Write to register 0
        write_address = 4'b0000;
        write_data = 16'h1234;
        write_enable = 1;
        #10 write_enable = 0;

        // Read from register 0
        read_address_a = 4'b0000;
        read_address_b = 4'b0001; // Read from an unused register
        #10 $display("Read Data A: %h, Read Data B: %h", read_data_a, read_data_b);

        // Load constant low byte
        load_constant_low = 1;
        constant_low = 8'hAB;
        #10 load_constant_low = 0;

        // Load constant high byte
        load_constant_high = 1;
        constant_high = 8'hCD;
        #10 load_constant_high = 0;

        // Read from constant register
        read_address_a = 4'b1111; // Constant register address
        read_address_b = 4'b0001; // Read from an unused register
        #10 $display("Read Constant Register: %h, Read Data B: %h", read_data_a, read_data_b);
        $finish;
    end
    
endmodule