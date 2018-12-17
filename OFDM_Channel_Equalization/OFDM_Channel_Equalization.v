`timescale 1 ps / 1 ps
module OFDM_Channel_Equalization(
		output wire [31:0] aso_out0_data,  // aso_out0.data
		input  wire        aso_out0_ready, //         .ready
		output wire        aso_out0_valid, //         .valid
        output wire         aso_out0_endofpacket,
        output wire         aso_out0_startofpacket,

		input  wire        clock_clk,      //    clock.clk
		input  wire        reset_reset,    //    reset.reset

		input  wire [33:0] asi_in0_data,   //  asi_in0.data
		output wire        asi_in0_ready,  //         .ready
		input  wire        asi_in0_valid,   //         .valid
        input  wire        asi_in0_endofpacket,
        input  wire        asi_in0_startofpacket
	);
    assign aso_out0_data[31:18] = asi_in0_data[33:20];
    assign aso_out0_data[17:4] =  asi_in0_data[19:6];
    assign aso_out0_valid= asi_in0_valid;
    assign asi_in0_ready= aso_out0_ready;
    assign aso_out0_endofpacket = asi_in0_endofpacket;
    assign aso_out0_startofpacket =asi_in0_startofpacket;
endmodule
