
`timescale 1 ps / 1 ps
module Avalon_ST_Demux #(
    parameter INPUT_WIDTH=32
)
(
		input  wire [INPUT_WIDTH-1:0] asi_in0_data,           //  asi_in0.data
		output wire        asi_in0_ready,          //         .ready
		input  wire        asi_in0_valid,          //         .valid
		input  wire        asi_in0_endofpacket,    //         .endofpacket
		input  wire        asi_in0_startofpacket,  //         .startofpacket

		input  wire        clock_clk,              //    clock.clk
		input  wire        reset_reset,            //    reset.reset

		output wire [INPUT_WIDTH-1:0] aso_out0_data,          // aso_out0.data
		input  wire        aso_out0_ready,         //         .ready
		output wire        aso_out0_valid,         //         .valid
		output wire        aso_out0_endofpacket,   //         .endofpacket
		output wire        aso_out0_startofpacket, //         .startofpacket

		output wire [INPUT_WIDTH-1:0] aso_out1_data,          // aso_out1.data
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
