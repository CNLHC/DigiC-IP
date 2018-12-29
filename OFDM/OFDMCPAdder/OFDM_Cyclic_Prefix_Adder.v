// OFDM_Cyclic_Prefix_Adder.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

`timescale 1 ps / 1 ps
module OFDM_Cyclic_Prefix_Adder #(
		parameter Packet_Length = 1024,
		parameter CP_Length     = 128,
        parameter INPUT_WIDTH = 32
	) (
		input  wire [INPUT_WIDTH-1:0] asi_in0_data,           //    asi_in0.data
		input  wire        asi_in0_valid,          //           .valid
		input  wire        asi_in0_endofpacket,    //           .endofpacket
		input  wire        asi_in0_startofpacket,  //           .startofpacket
        output reg         asi_in0_ready,

		input  wire        clock_clk,              //      clock.clk
		input  wire        reset_reset,            //      reset.reset

		output reg  [INPUT_WIDTH-1 :0] data_out_data,          // dataSource.data
		output reg         data_out_valid,         //           .valid
		output reg         data_out_startofpacket,         //           .valid
		output reg         data_out_endofpacket,         //           .valid
		output reg   [1:0] data_out_error,
        
        input  wire [INPUT_WIDTH-1 :0] buffer_in_data,
        output reg         buffer_in_ready,
        input  wire        buffer_in_valid,
        input  wire        buffer_in_startofpacket,
        input  wire        buffer_in_endofpacket
	);
    reg [12:0]tDataSymbolCounter;
    reg [3:0]tInnerState;
    reg tCheckDataInputAlignFlag;
    reg [13:0]tWatchDog;
    reg tPacketState;

    always @(posedge reset_reset or posedge clock_clk)begin 
        if(reset_reset)begin
            tDataSymbolCounter<=0;
            tInnerState<=0;
            tPacketState<=0;
        end
        else begin
            case(tInnerState)
                0:begin//waiting for the SOP
                    asi_in0_ready<=1;
                    buffer_in_ready<=0;
                    data_out_valid<=0;
                    if(asi_in0_startofpacket&&asi_in0_valid) begin
                        tInnerState<=1;
                        tDataSymbolCounter<=tDataSymbolCounter+1;
                    end
                    else 
                        tDataSymbolCounter<=0;
                end
                1:begin// Waiting
                    asi_in0_ready<=1;
                    buffer_in_ready<=0;
                    if(asi_in0_valid)
                        tDataSymbolCounter<=tDataSymbolCounter+1;

                    if(tDataSymbolCounter>=Packet_Length-CP_Length-1)begin
                        tInnerState<=2;
                    end
                    else begin
                        data_out_valid<=0;
                        data_out_error<=0;
                    end
                end
                2:begin //CP-Writing
                    asi_in0_ready<=1;
                    if(data_out_startofpacket)
                        data_out_startofpacket<=0;
                    buffer_in_ready<=0; 
                    data_out_error<=0;
                    if(asi_in0_valid)begin
                        if(!tPacketState)begin
                            data_out_startofpacket<=1;
                            tPacketState<=1;
                        end
                        data_out_valid<=1;
                        tDataSymbolCounter<=tDataSymbolCounter+1;
                        data_out_data<=asi_in0_data;
                    end
                    if(tDataSymbolCounter>=Packet_Length-1)begin
                        tInnerState<=3;
                        tDataSymbolCounter<=0;
                        tCheckDataInputAlignFlag<=0;
                    end
                    else begin 
                        data_out_valid<=1;//this signal was deasserted in below, state 3
                    end
                end
                3:begin
                    buffer_in_ready<=1;
                    asi_in0_ready<=0;
                    tWatchDog<=tWatchDog+1;
                    if(!tCheckDataInputAlignFlag)begin
                        tCheckDataInputAlignFlag<=1;
                        data_out_valid<=0;
                        if(!asi_in0_endofpacket)begin //此处应当对齐
                            data_out_error<=2'b01;
                        end
                        tWatchDog<=0;
                    end
                    if(buffer_in_valid)begin
                        data_out_valid<=1;
                        data_out_data<=buffer_in_data;
                        tDataSymbolCounter<=tDataSymbolCounter+1;
                    end
                    if(tWatchDog>Packet_Length)
                        tInnerState<=0;

                    if(tDataSymbolCounter>=Packet_Length-1)begin
                        data_out_endofpacket<=1;
                    end

                    if (data_out_endofpacket) begin // The Last Frame of output must align to the last frame to the fifo output
                        data_out_endofpacket<=0;
                        tPacketState<=0;
                        data_out_valid<=0;
                        tInnerState<=0;
                        if(!buffer_in_endofpacket)
                            data_out_error<=2'b10;
                    end
                end
            endcase
        end
    end
endmodule
