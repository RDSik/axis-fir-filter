vlib work
vmap work

vlog fir_filter_tb.sv
vlog fir_filter_if.sv
vlog environment.sv
vlog ../areg.sv
vlog ../fir_filter.sv
vlog ../axis_if.sv

vsim -voptargs="+acc" fir_filter_tb
add log -r /*

###############################
# Add signals to time diagram #
###############################
add wave -expand -color #ff9911 -radix hex -group TOP \
/fir_filter_tb/dut/clk_i   \
/fir_filter_tb/dut/arstn_i \
/fir_filter_tb/dut/coe_mem \
/fir_filter_tb/dut/reg_o   \
/fir_filter_tb/dut/fir_o   \
/fir_filter_tb/dut/fir_i   \
/fir_filter_tb/dut/fir_cnt \
/fir_filter_tb/dut/reg_en  \

add wave -expand -color #cccc00 -radix hex -group M_AXIS \
/fir_filter_tb/m_axis/tdata  \
/fir_filter_tb/m_axis/tvalid \
/fir_filter_tb/m_axis/tready \

add wave -expand -color #ee66ff -radix hex -group S_AXIS \
/fir_filter_tb/s_axis/tdata  \
/fir_filter_tb/s_axis/tvalid \
/fir_filter_tb/s_axis/tready \

run -all
wave zoom full
