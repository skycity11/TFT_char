module TFT_image(
	input						clk_vga,
	input						rst_n,
	
	input						tft_req_veneno,	//数据请求信号——veneno	
	input     	[10:0]   hcount_veneno,		//x坐标——veneno
	input     	[10:0]   vcount_veneno,		//y坐标——veneno
	
	input						tft_req_xiaofang,	//数据请求信号——xiaofang
	input     	[10:0]   hcount_xiaofang,	//x坐标——xiaofang
	input     	[10:0]   vcount_xiaofang,	//y坐标——xiaofang

	input						tft_req_num,	//数据请求信号——num
	input     	[10:0]   hcount_num,	//x坐标——num
	input     	[10:0]   vcount_num,	//y坐标——num

	output reg  [15:0]	display_data										
);

localparam	BLACK 	= 16'h0000,		//黑色
				BLUE 		= 16'h001f,		//蓝色
				RED 		= 16'hf800,		//红色
				PURPPLE 	= 16'hf81f,		//紫色
				GREEN		= 16'h07e0,		//绿色
				CYAN 		= 16'h07ff,		//青色
				YELLOW 	= 16'hffe0,		//黄色
				WHITE 	= 16'hffff;		//白色


//循环输入0-9，间隔0.5s
reg	[23:0]	cnt;
parameter	clk_div = 24'd16650000;
always @(posedge clk_vga or negedge rst_n) begin
	if(!rst_n)
		cnt <= 24'd0;
	else if(cnt == (clk_div - 1'b1))
		cnt <= 24'd0;
	else
		cnt <= cnt + 1'b1;
end

reg	[3:0]		data_cnt;
always @(posedge clk_vga or negedge rst_n) begin
	if(!rst_n)
		data_cnt <= 4'd0;
	else if(cnt == (clk_div - 1'b1))
		if(data_cnt == 4'd9)
			data_cnt <= 4'd0;
		else
			data_cnt <= data_cnt + 1'b1;
	else
		data_cnt <= data_cnt;
end

reg				data_num;
always @(*) begin
	case(data_cnt)
		4'd0 		: data_num = data_0;
		4'd1 		: data_num = data_1;
		4'd2 		: data_num = data_2;
		4'd3 		: data_num = data_3;
		4'd4 		: data_num = data_4;
		4'd5 		: data_num = data_5;
		4'd6 		: data_num = data_6;
		4'd7 		: data_num = data_7;
		4'd8 		: data_num = data_8;
		4'd9 		: data_num = data_9;
		default	: data_num = 1'b0;
	endcase
end

//ROM例化
reg 	[13:0] 	rdaddress_char;
wire 				data_char;
ROM_char  ROM_char_inst (
	.address ( rdaddress_char ),
	.clock ( clk_vga ),
	.q ( data_char )
	);


wire 				data_0;
ROM_0  ROM_0_inst (
	.address ( rdaddress_num ),
	.clock ( clk_vga ),
	.q ( data_0 )
	);

wire 				data_1;
ROM_1  ROM_1_inst (
	.address ( rdaddress_num ),
	.clock ( clk_vga ),
	.q ( data_1 )
	);

wire 				data_2;
ROM_2  ROM_2_inst (
	.address ( rdaddress_num ),
	.clock ( clk_vga ),
	.q ( data_2 )
	);
	
wire 				data_3;
ROM_3  ROM_3_inst (
	.address ( rdaddress_num ),
	.clock ( clk_vga ),
	.q ( data_3 )
	);
	
wire 				data_4;
ROM_4  ROM_4_inst (
	.address ( rdaddress_num ),
	.clock ( clk_vga ),
	.q ( data_4 )
	);
	
wire 				data_5;
ROM_5  ROM_5_inst (
	.address ( rdaddress_num ),
	.clock ( clk_vga ),
	.q ( data_5 )
	);
	
wire 				data_6;
ROM_6  ROM_6_inst (
	.address ( rdaddress_num ),
	.clock ( clk_vga ),
	.q ( data_6 )
	);
	
wire 				data_7;
ROM_7  ROM_7_inst (
	.address ( rdaddress_num ),
	.clock ( clk_vga ),
	.q ( data_7 )
	);
	
wire 				data_8;
ROM_8  ROM_8_inst (
	.address ( rdaddress_num ),
	.clock ( clk_vga ),
	.q ( data_8 )
	);
	
wire 				data_9;
ROM_9  ROM_9_inst (
	.address ( rdaddress_num ),
	.clock ( clk_vga ),
	.q ( data_9 )
	);

//rdadress
wire [13:0] rdaddress_veneno;
assign rdaddress_veneno = hcount_veneno[10:0] + vcount_veneno[10:0]*48;

wire [13:0] rdaddress_xiaofang;
assign rdaddress_xiaofang = hcount_xiaofang[10:0] + vcount_xiaofang[10:0]*32 + 768;

wire [13:0] rdaddress_num;
assign rdaddress_num = hcount_num[10:0] + vcount_num[10:0]*8;

always@(*) begin
	case({tft_req_xiaofang,tft_req_veneno})
		2'b01:rdaddress_char = rdaddress_veneno;
		2'b10:rdaddress_char = rdaddress_xiaofang;
		default:rdaddress_char = 14'b0;
	endcase
end				

//display_data

always @(*) begin
	case({tft_req_num,tft_req_xiaofang,tft_req_veneno})
		3'b000:	display_data = BLACK;
		3'b001:	display_data = {11'b0,data_char,data_char,data_char,data_char,data_char};
		3'b010:	display_data = {data_char,data_char,data_char,data_char,data_char,data_char,data_char,data_char,data_char,data_char,data_char,data_char,data_char,data_char,data_char,data_char};
		3'b100:	display_data = {data_num,data_num,data_num,data_num,data_num,11'b0};
		default: display_data = BLACK;
	endcase
end

endmodule
