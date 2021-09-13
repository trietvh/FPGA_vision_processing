`timescale 1ns/1ps

module testbench ( );
    // Input
    reg clk;
    reg href;
    reg vsync;
    reg [7:0] CAM_DTA;
    // Output
    wire [15:0] pixel;
    wire o_pclk;
    wire en;

    CAM_RGB_Capture UUT (
        .i_pclk(clk),
        .CAM_RGB(CAM_DTA),
        .HREF(href),
        .VSYNC(vsync),
        .PIXEL(pixel),
        .o_pclk(o_pclk),
        .en(en)
    );

    always 
        #5 clk <= ~clk;

    initial begin
        clk <= 1'b0;
        vsync <= 1'b0;
        href <= 1'b0;
        //CAM_DTA <= 8'b0;
        #10 vsync <= 1'b1;
        #20 vsync <= 1'b0;
        #10 href <= 1'b1;
        CAM_DTA <= 8'hF;
        #10 CAM_DTA <= 8'hE;
        #10 CAM_DTA <= 8'h6;
        #10 CAM_DTA <= 8'h8;
        #10 href <= 1'b0;
        CAM_DTA <= 8'hx;
        #10 vsync <= 1'b1;
        #20 vsync <= 1'b0;
    end

endmodule