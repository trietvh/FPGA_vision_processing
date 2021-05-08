module I2C_WRITE_DATA (
	input 				clk,
	input 				reset,
	input 				enable,
	input		[15:0]	REG_DATA,
	input		[7:0]		SL_ADDR,
	input					SDAI,
	input  	[7:0]		BYTE_NUM,
	output	reg		ACK,
	output	reg		SDA,
	output	reg		SCL,
	output 	reg		END
	);
	
	// REG/WIRE //
	reg [8:0] Temp;
	reg [7:0] CNT;
	reg [7:0] ST;
	reg [7:0] BYTE;
	
	
	always @(posedge clk or negedge reset)
	begin
		if (!reset)
			ST 	<= 0;
		else
			case (ST)
				0: begin
						SDA	<= 1;
						SCL	<= 1;
						ACK	<= 0;
						CNT	<= 0;
						END	<= 1;
						BYTE	<= 0;
						if (enable) ST	<= 30;
					end
				1: begin
						ST		<= 2;
						{SDA, SCL}	<= 2'b01;
						Temp	<= {SL_ADDR, 1'b1};
					end
				2: begin
						ST		<= 3;
						{SDA, SCL} 	<= 2'b00;
					end
				3: begin
						ST		<= 4;
						{SDA, Temp}	<= {Temp, 1'b0};
					end
				4: begin
						ST 	<= 5;
						SCL	<= 1'b1;
						CNT	<= CNT + 1;
					end
				5: begin
						SCL <= 1'b0;
						if (CNT == 9) 
						begin
							if (BYTE == BYTE_NUM) ST <= 6;
							else
							begin
								CNT 	<= 0;
								ST		<= 2;
								
								if ( BYTE == 0 )
								begin
									BYTE	<= 1;
									Temp	<= {REG_DATA[15:8], 1'b1};
								end
								else if ( BYTE == 1)
								begin
									BYTE	<= 2;
									Temp	<= {REG_DATA[7:0], 1'b1};
								end
								
							end
							
							if (SDAI) ACK	<= 1;
						end
						else ST <= 2;
					end
				6: begin 
						ST	<= 7;
						{SDA, SCL}	<= 2'b00;
					end
				7: begin
						ST	<= 8;
						{SDA, SCL}	<= 2'b01;
					end
				8: begin
						ST	<= 9;
						{SDA, SCL} 	<= 2'b11;
					end
				9: begin
						ST		<= 30;
						SDA	<= 1;
						SCL	<= 1;
						CNT	<= 0;
						END	<= 1;
						BYTE	<= 0;
					end
				30: begin
					if (!enable) ST <= 31;
					end
				31: begin
					END <= 0;
					ACK <= 0;
					ST <= 1;
					end
			endcase
	end
endmodule		
						
						
	