module instruction_memory (
    input wire clk,
    input wire rst,
    input wire [15:0] instruction_address,
    output reg [15:0] instruction
);
    reg [15:0] memory [0:4095]; // 4096 x 16-bit instruction memory

    initial begin
        // Initialize instruction memory with some instructions
        $readmemh("instructions.hex", memory);
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            instruction <= 16'h0000; // Reset instruction to NOP (or any default value)
        end else begin
            if (instruction_address < 16'h1000) begin
                instruction <= memory[instruction_address]; // Fetch instruction from memory
            end else begin
                instruction <= 16'h0000; // Out of bounds, return NOP
            end
        end
    end
endmodule
