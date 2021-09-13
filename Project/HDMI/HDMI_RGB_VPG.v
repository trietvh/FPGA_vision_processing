module HDMI_RGB_VPG (
	// Input
	input						clk,
	input	 					reset_n,
	input						buffer_rd,
	input			[15:0]		PIXEL,
	input			[10:0]		RD_ADDR,
	// Output
	output						pclk,
	output	reg					hs,
	output	reg					vs,
	output	reg					de,
	output	reg		[7:0]		vga_r,
	output 	reg		[7:0]		vga_g,
	output	reg		[7:0] 		vga_b
	);

	// VGA 640x480 parameter
	// Horizontal
	localparam 		h_total 	= 12'd799;
	localparam 		h_sync		= 12'd95;
	localparam		h_start  	= 12'd141;
	localparam 		h_end   	= 12'd781;
	// Vertical
	localparam 		v_total 	= 12'd492;
	localparam 		v_sync		= 12'd1;
	localparam		v_start  	= 12'd2;
	localparam 		v_end   	= 12'd482;

	// Reg/Wire //
	reg		[11:0]		h_count;
	reg		[11:0]		v_count;
	reg					h_act; 
	reg					v_act;
	reg					pre_vga_de;
	wire				h_max, hs_end, hr_start, hr_end;
	wire				v_max, vs_end, vr_start, vr_end;
	
	// Frame Condition
	assign h_max = h_count == h_total;
	assign hs_end = h_count >= h_sync;
	assign hr_start = h_count == h_start; 
	assign hr_end = h_count == h_end;
	assign v_max = v_count == v_total;
	assign vs_end = v_count >= v_sync;
	assign vr_start = v_count == v_start; 
	assign vr_end = v_count == v_end;
	assign pclk = clk;
  	
	// Horizontal Control Signals
	
	always @(posedge clk or negedge reset_n) 
	begin
		 if (!reset_n)
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

	always @(posedge clk or negedge reset_n) 
	begin
		 if(!reset_n)
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

	always @(posedge clk or negedge reset_n)
	begin
		if (!reset_n)
		begin 
			de <= 1'b0;
			pre_vga_de  <= 1'b0;
		end
		else
		begin
			de     		<= pre_vga_de;
			pre_vga_de 	<= v_act && h_act;
			/*
			if (pre_vga_de)
			begin
				vga_r <= {PIXEL[15:11],3'h0};
				vga_g <= {PIXEL[10:5],2'h0};
				vga_b <= {PIXEL[4:0],3'h0};
			end
			else {vga_r, vga_g, vga_b} <= 24'bx;
			*/
			{vga_r, vga_g, vga_b} <= {8'h00, 8'hFF, 8'hFF};
		end
	end
	
endmodule
