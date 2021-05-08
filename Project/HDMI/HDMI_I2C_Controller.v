module HDMI_I2C_Controller (
	input				clk,
	input [23:0] 	I2C_DATA,
	input 			enable,
	input 			reset,
	inout 			I2C_SDA,
	output 			I2C_SCL,
	output 			ACK,
	output 			END
	);
	wire SDAO;
	
	assign I2C_SDA = SDAO ? 1'bz : 0;
	
	I2C_WRITE_DATA (
		.clk(clk),
		.reset(reset),
		.SCL(I2C_SCL),
		.SDA(SDAO),
		.SDAI(I2C_SDA),
		.ACK(ACK),
		.END(END),
		.REG_DATA(I2C_DATA[15:0]),
		.SL_ADDR(I2C_DATA[23:16]),
		.BYTE_NUM(2)
		);
	
	
endmodule