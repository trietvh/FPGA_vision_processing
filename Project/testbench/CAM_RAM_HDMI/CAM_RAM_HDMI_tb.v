`timescale 1ns/1ps

module CAM_RAM_HDMI_tb ();
    // Input
    reg clk;
    reg href;
    reg vsync;
    reg reset_n;
    reg [7:0] CAM_DTA;
    reg [10:0] HDMI_ADDR;
    // Output
    wire o_pclk;
    wire CAM_En;
    wire [15:0] pixel;
    wire HDMI_En;
    wire [15:0] HDMI_DTA;

    // HDMI Output
    wire pclk;
    wire hs;
    wire vs;
    wire de;
    wire [7:0] vga_r;
    wire [7:0] vga_g;
    wire [7:0] vga_b;

    CAM_RGB_Capture CAM_u (
        // Input
        .i_pclk(clk),
        .CAM_RGB(CAM_DTA),
        .HREF(href),
        .VSYNC(vsync),
        // Output
        .PIXEL(pixel),
        .o_pclk(o_pclk),
        .en(CAM_En)
    );

    RGB_DTA_Buffer RAM_u (
        // Input
        .i_clk(o_pclk),
        .CAM_En(CAM_En),
        .CAM_DTA(pixel),
        .RD_ADDR(HDMI_ADDR),
        // Output
        .HDMI_En(HDMI_En),
        .HDMI_DTA(HDMI_DTA)
    );

    // HDMI_RGB_VPG HDMI_u (
    //     .clk(o_pclk),
    //     .reset_n(reset_n),
    //     .PIXEL(HDMI_DTA),
    //     .buffer_rd(HDMI_En),
    //     // Output
    //     .pclk(pclk),
    //     .hs(hs),
    //     .vs(vs),
    //     .de(de),
    //     .vga_r(vga_r),
    //     .vga_g(vga_g),
    //     .vga_b(vga_b)
    // );

    always 
        #1 clk <= ~clk;

    initial begin
        clk <= 1'b0;
        vsync <= 1'b0;
        href <= 1'b0;
        #2 vsync <= 1'b1;
        #4 vsync <= 1'b0;
        #2 href <= 1'b1;
        CAM_DTA <= 8'hF;
        #2 CAM_DTA <= 8'hE;
        #2 CAM_DTA <= 8'h6;
        #2 CAM_DTA <= 8'h8;
        #2 CAM_DTA <= 8'hAC;
        HDMI_ADDR <= 11'h0;
        #2 CAM_DTA <= 8'h98;
        #2 CAM_DTA <= 8'h6;
        HDMI_ADDR <= 11'h1;
        #2 CAM_DTA <= 8'h8;
        #2 CAM_DTA <= 8'hAC;
        HDMI_ADDR <= 11'h2;
        #2 CAM_DTA <= 8'h98;
        #2 CAM_DTA <= 8'h6;
        HDMI_ADDR <= 11'h3;
        #2 CAM_DTA <= 8'h8;
        #2 CAM_DTA <= 8'hAC;
        HDMI_ADDR <= 11'h4;
        #2 CAM_DTA <= 8'h98;
        #2 CAM_DTA <= 8'h6;
        HDMI_ADDR <= 11'h0;
        #2 CAM_DTA <= 8'h8;
        #2 CAM_DTA <= 8'hAC;
        HDMI_ADDR <= 11'h1;
        #2 CAM_DTA <= 8'h98;
        #2 href <= 1'b0;
        HDMI_ADDR <= 11'h2;
        CAM_DTA <= 8'hx;
        #2 vsync <= 1'b1;
        #2 HDMI_ADDR <= 11'hx;
        #2 vsync <= 1'b0;
        
    end

endmodule