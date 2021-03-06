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
module	led_ctrl(
input		wire					sclk		,
input		wire					rst_n		,
input		wire[3:0]			flag_key,
input		wire[23:0]		rNum,

output	reg[3:0]			led	
);
reg[25:0]					cnt_1s;
reg								flag_1s;
reg[24:0]					cnt_500ms;
reg[2:0]					cnt_flag_500ms;
reg								flag_500ms;
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
		
//cnt_500ms
always@(posedge	sclk	or	negedge	rst_n)
	if(rst_n==0)
		cnt_500ms	<=	26'b0;
	else	if(cnt_500ms==24999999)
		cnt_500ms	<=	25'b0;
	else
		cnt_500ms	<=	cnt_500ms+25'b1;
		
//led��ģ��
always@(posedge	sclk	or	negedge	rst_n)
	if(rst_n==0)
		led[3:0]	<=	4'b0000;
	else	if( flag_key[3]==1&&rNum[15:12] > 1'b0&&flag_1s==1)
		led[3:0]	<=	4'b1111;
	else	if( flag_key[3]==1&&rNum[11:8] > 2'd2&&flag_1s==1)
		led[3:0]	<=	4'b1111;
	else	if(rNum[15:12] > 1'b0)
		led[3:0]	<=	4'b1111;
	else	if(rNum[11:8] > 2'd2)
		led[3:0]	<=	4'b1111;
	else	if(rNum[15:12] == 1'b0&&rNum[11:8] < 2'd3)
		led[3:0]	<=	4'b0000;
	else	
		led[3:0]	<=	led[3:0];
	
endmodule