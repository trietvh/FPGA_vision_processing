module CAM_DTA_Capture (
	input								i_pclk,
	input								reset,
	input 			[7:0] 		CAM_DTA,
	input								href,
	input								vsync,
	output	reg	[15:0] 		pixel,
	output	reg					o_pclk,
	output	reg					en
	);
	
	
	reg 	[1:0]		STATE;
	reg				full_pixel;
	
	localparam	WAIT = 0;
	localparam	CAPT = 1;
	
	always @(posedge i_pclk or negedge reset)
	begin
		if(!reset)
		begin
		STATE <= WAIT;
		full_pixel <= 0;
		pixel <= 16'b0;
		en <= 1'b0;
		end
		else
		begin
		case (STATE)
		WAIT:	begin
					STATE <= (!vsync) ? CAPT : WAIT;
					en <= 1'b0;
					full_pixel <= 0;
				end
		CAPT: begin 
					STATE <= vsync ? WAIT : CAPT;
					en <= href;
					if (href)
					begin
						full_pixel <= ~full_pixel;
						if (full_pixel)
							pixel[15:8] <= CAM_DTA;
						else
							pixel[7:0] <= CAM_DTA;
					end
				end
		endcase
		end
	end
	
	// Generate o_pclk = i_pclk/2
	reg [1:0] counter;
	always@(posedge i_pclk or negedge reset)
	begin
		if (!reset)
		begin
			counter <= 2'b0;
			o_pclk <= 1'b0;				//frequency divider
		end
		else
		begin
			if (counter < 1)
				counter <= counter + 1;
			else
			begin
				counter <= 0;
				o_pclk <= ~o_pclk;
			end
		end
	end
	
endmodule
	