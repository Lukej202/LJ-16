module instruction_fetch_tb;
    reg clk;
    reg rst;
    reg [15:0] jmp_address;
    reg increment_pc;
    reg load_pc;
    wire [15:0] instruction;

    instruction_fetch uut (
        .clk(clk),
        .rst(rst),
        .jmp_address(jmp_address),
        .increment_pc(increment_pc),
        .load_pc(load_pc),
        .instruction(instruction)
    );

    always #5 clk = ~clk; // Clock generation

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        jmp_address = 16'h0000;
        increment_pc = 0;
        load_pc = 0;

        // Reset the instruction fetch unit
        #12 rst = 0;

        // Test fetching instructions from memory
        #10 increment_pc = 1; // Increment PC to fetch next instruction
        #10 increment_pc = 0; // Stop incrementing

        @(posedge clk);
        #1;
        $display("Instruction at Jump Address: %h", instruction);

        #10 jmp_address = 16'h0002; // Load jump address
        load_pc = 1; // Load the jump address into PC
        #10 load_pc = 0; // Stop loading

        @(posedge clk);
        #1;
        $display("Instruction at Jump Address: %h", instruction);

        #10 $finish; // End simulation
    end
endmodule