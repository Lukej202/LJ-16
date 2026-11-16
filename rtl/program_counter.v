module program_counter (

    input wire clk,
    input wire rst,
    input wire [15:0] jmp_address,
    input wire increment_pc,
    input wire load_pc,
    output reg [15:0] pc
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 16'h0000; // Reset PC to 0
        end else if (load_pc) begin
            pc <= jmp_address; // Load jump address
        end else if (increment_pc) begin
            pc <= pc + 1; // Increment PC
        end
    end
endmodule
