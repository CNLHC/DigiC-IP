// Avalon_ST_Demux.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

`timescale 1 ps / 1 ps
module Avalon_ST_Demux (
		input  wire [33:0] asi_in0_data,           //  asi_in0.data
		output wire        asi_in0_ready,          //         .ready
		input  wire        asi_in0_valid,          //         .valid
		input  wire        asi_in0_endofpacket,    //         .endofpacket
		input  wire        asi_in0_startofpacket,  //         .startofpacket

		input  wire        clock_clk,              //    clock.clk
		input  wire        reset_reset,            //    reset.reset

		output wire [33:0] aso_out0_data,          // aso_out0.data
		input  wire        aso_out0_ready,         //         .ready
		output wire        aso_out0_valid,         //         .valid
		output wire        aso_out0_endofpacket,   //         .endofpacket
		output wire        aso_out0_startofpacket, //         .startofpacket

		output wire [33:0] aso_out1_data,          // aso_out1.data
		input  wire        aso_out1_ready,         //         .ready
		output wire        aso_out1_valid,         //         .valid
		output wire        aso_out1_endofpacket,   //         .endofpacket
		output wire        aso_out1_startofpacket  //         .startofpacket
	);
    assign aso_out0_data=asi_in0_data;
    assign aso_out1_data=asi_in0_data;

    assign asi_in0_ready=aso_out0_ready & aso_out1_ready;

    assign aso_out0_valid=asi_in0_valid;
    assign aso_out1_valid=asi_in0_valid;

    assign aso_out0_endofpacket=asi_in0_endofpacket;
    assign aso_out1_endofpacket=asi_in0_endofpacket;

    assign aso_out0_startofpacket=asi_in0_startofpacket;
    assign aso_out1_startofpacket=asi_in0_startofpacket;


endmodule
