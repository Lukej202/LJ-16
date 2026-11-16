module program_counter_tb;
    reg clk;
    reg rst;
    reg [15:0] jmp_address;
    reg increment_pc;
    reg load_pc;
    wire [15:0] pc;

    program_counter uut (
        .clk(clk),
        .rst(rst),
        .jmp_address(jmp_address),
        .increment_pc(increment_pc),
        .load_pc(load_pc),
        .pc(pc)
    );

    always #5 clk = ~clk; // Clock generation

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        jmp_address = 16'h0000;
        increment_pc = 0;
        load_pc = 0;

        // Reset the program counter
        #12 rst = 0;

        // Increment PC
        increment_pc = 1;
        #10 increment_pc = 0;
        #1;
        $display("PC after increment: %h", pc);

        // Load jump address
        jmp_address = 16'h00FF;
        load_pc = 1;
        #10 load_pc = 0;
        #1;
        $display("PC after load: %h", pc);

        // Increment PC again
        increment_pc = 1;
        #10 increment_pc = 0;
        #1;
        $display("PC after increment: %h", pc);
        // First jump to FFFF
        @(negedge clk);
        // Set jump controls here
        jmp_address = 16'hFFFF;
        load_pc = 1;

        @(posedge clk);
        #1;
        // Verify PC = FFFF
        $display("PC after jump: %h", pc);

        @(negedge clk);
        // Disable jump and enable increment
        load_pc = 0;
        increment_pc = 1;

        @(posedge clk);
        #1;
        // Verify PC = 0000
        $display("PC after increment: %h", pc);
        #10 $finish; // End simulation
    end
endmodule