`define FFT_ADAPTER_OUT_WIDTH (2*EXTRA_LEFT_PADDING+2*INPUT_SYMBOL_WIDTH+2*EXTRA_RIGHT_PADDING+1)
`define FFT_DATA_WIDTH (EXTRA_RIGHT_PADDING+EXTRA_LEFT_PADDING+INPUT_SYMBOL_WIDTH)
module FFTDataAdapter#(
    parameter INVERSE_FFT={{INVERSE_FFT}},
    parameter INPUT_SYMBOL_WIDTH={{INPUT_SYMBOL_WIDTH}},
    parameter EXTRA_LEFT_PADDING={{EXTRA_LEFT_PADDING}},
    parameter EXTRA_RIGHT_PADDING={{EXTRA_RIGHT_PADDING}}
)(
    input wire clock_clk,
    input wire reset_reset,
    input wire   [2*INPUT_SYMBOL_WIDTH-1:0]      asi_in_data ,
    input wire          asi_in_valid ,
    input wire          asi_in_startofpacket,
    input wire          asi_in_endofpacket,
    output wire         asi_in_ready,
    output wire [`FFT_ADAPTER_OUT_WIDTH-1:0]       aso_out_data ,
    output wire aso_out_valid ,
    output wire aso_out_startofpacket ,
    output wire aso_out_endofpacket ,
    input wire  aso_out_ready
);

    assign aso_out_valid =                      asi_in_valid;
    assign aso_out_endofpacket =                asi_in_endofpacket;
    assign aso_out_startofpacket=               asi_in_startofpacket;
    assign asi_in_ready = aso_out_ready;

    //Real Left Extending
    generate
        genvar i1;
        for(i1=0;i1<EXTRA_LEFT_PADDING;i1=i1+1)begin:LEFT_PADDING_GENERATED_REAL
            assign aso_out_data[`FFT_ADAPTER_OUT_WIDTH-i1-1] = asi_in_data[2*INPUT_SYMBOL_WIDTH-1];
        end
    endgenerate 
    //Real Part
    assign aso_out_data[`FFT_DATA_WIDTH+EXTRA_RIGHT_PADDING+INPUT_SYMBOL_WIDTH-:INPUT_SYMBOL_WIDTH] = asi_in_data[2*INPUT_SYMBOL_WIDTH-1:INPUT_SYMBOL_WIDTH];

    //Real Right Padding
    generate
        genvar i2;
        for(i2=0;i2<EXTRA_RIGHT_PADDING;i2=i2+1)begin:RIGHT_PADDING_GENERATED_REAL
            assign aso_out_data[`FFT_DATA_WIDTH+EXTRA_RIGHT_PADDING-i2] = 1'b0;
        end
    endgenerate 

    //imag right padding
    generate
        genvar i3;
        for(i3=0;i3<EXTRA_LEFT_PADDING;i3=i3+1)begin:LEFT_PADDING_GENERATED_IMAG
            assign aso_out_data[`FFT_DATA_WIDTH-i3] = asi_in_data[INPUT_SYMBOL_WIDTH-1];
        end
    endgenerate 

    assign aso_out_data[EXTRA_RIGHT_PADDING+INPUT_SYMBOL_WIDTH-:INPUT_SYMBOL_WIDTH] = asi_in_data[INPUT_SYMBOL_WIDTH-1:0];

    generate
        genvar i4;
        for(i4=0;i4<EXTRA_RIGHT_PADDING;i4=i4+1)begin:RIGHT_PADDING_GENERATED_IMAG
            assign aso_out_data[EXTRA_RIGHT_PADDING-i4] = 1'b0;
        end
    endgenerate 

    assign aso_out_data[0] = INVERSE_FFT;

endmodule


