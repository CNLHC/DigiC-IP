# Fix_Length_Bytes2Packets "Fix Length Bytes To Packet" v1.0
# CNLHC 2018.12.14.13:05:59
# 
# 

# 
# request TCL package from ACDS 16.1
# 
package require -exact qsys 16.1


# 
# module Fix_Length_Bytes2Packets
# 
set_module_property DESCRIPTION "Convert plain Avalon-ST streaming to packet based streaming. "
set_module_property NAME Fix_Length_Bytes2Packets
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property GROUP DigiC
set_module_property AUTHOR CNLHC
set_module_property DISPLAY_NAME "Fix Length Bytes To Packet"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false



# 
# parameters
# 
add_parameter SYMBOL_PER_PACKET INTEGER  256 "How many symbols does one packet contain"
set_parameter_property SYMBOL_PER_PACKET ALLOWED_RANGES {4,8,16,32,64,128,256,512,1024} 

add_parameter BYTES_PER_SYMBOL INTEGER  4 "How many bytes does one symbol contain"
set_parameter_property BYTES_PER_SYMBOL ALLOWED_RANGES {1,2,3,4,5,6,7,8}

add_parameter BITS_PER_BYTES  INTEGER  4 "How many bits does one bytes contain"
set_parameter_property BYTES_PER_SYMBOL ALLOWED_RANGES {1:16}





# 
# display items
# 


# 
# connection point asi_in0
# 
add_interface asi_in0 avalon_streaming end
set_interface_property asi_in0 associatedClock clock_1
set_interface_property asi_in0 associatedReset reset
set_interface_property asi_in0 dataBitsPerSymbol 8
set_interface_property asi_in0 errorDescriptor ""
set_interface_property asi_in0 firstSymbolInHighOrderBits true
set_interface_property asi_in0 maxChannel 0
set_interface_property asi_in0 readyLatency 0
set_interface_property asi_in0 ENABLED true
set_interface_property asi_in0 EXPORT_OF ""
set_interface_property asi_in0 PORT_NAME_MAP ""
set_interface_property asi_in0 CMSIS_SVD_VARIABLES ""
set_interface_property asi_in0 SVD_ADDRESS_GROUP ""

add_interface_port asi_in0 asi_in0_data data Input 8
add_interface_port asi_in0 asi_in0_ready ready Output 1
add_interface_port asi_in0 asi_in0_valid valid Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock_1
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset_reset reset Input 1


# 
# connection point clock_1
# 
add_interface clock_1 clock end
set_interface_property clock_1 clockRate 0
set_interface_property clock_1 ENABLED true
set_interface_property clock_1 EXPORT_OF ""
set_interface_property clock_1 PORT_NAME_MAP ""
set_interface_property clock_1 CMSIS_SVD_VARIABLES ""
set_interface_property clock_1 SVD_ADDRESS_GROUP ""

add_interface_port clock_1 clock_clk clk Input 1


# 
# connection point aso_out0_1
# 
add_interface aso_out0_1 avalon_streaming start
set_interface_property aso_out0_1 associatedClock clock_1
set_interface_property aso_out0_1 associatedReset reset
set_interface_property aso_out0_1 dataBitsPerSymbol  8
set_interface_property aso_out0_1 errorDescriptor ""
set_interface_property aso_out0_1 firstSymbolInHighOrderBits true
set_interface_property aso_out0_1 maxChannel 0
set_interface_property aso_out0_1 readyLatency 0
set_interface_property aso_out0_1 ENABLED true
set_interface_property aso_out0_1 EXPORT_OF ""
set_interface_property aso_out0_1 PORT_NAME_MAP ""
set_interface_property aso_out0_1 CMSIS_SVD_VARIABLES ""
set_interface_property aso_out0_1 SVD_ADDRESS_GROUP ""

add_interface_port aso_out0_1 aso_out0_data data Output 8
add_interface_port aso_out0_1 aso_out0_valid valid Output 1
add_interface_port aso_out0_1 aso_out0_startofpacket startofpacket Output 1
add_interface_port aso_out0_1 aso_out0_endofpacket endofpacket Output 1

set_module_property ELABORATION_CALLBACK elaborate
# 
# file sets
# 
add_fileset synth_fileset QUARTUS_SYNTH generate
set_fileset_property synth_fileset ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property synth_fileset ENABLE_FILE_OVERWRITE_MODE true
set_fileset_property synth_fileset TOP_LEVEL FixLengthB2P
#add_fileset_file Fix_Length_Bytes2Packets.v VERILOG PATH Fix_Length_Bytes2Packets.v


proc elaborate {} {
    set tPythonVersion [exec python --version]
    if {{string  tPacketLength "\n"} eq ""} {
            send_message error "Can not find python" 
        } else  {
            send_message info "Detected Python Version: $tPythonVersion" 
    }
	set tPacketLength [expr [get_parameter_value SYMBOL_PER_PACKET] ]
	set tSymbolLength [expr [get_parameter_value BYTES_PER_SYMBOL] ]
	set tBytesLength  [expr [get_parameter_value BITS_PER_BYTES] ]
    set_interface_property asi_in0 dataBitsPerSymbol $tBytesLength
    set_interface_property aso_out0_1 dataBitsPerSymbol  [expr {$tSymbolLength*$tBytesLength}]
    set_port_property aso_out0_data WIDTH_EXPR  "$tBytesLength*$tSymbolLength"
    set_port_property asi_in0_data WIDTH_EXPR   "$tBytesLength"
}

proc generate {entity_name} {
	set tPacketLength [expr [get_parameter_value SYMBOL_PER_PACKET] ]
	set tSymbolLength [expr [get_parameter_value BYTES_PER_SYMBOL] ]
	set tBytesLength  [expr [get_parameter_value BITS_PER_BYTES] ]
    set fileID [open "./FixLengthB2P.v" r]
    set temp ""
    while {[eof $fileID] != 1} {
        gets $fileID lineInfo
        regsub -all {\{\{SYMBOL_PER_PACKET\}\}} $lineInfo [format %d $tPacketLength] lineInfo
        regsub -all {\{\{BYTES_PER_SYMBOL\}\}} $lineInfo  [format %d $tSymbolLength] lineInfo
        regsub -all {\{\{BITS_PER_BYTES\}\}} $lineInfo    [format %d $tBytesLength] lineInfo
        append temp "${lineInfo}\n"
    }
    add_fileset_file FixLengthB2P.v VERILOG TEXT $temp
}

