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
	
	
	challengetask Ch1 (CLOCK_50,KEY_N,x,y,vga_x,vga_y,vga_plot,vga_colour);

	vga_adapter VGA(
			.resetn(KEY_N[3]),
			.clock(CLOCK_50),
			.colour(vga_colour),
			.x(vga_x),
			.y(vga_y),
			.plot(vga_plot),
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




module challengetask (CLOCK_50,KEY_N,x,y,vga_x,vga_y,vga_plot,vga_colour);

	input CLOCK_50;
	input [3:0]KEY_N;
	output reg [7:0] vga_x;
   	output reg [6:0] vga_y;
	output reg [2:0]vga_colour;	
	output reg vga_plot;


	output [7:0] x;
	output [6:0] y;	
	
	wire [7:0] xc;
	wire [6:0] yc;
		
	//assign xc=79;
	//assign yc=59;
	

	
	wire [7:0] x1,x2;
	wire [6:0] y1,y2;

	
	wire Reset,plotclear,plotcircle;
	wire Done;
	assign Reset=KEY_N[3];
	
	

	wire [2:0]colour,colourcircle,colourclear;

	
	always@(*)begin
	if(Done)begin  vga_x=x2; vga_y=y2; vga_plot=plotcircle; vga_colour=colourcircle; end
	else begin vga_x=x1; vga_y=y1; vga_plot=plotclear; vga_colour=colourclear; end
	end

	////////////////////////////////////////
	
	reg check;	
	parameter dn=26;
   
	reg [dn-1:0]count;
	always@(posedge CLOCK_50,negedge Reset)begin
	if(!Reset) count<=0;
	else if(count==510) count<=0;
	else if(~plotcircle & Done)count<=count+1;
	else count<=count;
	end
	//50000001
	
	
	wire [4:0]tmp;
	LFSR #(8,2,6,7,159,97) L0 (8'd79,CLOCK_50,Reset,(count==509),xc);
	LFSR #(7,2,3,6,119, 9) L1 (7'd59,CLOCK_50,Reset,(count==509),yc);
	LFSR #(5,1,2,4,  7, 0) L2 (5'd7 ,CLOCK_50,Reset,(count==509),tmp);
	
	
	assign colour=tmp[2:0];

	
	wire [5:0] r;
	Comparator C0(CLOCK_50,xc,yc,r);	

	
	
	///////////////////////////////////////

	
	task2 T2(CLOCK_50,Reset,1'b0,x1,y1,colourclear,plotclear,Done);
	
	task3 T3(CLOCK_50,Reset,Done,~(count==510),xc,yc,{r,colour},x,y,x2,y2,plotcircle,colourcircle);
	
endmodule







module Comparator(CLOCK_50,xc,yc,Q3);

	input CLOCK_50;
	input [7:0] xc;
	input [6:0] yc;
	output reg [5:0] Q3;
	reg [7:0] a;
	reg [6:0] b;
	
	reg [7:0] Q1;
	reg [6:0] Q2;
		
	always@(*)begin
	a=(159-xc);
	b=(119-yc);
	Q1=((159-xc)<xc)?(159-xc):xc;
	Q2=((119-yc)<yc)?(119-yc):yc;
   Q3= (Q1<Q2)?Q1[5:0] :Q2[5:0];
	end

endmodule




module LFSR #(parameter n=8,tap1=2,tap2=6,tap3=7,check=159,sub=97)(input [n-1:0] Din,input Clk,input L,input Enable,output reg [n-1:0] Qout);

	reg [n-1:0]Q;	
	integer k;
	//posedge Clk
	always@(posedge Clk,negedge L)begin
		if(!L) begin Q<=Din; end
		else if(Enable) begin
				for(k=0;k<n-1;k=k+1)begin
					Q[k+1]<=Q[k];
				end
					Q[0]<=Q[tap1]^Q[tap2]^Q[tap3];				
				end
			end
	
	always@(*)begin
	if(Q>check) Qout=Q-sub;
	else Qout=Q;
	end
	
endmodule



module task3(CLOCK_50,Reset,Done,key,xc,yc,SW,x,y,xp,yp,plot,colourcircle);

	input key,Reset,Done;
	input CLOCK_50;
		
	output reg [7:0] xp;
	output reg [6:0] yp;
   
	output reg [7:0] x;
   output reg [6:0] y;
	
	output reg [2:0]colourcircle;
	
	output plot;
	
	input [7:0] xc;
	input [6:0] yc;

	input [8:0] SW;
	
	wire ch;
	assign ch=(x>y);

  	
	reg [5:0]r;
	
	reg [3:0]state,nstate;
	parameter R=4'd0,P1=4'd1,P2=4'd2,P3=4'd3,P4=4'd4,P5=4'd5,P6=4'd6,P7=4'd7,P8=4'd8;//Done=4'd9;
	
	always@(*)begin
	case(state)
	R:nstate=key?R:P1;
	
	P1:nstate=P2;
	P2:nstate=P3;
	P3:nstate=P4;
	P4:nstate=P5;
	P5:nstate=P6;
	P6:nstate=P7;
	P7:nstate=(y==0)?R:P8;
	P8:nstate=ch?R:P1;
	
	default:nstate=state;
	endcase
	end

	
	always@(posedge CLOCK_50,negedge Reset)begin
	if(~Reset)state<=R;
	else if(Done) state<=nstate;
	else state<=state;
	end

	
	reg [8:0]d;
	
	always@(posedge CLOCK_50)begin
	case(state)
	R:begin 
	        if(SW[8:3]>59) r=59; else r=SW[8:3];
			  colourcircle=SW[2:0];
			  d=(9'd3)-(9'd2*r); 
			  x=(8'd0); 
			  y=r; 
			  xp=xc + x; yp=yc + y; 
	  end
	 P1:begin xp=xc + x; yp=yc + y; end
    P2:begin xp=xc - x; yp=yc + y; end
    P3:begin xp=xc + x; yp=yc - y; end
    P4:begin xp=xc - x; yp=yc - y; end
    P5:begin xp=xc + y; yp=yc + x; end
    P6:begin xp=xc - y; yp=yc + x; end
    P7:begin xp=xc + y; yp=yc - x; end
    P8:begin
		xp=xc - y; yp=yc - x;
	   x=x+8'd1;	
	   if ((d>256))begin d=d+((9'd4)*x)+(9'd6);  end
	   else if ((d<=256))begin d=d+((9'd4)*(x-y))+(9'd10); y=y-7'd1; end
	   else d=d;
	   end
	endcase
	end
	
	assign plot=~(state==R);
	

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
