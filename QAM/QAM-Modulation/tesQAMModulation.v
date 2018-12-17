
`timescale 1 ps / 1 ps
`define  PIPELINE_DEEPTH 1
`define  QAM_STAGE 4
`define  MOD_OUT_WIDTH 4
module testQAMModulation();
    reg        clock_clk;             
    reg        reset_reset;           
    reg        asi_in0_valid;         
    reg        asi_in0_empty;         
    reg        asi_in0_startofpacket; 
    reg        asi_in0_endofpacket;   
    reg        aso_out0_ready;        
    reg        [(`PIPELINE_DEEPTH*$clog2(`QAM_STAGE))-1:0] asi_in0_data;          
    wire        asi_in0_ready;         
    wire       [(`PIPELINE_DEEPTH*`MOD_OUT_WIDTH*2)-1:0] aso_out0_data;         
    wire       aso_out0_valid;        
    wire       aso_out0_endofpacket;
    wire       aso_out0_startofpacket;
    wire       aso_out0_empty;

    QAM_Modulation #(
            1024,
            `QAM_STAGE ,
            `MOD_OUT_WIDTH,
            `PIPELINE_DEEPTH
        )U1 (
            clock_clk,             //    clock.clk
            reset_reset,           //    reset.reset
            asi_in0_data,          //  asi_in0.data
            asi_in0_ready,         //         .ready
            asi_in0_valid,         //         .valid
            asi_in0_empty,         //         .valid
            asi_in0_startofpacket, //         .startofpacket
            asi_in0_endofpacket,   //         .endofpacket
            aso_out0_data,         // aso_out0.data
            aso_out0_ready,        //         .ready
            aso_out0_valid,        //         .valid
            aso_out0_endofpacket,
            aso_out0_startofpacket,
            aso_out0_empty);
    integer counter;
    initial begin
        reset_reset = 0;
        counter = 1;
        #1
        reset_reset =1;
        clock_clk=0;
        asi_in0_empty=0;
        aso_out0_ready=1;
        #5
        asi_in0_startofpacket=1;

    end

    always begin
        #5 clock_clk=~clock_clk;
    end
    always @(posedge clock_clk)begin
        if(counter<100) begin
            counter=counter+1;
            asi_in0_valid=1;
            asi_in0_data=$urandom%255;
        end
        else begin
            asi_in0_endofpacket=1;
            $stop;
        end
    end

       

endmodule

