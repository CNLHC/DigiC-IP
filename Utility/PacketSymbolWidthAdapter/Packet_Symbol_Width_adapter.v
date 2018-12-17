`timescale 1 ps / 1 ps
`define O_SYMBOL_LENGTH (INPUT_SYMBOL_WIDTH/OUTPUT_SYMBOL_WIDTH)
module Packet_Symbol_Width_adapter #(
		parameter INPUT_SYMBOL_WIDTH  = 256,
		parameter OUTPUT_SYMBOL_WIDTH = 32
	) (
		input  wire        clock_clk,              
		input  wire        reset_reset,            
		output reg  [OUTPUT_SYMBOL_WIDTH-1:0] aso_out0_data,          
		input  wire        aso_out0_ready,         
		output reg         aso_out0_valid,         
		output wire        aso_out0_endofpacket,   
		output wire        aso_out0_startofpacket, 

		input  wire [INPUT_SYMBOL_WIDTH-1:0] asi_in0_data,           
		output reg         asi_in0_ready,          
		input  wire        asi_in0_valid,          
		input  wire        asi_in0_endofpacket,    
		input  wire        asi_in0_startofpacket   
	);
    reg  [INPUT_SYMBOL_WIDTH-1:0] tInputSymbolBuffer;
    reg  [3:0] tInnerState;
    reg  [$clog2(INPUT_SYMBOL_WIDTH/OUTPUT_SYMBOL_WIDTH)+2:0] tOBytesCounter;
    reg  [20:0] tOSymbolCounter;
    reg  tPacketingState;
    always @(posedge clock_clk or posedge reset_reset) begin
        if(reset_reset) begin
            tInputSymbolBuffer <= 0;
            tOSymbolCounter <=0;
            tOBytesCounter <=0;
            tInnerState <= 0;
            tPacketingState <=0;
            asi_in0_ready<=1;
        end
        else begin
            case(tInnerState)
                0:begin
                    asi_in0_ready <= 1 ;
                    aso_out0_valid <=0 ;
                    if(asi_in0_startofpacket && asi_in0_valid) begin
                        tInnerState<=1;
                        tInputSymbolBuffer <= asi_in0_data;
                        asi_in0_ready <= 0 ;
                    end
                end
                1:begin
                    if(aso_out0_startofpacket)
                        aso_out0_startofpacket<=0;
                    
                    if(tOBytesCounter<`O_SYMBOL_LENGTH)begin
                        if(!tPacketingState)begin
                            aso_out0_startofpacket<=1;
                            tPacketingState<=1;
                        end
                        aso_out0_valid <=1;
                        aso_out0_data  <= tInputSymbolBuffer[(`O_SYMBOL_LENGTH-tOBytesCounter)*INPUT_SYMBOL_WIDTH-1-:INPUT_SYMBOL_WIDTH];
                        tOBytesCounter<=tOBytesCounter+1;
                        tOSymbolCounter<=tOSymbolCounter+1;
                    end
                    else begin
                        aso_out0_valid <=0;
                        asi_in0_ready <= 1 ;
                    end
                    if(asi_in0_valid &&asi_in0_ready) begin
                        tInputSymbolBuffer <= asi_in0_data;
                        asi_in0_ready  <= 0;
                        tOBytesCounter <= 0;
                        if(asi_in0_endofpacket)begin
                            tInnerState<=2;
                        end
                    end
                end
                2:begin
                    if(tOBytesCounter<`O_SYMBOL_LENGTH)begin
                        aso_out0_valid <=1;
                        aso_out0_data  <= tInputSymbolBuffer[(`O_SYMBOL_LENGTH-tOBytesCounter)*INPUT_SYMBOL_WIDTH-1-:INPUT_SYMBOL_WIDTH];
                        tOBytesCounter<=tOBytesCounter+1;
                        tOSymbolCounter<=tOSymbolCounter+1;
                        if(tOBytesCounter==`O_SYMBOL_LENGTH-1)
                            aso_out0_endofpacket<=1;
                    end
                    else begin
                        aso_out0_valid <=0;
                        asi_in0_ready<=1;
                        aso_out0_endofpacket<=0;
                        tPacketingState<=0;
                        tInnerState<=0;
                        tInputSymbolBuffer<=0;
                        tOBytesCounter<=0;
                        tOSymbolCounter<=0;
                    end
                end
            endcase
        end
    end
endmodule
