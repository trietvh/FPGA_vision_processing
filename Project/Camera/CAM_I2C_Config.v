module CAM_I2C_Config (
	// FPGA Side
	input wire	clk,
	input wire  reset,
	// I2C Side
	output wire I2C_SCL,
	output wire I2C_SDA,
	output		finish
	);
	
	// Reg/Wire
	reg		[7:0]		I2C_CLK_DIV;
	reg		[23:0] 		I2C_DATA;
	reg					I2C_CTRL_CLK;
	reg 				I2C_EN;
	wire				I2C_END;
	wire				I2C_ACK;
	reg		[15:0]		LUT_DATA;
	reg		[6:0]		LUT_INDEX;
	reg 	[1:0]		Setup_ST;
	
	localparam CLK_ref = 1000000;
	localparam I2C_clk = 20000;
	localparam LUT_SIZE = 71;
	
	assign finish = LUT_INDEX == LUT_SIZE;
	
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
				I2C_CLK_DIV		<= I2C_CLK_DIV + 8'd1;
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
			Setup_ST	<= 0;
			I2C_EN		<= 0;
		end
		else
		begin
			if (LUT_INDEX < LUT_SIZE)
			begin
				case (Setup_ST)
				0:	begin
						I2C_DATA		<= {8'h42,LUT_DATA};
						I2C_EN			<= 1;
						Setup_ST		<= 1;
					end
				1:	begin
						if (I2C_END)
						begin
							Setup_ST	<= 2;
							I2C_EN		<= 0;
						end
					end
				2:	begin
						LUT_INDEX		<= LUT_INDEX + 7'd1;
						Setup_ST		<= 0;
					end
				endcase
			end
		end
	end
	
	/////////////////////	Config Data LUT	  //////////////////////////	
	always
		begin
			case(LUT_INDEX)
				    0:  LUT_DATA <= 16'h12_80; //reset
					 1:  LUT_DATA <= 16'hFF_FF; //delay
					 2:  LUT_DATA <= 16'h12_04; // COM7,     set RGB color output
					 3:  LUT_DATA <= 16'h11_80; // CLKRC     Use external clock
					 4:  LUT_DATA <= 16'h0C_00; // COM3,     default settings
					 5:  LUT_DATA <= 16'h3E_00; // COM14,    no scaling, normal pclock
					 6:  LUT_DATA <= 16'h04_00; // COM1,     disable CCIR656
					 7:  LUT_DATA <= 16'h40_10; //COM15,     RGB565, full output range
					 8:  LUT_DATA <= 16'h3a_04; //TSLB       set correct output data sequence (magic)
					 9:  LUT_DATA <= 16'h14_38; //COM9       MAX AGC value x4
					 
					10: LUT_DATA <= 16'h4F_40; //MTX1       all of these are magical matrix coefficients
					11: LUT_DATA <= 16'h50_34; //MTX2
					12: LUT_DATA <= 16'h51_0c; //MTX3
					13: LUT_DATA <= 16'h52_17; //MTX4
					14: LUT_DATA <= 16'h53_29; //MTX5
					15: LUT_DATA <= 16'h54_40; //MTX6
					16: LUT_DATA <= 16'h58_1e; //MTXS
					17: LUT_DATA <= 16'h3D_C0; //COM13      sets gamma enable
					18: LUT_DATA <= 16'h17_14; //HSTART     start high 8 bits
					19: LUT_DATA <= 16'h18_02; //HSTOP      stop high 8 bits //these kill the odd colored line
					20: LUT_DATA <= 16'h32_80; //HREF       edge offset
					
					21: LUT_DATA <= 16'h19_03; //VSTART     start high 8 bits
					22: LUT_DATA <= 16'h1A_7B; //VSTOP      stop high 8 bits
					23: LUT_DATA <= 16'h03_0A; //VREF       vsync edge offset
					24: LUT_DATA <= 16'h0F_41; //COM6       reset timings
					
					25: LUT_DATA <= 16'h1E_20; //MVFP       disable mirror / flip //might have magic value of 03
					26: LUT_DATA <= 16'h33_0B; //CHLF       //magic value from the internet
					27: LUT_DATA <= 16'h3C_78; //COM12      no HREF when VSYNC low
					28: LUT_DATA <= 16'h69_00; //GFIX       fix gain control
					29: LUT_DATA <= 16'h74_10; //REG74      Digital gain control
					30: LUT_DATA <= 16'hB0_84; //RSVD       magic value from the internet *required* for good color
					31: LUT_DATA <= 16'hB1_0c; //ABLC1
					32: LUT_DATA <= 16'hB2_0e; //RSVD       more magic internet values
					33: LUT_DATA <= 16'hB3_80; //THL_ST
					//begin mystery scaling numbers
					34: LUT_DATA <= 16'h70_3a;
					35: LUT_DATA <= 16'h71_35;
					36: LUT_DATA <= 16'h72_11;
					37: LUT_DATA <= 16'h73_f0;
					38: LUT_DATA <= 16'ha2_02;
					 //gamma curve values
					39: LUT_DATA <= 16'h7a_20;
					40: LUT_DATA <= 16'h7b_10;
					41: LUT_DATA <= 16'h7c_1e;
					42: LUT_DATA <= 16'h7d_35;
					43: LUT_DATA <= 16'h7e_5a;
					44: LUT_DATA <= 16'h7f_69;
					45: LUT_DATA <= 16'h80_76;
					46: LUT_DATA <= 16'h81_80;
					47: LUT_DATA <= 16'h82_88;
					48: LUT_DATA <= 16'h83_8f;
					49: LUT_DATA <= 16'h84_96;
					50: LUT_DATA <= 16'h85_a3;
					51: LUT_DATA <= 16'h86_af;
					52: LUT_DATA <= 16'h87_c4;
					53: LUT_DATA <= 16'h88_d7;
					54: LUT_DATA <= 16'h89_e8;
					//AGC and AEC
					55: LUT_DATA <= 16'h00_00; //set gain reg to 0 for AGC
					56: LUT_DATA <= 16'h10_00; //set ARCJ reg to 0
					57: LUT_DATA <= 16'h0d_40; //magic reserved bit for COM4
					58: LUT_DATA <= 16'ha5_05; //BD50MAX
					59: LUT_DATA <= 16'hab_07; //DB60MAX
					60: LUT_DATA <= 16'h24_95; //AGC upper limit
					61: LUT_DATA <= 16'h25_33; //AGC lower limit
					62: LUT_DATA <= 16'h26_e3; //AGC/AEC fast mode op region
					63: LUT_DATA <= 16'h9f_78; //HAECC1
					64: LUT_DATA <= 16'ha0_68; //HAECC2
					65: LUT_DATA <= 16'ha1_03; //magic
					66: LUT_DATA <= 16'ha6_d8; //HAECC3
					67: LUT_DATA <= 16'ha7_d8; //HAECC4
					68: LUT_DATA <= 16'ha8_f0; //HAECC5
					69: LUT_DATA <= 16'ha9_90; //HAECC6
					70: LUT_DATA <= 16'haa_94; //HAECC7
					71: LUT_DATA <= 16'h13_e5; //COM8, disable AGC / AEC
				default: LUT_DATA <= 16'h12_04;        
			endcase
		end
endmodule