module vga_demo(CLOCK_50, SW, KEY_N,
				VGA_R, VGA_G, VGA_B,
				VGA_HS, VGA_VS, VGA_BLANK, VGA_SYNC, VGA_CLK);
	
	input CLOCK_50;	
	input [9:0] SW;
	input [3:0] KEY_N;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output VGA_HS;
	output VGA_VS;
	
	output VGA_BLANK;
	output VGA_SYNC;
	output VGA_CLK;	
	

	wire [7:0] x;
	wire [6:0] y;
	
	wire [7:0] vga_x;
   wire [6:0] vga_y;
	wire [2:0]vga_colour;	
	wire vga_plot;
	
	
	task2(CLOCK_50,SW[3],SW[9],vga_x,vga_y,vga_colour,vga_plot,Done);

	vga_adapter VGA(
			.resetn(KEY_N[3]),
			.clock(CLOCK_50),
			.colour(vga_colour),
			.x(vga_x),
			.y(vga_y),
			.plot(1),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK),
			.VGA_SYNC(VGA_SYNC),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";//"320x240";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "image.colour.mif";
		defparam VGA.USING_DE1 = "TRUE";
		
endmodule


module task2(CLOCK_50,Reset,Enable,x,y,colour,plot,Done);
	
	input CLOCK_50,Reset,Enable;
	output reg plot;
	output reg[2:0]colour;
	output reg [7:0] x;
	output reg [6:0] y;
	output Done;

	always@(posedge CLOCK_50,negedge Reset)begin
	if(~Reset)begin plot<=1; x<=0; y<=0; end
	else if((x<159)) begin x<=x+1; colour<=Enable?(y%8):3'b000; end
	else if(x==159 & y<119) begin y<=y+1; x<=0; end
	else if((y==119)&(x==159))begin plot<=0; end
	else begin x<=0;y<=0;end
	end
	assign Done=(~plot);
	
endmodule 
