module instruction_decoder(
    input wire [15:0] instruction,
    output wire [4:0] opcode,
    output wire [3:0] reg_a,
    output wire [3:0] reg_b,
    output wire [7:0] imediate
);


assign opcode = instruction[15:11];
assign reg_a = instruction[10:7];
assign reg_b = instruction[6:3];
assign imediate = instruction[7:0];
endmodule