module CAM_RGB_Capture (
	// Input
	input							i_pclk,
	input 				[7:0] 		CAM_RGB,
	input							HREF,
	input							VSYNC,
	// Output
	output	reg						HDMI_En,
	output	reg			[15:0] 		PIXEL,
	output	reg						o_pclk,
	output	reg						en = 1'b0
	);
	
	localparam WAIT_FRAME = 1'b0;
	localparam FRAME_START = 1'b1;
	reg STATE = 1'b0;
	reg frame_done;
	reg half_pixel;
	reg clk_STATE = 1'b0;

	// Generate an output clk = input clk / 2		
	always@(negedge i_pclk)
		case (clk_STATE)
		WAIT_FRAME: 
		begin
		// Using VSYNC to synchronize o_pclk
			clk_STATE <= VSYNC ? FRAME_START : WAIT_FRAME; 
			o_pclk <= 1'b0;
			HDMI_En <= 1'b0;
		end
		FRAME_START:
		begin
			o_pclk <= ~o_pclk;
			HDMI_En <= 1'b1;
		end
		endcase
		
	always @(posedge i_pclk)
		case (STATE)
		WAIT_FRAME:	
		begin
			STATE <= VSYNC ? FRAME_START : WAIT_FRAME;
			en <= 1'b0;
			half_pixel <= 1'b0;
			frame_done <= 1'b0;
			PIXEL[15:0] <= 16'hxx;
		end
		FRAME_START: 
		begin
			STATE <= (frame_done && VSYNC) ? WAIT_FRAME : FRAME_START;
			if (HREF)
			begin
				if (!half_pixel) 
				begin
					PIXEL[15:8] <= CAM_RGB;
					en <= 1'b0;
				end
				else
				begin
					PIXEL[7:0] <= CAM_RGB;
					en <= 1'b1;
				end
				half_pixel <= ~half_pixel;
				frame_done <= 1'b1;
			end
			else
			begin 
				PIXEL[15:0] <= 16'hxx;
				en <= 1'b0;
			end
		end
		endcase
endmodule
	