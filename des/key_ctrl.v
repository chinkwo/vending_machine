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
module key_ctrl  (
							sclk,              // 开发板上输入时钟: 50Mhz
							rst_n,            // 开发板上输入复位按键
							key_in,           // 输入按键信号(KEY1~KEY4)
							flag_key				//	输出按键信号(KEY1~KEY4)
						);

//===========================================================================
// PORT declarations
//===========================================================================						
input        sclk; 
input        rst_n;
input  [3:0] key_in;
output [3:0] flag_key;

//寄存器定义
reg [19:0] count;
reg [3:0] key_scan; //按键扫描值KEY

//===========================================================================
// 采样按键值，20ms扫描一次,采样频率小于按键毛刺频率，相当于滤除掉了高频毛刺信号。
//===========================================================================
always @(posedge sclk or negedge rst_n)     //检测时钟的上升沿和复位的下降沿
begin
   if(!rst_n)                //复位信号低有效
      count <= 20'd0;        //计数器清0
   else
      begin
         if(count ==20'd999_999)   //20ms扫描一次按键,20ms计数(50M/50-1=999_999)
            begin
               count <= 20'b0;     //计数器计到20ms，计数器清零
               key_scan <= key_in; //采样按键输入电平
            end
         else
            count <= count + 20'b1; //计数器加1
     end
end
//===========================================================================
// 按键信号锁存一个时钟节拍
//===========================================================================
reg [3:0] key_scan_r;
always @(posedge sclk)
    key_scan_r <= key_scan;       
    
wire [3:0] flag_key = key_scan_r[3:0] & (~key_scan[3:0]);  //当检测到按键有下降沿变化时，代表该按键被按下，按键有效 
		
endmodule