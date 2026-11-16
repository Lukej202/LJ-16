module register_file (
    input wire clk,
    input wire rst,
    input wire load_constant_low,
    input wire load_constant_high,
    input wire [7:0] constant_low,
    input wire [7:0] constant_high,
    input wire [3:0] read_address_a,
    input wire [3:0] read_address_b,
    input wire [3:0] write_address,
    input wire [15:0] write_data,
    input wire write_enable,
    output reg [15:0] read_data_a,
    output reg [15:0] read_data_b


);
reg [15:0] registers [0:14]; // 15 general-purpose registers
reg [15:0] constant_register; // Constant register for immediate values

        always @(negedge clk or posedge rst) begin
            if(rst) begin
                //reset all registers to 0
                integer i;
                for (i = 0; i < 15; i = i + 1) begin
                    registers[i] <= 16'h0000;
                end
                constant_register <= 16'h0000;
            end else begin
                if(write_enable && write_address != 4'b1111) begin
                    registers[write_address] <= write_data; // Write to general-purpose register
                end
                    if(load_constant_low) begin
                        constant_register[7:0] <= constant_low; // Write to constant register
                    end
                    if(load_constant_high) begin
                        constant_register[15:8] <= constant_high; // Write to constant register
                    end
                end
            end

        always @(*) begin
            read_data_a = (read_address_a == 4'b1111) ? constant_register : registers[read_address_a];
            read_data_b = (read_address_b == 4'b1111) ? constant_register : registers[read_address_b];
        end

endmodule