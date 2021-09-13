`timescale 1ns/1ps

module HDMI_RGB_VPG_tb ();

    // Input
    reg clk;
    reg reset_n;
    reg [15:0] PIXEL; 

    // Output
    wire pclk;
    wire hs;
    wire vs;
    wire de;
    wire [7:0] vga_r;
    wire [7:0] vga_g;
    wire [7:0] vga_b;

    HDMI_RGB_VPG UUT (
        .clk(clk),
        .reset_n(reset_n),
        .PIXEL(PIXEL),
        // Output
        .pclk(pclk),
        .hs(hs),
        .vs(vs),
        .de(de),
        .vga_r(vga_r),
        .vga_g(vga_g),
        .vga_b(vga_b)
    );

    always 
        #0.5 clk <= ~clk;

    initial begin
        clk <= 1'b0;
        reset_n <= 1'b0;
        PIXEL <= 16'hFF_FF;
        #0.25 reset_n <= 1'b1;
    end



endmodule