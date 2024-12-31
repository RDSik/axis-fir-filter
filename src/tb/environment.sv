`ifndef ENV_SV
`define ENV_SV

class environment;

    localparam SAMPLE_NUM   = 256;
    localparam SAMPLE_WIDTH = 16;
    localparam SIN_MEM      = "sin.mem";

    logic [SAMPLE_WIDTH-1:0] sin_mem [SAMPLE_NUM-1:0];

    local virtual fir_filter_if dut_if;
    local virtual axis_if s_axis;
    local virtual axis_if m_axis;

    function new(virtual fir_filter_if dut_if, virtual axis_if s_axis, virtual axis_if m_axis);
        this.dut_if = dut_if;
        this.m_axis = m_axis;
        this.s_axis = s_axis;
    endfunction

    task run();
        begin
            dut_if.clk_i = 1'b0;
            rst_gen();
            data_gen();
        end
    endtask

    task rst_gen();
        begin
            dut_if.arstn_i = 1'b0;
            @(posedge dut_if.clk_i);
            dut_if.arstn_i = 1'b1;
        end
    endtask

    task data_gen();
        begin
            $readmemh(SIN_MEM, sin_mem);

            s_axis.tvalid = 1'b1;

            for (int i = 0; i < 256; i = i + 1) begin
                s_axis.tdata = sin_mem[i];
                @(posedge dut_if.clk_i);
            end

            s_axis.tvalid = 1'b0;
        end
    endtask
    
endclass

`endif
