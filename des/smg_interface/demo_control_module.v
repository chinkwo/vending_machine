module demo_control_module
(
	 input 	wire				CLK		,
	 input  wire				RSTn		,
	 input	wire[3:0] 	flag_key,
	 output	reg [23:0]	rNum,
	 output [23:0]Number_Sig
);
		reg[3:0] 	i;
		//reg [23:0]rNum;
		reg [23:0]rNumber;
	 
//数码管显示区域
always @ ( posedge CLK or negedge RSTn )
	      if( !RSTn )
			    begin
					   i <= 4'd0;
					  rNum <= 24'd0;
					  rNumber <= 24'd0;
				 end
		   else
			    case( i )
				 
				     0:
					  if( flag_key[0] ) begin rNum[7:4] <= rNum[7:4] + 3'd5; i <= i + 1'b1; end                 //flag_key[0]输入五毛，十位+5
					  else	if(flag_key[1])	 begin rNum[11:8] <= rNum[11:8] + 1'b1; i <= i + 1'b1; end									 //flag_key[1]输入一块，百位加一
					  else	if(flag_key[2])	 begin rNum[11:8] <= rNum[11:8] + 3'd5; i <= i + 1'b1; end									 //flag_key[2]输入五块，百位加一
					  else	if(flag_key[3]&&rNum[11:8] > 2'd2 ) begin rNum[11:8] <= rNum[11:8] - 2'd3; i <= i + 1'b1;	end
					  else	if(flag_key[3]&&rNum[15:12] > 1'b0)begin rNum[15:12] <= rNum[15:12] - 1'b1; rNum[11:8] <= rNum[11:8] + 4'd7; i <= i + 1'b1; end
			        	
					  
					  1:
					  if( rNum[7:4] > 4'd9 ) begin rNum[11:8] <= rNum[11:8] + 1'b1; rNum[7:4] <= 4'd0; i <= i + 1'b1; end//十位>9, 进位给百位
					  else i <= i + 1'b1;
					  
					  2:
					  if( rNum[11:8] > 4'd9 ) begin rNum[15:12] <= rNum[15:12] + 1'b1; rNum[11:8] <= 4'd0; i <= i + 1'b1; end//百位>9, 进位给千位
					  else i <= i + 1'b1;
					  
					  3:
				
					  begin rNumber <= rNum; i <= 4'd0; end
					  
				 endcase
							  
							  
    /*******************************************************/
    
	 assign Number_Sig = rNumber;
	 
	 /*******************************************************/
	 
endmodule
