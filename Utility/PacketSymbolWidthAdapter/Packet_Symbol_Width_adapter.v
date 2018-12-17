`timescale 1 ps / 1 ps
module Packet_Symbol_Width_adapter #
		parameter INPUT_SYMBOL_WIDTH  = 32,
		parameter OUTPUT_SYMBOL_WIDTH = 16
	) (
		input  wire        clock_clk,              
		input  wire        reset_reset,            
		output wire [31:0] aso_out0_data,          
		input  wire        aso_out0_ready,         
		output wire        aso_out0_valid,         
		output wire        aso_out0_endofpacket,   
		output wire        aso_out0_startofpacket, 
		input  wire [31:0] asi_in0_data,           
		output wire        asi_in0_ready,          
		input  wire        asi_in0_valid,          
		input  wire        asi_in0_endofpacket,    
		input  wire        asi_in0_startofpacket   
	);
    endmodule
