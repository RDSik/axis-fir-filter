`timescale 1ns/1ps

`include "environment.sv"

module fir_filter_tb ();

    localparam DATA_WIDTH = 16;
    localparam COE_WIDTH  = 16;
    localparam COE_NUM    = 33;
    localparam COE_MEM    = "../coe.mem";

    localparam CLK_PER = 2;

    fir_filter_if dut_if();
    axis_if s_axis();
    axis_if m_axis();
    environment env;

    fir_filter #(
        .DATA_WIDTH (DATA_WIDTH), 
        .COE_WIDTH  (COE_WIDTH ), 
        .COE_NUM    (COE_NUM   ), 
        .COE_MEM    (COE_MEM   ) 
    ) dut (
        .clk_i   (dut_if.clk_i  ),
        .arstn_i (dut_if.arstn_i),
        .s_axis  (s_axis        ),
        .m_axis  (m_axis        )
    );

    always #(CLK_PER/2) dut_if.clk_i = ~dut_if.clk_i;

    initial begin
        fork
            env = new(dut_if, s_axis, m_axis);
            env.run();
        join
        $stop;
    end

    initial begin
        $dumpfile("fir_filter_tb.vcd");
        $dumpvars(0, fir_filter_tb);
    end

endmodule
