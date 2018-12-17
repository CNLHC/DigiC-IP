onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testFixLengthBytes2Packets/U1/clock_clk
add wave -noupdate /testFixLengthBytes2Packets/U1/reset_reset
add wave -noupdate /testFixLengthBytes2Packets/U1/asi_in0_data
add wave -noupdate /testFixLengthBytes2Packets/U1/asi_in0_ready
add wave -noupdate /testFixLengthBytes2Packets/U1/asi_in0_valid
add wave -noupdate -radix unsigned -radixshowbase 0 /testFixLengthBytes2Packets/U1/tSymbolCounter
add wave -noupdate /testFixLengthBytes2Packets/U1/tInnerState
add wave -noupdate /testFixLengthBytes2Packets/U1/tBytesCounter
add wave -noupdate /testFixLengthBytes2Packets/U1/tPacketState
add wave -noupdate -expand -group {Avalon Source} /testFixLengthBytes2Packets/U1/aso_out0_data
add wave -noupdate -expand -group {Avalon Source} /testFixLengthBytes2Packets/U1/aso_out0_ready
add wave -noupdate -expand -group {Avalon Source} /testFixLengthBytes2Packets/U1/aso_out0_valid
add wave -noupdate -expand -group {Avalon Source} /testFixLengthBytes2Packets/U1/aso_out0_empty
add wave -noupdate -expand -group {Avalon Source} /testFixLengthBytes2Packets/U1/aso_out0_startofpacket
add wave -noupdate -expand -group {Avalon Source} /testFixLengthBytes2Packets/U1/aso_out0_endofpacket
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1539 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 368
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {1511 ps} {1567 ps}
