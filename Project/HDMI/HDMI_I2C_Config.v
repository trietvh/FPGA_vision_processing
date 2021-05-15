module HDMI_I2C_Config (
	// FPGA Side
	input wire	clk,
	input wire  reset,
	// I2C Side
	output wire I2C_SCL,
	output wire I2C_SDA,
	input  wire HDMI_TX_INT
	);
	
	// Reg/Wire
	reg		[7:0]		I2C_CLK_DIV;
	reg		[23:0] 	I2C_DATA;
	reg					I2C_CTRL_CLK;
	reg 					I2C_EN;
	wire					I2C_END;
	wire					I2C_ACK;
	reg		[15:0]	LUT_DATA;
	reg		[5:0]		LUT_INDEX;
	reg 		[1:0]		Setup_ST;
	
	
	localparam CLK_ref = 1000000;
	localparam I2C_clk = 20000;
	localparam LUT_SIZE = 31;
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
	HDMI_I2C_Controller u_HDMI_I2C_Controller (
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
						I2C_DATA		<= {8'h72,LUT_DATA};
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
			else
			begin	
				if (!HDMI_TX_INT)
					LUT_INDEX <= 0;
				else
					LUT_INDEX <= LUT_INDEX;
			end
		end
	end
	
	/////////////////////	Config Data LUT	  //////////////////////////	
	always
		begin
			case(LUT_INDEX)
				0	:	LUT_DATA	<=	16'h9803;  //Must be set to 0x03 for proper operation
				1	:	LUT_DATA	<=	16'h0100;  //Set 'N' value at 6144
				2	:	LUT_DATA	<=	16'h0218;  //Set 'N' value at 6144
				3	:	LUT_DATA	<=	16'h0300;  //Set 'N' value at 6144
				4	:	LUT_DATA	<=	16'h1470;  //Set Ch count in the channel status to 8.
				5	:	LUT_DATA	<=	16'h1520;  //Input 444 (RGB or YCrCb) with Separate Syncs, 48kHz fs
				6	:	LUT_DATA	<=	16'h1630;  //Output format 444, 24-bit input
				7	:	LUT_DATA	<=	16'h1846;  //Disable CSC
				8	:	LUT_DATA	<=	16'h4080;  //General control packet enable
				9	:	LUT_DATA	<=	16'h4110;  //Power down control
				10	:	LUT_DATA	<=	16'h49A8;  //Set dither mode - 12-to-10 bit
				11	:	LUT_DATA	<=	16'h5510;  //Set RGB in AVI infoframe
				12	:	LUT_DATA	<=	16'h5608;  //Set active format aspect
				13	:	LUT_DATA	<=	16'h96F6;  //Set interrup
				14	:	LUT_DATA	<=	16'h7307;  //Info frame Ch count to 8
				15	:	LUT_DATA	<=	16'h761f;  //Set speaker allocation for 8 channels
				16	:	LUT_DATA	<=	16'hFFF0;  //Must be set to 0x03 for proper operation
				17	:	LUT_DATA	<=	16'h9902;  //Must be set to Default Value
				18	:	LUT_DATA	<=	16'h9ae0;  //Must be set to 0b1110000
				19	:	LUT_DATA	<=	16'h9c30;  //PLL filter R1 value
				20	:	LUT_DATA	<=	16'h9d61;  //Set clock divide
				21	:	LUT_DATA	<=	16'ha2a4;  //Must be set to 0xA4 for proper operation
				22	:	LUT_DATA	<=	16'ha3a4;  //Must be set to 0xA4 for proper operation
				23	:	LUT_DATA	<=	16'ha504;  //Must be set to Default Value
				24	:	LUT_DATA	<=	16'hab40;  //Must be set to Default Value
				25	:	LUT_DATA	<=	16'haf16;  //Select HDMI mode
				26	:	LUT_DATA	<=	16'hba60;  //No clock delay
				27	:	LUT_DATA	<=	16'hd1ff;  //Must be set to Default Value
				28	:	LUT_DATA	<=	16'hde10;  //Must be set to Default for proper operation
				29	:	LUT_DATA	<=	16'he460;  //Must be set to Default Value
				30	:	LUT_DATA	<=	16'hfa7d;  //Nbr of times to look for good phase
				default:LUT_DATA	<=	16'h9803;
			endcase
		end
endmodule