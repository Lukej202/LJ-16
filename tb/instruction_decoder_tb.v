module instruction_decoder_tb;
reg[15:0] instruction;
wire[4:0] opcode;
wire[3:0] reg_a;
wire[3:0] reg_b;
wire[7:0] imediate;

instruction_decoder uut(
    .instruction(instruction),
    .opcode(opcode),
    .reg_a(reg_a),
    .reg_b(reg_b),
    .imediate(imediate)
);

task test_decode;
    input [15:0] test_instruction;
    input [4:0] expected_opcode;
    input [3:0] expected_a;
    input [3:0] expected_b;
    input [7:0] expected_immediate;

    begin
        instruction = test_instruction;
        #10;

        if (opcode !== expected_opcode ||
            reg_a !== expected_a ||
            reg_b !== expected_b ||
            imediate !== expected_immediate) begin

            $fatal(1, "FAIL: Instruction %h", instruction);

        end else begin
            $display("PASS: Instruction %h", instruction);
        end
    end
endtask

initial begin
//intialise signals
instruction = 16'h0000;
#10;

    test_decode(16'h0000, 5'h00, 4'h0, 4'h0, 8'h00);
    test_decode(16'hFFFF, 5'h1F, 4'hF, 4'hF, 8'hFF);
    test_decode(16'hF800, 5'h1F, 4'h0, 4'h0, 8'h00);
    test_decode(16'h0780, 5'h00, 4'hF, 4'h0, 8'h80);
    test_decode(16'h0078, 5'h00, 4'h0, 4'hF, 8'h78);
    test_decode(16'h00FF, 5'h00, 4'h1, 4'hF, 8'hFF);
    test_decode(16'h0007, 5'h00, 4'h0, 4'h0, 8'h07);
    test_decode(16'hAAAA, 5'h15, 4'h5, 4'h5, 8'hAA);
    test_decode(16'h5555, 5'h0A, 4'hA, 4'hA, 8'h55);
    test_decode(16'h10F8, 5'h02, 4'h1, 4'hF, 8'hF8);
    test_decode(16'h5900, 5'h0B, 4'h2, 4'h0, 8'h00);
    test_decode(16'h58AB, 5'h0B, 4'h1, 4'h5, 8'hAB);
    test_decode(16'h60CD, 5'h0C, 4'h1, 4'h9, 8'hCD);
    test_decode(16'h7F80, 5'h0F, 4'hF, 4'h0, 8'h80);

    $display("All 14 decoder tests passed!");
    $finish;
end

endmodule