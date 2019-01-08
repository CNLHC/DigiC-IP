// OFDM_Symbol_Sync.v


`define SYMBOL_DECISION_THRESHOLD 14'h1fff

`timescale 1 ps / 1 ps
module OFDM_Symbol_Sync #(
    THRESHOLD=100,
    OFDM_SYMBOL_LENGTH=64

) (
        //Clock and Reset 
		output  reg        sample_clock_reset, //   reset_source.reset
		input  wire        clock_clk,             //          clock.clk
        input  wire        reset_reset,

        //Avalon Sink
		input  wire signed [31:0] asi_in0_data,           //       asi_in_0.data
		input  wire        asi_in0_valid,          //               .valid

        //Avalon Source
		output reg  [31:0] aso_out0_data,          //       aso_out0.data
		output reg         aso_out0_valid,         //               .valid
		output reg         aso_out0_endofpacket,   //               .endofpacket
		output reg         aso_out0_startofpacket, //               .startofpacket

        //Feedback Control Signal
		output  reg        pre_sampling            // sample_control.pre_sample_control
	);
    wire signed [15:0] asiReal;
    wire signed [15:0] asiImag;
    
    reg signed [31:0]tMA32;
    reg signed [31:0]tMA32Accu;
    reg signed [5:0]tMA32Index;

    reg signed [31:0]tMA4;
    reg signed [31:0]tMA4Accu;
    reg signed [5:0]tMA4Index;
    reg signed [31:0]tMADifference;
    reg [10:0]tIDLECounter;
    reg tSlackState;

    reg tAccuFlag;
    reg [1:0]tInnerState;
    reg tPacketState;
    reg [15:0]tDataCounter;

    wire signed [31:0]tSyncChannelData;
    assign tSyncChannelData={{16{asi_in0_data[15]}},asi_in0_data[15:0]};
    assign asiReal=asi_in0_data[31:16];
    assign asiImag=asi_in0_data[15:0];



    always @ (posedge clock_clk or posedge reset_reset)begin
        if(reset_reset) begin
            tMA32<=0;
            tMA32Accu<=0;
            tMA32Index<=0;
            tMA4<=0;
            tMA4Accu<=0;
            tMA4Index<=0;
            tAccuFlag<=0;
            pre_sampling<=1;
            tPacketState<=0;
            tDataCounter<=0;
            tInnerState<=0;
            tMADifference=0;
            tIDLECounter<=0;
            tSlackState<=0;
        end
        else begin
            case (tInnerState)
                0:begin 
                    if(asi_in0_valid)begin
                        if(tMA4Index==1)begin
                            tMA4<=(tMA4Accu>>>1);
                            tMA4Accu<=0;
                            tMA4Index<=0;
                            tMADifference=(tMA32-tMA4)>0?(tMA32-tMA4):(tMA4-tMA32);
                            if(tMADifference>THRESHOLD)begin
                                pre_sampling<=0;
                                tInnerState<=1;
                            end
                        end else begin
                            tMA4Accu<=tMA4Accu+tSyncChannelData;
                            tMA4Index<=tMA4Index+1;
                        end

                        if (tMA32Index==31)begin
                            tAccuFlag<=1;
                            tMA32<=(tMA32Accu>>>5);
                            tMA32Index<=0;
                            tMA32Accu<=0;
                        end else begin
                            tMA32Accu<=tMA32Accu+tSyncChannelData;
                            tMA32Index<=tMA32Index+1;
                        end
                    end
                end
                1:begin
                    pre_sampling<=0; 
                    if(!tSlackState)
                        tSlackState<=1;

                    if(asi_in0_valid&&tSlackState)begin
                        if(!tPacketState)begin
                            aso_out0_startofpacket<=1;
                            tPacketState<=1;
                        end
                        aso_out0_data={{16'b0-asiReal},{16'b0-asiImag}};
                        if(aso_out0_startofpacket)
                            aso_out0_startofpacket<=0;

                        if(tDataCounter==OFDM_SYMBOL_LENGTH-1)begin
                            aso_out0_endofpacket<=1;
                            tDataCounter<=tDataCounter+1;
                        end
                        else if(tDataCounter==OFDM_SYMBOL_LENGTH)begin
                            aso_out0_endofpacket<=0;
                            aso_out0_valid<=0;
                            tPacketState<=0;
                            tMA32<=0;
                            tMA32Accu<=0;
                            tMA32Index<=0;
                            tMA4<=0;
                            tMA4Accu<=0;
                            tMA4Index<=0;
                            tAccuFlag<=0;
                            pre_sampling<=1;
                            tPacketState<=0;
                            tDataCounter<=0;
                            tInnerState<=2;
                            tSlackState<=0;
                            tIDLECounter<=0;
                        end
                        else begin
                            aso_out0_valid<=1;
                            tDataCounter<=tDataCounter+1;
                        end
                    end
                end
                2:begin
                    if(tIDLECounter<64)
                        tIDLECounter<=tIDLECounter+1;
                    else
                        tInnerState<=0;
                end
            endcase
        end
    end


endmodule
