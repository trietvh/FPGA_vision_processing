// Final Year Project
// FPGA Vision Processing
// Student: 	Triet Hoang Vo
// Supervisor: Lindsay Kleeman

module TV_FYP (
	///////////// CLOCK /////////////
	input 					CLOCK_50,
	
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
	
	output		[3:0] 	GPIO_1,
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
	wire						CAM_RST;
	wire						CAM_PWD;
	wire 		[7:0]			CAM_DTA;

	// Assign Camera Pins
	assign CAM_HS 	= GPIO_0[23];
	assign CAM_VS 	= GPIO_0[22];
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
		.outclk_0(CAM_XLK),			// 	25 MHz (640x480 @ 60fps)
		.outclk_1(i2c_clk),			//  1 MHz 
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
		.I2C_SDA(CAM_SDA),
		.finish(LED[6])
		);	
		
	wire		[15:0]		pixel;
	wire					cam_o_pclk;
	wire					CAM_EN;
	
	// Camera RGB Data Capture
	CAM_RGB_Capture u_CAM_RGB_Capture (
		// Input
		.i_pclk(CAM_PLK),
		.CAM_RGB(CAM_DTA),
		.HREF(CAM_HS),
		.VSYNC(CAM_VS),
		// Output
		.HDMI_En(HDMI_EN),
		.PIXEL(pixel),
		.o_pclk(cam_o_pclk),
		.en(CAM_EN)
    );
	
	wire			HDMI_EN;
	
	// HDMI Pattern Generator
	HDMI_RGB_VPG HDMI_u (
		// Input
        .clk(cam_o_pclk),
        .HDMI_EN(HDMI_EN),
        .PIXEL(pixel),
		.SLO(SLO),
        // Output
        .pclk(HDMI_TX_CLK),
        .hs(HDMI_TX_HS),
        .vs(HDMI_TX_VS),
        .de(HDMI_TX_DE),
        .vga_r(HDMI_TX_D[23:16]),
        .vga_g(HDMI_TX_D[15:8]),
        .vga_b(HDMI_TX_D[7:0])
    );
	 
	reg [18:0] 	counter_1200k;
	reg 		en_150;
	reg [1:0] 	SLO = 2'd0;
	
	 
	always@(posedge i2c_clk or negedge reset_n)
	begin
		if (!reset_n)
		begin
			counter_1200k <= 19'b0;
			en_150 <= 1'b0;				//frequency divider
		end
		else
		begin
			counter_1200k <= counter_1200k + 19'b1;
			en_150 <= &counter_1200k;
		end
	end
	
	always@(posedge en_150)
	begin
		if (!KEY[1])
			if (SLO == 2'd2)
				SLO <= 2'd0;
			else
				SLO <= SLO + 2'd1;
		
	end

	assign LED[1:0] = SLO;
	assign GPIO_1[0] = HDMI_TX_HS;
	assign GPIO_1[1] = HDMI_TX_VS;
	assign GPIO_1[2] = HDMI_TX_DE;
	assign GPIO_1[3] = HDMI_TX_CLK;
	
endmodule