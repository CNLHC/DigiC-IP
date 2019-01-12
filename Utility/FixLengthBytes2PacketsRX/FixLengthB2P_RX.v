
`timescale 1 ps / 1 ps
module  FixLengthB2P_RX#(
    parameter SYMBOL_PER_PACKET={{SYMBOL_PER_PACKET}},
    parameter BYTES_PER_SYMBOL={{BYTES_PER_SYMBOL}},
    parameter BITS_PER_BYTES={{BITS_PER_BYTES}}
)
(
    // Clock and Reset
		input  wire        clock_clk,              
		input  wire        reset_reset,            
    //Avalon-ST Sink
		input  wire        [BITS_PER_BYTES-1:0]  asi_in0_data,           
		output wire        asi_in0_ready,          
		input  wire        asi_in0_valid,          
		input asi_in0_startofpacket, 
		input asi_in0_endofpacket
    //Avalon-ST Source
		output reg         [BYTES_PER_SYMBOL*BITS_PER_BYTES-1:0] aso_out0_data,          
		output reg         aso_out0_valid,         
		output reg         aso_out0_startofpacket, 
		output reg         aso_out0_endofpacket
	);

    reg [$clog2(SYMBOL_PER_PACKET)+1:0] tSymbolCounter; 
    reg [$clog2(BYTES_PER_SYMBOL)+1:0]  tBytesCounter;
    reg tPacketState;

    assign asi_in0_ready =1 ;

    always @(posedge reset_reset or posedge clock_clk) begin
        if(reset_reset) begin
            tSymbolCounter<=0;
            tBytesCounter<=0;
            tPacketState<=0;
        end
        else begin 
            if(aso_out0_startofpacket)
                aso_out0_startofpacket<=0;
            if(aso_out0_endofpacket)begin
                aso_out0_valid<=0;
                aso_out0_endofpacket<=0;
            end

            if(asi_in0_valid)begin
                tBytesCounter<=tBytesCounter+1;
                aso_out0_data[(BYTES_PER_SYMBOL-tBytesCounter)*BITS_PER_BYTES-1-:BITS_PER_BYTES]<=asi_in0_data;
            end
            if(tBytesCounter>BYTES_PER_SYMBOL-1)begin
                if(!tPacketState)begin
                    aso_out0_startofpacket<=1;
                    tPacketState<=1;
                end
                tSymbolCounter<=tSymbolCounter+1;
                tBytesCounter<=0;
                aso_out0_valid<=1;
                if(tSymbolCounter>=SYMBOL_PER_PACKET-1)begin 
                    tSymbolCounter<=0;
                    tPacketState<=0;
                    aso_out0_endofpacket<=1;

                end
            end
            else begin
                aso_out0_valid<=0;
            end
        end
    end
endmodule
