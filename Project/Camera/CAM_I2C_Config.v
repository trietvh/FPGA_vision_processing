module CAM_I2C_Config #(
	parameter CLK_ref = 1000000,
	parameter I2C_clk = 20000,
	parameter LUT_SIZE = 73
	) 
	(
	// FPGA Side
	input wire	clk,
	input wire  reset,
	// I2C Side
	output wire I2C_SCL,
	output wire I2C_SDA
	);
	
	// Reg/Wire
	reg		[7:0]		I2C_CLK_DIV;
	reg		[23:0] 	I2C_DATA;
	reg					I2C_CTRL_CLK;
	reg 					I2C_EN;
	wire					I2C_END;
	wire					I2C_ACK;
	reg		[15:0]	LUT_DATA;
	reg		[6:0]		LUT_INDEX;
	reg 		[1:0]		Setup_ST;
	
	
	
	// I2C Control Clock //
	always @(posedge clk or negedge reset)
	begin
		if (!reset)
		begin
			I2C_CTRL_CLK	<= 0;
			I2C_CLK_DIV		<= 0;
		end
		else
		begin 
			if ( I2C_CLK_DIV	< (CLK_ref/I2C_clk))
				I2C_CLK_DIV		<= I2C_CLK_DIV + 1;
			else
			begin
				I2C_CLK_DIV		<= 0;
				I2C_CTRL_CLK 	<= ~I2C_CTRL_CLK;
			end
		end
	end
	// I2C Controller //
	CAM_I2C_Controller u_CAM_I2C_Controller (
		.clk(I2C_CTRL_CLK),
		.reset(reset),
		.I2C_DATA(I2C_DATA),
		.enable(I2C_EN),
		.I2C_SCL(I2C_SCL),
		.I2C_SDA(I2C_SDA),
		.ACK(I2C_ACK),
		.END(I2C_END)
		);

	//	Config Control //
	always @(posedge I2C_CTRL_CLK or negedge reset)
	begin 
		if (!reset)
		begin
			LUT_INDEX	<= 0;
			Setup_ST		<= 0;
			I2C_EN		<= 0;
		end
		else
		begin
			if (LUT_INDEX < LUT_SIZE)
			begin
				case (Setup_ST)
				0:	begin
						I2C_DATA		<= {8'h42,LUT_DATA};
						I2C_EN		<= 1;
						Setup_ST		<= 1;
					end
				1:	begin
						if (I2C_END)
						begin
							if (!I2C_ACK)
								Setup_ST		<= 2;
							else
								Setup_ST		<= 0;
							I2C_EN		<= 0;
						end
					end
				2:	begin
						LUT_INDEX		<= LUT_INDEX + 1;
						Setup_ST			<= 0;
					end
				endcase
			end
		end
	end
	
	/////////////////////	Config Data LUT	  //////////////////////////	
	always
		begin
			case(LUT_INDEX)
				0: 	LUT_DATA <= 16'h12_80;		// COM7, 	Reset
				1:	LUT_DATA <= 16'hFF_F0;		// Delay 	10 ms
				2:	LUT_DATA <= 16'h11_81;		// CLKRC,	Clock divine by 4
				3:	LUT_DATA <= 16'h6B_4A;		// DBLV, 	Clock multiply by 4
				4:	LUT_DATA <= 16'h12_04;		// COM7, 	Set RGB Output
				5: 	LUT_DATA <= 16'h3E_00;		// COM14,	Normal PCLK
				7:	LUT_DATA <= 16'h40_D0;		// COM15,	RGB565, Full range
				default: LUT_DATA <= 16'hFF_F0;        
			endcase
		end
		
endmodule