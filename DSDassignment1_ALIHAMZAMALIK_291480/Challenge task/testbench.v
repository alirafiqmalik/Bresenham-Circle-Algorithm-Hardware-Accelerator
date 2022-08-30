
module testbench;
reg CLOCK_50;
reg [3:0]KEY_N;

wire [7:0] vga_x;
wire [6:0] vga_y;
wire [7:0] x;
wire [6:0] y;
//wire [7:0] xc;
//wire [6:0] yc;
//wire [5:0] r;
wire vga_plot;
wire [2:0]vga_colour;
	
integer f,i;


top mycir(CLOCK_50,KEY_N,x,y,vga_x,vga_y,vga_plot,vga_colour);		 
 
initial 
begin 
KEY_N[3] = 1'b1; // KEY_N[3] = 1'b1;//KEY_N[1] = 1'b0;KEY_N[2] = 1'b0;
#10
KEY_N[3] = 1'b0;  //KEY_N[3] = 1'b0;
#10
KEY_N[3] = 1'b1;  //KEY_N[3] = 1'b0;
#10
KEY_N[3] = 1'b1;  //KEY_N[3] = 1'b0;
#10
KEY_N[3] = 1'b1;  KEY_N[0] = 1'b0; //KEY_N[3] = 1'b0;
#10
KEY_N[3] = 1'b1;  //KEY_N[3] = 1'b0;
#205000
KEY_N[3] = 1'b0;  //KEY_N[3] = 1'b0;
#10
KEY_N[3] = 1'b1;  //KEY_N[3] = 1'b0;
end 


// CLOCK_50
always
begin
	CLOCK_50 = 1'b0;#5 CLOCK_50 = 1'b1;#5;
end 


initial begin
  f = $fopen("C:/Users/alira/Desktop/DSD/Assign1/HDL/LAB2/output.txt","w");
  
  for(i=1;i<30000;i=i+1) begin
    @(posedge CLOCK_50);
  
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

