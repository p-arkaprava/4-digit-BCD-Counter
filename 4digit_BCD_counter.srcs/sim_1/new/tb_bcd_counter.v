`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Arkaprava Paul
// 
// Create Date: 13.03.2026 21:29:50
// Design Name: 
// Module Name: tb_bcd_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module tb_bcd_counter;

reg clk;
reg reset;
wire [3:1] ena;
wire [15:0] q;

// Instantiate DUT
top_module uut (
    .clk(clk),
    .reset(reset),
    .ena(ena),
    .q(q)
);

// Clock generation (10 ns period)
always #5 clk = ~clk;

initial begin
    // Initialize
    clk = 0;
    reset = 1;

    // Apply reset
    #10 reset = 0;

    // Run counter for some cycles
    #500;

    $finish;
end

// Monitor values
initial begin
    $monitor("time=%0t reset=%b q=%d%d%d%d ena=%b",
             $time, reset,
             q[15:12], q[11:8], q[7:4], q[3:0],
             ena);
end

endmodule
