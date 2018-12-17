
`timescale 1 ps / 1 ps
module Fix_Length_Bytes2Packets#(
        parameter SYMBOL_PER_PACKET={{SYMBOL_PER_PACKET}},
        parameter BYTES_PER_SYMBOL={{BYTES_PER_SYMBOL}},
        parameter BITS_PER_BYTES={{BITS_PER_BYTES}}
)
(
		input  wire        clock_clk,              
		input  wire        reset_reset,            

		input  wire        [BITS_PER_BYTES-1:0]  asi_in0_data,           
		output wire        asi_in0_ready,          
		input  wire        asi_in0_valid,          

		output wire [BYTES_PER_SYMBOL*BITS_PER_BYTES-1:0] aso_out0_data,          
		output wire aso_out0_valid,         
		output wire aso_out0_startofpacket, 
		output wire aso_out0_endofpacket
);

FixLengthB2P #(
    SYMBOL_PER_PACKET,
    BYTES_PER_SYMBOL,
    BITS_PER_BYTES)U0 (       
    clock_clk,              
    reset_reset,            
    asi_in0_data,           
    asi_in0_ready,          
    asi_in0_valid,          
    aso_out0_data,          
    aso_out0_valid,         
    aso_out0_startofpacket, 
    aso_out0_endofpacket);

endmodule
