`timescale 1 ps / 1 ps
module Fix_Length_Bytes2Packets (
    // Clock and Reset
		input  wire        clock_clk,              //     clock_1.clk
		input  wire        reset_reset,            //       reset.reset
    //Avalon-ST Sink
		input  wire [7:0]  asi_in0_data,           //     asi_in0.data
		output wire asi_in0_ready,          //            .ready
		input  wire        asi_in0_valid,          //            .valid
    //Avalon-ST Source
		output wire [16:0] aso_out0_data,          //    aso_out0.data
		input  wire        aso_out0_ready,         //            .ready
		output reg         aso_out0_valid,         //            .valid
		output reg         aso_out0_startofpacket, //            .startofpacket
		output reg         aso_out0_endofpacket,   //            .endofpacket
        output wire        aso_out0_empty
	);
    reg [12:0]tSymbolCounter; 
    reg tPacketState;
    reg [7:0]realData;
    reg [7:0]imagData;
    assign aso_out0_data[16:9] = realData;
    assign aso_out0_data[8:1] = imagData;
    assign aso_out0_data[0] = 1;
    reg tInnerPacketReady;

    assign asi_in0_ready = tInnerPacketReady &aso_out0_ready;
    assign aso_out0_empty = 0;

    always @(posedge reset_reset or posedge clock_clk) begin
        if(reset_reset) begin
            tSymbolCounter<=0;
            tPacketState<=0;
            tInnerPacketReady<=1;
        end
        else begin 
            

            if(aso_out0_startofpacket)
                aso_out0_startofpacket<=0;
            if(aso_out0_endofpacket)begin
                aso_out0_valid<=0;
                aso_out0_endofpacket<=0;
                tSymbolCounter<=0;
                tPacketState<=0;
                tInnerPacketReady<=1;
            end
            


            if(asi_in0_valid)begin
                if(tSymbolCounter>=1023 )begin
                    aso_out0_endofpacket<=1;
                end
                if(!tPacketState)begin
                    aso_out0_startofpacket<=1;
                    tPacketState<=1;
                end
                realData <= asi_in0_data;
                imagData <= 0;
                tSymbolCounter<=tSymbolCounter+1;
                aso_out0_valid<=1;
            end
            else
                aso_out0_valid<=0;

        end
    end
endmodule
