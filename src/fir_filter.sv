/* verilator lint_off TIMESCALEMOD */
module fir_filter #(
    parameter DATA_WIDTH = 16,
    parameter COE_WIDTH  = 16,
    parameter COE_NUM    = 33,
    parameter COE_MEM    = "coe.mem"
) (
    input logic clk_i,
    input logic arstn_i,

    axis_if.master m_axis,
    axis_if.slave  s_axis
);

    logic [COE_WIDTH-1:0] coe_mem [COE_NUM-1:0];

    initial $readmemh(COE_MEM, coe_mem);

    logic signed [((COE_NUM-1)*DATA_WIDTH)-1:0] reg_o;

    logic signed [DATA_WIDTH-1:0] fir_o;
    logic signed [DATA_WIDTH-1:0] fir_i;

    logic [$clog2(COE_NUM)-1:0] fir_cnt;

    logic reg_en;

    generate
        for (genvar i  = 0; i < COE_NUM; i = i + 1) begin
            if (i < COE_NUM - 1) begin
                if (i == 0) begin
                    areg #(
                        .DATA_WIDTH (DATA_WIDTH)
                    ) i_areg (
                        .clk_i  (clk_i                ), 
                        .arstn_i(arstn_i              ),
                        .en_i   (reg_en               ),
                        .data_i (fir_i                ),
                        .data_o (reg_o[DATA_WIDTH-1:0])
                    );
                end else begin
                    areg #(
                        .DATA_WIDTH (DATA_WIDTH)
                    ) i_areg (
                        .clk_i  (clk_i                                 ), 
                        .arstn_i(arstn_i                               ),
                        .en_i   (reg_en                                ),
                        .data_i (reg_o[i*DATA_WIDTH-1:(i-1)*DATA_WIDTH]),
                        .data_o (reg_o[(i+1)*DATA_WIDTH-1:i*DATA_WIDTH])
                    );
                end
            end

            always_ff @(posedge clk_i or negedge arstn_i) begin
                if (~arstn_i) begin
                    fir_o <= '0;
                end else if (reg_en) begin
                    if (i == 0) begin 
                        fir_o <= fir_o + (fir_i * coe_mem[i]);
                    end else begin
                        fir_o <= fir_o + (reg_o[i*DATA_WIDTH-1:(i-1)*DATA_WIDTH] * coe_mem[i]);
                    end
                end
            end
        end
    endgenerate

    always @(posedge clk_i or negedge arstn_i) begin
        if (~arstn_i) begin
            fir_cnt      <= '0;
            m_axis.tdata <= '0;
            fir_i        <= '0;
        end else if (fir_cnt == COE_NUM - 1) begin
            fir_cnt      <= '0;
            m_axis.tdata <= fir_o;
            fir_i        <= s_axis.tdata;
        end else if (~s_axis.tvalid | ~m_axis.tready) begin
            fir_cnt <= COE_NUM - 1;
        end else begin
            fir_cnt <= fir_cnt + 1;
            fir_i   <= s_axis.tdata;
        end
    end

    always_ff @(posedge clk_i or negedge arstn_i) begin
        if (~arstn_i | ~s_axis.tvalid | ~m_axis.tready) begin
            s_axis.tready <= 1'b0;
            m_axis.tvalid <= 1'b0;
            reg_en        <= 1'b0;
        end else begin
            s_axis.tready <= 1'b1;
            m_axis.tvalid <= 1'b1;
            reg_en        <= 1'b1;
        end
    end

endmodule
