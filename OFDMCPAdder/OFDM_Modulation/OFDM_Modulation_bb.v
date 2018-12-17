
module OFDM_Modulation (
	clk_clk,
	fft_ii_0_sink_valid,
	fft_ii_0_sink_ready,
	fft_ii_0_sink_error,
	fft_ii_0_sink_startofpacket,
	fft_ii_0_sink_endofpacket,
	fft_ii_0_sink_data,
	reset_reset_n);	

	input		clk_clk;
	input		fft_ii_0_sink_valid;
	output		fft_ii_0_sink_ready;
	input	[1:0]	fft_ii_0_sink_error;
	input		fft_ii_0_sink_startofpacket;
	input		fft_ii_0_sink_endofpacket;
	input	[32:0]	fft_ii_0_sink_data;
	input		reset_reset_n;
endmodule
