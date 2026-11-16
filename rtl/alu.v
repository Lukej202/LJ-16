module alu (
    input wire [4:0] opcode,
    input wire [15:0] a,
    input wire [15:0] b,
    input wire carry_in,
    input wire borrow_in,
    output reg [15:0] result,
    output reg carry_out,
    output reg borrow_out,
    output reg zero_flag,
    output reg negative_flag,
    output reg signed_overflow_flag
);
    reg [16:0] temp_result;
    always @(*) begin
        result = 16'h0000;
        temp_result = 17'h00000;
        carry_out = 1'b0;
        borrow_out = 1'b0;
        case (opcode)
            5'b00000: begin // ADD
                result = a + b;
                carry_out = (result < a); // Set carry_out if overflow occurs
            end
            5'b00001: begin // SUB
                result = a - b;
                borrow_out = (result > a); // Set borrow_out if underflow occurs
            end
            5'b00010: result = a & b; // AND
            5'b00011: result = a | b; // OR
            5'b00100: result = a ^ b; // XOR
            5'b00101: result = ~a;    // NOT
            5'b00110: result = a << 1; // Shift left
            5'b00111: result = a >> 1; // Shift right
            5'b01000: result = (a < b) ? 16'h0001 : 16'h0000; // SLT
            5'b01001: result = a << 1; // MUL by 2
            5'b01010: result = 16'h0000; // JMP
            // add later 5'b01011: result = a % b; // MOD
            5'b01100: result = a; // PASS A
            5'b01101: result = b; // PASS B
            5'b01110: result = a + 1; // INC
            5'b01111: result = a - 1; // DEC
            5'b10000: result = (a == b) ? 16'h0001 : 16'h0000; // EQ
            5'b10001: result = (a != b) ? 16'h0001 : 16'h0000; // NEQ
            5'b10010: result = (a > b) ? 16'h0001 : 16'h0000; // GT
            5'b10011: result = (a < b) ? 16'h0001 : 16'h0000; // LT
            5'b10100: result = (a >= b) ? 16'h0001 : 16'h0000; // GTE
            5'b10101: result = (a <= b) ? 16'h0001 : 16'h0000; // LTE
            5'b10110: result = a << b[3:0]; // Variable shift left
            5'b10111: result = a >> b[3:0]; // Variable shift right
            5'b11000: result = (a == 16'h0000) ? 16'h0000 : (~a + 1); // Two's complement
            5'b11001: begin
                temp_result = a + b + carry_in; // ADD with carry
                carry_out = temp_result[16];
                result = temp_result[15:0];
            end // ADD with carry
            5'b11010: begin // SUB with borrow
                result = a - b - borrow_in;
                temp_result = {1'b0, b} + borrow_in; // Calculate b + borrow_in
                borrow_out = (a < temp_result); // Set borrow_out if underflow occurs
            end
            5'b11011: result = ~(a & b); // NAND
            5'b11100: result = ~(a | b); // NOR
            5'b11101: result = ~(a ^ b); // XNOR
            5'b11110: result = (a << 1) | (a[15]); // Rotate left
            5'b11111: result = {a[0], a[15:1]}; // Rotate right
            default: result = 16'h0000; // Default case
        endcase
        zero_flag = (result == 16'h0000) ? 1'b1 : 1'b0; // Set zero flag
        negative_flag = result[15]; // Set negative flag based on MSB
        signed_overflow_flag = ((opcode == 5'b00000 || opcode == 5'b11001) && ((a[15] == b[15]) && (result[15] != a[15]))) ? 1'b1 : 1'b0; // Set signed overflow flag for ADD and ADD with carry
    end

endmodule