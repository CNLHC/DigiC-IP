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
    reg signed [31:0]tMA32C2;

    reg signed [31:0]tMA32Accu;
    reg signed [31:0]tMA32C2Accu;

    reg signed [5:0]tMA32Index;
    reg signed [5:0]tMA32C2Index;

    reg signed [31:0]tMA4;
    reg signed [31:0]tMA4C2;

    reg signed [31:0]tMA4Accu;
    reg signed [31:0]tMA4C2Accu;

    reg signed [5:0]tMA4Index;
    reg signed [5:0]tMA4C2Index;

    reg signed [31:0]tMADifference;
    reg signed [31:0]tMAC2Difference;

    reg [15:0]tMA32Settd;
    reg [15:0]tMA32C2Settd;

    reg [10:0]tIDLECounter;

    reg tSlackState;
    reg tSlackStateC2;

    reg tAccuFlag;
    reg tAccuFlagC2;

    reg [1:0]tInnerState;
    reg tPacketState;

    reg [15:0]tDataCounter;

    wire signed [31:0]tSyncChannelData;
    wire signed [31:0]tSyncChannelDataC2;
    assign tSyncChannelData={{16{asi_in0_data[15]}},asi_in0_data[15:0]};
    assign tSyncChannelDataC2={{16{asi_in0_data[31]}},asi_in0_data[31:16]};
    assign asiReal=asi_in0_data[31:16];
    assign asiImag=asi_in0_data[15:0];




    always @ (posedge clock_clk or posedge reset_reset)begin
        if(reset_reset) begin
            tMA32<=0;
            tMA32C2<=0;

            tMA32Accu<=0;
            tMA32C2Accu<=0;

            tMA32Index<=0;
            tMA32C2Index<=0;

            tMA4<=0;
            tMA4C2<=0;

            tMA4Accu<=0;
            tMA4C2Accu<=0;

            tMA4Index<=0;
            tMA4C2Index<=0;

            tAccuFlag<=0;
            tAccuFlagC2<=0;

            tMA32Settd<=0;
            tMA32C2Settd<=0;

            tMADifference=0;
            tMAC2Difference=0;

            pre_sampling<=1;
            tPacketState<=0;
            tDataCounter<=0;
            tInnerState<=0;
            tIDLECounter<=0;
            tSlackState<=0;
        end
        else begin
            case (tInnerState)
                0:begin 
                    if(asi_in0_valid)begin
                        if(tMA4Index==1)begin
                            tMA4<=(tMA4Accu>>>1);
                            tMA4Accu<=tSyncChannelData;
                            tMA4Index<=0;
                            tMADifference=(tMA32-tMA4)>0?(tMA32-tMA4):(tMA4-tMA32);
                            if(tMADifference>THRESHOLD&&tMA32Settd==1)begin
                                pre_sampling<=0;
                                tInnerState<=1;
                                aso_out0_valid<=1;
                                aso_out0_startofpacket<=1;
                            end
                        end else begin
                            tMA4Accu<=tMA4Accu+tSyncChannelData;
                            tMA4Index<=tMA4Index+1;
                        end
                        //if(tSyncChannelData>THRESHOLD&&tMA32Settd==1)begin
                        //    pre_sampling<=0;
                        //    tInnerState<=1;
                        //    aso_out0_valid<=1;
                        //    aso_out0_startofpacket<=1;
                        //end

                        if (tMA32Index==31)begin
                            tAccuFlag<=1;
                            tMA32<=(tMA32Accu>>>5);
                            tMA32Index<=0;
                            tMA32Accu<=0;
                            tMA32Settd<=1;
                        end else begin
                            tMA32Accu<=tMA32Accu+tSyncChannelData;
                            tMA32Index<=tMA32Index+1;
                        end

                        if(tMA4C2Index==1)begin
                            tMA4C2<=(tMA4C2Accu>>>1);
                            tMA4C2Accu<=tSyncChannelDataC2;
                            tMA4C2Index<=0;
                            tMAC2Difference=(tMA32C2-tMA4C2)>0?(tMA32C2-tMA4C2):(tMA4C2-tMA32C2);
                            if(tMAC2Difference>THRESHOLD&&tMA32C2Settd==1)begin
                                pre_sampling<=0;
                                tInnerState<=1;
                                aso_out0_valid<=1;
                                aso_out0_startofpacket<=1;
                            end
                        end else begin
                            tMA4C2Accu<=tMA4C2Accu+tSyncChannelDataC2;
                            tMA4C2Index<=tMA4C2Index+1;
                        end
                        //if(tSyncChannelDataC2>THRESHOLD&&tMA32C2Settd==1)begin
                        //    pre_sampling<=0;
                        //    tInnerState<=1;
                        //    aso_out0_valid<=1;
                        //    aso_out0_startofpacket<=1;
                        //end

                        if (tMA32C2Index==31)begin
                            tAccuFlagC2<=1;
                            tMA32C2<=(tMA32C2Accu>>>5);
                            tMA32C2Index<=0;
                            tMA32C2Accu<=0;
                            tMA32C2Settd<=1;
                        end else begin
                            tMA32C2Accu<=tMA32C2Accu+tSyncChannelDataC2;
                            tMA32C2Index<=tMA32C2Index+1;
                        end

                    end
                end
                1:begin
                    if(aso_out0_valid) begin
                        aso_out0_valid<=0;
                    end
                    else begin
                        if(asi_in0_valid)
                            aso_out0_valid<=1;
                    end

                    if(aso_out0_startofpacket)
                        aso_out0_startofpacket<=0;

                    if(asi_in0_valid)begin
                        if(!tPacketState)begin
                            aso_out0_startofpacket<=1;
                            tPacketState<=1;
                        end
                        aso_out0_data={{16'b0-asiReal},{16'b0-asiImag}};

                        if(tDataCounter==OFDM_SYMBOL_LENGTH-1)begin
                            aso_out0_endofpacket<=1;
                            tDataCounter<=tDataCounter+1;
                        end
                        else if(tDataCounter==OFDM_SYMBOL_LENGTH)begin
                            aso_out0_endofpacket<=0;
                            aso_out0_valid<=0;
                            tPacketState<=0;
                            tMA32<=0;
                            tMA32C2<=0;

                            tMA32Accu<=0;
                            tMA32C2Accu<=0;

                            tMA32Index<=0;
                            tMA32C2Index<=0;

                            tMA4<=0;
                            tMA4C2<=0;

                            tMA4Accu<=0;
                            tMA4C2Accu<=0;

                            tMA4Index<=0;
                            tMA4C2Index<=0;

                            tAccuFlag<=0;
                            tAccuFlagC2<=0;

                            tMA32Settd<=0;
                            tMA32C2Settd<=0;

                            tMADifference=0;
                            tMAC2Difference=0;

                            pre_sampling<=1;
                            tPacketState<=0;
                            tDataCounter<=0;
                            tInnerState<=2;
                            tSlackState<=0;
                            tIDLECounter<=0;
                        end
                        else begin
                            tDataCounter<=tDataCounter+1;
                        end
                    end
                end
                2:begin
                    if(tIDLECounter<512)
                        tIDLECounter<=tIDLECounter+1;
                    else
                        tInnerState<=0;
                end
            endcase
        end
    end


endmodule
