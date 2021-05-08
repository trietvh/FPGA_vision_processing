module HDMI_VPG #(
	// VGA 640x480 parameter
	// Horizontal
	parameter 		[11:0]		h_total 	= 12'd799,
	parameter 		[11:0]		h_sync	= 12'd95,
	parameter		[11:0]		h_start  = 12'd141,
	parameter 		[11:0]		h_end   	= 12'd781,
	// Vertival
	parameter 		[11:0]		v_total 	= 12'd524,
	parameter 		[11:0]		v_sync	= 12'd1,
	parameter		[11:0]		v_start  = 12'd34,
	parameter 		[11:0]		v_end   	= 12'd514
	) (
	input							clk,
	input	 						reset,
	input				[1:0] 	SW,
	output						pclk,
	output	reg				de,
	output	reg				hs,
	output	reg				vs,
	output	reg	[7:0]		vga_r,
	output 	reg	[7:0]		vga_g,
	output	reg	[7:0] 	vga_b
	);
	
	// Reg/Wire //
	reg	[11:0]	h_count;
	reg	[11:0]	v_count;
	reg				h_act; 
	reg				v_act;
	reg				pre_vga_de;
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
	always @(posedge clk or negedge reset) 
	begin
		 if (!reset)
		 begin
			  h_count <= 1'b0;
			  hs      <= 1'b1;
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
	always @(posedge clk or negedge reset) 
	begin
		 if(!reset)
		 begin
			  v_count <= 1'b0;
			  vs      <= 1'b1;
			  v_act   <= 1'b1;
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
	
	// Pattern Generator
	`define col  		12'd270
	`define width1  	12'd100
	`define width2  	12'd300
	`define len1 	 	12'd80
	`define len2 		12'd180
	`define row 		12'd190

	reg [11:0] width; 
	reg [11:0] len;
	
	always @(posedge clk or negedge reset)
	begin
		 if (!reset)
		 begin 
				de <= 1'b0;
			  pre_vga_de  <= 1'b0;
		 end
		 else
		 begin
			  de     <= pre_vga_de;
			  pre_vga_de <= v_act && h_act;
			  
			  case (SW[0])
					1'b0 : width <= `width1;
					1'b1 : width <= `width2;
					default: width <= `width1;
			  endcase

			  case (SW[1])
					0: len <= `len1;
					1: len <= `len2;
					default: len <= `len1;
			  endcase

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

		 end
	end
	
endmodule
