`timescale 1 ps / 1 ps
module QAM_Modulation #(
        parameter QAM_STAGE = 4,
        parameter MOD_OUT_WIDTH = 8,
        parameter PIPELINE_DEEPTH= 16
	) (
    //Clock and Resource 
		input  wire        clock_clk,             
		input  wire        reset_reset,           
    // Avalon Sink
		input  wire [(PIPELINE_DEEPTH*$clog2(QAM_STAGE))-1:0] asi_in0_data,          
		output wire        asi_in0_ready,         
		input  wire        asi_in0_valid,         
		input  wire        asi_in0_startofpacket, 
		input  wire        asi_in0_endofpacket,   
    // Avalon Source
		output wire [(PIPELINE_DEEPTH*MOD_OUT_WIDTH*2)-1:0] aso_out0_data,         
		input  wire        aso_out0_ready,        
		output wire        aso_out0_valid,        
        output wire        aso_out0_endofpacket,
        output wire        aso_out0_startofpacket);

    genvar i;
    generate        
        for (i = 0; i < PIPELINE_DEEPTH ; i=i+1) begin: generate_block
              assign aso_out0_data[((i+1)*MOD_OUT_WIDTH*2)-1-:MOD_OUT_WIDTH*2]  = QAM_4_MAPPER(asi_in0_data[(i+1)*$clog2(QAM_STAGE)-1-:$clog2(QAM_STAGE)]);
        end
    endgenerate 
    assign aso_out0_endofpacket = asi_in0_endofpacket;
    assign aso_out0_startofpacket= asi_in0_startofpacket;
    assign asi_in0_ready = aso_out0_ready;
    assign aso_out0_valid = asi_in0_valid;

    function [(MOD_OUT_WIDTH*2)-1:0]  QAM_4_MAPPER;
        input [1:0] QAMSymbol;
        begin
            case(QAMSymbol)
                2'b00: begin
                    QAM_4_MAPPER[MOD_OUT_WIDTH*2-1:MOD_OUT_WIDTH]=(2**MOD_OUT_WIDTH)/4;
                    QAM_4_MAPPER[MOD_OUT_WIDTH-1:0]=(2**MOD_OUT_WIDTH)/4;
                end
                2'b01:begin
                    QAM_4_MAPPER[MOD_OUT_WIDTH*2-1:MOD_OUT_WIDTH]=-(2**MOD_OUT_WIDTH)/4;
                    QAM_4_MAPPER[MOD_OUT_WIDTH-1:0]=(2**MOD_OUT_WIDTH)/4;
                end
                2'b11: begin
                    QAM_4_MAPPER[MOD_OUT_WIDTH*2-1:MOD_OUT_WIDTH]=-(2**MOD_OUT_WIDTH)/4;
                    QAM_4_MAPPER[MOD_OUT_WIDTH-1:0]=-(2**MOD_OUT_WIDTH)/4;
                end
                2'b10: begin
                    QAM_4_MAPPER[MOD_OUT_WIDTH*2-1:MOD_OUT_WIDTH]=(2**MOD_OUT_WIDTH)/4;
                    QAM_4_MAPPER[MOD_OUT_WIDTH-1:0]=-(2**MOD_OUT_WIDTH)/4;
                end
            endcase
        end
    endfunction


endmodule


