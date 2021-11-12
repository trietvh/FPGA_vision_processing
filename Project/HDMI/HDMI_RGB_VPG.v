module HDMI_RGB_VPG (
	// Input
	input								clk,
	input								HDMI_EN,
	input					[15:0]		PIXEL,
	input					[1:0]		SLO,
	// Output
	output						pclk,
	output	reg					hs,
	output	reg					vs,
	output	reg					de,
	output	reg		[7:0]		vga_r,
	output 	reg		[7:0]		vga_g,
	output	reg		[7:0] 	vga_b
	);

	// VGA 640x480 parameter
	// Horizontal
	localparam 		h_total 		= 12'd783;
	localparam 		h_sync			= 12'd143;
	localparam		h_start  		= 12'd143;
	localparam 		h_end   		= 12'd783;
	// Vertical
	localparam 		v_total 		= 12'd509;
	localparam 		v_sync			= 12'd19;
	localparam		v_start  		= 12'd19;
	localparam 		v_end   		= 12'd499;

	// Reg/Wire //
	reg		[11:0]		h_count;
	reg		[11:0]		v_count;
	reg					h_act; 
	reg					v_act;
	reg					pre_vga_de;
	wire				h_max, hs_end, hr_start, hr_end;
	wire				v_max, vs_end, vr_start, vr_end;
	
	// Frame Condition
	assign h_max 		= h_count == h_total;
	assign hs_end 		= h_count >= h_sync;
	assign hr_start 	= h_count == h_start; 
	assign hr_end 		= h_count == h_end;
	assign v_max 		= v_count == v_total;
	assign vs_end 		= v_count >= v_sync;
	assign vr_start 	= v_count == v_start; 
	assign vr_end 		= v_count >= v_end;
	assign pclk 		= clk;
	
	// HDMI Start when buffer is filled with 1 pixel CAM_DTA
  	
	localparam 			WAIT_BUFFER		= 1'b0;
	localparam 			BUFFER_FULL		= 1'b1;
	reg 				BUFFER_STATE 	= 1'b0; 
	reg 				HDMI_START 		= 1'b0;
	reg      [10:0]		cnt = 11'd0;
	
	always @(posedge clk)
		case (BUFFER_STATE)
		WAIT_BUFFER: BUFFER_STATE 	<= HDMI_EN ? BUFFER_FULL : WAIT_BUFFER; 
		BUFFER_FULL: 
			begin
				if (cnt < 11'd1581)	// Delay for 2 lines (1 line = 784 pixels) (base 1581)
					cnt <= cnt + 11'd1;
				else
				begin
					HDMI_START 	<= 1'b1;
				end
			end
		endcase
	
	// Horizontal Control Signals
	always @(posedge clk) 
	begin
		 if (!HDMI_START)
		 begin
			  h_count <= 12'b0;
			  hs      <= 1'b0;
			  h_act   <= 1'b0;
		 end
		 else
		 begin
			if (h_max)
				h_count <= 12'b0;
			else
				h_count <= h_count + 12'b1;
			  
			if (hs_end && !h_max)
				hs	<=	1'b1;
			else
				hs	<=	1'b0;

			if (hr_start)
				h_act		<=	1'b1;
			else if (hr_end)
				h_act		<=	1'b0;
		 end
	end
	
	// Vertical Control Signals
	always @(posedge clk) 
	begin
		 if(!HDMI_START)
		 begin
			  v_count <= 12'b0;
			  vs      <= 1'b0;
			  v_act   <= 1'b0;
		 end
		 else
		 begin
			  if(h_max)
			  begin
					if (v_max)
						v_count <= 12'b0;
					else
						v_count <= v_count + 12'b1;

					if (vs_end && !vr_end)
						 vs <= 1'b1;
					else
						 vs <= 1'b0;

					if (vr_start)
						 v_act <= 1'b1;
					else if (vr_end)
						v_act <= 1'b0;	 
			  end
		 end
	end
	
	// Data Control Signals
	reg 		[15:0] 		PRE_PIXEL;
	reg 		[4:0]			GREY_PIXEL;
	wire R_TH, G_TH;
	wire [1:0] B_TH;
	wire TH;
	// Threshold
	assign R_TH = (PRE_PIXEL[15:11] > 5'd11) ? 1'b1 : 1'b0;
	assign G_TH = (PRE_PIXEL[10:5] > 6'd25) ? 1'b1 : 1'b0;
	assign B_TH[1] = PRE_PIXEL[4] ^ 1'b1;
	assign B_TH[0] = PRE_PIXEL[3] ^ 1'b1;
	assign TH = &B_TH || R_TH || G_TH;
	
	localparam RGB = 2'd0;
	localparam GREY = 2'd1;
	localparam THRESHOLD = 2'd2;
	
	// Select output
	always @(posedge clk)
	begin
		case (SLO)
		RGB:
		begin
			if (pre_vga_de)
				vga_r <= {PRE_PIXEL[15:11], PRE_PIXEL[15:13]};
				vga_g <= {PRE_PIXEL[10:5], PRE_PIXEL[10:9]};
				vga_b <= {PRE_PIXEL[4:0], PRE_PIXEL[4:2]};
		end
		GREY:
		begin
			if (pre_vga_de)
				vga_r <= {GREY_PIXEL, 3'b0};
				vga_g <= {GREY_PIXEL, 3'b0};
				vga_b <= {GREY_PIXEL, 3'b0};
		end
		THRESHOLD:
		begin
			if (pre_vga_de)
				if (TH)
					{vga_r, vga_g, vga_b} <= 24'h00_00_00;
				else
					{vga_r, vga_g, vga_b} <= 24'hFF_FF_FF;
		end
		endcase
	end

	always @(posedge clk)
	begin
		if (!HDMI_START)
		begin 
			de 			<= 1'b0;
			pre_vga_de  <= 1'b0;
			PRE_PIXEL	<= 16'b0;
		end
		else
		begin
			de     		<= pre_vga_de;
			pre_vga_de 	<= v_act && h_act;
			if (pre_vga_de)
			begin 
				PRE_PIXEL  <= PIXEL;
				GREY_PIXEL <= (PIXEL[15:11] + PIXEL[10:6] + PIXEL[4:0]) / 3'd3;
			end
		end
	end
endmodule
