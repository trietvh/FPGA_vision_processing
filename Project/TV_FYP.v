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
	wire						CAM_HR;
	wire 						CAM_XLK;
	wire 						CAM_PLK;
	wire						CAM_RST;
	wire						CAM_PWD;
	wire 		[7:0]			CAM_DTA;

	// Assign Camera Pins
	assign CAM_HS 	= GPIO_0[22];
	assign CAM_VS 	= GPIO_0[23];
	assign CAM_PLK = GPIO_0[20];
	assign CAM_PWD = 1'b0;
	assign CAM_RST = 1'b1;
	assign GPIO_0[21] = CAM_XLK;
	assign GPIO_0[10] = CAM_RST;
	assign GPIO_0[11] = CAM_PWD;
	assign GPIO_0[24] = CAM_SCL;
	assign GPIO_0[25] = CAM_SDA;
	
	// Camera Data
	assign CAM_DTA[7] = GPIO_0[18];  
	assign CAM_DTA[6] = GPIO_0[19];  
	assign CAM_DTA[5] = GPIO_0[16];  
	assign CAM_DTA[4] = GPIO_0[17];  
	assign CAM_DTA[3] = GPIO_0[14];  
	assign CAM_DTA[2] = GPIO_0[15];  
	assign CAM_DTA[1] = GPIO_0[12];  
	assign CAM_DTA[0] = GPIO_0[13];  
	
	// Indicator
	assign	LED[7]  = reset_n;
	
	//  Clock
	HDMI_PLL u_hdmi_pll (
		.refclk(CLOCK_50),
		.rst(!KEY[0]),
		.outclk_0(CAM_XLK),			// 12.5 MHz (640x480 @ 30fps)
		.outclk_1(i2c_clk),			//    1 MHz 
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
	
	// Camera I2C Config
	CAM_I2C_Config u_CAM_I2C_Config (
		.clk(i2c_clk),
		.reset(reset_n),
		.I2C_SCL(CAM_SCL),
		.I2C_SDA(CAM_SDA)
		);	

	wire [15:0] P_DTA;
	reg o_pclk;
	wire en;
/*
	// Camera data capture
	CAM_DTA_Capture u_CAM_DTA_Capture (
		.i_pclk(CAM_PLK),
		.reset(reset_n),
		.CAM_DTA(CAM_DTA),
		.href(CAM_HR),
		.vsync(CAM_VS),
		.pixel(P_DTA),
		.o_pclk(o_pclk),
		.en(en)
		);
*/

/*
	// Video Generator
	HDMI_VPG_V2 u_HDMI_VPG_V2 (
		.clk(o_pclk),
		.reset(reset_n),
		.P_DTA(P_DTA),
		.href(CAM_HR),
		.vsync(CAM_VS),
		.en(en),
		.de(HDMI_TX_DE),
		.hs(HDMI_TX_HS),
		.vs(HDMI_TX_VS),
		.pclk(HDMI_TX_CLK),
		.vga_r(HDMI_TX_D[23:16]),
		.vga_g(HDMI_TX_D[15:8]),
		.vga_b(HDMI_TX_D[7:0])
		);
*/	
	

	// HDMI Pattern Generator
	HDMI_VPG u_HDMI_VPG (
		.clk(CAM_PLK),
		.reset(reset_n),
		.SW(SW[1:0]),
		.CAM_DTA(CAM_DTA),
		.de(HDMI_TX_DE),
		.hs(HDMI_TX_HS),
		.vs(HDMI_TX_VS),
		.pclk(HDMI_TX_CLK),
		.vga_r(HDMI_TX_D[23:16]),
		.vga_g(HDMI_TX_D[15:8]),
		.vga_b(HDMI_TX_D[7:0])
		);
		

/*
	// Create clock 2 Hz
	localparam delay = 100000;
	reg [19:0] counter_1m;
	reg clk_1hz;
	always@(posedge i2c_clk or negedge reset_n)
	begin
		if (!reset_n)
		begin
			counter_1m <= 20'b0;
			clk_1hz <= 1'b0;				//frequency divider
		end
		else
		begin
			if (counter_1m < delay)
				counter_1m <= counter_1m + 1;
			else
			begin
				counter_1m <= 0;
				clk_1hz <= ~clk_1hz;
			end
		end
	end
	
	reg [7:0] camout;
	
	always @(posedge clk_1hz or negedge reset_n)
	begin
		if (!reset_n)
			camout <= 0;
		else
			camout <= CAM_DTA;
	end
	assign 	LED 	  = camout;
*/	
endmodule