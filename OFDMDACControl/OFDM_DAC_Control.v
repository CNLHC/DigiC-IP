// OFDM_DAC_Control.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

`timescale 1 ps / 1 ps
module OFDM_DAC_Control (
		input  wire [33:0] asi_in0_data,          //      asi_in0.data
		output wire        asi_in0_ready,         //             .ready
		input  wire        asi_in0_valid,         //             .valid
        input  wire        asi_in0_startofpacket,
        input wire         asi_in0_endofpacket,
		input  wire        reset_reset,           //        reset.reset

		output reg  [13:0] DAC_Control_ChA_Data,  //  DAC_Control.chadata
		output reg  [13:0] DAC_Control_ChB_Data,  //             .chbdata
		input  wire        sample_clock_dac       // sample_clock.clk
	);
    wire [5:0]  tBFPExp;
    wire [13:0]  tReal;
    wire [13:0]  tImag;
    wire [13:0] tRealExpended;
    wire [13:0] tImagExpended;

    assign asi_in0_ready=1;
    assign tReal=asi_in0_data[33:20];
    assign tImag=asi_in0_data[19:6];
    assign tBFPExp =-asi_in0_data[5:0];
    //assign tRealExpended=(tReal<<tBFPExp)>>>8;
    //assign tImagExpended=(tImag<<tBFPExp)>>>8;
    assign tRealExpended=(tReal);
    assign tImagExpended=(tImag);

    always @(posedge sample_clock_dac or  posedge reset_reset)begin
        if(reset_reset)begin
        end
        else begin
            if(!asi_in0_valid)begin
                DAC_Control_ChA_Data<=8191;
                DAC_Control_ChB_Data<=-8191;
            end
            else begin
                DAC_Control_ChA_Data<=tRealExpended;
                DAC_Control_ChB_Data<=tImagExpended;
            end
        end
    end
endmodule
