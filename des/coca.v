// ************************Declaration***************************************
// File name: key_ctrl.v
// Author: YuZhengguo
// Date: 2017/6/15 8:39:57
// Version Number: 1.0
// Abstract:
// Modification history:(including time, version, author and abstract)
// 2017-06-01 00:00 version 1.0 xxx
// Abstract: Initial
// *********************************end**************************************
module	coca(
input		wire					sclk,
input		wire					rst_n,
input		wire					key1,//输入五毛钱
input		wire					key2,//输入一块钱
input		wire					key3,//输出

output	reg						po_money,
output	reg[3:0]					led	,
output	reg						po_coal
);
reg[1:0]			pi_money;
reg[2:0]					state	;
reg[25:0]					cnt_1s;
reg								flag_1s;
parameter					IDLE		=			3'd0;//初始状态，	
parameter					ONE			=			3'd1;//五毛钱的状态
parameter					TWO			=			3'd2;//一块钱的状态
parameter					THREE		=			3'd3;//一块五毛钱的状态
parameter					FOUR		=			3'd4;//二块钱的状态
parameter					FIVE		=			3'd5;//二块五毛钱的状态
parameter					SIX			=			3'd6;//三块钱的状态

//cnt_1s
always@(posedge	sclk	or	negedge	rst_n)
	if(rst_n==0)
		cnt_1s	<=	26'b0;
	else	if(cnt_1s==49999999)
		cnt_1s	<=	26'b0;
	else
		cnt_1s	<=	cnt_1s+26'b1;
		
//flag_1s
always@(posedge	sclk	or	negedge	rst_n)
	if(rst_n==1'b0)
		flag_1s	<=	1'b0;
	else	if(cnt_1s==49999999)
		flag_1s	<=	~flag_1s;
		
//led灯模块
always@(posedge	sclk	or	negedge	rst_n)
	if(rst_n==0)
		led[3:0]	<=	4'b0000;
	else	if(po_coal	==	1)
		led[3:0]	<=	4'b1111;
	else	if(flag_1s==1&&po_coal	==	0)
		led[3:0]	<=	4'b1111;
	else	if(flag_1s==0&&po_coal	==	0)
		led[3:0]	<=	4'b0000;
	

//对pi_money赋值
always@(posedge	sclk	or	negedge	rst_n)
	if(rst_n==0)
		pi_money	<=	1'b0;
	else	if(key1==1)
		pi_money	<=	1;
	else	if(key2==1)
		pi_money	<=	2;
	else 
		pi_money	<=	0;
		
		
//二段式状态机第一段，对state赋值	
always@(posedge	sclk	or	negedge	rst_n)
	if(rst_n==0)
		state	<=	IDLE;
	else	case(state)
		IDLE:	if(pi_money==1)
						state	<=	ONE;
					else	if(pi_money==2)  
						state	<=	TWO; 
					else	
						state	<=	state;
		ONE:	if(pi_money==1)
						state	<=	TWO;
					else	if(pi_money==2)  
						state	<=	THREE;
					else	
						state	<=	state;
		TWO:	if(pi_money==1)
						state	<=	THREE;
					else	if(pi_money==2)  
						state	<=	FOUR;
					else	
						state	<=	state; 
		THREE	:if(pi_money==1)
						state	<=	FOUR;
					else	if(pi_money==2)  
						state	<=	IDLE;
					else	
						state	<=	state;	
		FOUR:	if(pi_money==1)
						state	<=	IDLE;
					else	if(pi_money==2)  
						state	<=	IDLE;
					else	
						state	<=	state;	
					default:	
						state	<=	IDLE;
				endcase
		
//二段式状态机第二段，对输出变量po_cola赋值
always@(posedge	sclk	or	negedge	rst_n)
	if(rst_n==0)		
		po_coal	<=	0;
	else	if(pi_money==1&&state==FOUR)
		po_coal	<=	1;
	else	if(pi_money==2&&state==FOUR)
		po_coal	<=	1;
	else	if(pi_money==2&&state==THREE)
		po_coal	<=	1;
	else	
		po_coal	<=	0;
		
//对po_money赋值
always@(posedge	sclk	or	negedge	rst_n)
	if(rst_n==0)		
		po_money<=0;
	else	if(pi_money==2&&state==FOUR)
		po_money<=1'b1;
	else	
		po_money<=1'b0;
endmodule
