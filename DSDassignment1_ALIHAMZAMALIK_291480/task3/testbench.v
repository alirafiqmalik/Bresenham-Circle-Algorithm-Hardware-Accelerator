
module testbench;
reg CLOCK_50;
reg [3:0]KEY_N;
reg [9:0]SW;
 
wire [7:0] vga_x;
wire [6:0] vga_y;
wire [7:0] x;
wire [6:0] y;
wire [5:0] r;
wire vga_plot;
wire [2:0]vga_colour;
	
integer f,i;

top mycir(CLOCK_50,KEY_N,SW,x,y,vga_x,vga_y,vga_plot,vga_colour);
 
initial 
begin
KEY_N[3] = 1'b1;  KEY_N[0] = 1'b1;
#10
KEY_N[3] = 1'b0;  
#10
KEY_N[3] = 1'b1;  
#10
KEY_N[3] = 1'b1;  
#10
KEY_N[3] = 1'b1;  
#10
KEY_N[3] = 1'b1;  
end 


// CLOCK_50
always
begin
	CLOCK_50 = 1'b0;#5 CLOCK_50 = 1'b1;#5;
end 


 
always
begin
SW[2:0]=3'd5;
SW[9]=1'd0;
 
SW[8:3]=6'd59;#2000
SW[8:3]=6'd40;#2000
SW[8:3]=6'd10;#2000
SW[8:3]=6'd16;#2000
SW[8:3]=6'd19;#2000
SW[8:3]=6'd5;#2000
SW[8:3]=6'd0;#2000;
SW[8:3]=6'd0;#2000;
SW[8:3]=6'd0;#2000;
SW[8:3]=6'd0;#2000;
end 

initial
begin
KEY_N[3] = 1'b1;#1000; KEY_N[3] = 1'b0;#1000;
end 


initial begin
  f = $fopen("C:/Users/alira/Desktop/LAB2/output.txt","w");

  //@(negedge reset); //Wait for reset to be released
  //@(posedge clk);   //Wait for fisrt clock out of reset

  for(i=1;i<30000;i=i+1) begin
    @(posedge CLOCK_50);
	 //$display("%d",d);
   if(vga_plot & i>20000 &i<21400)begin
	$fwrite(f,"%d , %d \n",vga_x,vga_y);
  end
  
  if(~vga_plot& i>20000 &i<21400)begin
	$fwrite(f,"\n\n\n");
  end
  end

  $fclose(f);  
end


endmodule

