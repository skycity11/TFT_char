module TFT_display_top(
	input					clk_50m,
	input					rst_n,
	
	output	[15:0]	tft_rgb,
	output				tft_vsync,
	output				tft_hsync,
	output				tft_clk,
	output				tft_de,
	output				tft_pwm,
	output				tft_blank_n
);

wire				clk33_3m;


pll_0002 pll_inst(
	.refclk   (clk_50m),   
	.rst      (~rst_n),      
	.outclk_0 (clk33_3m), 
	.locked   (locked) 
);

wire				clk_vga;

wire	[10:0]	hcount_veneno;
wire	[10:0]	vcount_veneno;
wire				tft_req_veneno;

wire	[10:0]	hcount_xiaofang;
wire	[10:0]	vcount_xiaofang;
wire				tft_req_xiaofang;

wire	[10:0]	hcount_num;
wire	[10:0]	vcount_num;
wire				tft_req_num;

wire	[15:0]	data;

assign clk_vga = clk33_3m;

TFT_image u0(
	.clk_vga(clk_vga),
	.rst_n(rst_n),
	
	.tft_req_veneno(tft_req_veneno),	
	.hcount_veneno(hcount_veneno),	
	.vcount_veneno(vcount_veneno),	
	
	.tft_req_xiaofang(tft_req_xiaofang),
	.hcount_xiaofang(hcount_xiaofang),
	.vcount_xiaofang(vcount_xiaofang),
	
	.tft_req_num(tft_req_num),
	.hcount_num(hcount_num),
	.vcount_num(vcount_num),
	
	.display_data(data)										
);

TFT_driver u1(
	.clk_vga(clk_vga),
	.rst_n(rst_n),
	.data_in(data),
	
	.tft_req_veneno(tft_req_veneno),
	.hcount_veneno(hcount_veneno),
	.vcount_veneno(vcount_veneno),
	
	.tft_req_xiaofang(tft_req_xiaofang),
	.hcount_xiaofang(hcount_xiaofang),
	.vcount_xiaofang(vcount_xiaofang),
	
	.tft_req_num(tft_req_num),
	.hcount_num(hcount_num),
	.vcount_num(vcount_num),
	
	.tft_rgb(tft_rgb),
	.tft_hs(tft_hsync),
	.tft_vs(tft_vsync),
	.tft_clk(tft_clk),
	.tft_de(tft_de),
	.tft_pwm(tft_pwm),
	.tft_blank_n(tft_blank_n)
);

endmodule
