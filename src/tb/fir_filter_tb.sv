`timescale 1ns/1ps

/* verilator lint_off MODDUP */
module fir_filter_tb ();

    localparam DATA_WIDTH = 16;
    localparam COE_WIDTH  = 16;
    localparam COE_NUM    = 29;
    localparam COE_MEM    = "../coe.mem";

    localparam CLK_PER    = 2;
    localparam SIN_MEM    = "sin.mem";
    localparam SAMPLE_NUM = 256;

    logic arstn_i;
    logic clk_i;

    logic [DATA_WIDTH-1:0] sin_mem [SAMPLE_NUM-1:0];

    axis_if s_axis();
    axis_if m_axis();

    fir_filter #(
        .DATA_WIDTH (DATA_WIDTH), 
        .COE_WIDTH  (COE_WIDTH ), 
        .COE_NUM    (COE_NUM   ), 
        .COE_MEM    (COE_MEM   ) 
    ) dut (
        .clk_i   (clk_i  ),
        .arstn_i (arstn_i),
        .s_axis  (s_axis ),
        .m_axis  (m_axis )
    );

    always #(CLK_PER/2) clk_i = ~clk_i;

    task rst_gen();
        begin
            arstn_i = 1'b0;
            @(posedge clk_i);
            arstn_i = 1'b1;
        end
    endtask

    task sin_gen();
        begin
            $readmemh(SIN_MEM, sin_mem);

            s_axis.tvalid = 1'b1;
            m_axis.tready = 1'b1;

            repeat (SAMPLE_NUM) begin
                for (int i = 0; i < SAMPLE_NUM; i = i + 1) begin
                    s_axis.tdata = sin_mem[i];
                    @(posedge clk_i);
                end
            end

            s_axis.tvalid = 1'b0;
            m_axis.tready = 1'b0;
        end
    endtask

    task run();
        begin
            clk_i = 1'b0;
            m_axis.tready = 1'b0;
            s_axis.tvalid = 1'b0;
            s_axis.tdata = '0;
            rst_gen();
            sin_gen();
        end
    endtask

    initial begin
        fork
            run();
        join
        `ifdef VERILATOR
        $finish;
        `else
        $stop;
        `endif
    end

    initial begin
        $dumpfile("fir_filter_tb.vcd");
        $dumpvars(0, fir_filter_tb);
    end

endmodule
