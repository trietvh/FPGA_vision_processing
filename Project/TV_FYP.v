module TV_FYP (
	///////////// CLOCK /////////////
	input 					CLOCK_50,
	input 					CLOCK2_50,
	input						CLOCK3_50,
	
	///////////// HDMI //////////////
	inout              	HDMI_I2C_SCL,
	inout              	HDMI_I2C_SDA,
	inout              	HDMI_I2S,
	inout              	HDMI_LRCLK,
	inout              	HDMI_MCLK,
	inout              	HDMI_SCLK,
	output             	HDMI_TX_CLK,
	output      [23:0] 	HDMI_TX_D,
	output             	HDMI_TX_DE,
	output             	HDMI_TX_HS,
	input              	HDMI_TX_INT,
	output             	HDMI_TX_VS,
	
	///////////// GPIO //////////////
	inout  		[35:0]	GPIO_0,
	inout			[35:0] 	GPIO_1,
	
	
	///////////// KEY ///////////////
	input 		[1:0]  	KEY,
	
	///////////// SW  //////////////
	input 		[3:0]  	SW,
	
	///////////// LED //////////////
	
	output      [7:0]  	LED
);

	//=======================================================
	//  REG/WIRE declarations
	//=======================================================

	wire						hdmi_reset;
	wire						hdmi_i2c_clk;
	wire						hdmi_clk;

	// HDMI Clock
	HDMI_PLL u_hdmi_pll (
		.refclk(CLOCK_50),
		.rst(!KEY[0]),
		.outclk_0(hdmi_clk),			// 24 MHz
		.outclk_1(hdmi_i2c_clk),	// 1	MHz
		.locked(hdmi_reset) 
	);
	
	HDMI_I2C_Config u_HDMI_I2C_Config (
		.clk(hdmi_i2c_clk),
		.reset(hdmi_reset),
		.I2C_SCL(HDMI_I2C_SCL),
		.I2C_SDA(HDMI_I2C_SDA),
		.HDMI_TX_INT(HDMI_TX_INT)
		);
	
	HDMI_VPG u_HDMI_VPG (
		.clk(hdmi_clk),
		.reset(hdmi_reset),
		.SW(SW[1:0]),
		.de(HDMI_TX_DE),
		.hs(HDMI_TX_HS),
		.vs(HDMI_TX_VS),
		.pclk(HDMI_TX_CLK),
		.vga_r(HDMI_TX_D[23:16]),
		.vga_g(HDMI_TX_D[15:8]),
		.vga_b(HDMI_TX_D[7:0])
		);
	
	assign	LED[7] = hdmi_reset;



endmodule