module HDMI_RGB_VPG (
	// Input
	input								clk,
	input								BUFFER_EN,
	input					[15:0]	PIXEL,
	// Output
	output	reg		[12:0]	RD_ADDR,
	output							pclk,
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
	localparam 		h_sync		= 12'd90;
	localparam		h_start  	= 12'd127;
	localparam 		h_end   		= 12'd767;
	// Vertical
	localparam 		v_total 		= 12'd509;
	localparam 		v_sync		= 12'd1;
	localparam		v_start  	= 12'd8;
	localparam 		v_end   		= 12'd488;

	// Reg/Wire //
	
	reg		[11:0]		h_count;
	reg		[11:0]		v_count;
	reg						h_act; 
	reg						v_act;
	reg						pre_vga_de;
	wire						h_max, hs_end, hr_start, hr_end;
	wire						v_max, vs_end, vr_start, vr_end;
	
	// Frame Condition
	assign h_max 		= h_count == h_total;
	assign hs_end 		= h_count >= h_sync;
	assign hr_start 	= h_count == h_start; 
	assign hr_end 		= h_count == h_end;
	assign v_max 		= v_count == v_total;
	assign vs_end 		= v_count >= v_sync;
	assign vr_start 	= v_count == v_start; 
	assign vr_end 		= v_count == v_end;
	assign pclk 		= clk;
	
	// HDMI Start when buffer is filled with 1 pixel CAM_DTA
  	
	localparam 		WAIT_BUFFER		= 1'b0;
	localparam 		BUFFER_FULL		= 1'b1;
	reg 				BUFFER_STATE 	= 1'b0; 
	reg 				HDMI_START 		= 1'b0;
	
	always @(posedge clk)
		case (BUFFER_STATE)
		WAIT_BUFFER: BUFFER_STATE 	<= BUFFER_EN ? BUFFER_FULL : WAIT_BUFFER; 
		BUFFER_FULL: HDMI_START 	<= 1'b1;
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

					if (vs_end && !v_max)
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
	`define row 		12'd190
	`define col  		12'd270
	
	reg [11:0] width = 12'd300; 
	reg [11:0] len = 12'd180;
	always @(posedge clk)
	begin
		if (!HDMI_START)
		begin 
			de 			<= 1'b0;
			pre_vga_de  <= 1'b0;
			RD_ADDR		<= 13'd0;
			PRE_PIXEL	<= 16'b0;
		end
		else
		begin
			de     		<= pre_vga_de;
			pre_vga_de 	<= v_act && h_act;

			if (pre_vga_de)
			begin 
				PRE_PIXEL <= PIXEL;
				if (RD_ADDR <= 13'd7039)
					RD_ADDR <= RD_ADDR + 1'b1;
				else	
					RD_ADDR <= 13'd0;
			end
			
			
			if (de)
			begin
				vga_r <= {PRE_PIXEL[15:11], 3'h0};
				vga_g <= {PRE_PIXEL[10:5], 2'h0};
				vga_b <= {PRE_PIXEL[4:0], 3'h0};
			end
			else 
				{vga_r, vga_g, vga_b} <= 24'hFF_00_00;
			
			
			//{vga_r, vga_g, vga_b} <= {8'h00, 8'hFF, 8'hFF};
			
			/*
			if (v_count == `row && h_count >= `col && h_count <= `col + width)
					{vga_r, vga_g, vga_b} <= {8'h00, 8'hFF, 8'hFF};
			else if (v_count == `row + len && h_count >= `col && h_count <= `col + width)
					{vga_r, vga_g, vga_b} <= {8'h00, 8'hFF, 8'hFF};
			else if (h_count == `col && v_count >= `row && v_count <= `row + len)
					{vga_r, vga_g, vga_b} <= {8'h00, 8'hFF, 8'hFF};
			else if (h_count == `col + width && v_count >= `row && v_count <= `row + len)
					{vga_r, vga_g, vga_b} <= {8'h00, 8'hFF, 8'hFF};
			else
					{vga_r, vga_g, vga_b} <= {8'h00, 8'h00, 8'h00};
			*/
		end
	end
	
endmodule
