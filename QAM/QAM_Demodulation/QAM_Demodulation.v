`timescale 1 ps / 1 ps
module QAM_Demodulation (
        //Clock and Reset
		input  wire        clock_clk,      //    clock.clk
		input  wire        reset_reset,    //    reset.reset

        //Avalon Sink
		input  wire [37:0] asi_in0_data,   
		output wire        asi_in0_ready,  
		input  wire        asi_in0_valid,  
        input  wire        asi_in0_startofpacket,
        input  wire        asi_in0_endofpacket,

        //Avalon Source
		output reg  [1:0] aso_out0_data,  
		input  wire        aso_out0_ready, 
		output wire aso_out0_valid 
        //output wire aso_out0_startofpacket,
        //output wire aso_out0_endofpacket
	);
    wire signed [15:0]realInput;
    wire signed [15:0]imagInput;
    assign realInput=asi_in0_data[37:22];
    assign imagInput=asi_in0_data[21:6];
    //assign aso_out0_startofpacket=asi_in0_startofpacket;
    //assign aso_out0_endofpacket = asi_in0_endofpacket;
    assign aso_out0_valid = asi_in0_valid;
    assign asi_in0_ready = aso_out0_ready;
    always @(*) begin
        if(realInput>0&&imagInput>0)
            aso_out0_data=2'b00;
        else if(realInput<0&&imagInput>0)
            aso_out0_data=2'b01;
        else if(realInput<0&&imagInput<0)
            aso_out0_data=2'b11;
        else if(realInput>0&&imagInput<0)
            aso_out0_data=2'b10;
    end
endmodule
