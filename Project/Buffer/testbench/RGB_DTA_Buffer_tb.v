`timescale 1 ns / 1 ps

module DTA_Buffer_tb ( );
    reg clk;
    reg [15:0] PIXEL;
    wire [15:0] RD_DTA;
    reg [10:0] RD_ADDR;
    reg WR_EN;
    
    initial begin
        clk <= 1'b0;
        WR_EN <= 1'b1;
        PIXEL <= 16'hFF_FE;
        #7 WR_EN <= 1'b0;
        #3 WR_EN <= 1'b1; 
        PIXEL <= 16'h67_68;
        #7 WR_EN <= 1'b0;
        #3 WR_EN <= 1'b1; 
        PIXEL <= 16'h19;
        #7 WR_EN <= 1'b0;
        #3 WR_EN <= 1'b1; 
        PIXEL <= 16'h79;
        #7 WR_EN <= 1'b0;
        #3 WR_EN <= 1'b1; 
        PIXEL <= 16'h07_06;
        #7 WR_EN <= 1'b0;
        #3 RD_ADDR <= 11'h0;
        #10 RD_ADDR <= 11'h1;
        #10 RD_ADDR <= 11'h2;
        #10 RD_ADDR <= 11'h3;
        #10 RD_ADDR <= 11'h4;
        #10 RD_ADDR <= 11'h5;
    end

    always 
        #5 clk <= ~clk;

    DTA_Buffer	UUT (
        .i_clk (clk),
        .VLD_PIXEL (WR_EN),
        .P_DTA (PIXEL),
        .RD_ADDR (RD_ADDR),
        .RD_DTA (RD_DTA)
	);
endmodule