module FFTDataAdapter#(
    parameter INVERSE_FFT={{INVERSE_FFT}},
    parameter INPUT_SYMBOL_WIDTH={{INPUT_SYMBOL_WIDTH}}
)(
    input wire clock_clk,
    input wire reset_reset,
    input wire   [INPUT_SYMBOL_WIDTH-1:0]      asi_in_data ,
    input wire          asi_in_valid ,
    input wire          asi_in_startofpacket,
    input wire          asi_in_endofpacket,
    output wire         asi_in_ready,
    output wire [INPUT_SYMBOL_WIDTH:0]       aso_out_data ,
    output wire aso_out_valid ,
    output wire aso_out_startofpacket ,
    output wire aso_out_endofpacket ,
    input wire aso_out_ready
);

    assign aso_out_valid =                      asi_in_valid;
    assign aso_out_endofpacket =                asi_in_endofpacket;
    assign aso_out_startofpacket=               asi_in_startofpacket;
    assign aso_out_data[0] =                    INVERSE_FFT;
    assign aso_out_data[INPUT_SYMBOL_WIDTH:1] = asi_in_data[INPUT_SYMBOL_WIDTH-1:0];
    assign asi_in_ready =                       aso_out_ready;

endmodule


