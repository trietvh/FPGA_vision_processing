`timescale 1 ns / 1 ps

module RAM_DTA_Capture_tb ( );
    reg clk;
    reg [15:0] PIXEL;
    wire [15:0] RD_DTA;
    
    reg [10:0] WR_ADDR;
    reg [10:0] RD_ADDR;
    reg WR_EN;
    
    initial begin
        clk <= 1'b0;
        #2 WR_EN <= 1'b1;
        PIXEL <= 16'hFF_FE;
        WR_ADDR <= 11'h1;
        #5 WR_EN <= 1'b0;
        #3 WR_EN <= 1'b1; 
        PIXEL <= 16'h67_68;
        WR_ADDR <= 11'h2;
        #7 WR_EN <= 1'b0;
        #3 WR_EN <= 1'b1; 
        PIXEL <= 16'h19;
        WR_ADDR <= 11'h3;
        #7 WR_EN <= 1'b0;
        #3 WR_EN <= 1'b1; 
        PIXEL <= 16'h79;
        WR_ADDR <= 11'h4;
        #7 WR_EN <= 1'b0;
        #3 WR_EN <= 1'b1; 
        PIXEL <= 16'h07_06;
        WR_ADDR <= 11'h5;
        #7 WR_EN <= 1'b0;
        #3 RD_ADDR <= 11'h1;
        #10 RD_ADDR <= 11'h2;
        #10 RD_ADDR <= 11'h3;
        #10 RD_ADDR <= 11'h4;
        #10 RD_ADDR <= 11'h5;
        #10 RD_ADDR <= 11'h0;
    end

    always 
        #5 clk <= ~clk;

    RAM_DTA_Capture	UUT (
        .clock (clk),
        .data (PIXEL),
        .rdaddress (RD_ADDR),
        .wraddress (WR_ADDR),
        .wren (WR_EN),
        .q (RD_DTA)
	);
endmodule