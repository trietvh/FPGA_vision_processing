`timescale 1 ns / 1 ps

module RGB_DTA_Buffer(
    input                   i_clk,
    input                   CAM_En,
    input       [15:0]      CAM_DTA,
    input       [10:0]      RD_ADDR,
    // Output
    output                  HDMI_En,
    output      [15:0]      HDMI_DTA
);
    reg [10:0] WR_ADDR = 11'd0;
    assign HDMI_En = WR_ADDR == 13'd1;


    always @(posedge i_clk) begin
        if (CAM_En)
            if (WR_ADDR < 11'd1279)
                WR_ADDR <= WR_ADDR + 11'd1;
            else
                WR_ADDR <= 11'd0;
    end

    RAM_DTA_Capture	u_RAM_DTA_Capture (
        .clock (i_clk),
        .data (CAM_DTA),
        .rdaddress (RD_ADDR),
        .wraddress (WR_ADDR),
        .wren (CAM_En),
        .q (HDMI_DTA)
	);
endmodule
    