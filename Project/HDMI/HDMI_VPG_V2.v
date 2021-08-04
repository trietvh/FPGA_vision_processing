module HDMI_VPG_V2 (
	input							clk,
	input							reset,
	input				[15:0]	P_DTA,
	input							href,
	input							vsync,
	input							en,
	output						pclk,
	output	reg				de,
	output						hs,
	output						vs,
	output	reg	[7:0]		vga_r,
	output 	reg	[7:0]		vga_g,
	output	reg	[7:0] 	vga_b
	);
	
	
	assign pclk = clk;
	assign hs = href;
	assign vs = vsync;
	
	always @(posedge clk or negedge reset)
	begin
		if (!reset)
		begin
			de <= 1'b0;
		end
		else
		begin
			vga_r <= {P_DTA[7:3], 3'b0};
			vga_b <= {P_DTA[12:8], 3'b0};
			vga_g <= {P_DTA[2:0], P_DTA[15:13], 2'b0};
			de <= en;
		end
	end
	
	
	
	
	
	
	
endmodule 