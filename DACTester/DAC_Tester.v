
// new_component.vl

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

`timescale 1 ps / 1 ps
module DAC_Tester(
		input  wire [13:0] asi_in0_data,  //  asi_in0.data
		output wire        asi_in0_ready, //         .ready
		input  wire        asi_in0_valid, //         .valid
		input  wire        clock_clk,     //    clock.clk
		input  wire        reset_reset,   //    reset.reset
		output reg  [13:0] DAC_Test_CHA   // DAC_Test.datacha
	);
    assign asi_in0_ready=1;
    always@(posedge clock_clk)begin
        if(asi_in0_valid)
            DAC_Test_CHA<=asi_in0_data;
    end
endmodule
