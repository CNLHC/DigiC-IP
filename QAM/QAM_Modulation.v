// QAM_Modulation.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

`timescale 1 ps / 1 ps
module QAM_Modulation #(
		parameter PACKET_LENGTH = 1024
	) (
    //Clock and Resource 
		input  wire        clock_clk,             //    clock.clk
		input  wire        reset_reset,           //    reset.reset
    // Avalon Sink
		input  wire [31:0] asi_in0_data,          //  asi_in0.data
		output reg         asi_in0_ready,         //         .ready
		input  wire        asi_in0_valid,         //         .valid
		input  wire        asi_in0_empty,         //         .valid
		input  wire        asi_in0_startofpacket, //         .startofpacket
		input  wire        asi_in0_endofpacket,   //         .endofpacket
    // Avalon Source
		output reg  [28:0] aso_out0_data,         // aso_out0.data
		input  wire        aso_out0_ready,        //         .ready
		output reg         aso_out0_valid,        //         .valid
        output reg         aso_out0_endofpacket,
        output reg         aso_out0_startofpacket,
        output wire        aso_out0_empty);
    assign aso_out0_empty=0;
    reg [1:0]tInnerStateFlag;//00-idle 01-start asserted 02: reading packet 03: end asserted
    reg [5:0]tBytesBuffer;
    reg [31:0]tInputSymbolBuffer;
    reg tPacketState;

    always @(posedge clock_clk or posedge reset_reset) begin
        if(reset_reset)begin
            aso_out0_valid<=0;
            asi_in0_ready<=1;
            aso_out0_data<=0;
            tInputSymbolBuffer<=0;
            tBytesBuffer<=16;
            tPacketState<=0;
        end
        else
            case (tInnerStateFlag)
                0: begin
                    asi_in0_ready<=1;
                    if(asi_in0_startofpacket&&asi_in0_valid)begin // IDLE
                        tInnerStateFlag<=1;
                        if(asi_in0_ready) begin
                            tInputSymbolBuffer<=asi_in0_data;
                            tBytesBuffer<=0;
                            asi_in0_ready<=0;
                        end
                        else
                            tBytesBuffer<=16;
                    end
                end
                1:begin // Mapping QAM Symbol
                    if(asi_in0_endofpacket)
                        tInnerStateFlag<=2;

                    if(aso_out0_startofpacket)
                        aso_out0_startofpacket<=0;

                    if(asi_in0_ready && asi_in0_valid) begin
                        asi_in0_ready<=0;
                        tBytesBuffer<=0;
                        tInputSymbolBuffer<=asi_in0_data;
                    end

                    if(tBytesBuffer<16) begin
                        if(!tPacketState)begin
                            aso_out0_startofpacket<=1;
                            tPacketState<=1;
                        end
                        aso_out0_data[0]<=1; //set IFFT
                        aso_out0_valid<=1;
                        tBytesBuffer<=tBytesBuffer+1;
                        asi_in0_ready<=0;
                        case(tInputSymbolBuffer[(16-tBytesBuffer)*2-1-:2])
                            0: begin
                                aso_out0_data[28:15]<=8;
                                aso_out0_data[14:1]<=8;
                            end
                            1:begin
                                aso_out0_data[28:15]<=-8;
                                aso_out0_data[14:1]<=8;
                            end
                            2: begin
                                aso_out0_data[28:15]<=-8;
                                aso_out0_data[14:1]<=-8;
                            end
                            3: begin
                                aso_out0_data[28:15]<=8;
                                aso_out0_data[14:1]<=-8;
                            end
                        endcase
                    end
                    else begin
                        aso_out0_valid<=0;
                        if(asi_in0_ready)
                            asi_in0_ready<=0;

                        else
                            asi_in0_ready<=1;
                    end
                end
                2:begin
                    if(tBytesBuffer<16) begin
                        asi_in0_ready<=0;
                        aso_out0_valid<=1;
                        aso_out0_data[0]<=1; //set IFFT
                        tBytesBuffer<=tBytesBuffer+1;
                        case(tInputSymbolBuffer[(16-tBytesBuffer)*2-1-:2])
                            0: begin
                                aso_out0_data[28:15]<=8;
                                aso_out0_data[14:1]<=1;
                            end
                            1:begin
                                aso_out0_data[28:15]<=-8;
                                aso_out0_data[14:1]<=8;
                            end
                            2: begin
                                aso_out0_data[28:15]<=-8;
                                aso_out0_data[14:1]<=-8;
                            end
                            3: begin
                                aso_out0_data[28:15]<=8;
                                aso_out0_data[14:1]<=-8;
                            end
                        endcase
                        if(tBytesBuffer==15)
                            aso_out0_endofpacket<=1;
                    end
                    else begin
                        asi_in0_ready<=1;
                        aso_out0_endofpacket<=0;
                        tInnerStateFlag<=0;
                        aso_out0_valid<=0;
                        tPacketState<=0;
                    end
                end
            endcase
    end

endmodule
