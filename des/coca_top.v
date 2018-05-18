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
module	coca_top(
input		wire					sclk,
input		wire					rst_n,
input  [3:0] 					key_in,

output [7:0]SMG_Data,
output [5:0]Scan_Sig,
output	wire[3:0]			led
);
wire[3:0] 		flag_key	;		
wire[23:0]		rNum;

//key_ctrl例化
key_ctrl	U1(
.sclk			(sclk			)	,
.rst_n		(rst_n		)	,
.key_in		(key_in		)	,
.flag_key	(flag_key	)	
);

//led_ctrl例化
led_ctrl	U2(
.sclk			(sclk		),
.rst_n		(rst_n	),
.rNum			(rNum		),
.led	    (led	  )
);


//数码管例化
smg_ctrl	U4(
.CLK			(sclk			),           
.RSTn			(rst_n		), 
.flag_key	(flag_key	),
.rNum			(rNum		),        
.SMG_Data	(SMG_Data ),
.Scan_Sig (Scan_Sig )
);

endmodule
