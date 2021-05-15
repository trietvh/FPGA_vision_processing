module CAM_I2C_Controller (
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
	wire SCLO;
	
	assign I2C_SDA = SDAO ? 1'bz : 1'b0;
	assign I2C_SCL = SCLO ? 1'bz : 1'b0;
	
	I2C_WRITE_DATA CAM_I2C_WRITE_DATA (
		.clk(clk),
		.reset(reset),
		.enable(enable),
		.SCL(SCLO),
		.SDA(SDAO),
		.SDAI(I2C_SDA),
		.ACK(ACK),
		.END(END),
		.REG_DATA(I2C_DATA[15:0]),
		.SL_ADDR(I2C_DATA[23:16]),
		.BYTE_NUM(2)
		);
	
	
endmodule