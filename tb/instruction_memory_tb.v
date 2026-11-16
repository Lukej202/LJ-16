module instruction_memory_tb;
    reg clk;
    reg rst;
    reg [15:0] instruction_address;
    wire [15:0] instruction;

    instruction_memory uut (
        .clk(clk),
        .rst(rst),
        .instruction_address(instruction_address),
        .instruction(instruction)
    );

    always #5 clk = ~clk; // Clock generation

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        instruction_address = 16'h0000;

        // Reset the instruction memory
        #12 rst = 0;

        // Test fetching instructions from memory
        #10 instruction_address = 16'h0000; // Fetch first instruction
        #10 $display("Instruction at address %h: %h", instruction_address, instruction);

        #10 instruction_address = 16'h0001; // Fetch second instruction
        #10 $display("Instruction at address %h: %h", instruction_address, instruction);

        #10 instruction_address = 16'h0002; // Fetch third instruction
        #10 $display("Instruction at address %h: %h", instruction_address, instruction);
        // Test out-of-range address
        @(negedge clk);
        instruction_address = 16'h1000;

        @(posedge clk);
        #1;
        $display("Out-of-range instruction: %h", instruction);
        #10 $finish; // End simulation
    end
endmodule