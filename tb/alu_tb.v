module alu_tb;
    reg [4:0] alu_op;
    reg [15:0] a;
    reg [15:0] b;
    reg carry_in;
    reg borrow_in;
    wire [15:0] result;
    wire carry_out;
    wire borrow_out;

    alu uut (
        .alu_op(alu_op),
        .a(a),
        .b(b),
        .carry_in(carry_in),
        .borrow_in(borrow_in),
        .result(result),
        .carry_out(carry_out),
        .borrow_out(borrow_out)
    );
    initial begin
        // Test ADD operation
        alu_op = 5'b00000; a = 16'h0001; b = 16'h0001; carry_in = 0; borrow_in = 0;
        #10;
        $display("ADD: %h + %h = %h, carry_out = %b", a, b, result, carry_out);

        // Test SUB operation
        alu_op = 5'b00001; a = 16'h0002; b = 16'h0001; carry_in = 0; borrow_in = 0;
        #10;
        $display("SUB: %h - %h = %h, borrow_out = %b", a, b, result, borrow_out);

        // Test AND operation
        alu_op = 5'b00010; a = 16'h00FF; b = 16'h0F0F; carry_in = 0; borrow_in = 0;
        #10;
        $display("AND: %h & %h = %h", a, b, result);

        // Test OR operation
        alu_op = 5'b00011; a = 16'h00FF; b = 16'h0F0F; carry_in = 0; borrow_in = 0;
        #10;
        $display("OR: %h | %h = %h", a, b, result);

        // Test XOR operation
        alu_op = 5'b00100; a = 16'h00FF; b = 16'h0F0F; carry_in = 0; borrow_in = 0;
        #10;
        $display("XOR: %h ^ %h = %h", a, b, result);

        // Test NOT operation
        alu_op = 5'b00101; a = 16'h00FF; b = 16'h0000; carry_in = 0; borrow_in = 0;
        #10;
        $display("NOT: ~%h = %h", a, result);

        // Test Shift Left operation
        alu_op = 5'b00110; a = 16'h0001; b =    16'h0000; carry_in = 0; borrow_in = 0;
        #10;
        $display("Shift Left: %h << 1 = %h", a, result);

        // Test Shift Right operation
        alu_op = 5'b00111; a = 16'h0002; b = 16'h0000; carry_in = 0; borrow_in = 0;
        #10;
        $display("Shift Right: %h >> 1 = %h", a, result);

        // Test SLT operation
        alu_op = 5'b01000; a = 16'h0001; b = 16'h0002; carry_in = 0; borrow_in = 0;
        #10;
        $display("SLT: %h < %h = %h", a, b, result);

        // Test ADD with carry operation
        alu_op = 5'b11001; a = 16'hFFFF; b = 16'h0001; carry_in = 1; borrow_in = 0;
        #10;
        $display("ADD with carry: %h + %h + %b = %h, carry_out = %b", a, b, carry_in, result, carry_out);

        // Test SUB with borrow operation
        alu_op = 5'b11010; a = 16'h0000; b = 16'h0001; carry_in = 0; borrow_in = 1;
        #10;
        $display("SUB with borrow: %h - %h - %b = %h, borrow_out = %b", a, b, borrow_in, result, borrow_out);

        // Test NAND operation
        alu_op = 5'b11011; a = 16'h00FF; b = 16'h0F0F; carry_in = 0; borrow_in = 0;
        #10;
        $display("NAND: ~(%h & %h) = %h", a, b, result);
        // Test NOR operation
        alu_op = 5'b11100; a = 16'h00FF; b = 16'h0F0F; carry_in = 0; borrow_in = 0;
        #10;
        $display("NOR: ~(%h | %h) = %h", a, b, result);

        //test EQ operation
        alu_op = 5'b10000; a = 16'h0001; b = 16'h0001; carry_in = 0; borrow_in = 0;
        #10;
        $display("EQ: %h == %h = %h", a, b, result);

        //test NEQ operation
        alu_op = 5'b10001; a = 16'h0001; b = 16'h0002; carry_in = 0; borrow_in = 0;
        #10;
        $display("NEQ: %h != %h = %h", a, b, result);

        //test GT operation
        alu_op = 5'b10010; a = 16'h0002; b = 16'h0001; carry_in = 0; borrow_in = 0;
        #10;
        $display("GT: %h > %h = %h", a, b, result);

        //test LT operation
        alu_op = 5'b10011; a = 16'h0001; b = 16'h0002; carry_in = 0; borrow_in = 0;
        #10;
        $display("LT: %h < %h = %h", a, b, result);

        //test GTE operation
        alu_op = 5'b10100; a = 16'h0002; b =    16'h0001; carry_in = 0; borrow_in = 0;
        #10;
        $display("GTE: %h >= %h = %h", a, b, result);
        //test LTE operation
        alu_op = 5'b10101; a = 16'h0001; b = 16'h0002; carry_in = 0; borrow_in = 0;
        #10;
        $display("LTE: %h <= %h = %h", a, b, result);

        // Test Variable Shift Left operation
        alu_op = 5'b10110; a = 16'h0001; b = 16'h0003; carry_in = 0; borrow_in = 0;
        #10;

        $display("Variable Shift Left: %h << %h = %h", a, b[3:0], result);  

        // Test Variable Shift Right operation
        alu_op = 5'b10111; a = 16'h0008; b = 16'h0002; carry_in = 0; borrow_in = 0;
        #10;
        $display("Variable Shift Right: %h >> %h = %h", a, b[3:0], result);

        // Test Two's Complement operation
        alu_op = 5'b11000; a = 16'h0005; b = 16'h0000; carry_in = 0; borrow_in = 0;
        #10;
        $display("Two's Complement: ~%h + 1 = %h", a, result);
        $finish;

    end
endmodule