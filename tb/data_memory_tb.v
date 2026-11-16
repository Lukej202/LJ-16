module data_memory_tb;
    reg clk;
    reg [15:0] address;
    reg [15:0] write_data;
    reg write_enable;
    wire [15:0] read_data;

    data_memory uut (
        .clk(clk),
        .address(address),
        .write_data(write_data),
        .write_enable(write_enable),
        .read_data(read_data)
    );

    always #5 clk = ~clk; // Clock generation

    initial begin
        // Initialize signals
        clk = 0;
        address = 16'h0000;
        write_data = 16'h0000;
        write_enable = 0;

        //write to memory 
        #12 write_enable = 1;
        address = 16'h0000;
        write_data = 16'h1234;
        #10 write_enable = 0;

        // Read from memory
        #10 address = 16'h0000;
        #10 $display("Read data from address %h: %h", address, read_data);

        // Write to another address
        #10 write_enable = 1;
        address = 16'h0005;
        write_data = 16'hABCD;
        #10 write_enable = 0;

        // Read from the new address
        #10 address = 16'h0005;
        #10 $display("Read data from address %h: %h", address, read_data);

        //read x0000 again
        #10 address = 16'h0000;
        #10 $display("Read data from address %h: %h", address, read_data);

        //read invalid index
        @(negedge clk);
        address = 16'h1000;
        #10 $display("Read data from address %h: %h", address, read_data);

        //write to invalid index
        @(negedge clk);
        #1;
        write_enable = 1;
        address = 16'h1000;
        write_data = 16'h5678;
        #10 write_enable = 0;

        //read x1000 again
        #10 address = 16'h1000;
        #10 $display("Read data from address %h: %h", address, read_data);

        //rewrite to valid index
        @(negedge clk);
        #1;
        write_enable = 1;
        address = 16'h0000;
        write_data = 16'h9ABC;
        #10 write_enable = 0;

        //read x0000 again
        #10 address = 16'h0000;
        #10 $display("Read data from address %h: %h", address, read_data);

        #10 $finish; // End simulation
    end
    endmodule