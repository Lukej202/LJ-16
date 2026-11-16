module instruction_fetch (
    input wire clk,
    input wire rst,
    input wire [15:0] jmp_address,
    input wire increment_pc,
    input wire load_pc,
    output wire [15:0] instruction
);
    wire [15:0] pc;

    // Instantiate the program counter
    program_counter pc_inst (
        .clk(clk),
        .rst(rst),
        .jmp_address(jmp_address),
        .increment_pc(increment_pc),
        .load_pc(load_pc),
        .pc(pc)
    );

    // Instantiate the instruction memory
    instruction_memory im_inst (
        .clk(clk),
        .rst(rst),
        .instruction_address(pc),
        .instruction(instruction)
    );
endmodule