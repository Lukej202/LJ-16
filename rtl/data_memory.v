module data_memory (
    input wire clk,
    input wire [15:0] address,
    input wire [15:0] write_data,
    input wire write_enable,
    output reg [15:0] read_data
);
    reg [15:0] memory [0:4095]; // 4096 x 16-bit data memory

    always @(posedge clk) begin
        if(address < 16'h1000) begin
        if (write_enable) begin
            memory[address] <= write_data; // Write data to memory
        end else begin
        read_data <= memory[address]; // Read data from memory
        end
        end else begin
            read_data <= 16'h0000; // Out of bounds, return 0
        end
end
endmodule