package require -exact qsys 16.1

set_module_property DESCRIPTION "Convert data format to avalon-fft core acceptable"
set_module_property NAME FFT_Data_Adapter
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP DigiC/Utility
set_module_property AUTHOR CNLHC
set_module_property DISPLAY_NAME "FFT Data Format Adapter"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


add_parameter INVERSE_FFT INTEGER  0 "Assert it while using IFFT instead of FFT"
set_parameter_property INVERSE_FFT ALLOWED_RANGES {0,1} 

add_parameter INPUT_SYMBOL_WIDTH INTEGER  32 "Input data with(bits per symbol)"
set_parameter_property INPUT_SYMBOL_WIDTH ALLOWED_RANGES {1:64}

add_parameter EXTRA_LEFT_PADDING INTEGER  0 "Input data with(bits per symbol)"
add_parameter EXTRA_RIGHT_PADDING INTEGER  0 "Input data with(bits per symbol)"


# connection point reset
add_interface reset reset end
set_interface_property reset associatedClock clock_1
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset_reset reset Input 1


# connection point clock_1
add_interface clock_1 clock end
set_interface_property clock_1 clockRate 0
set_interface_property clock_1 ENABLED true
set_interface_property clock_1 EXPORT_OF ""
set_interface_property clock_1 PORT_NAME_MAP ""
set_interface_property clock_1 CMSIS_SVD_VARIABLES ""
set_interface_property clock_1 SVD_ADDRESS_GROUP ""

add_interface_port clock_1 clock_clk clk Input 1
#input
add_interface asi_in avalon_streaming end
set_interface_property asi_in associatedClock clock_1
set_interface_property asi_in associatedReset reset
set_interface_property asi_in dataBitsPerSymbol 8
set_interface_property asi_in errorDescriptor ""
set_interface_property asi_in firstSymbolInHighOrderBits true
set_interface_property asi_in maxChannel 0
set_interface_property asi_in readyLatency 0
set_interface_property asi_in ENABLED true
set_interface_property asi_in EXPORT_OF ""
set_interface_property asi_in PORT_NAME_MAP ""
set_interface_property asi_in CMSIS_SVD_VARIABLES ""
set_interface_property asi_in SVD_ADDRESS_GROUP ""

add_interface_port asi_in asi_in_data data Input 8
add_interface_port asi_in asi_in_valid valid Input 1
add_interface_port asi_in asi_in_startofpacket startofpacket  Input 1
add_interface_port asi_in asi_in_endofpacket endofpacket  Input 1
add_interface_port asi_in asi_in_ready ready Output 1

#output
add_interface aso_out avalon_streaming start
set_interface_property aso_out associatedClock clock_1
set_interface_property aso_out associatedReset reset
set_interface_property aso_out dataBitsPerSymbol  8
set_interface_property aso_out errorDescriptor ""
set_interface_property aso_out firstSymbolInHighOrderBits true
set_interface_property aso_out maxChannel 0
set_interface_property aso_out readyLatency 0
set_interface_property aso_out ENABLED true
set_interface_property aso_out EXPORT_OF ""
set_interface_property aso_out PORT_NAME_MAP ""
set_interface_property aso_out CMSIS_SVD_VARIABLES ""
set_interface_property aso_out SVD_ADDRESS_GROUP ""

add_interface_port aso_out aso_out_data data Output 8
add_interface_port aso_out aso_out_valid valid Output 1
add_interface_port aso_out aso_out_startofpacket startofpacket Output 1
add_interface_port aso_out aso_out_endofpacket endofpacket Output 1
add_interface_port aso_out aso_out_ready ready Input 1

add_fileset synth_fileset QUARTUS_SYNTH generate
set_fileset_property synth_fileset ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property synth_fileset ENABLE_FILE_OVERWRITE_MODE true
set_fileset_property synth_fileset TOP_LEVEL FFTDataAdapter

set_module_property ELABORATION_CALLBACK elaborate

proc elaborate {} {
	set tInverse [expr [get_parameter_value INVERSE_FFT ] ]
	set tWidth [expr [get_parameter_value INPUT_SYMBOL_WIDTH] ]
	set tWLeft [expr [get_parameter_value EXTRA_LEFT_PADDING] ]
	set tWRight [expr [get_parameter_value EXTRA_RIGHT_PADDING] ]
    set_interface_property asi_in dataBitsPerSymbol [expr {$tWidth*2}]
    set_interface_property aso_out dataBitsPerSymbol [expr {1+($tWidth*2)+(2*$tWRight)+(2*$tWLeft)}]
    set_port_property asi_in_data WIDTH_EXPR   "$tWidth*2"
    set_port_property aso_out_data WIDTH_EXPR  "($tWidth*2)+1+(2*$tWRight)+(2*$tWLeft)"
}
proc generate {entity_name} {
	set tInverse [expr [get_parameter_value INVERSE_FFT ] ]
	set tWidth [expr [get_parameter_value INPUT_SYMBOL_WIDTH] ]
	set tWLeft [expr [get_parameter_value EXTRA_LEFT_PADDING] ]
	set tWRight [expr [get_parameter_value EXTRA_RIGHT_PADDING] ]
    set fileID [open "./FFTDataAdapter.v" r]
    set temp ""
    while {[eof $fileID] != 1} {
        gets $fileID lineInfo
        regsub -all {\{\{INVERSE_FFT\}\}} $lineInfo [format %d $tInverse] lineInfo
        regsub -all {\{\{INPUT_SYMBOL_WIDTH\}\}} $lineInfo  [format %d $tWidth] lineInfo
        regsub -all {\{\{EXTRA_LEFT_PADDING\}\}} $lineInfo  [format %d $tWLeft] lineInfo
        regsub -all {\{\{EXTRA_RIGHT_PADDING\}\}} $lineInfo  [format %d $tWRight] lineInfo
        append temp "${lineInfo}\n"
    }
    add_fileset_file FFTDataAdapter.v VERILOG TEXT $temp
}
