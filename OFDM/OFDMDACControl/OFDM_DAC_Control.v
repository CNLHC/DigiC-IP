`timescale 1 ps / 1 ps
module OFDM_DAC_Control (
		input  wire [37:0] asi_in0_data,          //      asi_in0.data
		output wire        asi_in0_ready,         //             .ready
		input  wire        asi_in0_valid,         //             .valid
        input  wire        asi_in0_startofpacket,
        input  wire        asi_in0_endofpacket,
		input  wire        reset_reset,           //        reset.reset

		output reg  [13:0] DAC_Control_ChA_Data,  //  DAC_Control.chadata
		output reg  [13:0] DAC_Control_ChB_Data,  //             .chbdata
		input  wire        sample_clock_dac       // sample_clock.clk
	);
    wire [5:0]  tBFPExp;
    wire [15:0]  tReal;
    wire [15:0]  tImag;
    wire [13:0] tRealExpended;
    wire [13:0] tImagExpended;

    assign asi_in0_ready=1;
    assign tReal=asi_in0_data[37:22];
    assign tImag=asi_in0_data[21:6];
    assign tBFPExp =-asi_in0_data[5:0];

    assign tRealExpended=tReal[13:0];
    assign tImagExpended=tImag[13:0];

    always @(*)begin
        case (asi_in0_valid)
            0: begin
            DAC_Control_ChA_Data=8191;
            DAC_Control_ChB_Data=-8191;
            end
            1: begin
            DAC_Control_ChA_Data={~tRealExpended[11],tRealExpended[10:0],2'b0};
            DAC_Control_ChB_Data={~tImagExpended[11],tImagExpended[10:0],2'b0};
            end
        endcase
    end
endmodule

