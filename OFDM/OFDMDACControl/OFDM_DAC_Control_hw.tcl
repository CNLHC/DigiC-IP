package require -exact qsys 16.1


# 
# module OFDM_DAC_Control
# 
set_module_property DESCRIPTION ""
set_module_property NAME OFDM_DAC_Control
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP DigiC
set_module_property AUTHOR CNLHC
set_module_property DISPLAY_NAME "OFDM DAC Control"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL OFDM_DAC_Control
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE true
add_fileset_file OFDM_DAC_Control.v VERILOG PATH OFDM_DAC_Control.v TOP_LEVEL_FILE


# 
# parameters
# 


# 
# display items
# 


# 
# connection point asi_in0
# 
add_interface asi_in0 avalon_streaming end
set_interface_property asi_in0 associatedClock sample_clock
set_interface_property asi_in0 associatedReset reset
set_interface_property asi_in0 dataBitsPerSymbol 38
set_interface_property asi_in0 errorDescriptor ""
set_interface_property asi_in0 firstSymbolInHighOrderBits true
set_interface_property asi_in0 maxChannel 0
set_interface_property asi_in0 readyLatency 0
set_interface_property asi_in0 ENABLED true
set_interface_property asi_in0 EXPORT_OF ""
set_interface_property asi_in0 PORT_NAME_MAP ""
set_interface_property asi_in0 CMSIS_SVD_VARIABLES ""
set_interface_property asi_in0 SVD_ADDRESS_GROUP ""

add_interface_port asi_in0 asi_in0_data data Input 38
add_interface_port asi_in0 asi_in0_ready ready Output 1
add_interface_port asi_in0 asi_in0_valid valid Input 1
add_interface_port asi_in0 asi_in0_startofpacket startofpacket Input 1
add_interface_port asi_in0 asi_in0_endofpacket endofpacket Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock sample_clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset_reset reset Input 1


# 
# connection point DAC_Control
# 
add_interface DAC_Control conduit end
set_interface_property DAC_Control associatedClock sample_clock
set_interface_property DAC_Control associatedReset ""
set_interface_property DAC_Control ENABLED true
set_interface_property DAC_Control EXPORT_OF ""
set_interface_property DAC_Control PORT_NAME_MAP ""
set_interface_property DAC_Control CMSIS_SVD_VARIABLES ""
set_interface_property DAC_Control SVD_ADDRESS_GROUP ""

add_interface_port DAC_Control DAC_Control_ChA_Data chadata Output 14
add_interface_port DAC_Control DAC_Control_ChB_Data chbdata Output 14


# 
# connection point sample_clock
# 
add_interface sample_clock clock end
set_interface_property sample_clock clockRate 0
set_interface_property sample_clock ENABLED true
set_interface_property sample_clock EXPORT_OF ""
set_interface_property sample_clock PORT_NAME_MAP ""
set_interface_property sample_clock CMSIS_SVD_VARIABLES ""
set_interface_property sample_clock SVD_ADDRESS_GROUP ""

add_interface_port sample_clock sample_clock_dac clk Input 1


