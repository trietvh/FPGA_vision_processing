// Final Year Project
// FPGA Vision Processing
// Student: 	Triet Hoang Vo
// Supervisor: Lindsay Kleeman

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

	wire						reset_n;
	wire						i2c_clk;
	wire						hdmi_clk;
	wire						CAM_SCL;
	wire						CAM_SDA;
	wire						CAM_VS;
	wire						CAM_HS;
	wire 						CAM_XLK;
	wire 						CAM_PLK;
	wire 		[7:0]			CAM_D;

	// Assign Camera Pins
	assign GPIO_0[24] = CAM_SCL;
	assign GPIO_0[25] = CAM_SDA;
	assign GPIO_0[22] = CAM_HS;
	assign GPIO_0[23] = CAM_VS;
	assign GPIO_0[20] = CAM_PLK;
	assign GPIO_0[21] = CAM_XLK;
	assign GPIO_0[10] = CAM_RST;
	assign GPIO_0[11] = CAM_PWD;
	// Camera Data
	assign GPIO_0[18] = CAM_D[7];
	assign GPIO_0[19] = CAM_D[6];
	assign GPIO_0[16] = CAM_D[5];
	assign GPIO_0[17] = CAM_D[4];
	assign GPIO_0[14] = CAM_D[3];
	assign GPIO_0[15] = CAM_D[2];
	assign GPIO_0[12] = CAM_D[1];
	assign GPIO_0[13] = CAM_D[0];

	//  Clock
	HDMI_PLL u_hdmi_pll (
		.refclk(CLOCK_50),
		.rst(!KEY[0]),
		.outclk_0(hdmi_clk),			// 24 MHz
		.outclk_1(i2c_clk),			// 1	MHz
		.locked(reset_n) 
	);
	
	// HDMI I2C Config
	HDMI_I2C_Config u_HDMI_I2C_Config (
		.clk(i2c_clk),
		.reset(reset_n),
		.I2C_SCL(HDMI_I2C_SCL),
		.I2C_SDA(HDMI_I2C_SDA),
		.HDMI_TX_INT(HDMI_TX_INT)
		);
	
	// HDMI Pattern Generator
	HDMI_VPG u_HDMI_VPG (
		.clk(hdmi_clk),
		.reset(reset_n),
		.SW(SW[1:0]),
		.de(HDMI_TX_DE),
		.hs(HDMI_TX_HS),
		.vs(HDMI_TX_VS),
		.pclk(HDMI_TX_CLK),
		.vga_r(HDMI_TX_D[23:16]),
		.vga_g(HDMI_TX_D[15:8]),
		.vga_b(HDMI_TX_D[7:0])
		);
	
	// Camera I2C 
	CAM_I2C_Config u_CAM_I2C_Config (
		.clk(i2c_clk),
		.reset(reset_n),
		.I2C_SCL(CAM_SCL),
		.I2C_SDA(CAM_SDA)
		);
	
	
	assign	LED[7] = reset_n;



endmodule