// OFDM_ADC_Control.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

`timescale 1 ps / 1 ps
module OFDM_ADC_Control (
		output reg   [31:0] aso_out0_data,          
		output reg          aso_out0_valid,        
		input  wire         reset_reset,          
		input  wire         sampling_clk,        
		input  wire         oversampling_clk,        
        input  wire  [13:0] adc_data_Real,
        input  wire  [13:0] adc_data_Imag,
        input  wire         pre_sampling
	);
    reg tSampleSended;
    always @(posedge sampling_clk or posedge reset_reset or posedge oversampling_clk) begin
        if(reset_reset)begin
            aso_out0_data<=0;
            aso_out0_valid<=0;
        end
        else begin
            if(pre_sampling)begin
                if(sampling_clk&&(!tSampleSended)) begin
                    tSampleSended<=1;
                    aso_out0_valid<=1;
                    aso_out0_data<={{2{adc_data_Real[13]}},adc_data_Real,{2{adc_data_Imag[13]}},adc_data_Imag};
                end
                else begin
                    tSampleSended<=0;
                    if(aso_out0_valid)
                        aso_out0_valid<=0;
                end
            end else begin
                aso_out0_valid<=1;
                aso_out0_data<={{2{adc_data_Real[13]}},adc_data_Real,{2{adc_data_Imag[13]}},adc_data_Imag};
            end
        end
    end
endmodule
