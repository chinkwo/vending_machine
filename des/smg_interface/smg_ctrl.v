module smg_ctrl
(
   input 		wire					CLK,
	 input 		wire					RSTn,
	 input 		wire[2:0]			state,
	 input		wire[3:0] 		flag_key,
	 input		wire					po_money,
	 output	[23:0]rNum,
	 output [7:0]SMG_Data,
	 output [5:0]Scan_Sig
);

    /******************************/ 
 
    wire [23:0]Number_Sig;
	 
    demo_control_module U1
	 (
	    .CLK			( CLK ),
		  .RSTn			( RSTn ),
		  .flag_key	(flag_key)	,
		  .rNum			(rNum		),
		  .Number_Sig( Number_Sig ) // output - to U2
	 );
	 
	 /******************************/ 
	 
	 smg_interface U2
	 (
	    .CLK( CLK ),
		  .RSTn( RSTn ),
		  .Number_Sig( Number_Sig ), // input - from U1
		  .SMG_Data( SMG_Data ),     // output - to top
		  .Scan_Sig( Scan_Sig )      // output - to top
	 );
	 
    /******************************/ 

endmodule
