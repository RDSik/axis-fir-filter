/* verilator lint_off TIMESCALEMOD */
module fir_filter #(
    parameter DATA_WIDTH = 16,
    parameter COE_WIDTH  = 16,
    parameter COE_NUM    = 29,
    parameter COE_MEM    = "coe.mem"
) (
    input logic clk_i,
    input logic arstn_i,

    axis_if.master m_axis,
    axis_if.slave  s_axis
);

    logic [COE_WIDTH-1:0] coe_mem [COE_NUM-1:0];

    initial $readmemh(COE_MEM, coe_mem);

    logic signed [COE_NUM-2:0][DATA_WIDTH-1:0] reg_o;
    logic signed [COE_NUM-2:0][DATA_WIDTH-1:0] acc_o;
    logic signed [COE_NUM-1:0][COE_WIDTH-1:0]  coe_i;

    logic signed [DATA_WIDTH-1:0] fir_o;
    logic signed [DATA_WIDTH-1:0] fir_i;

    logic [$clog2(COE_NUM)-1:0] fir_cnt;

    logic reg_en;

    genvar i;
    generate
        for (i  = 0; i < COE_NUM; i = i + 1) begin : generate_block_identifier            
            assign coe_i[i] = coe_mem[i];

            if (i == 0) begin
                acc_reg #(
                    .DATA_WIDTH (DATA_WIDTH),
                    .COE_WIDTH  (COE_WIDTH )
                ) i_acc_areg_f (
                    .clk_i  (clk_i   ), 
                    .arstn_i(arstn_i ),
                    .en_i   (reg_en  ),
                    .reg_i  (fir_i   ),
                    .reg_o  (reg_o[i]),
                    .coe_i  (coe_i[i]),
                    .acc_i  ('0      ),
                    .acc_o  (acc_o[i])
                );
            end else if (i == COE_NUM - 1) begin
                acc_reg #(
                    .DATA_WIDTH (DATA_WIDTH),
                    .COE_WIDTH  (COE_WIDTH )
                ) i_acc_reg_l (
                    .clk_i  (clk_i     ),
                    .arstn_i(arstn_i   ),
                    .en_i   (reg_en    ),
                    .reg_i  (reg_o[i-1]),
                    .reg_o  (          ),
                    .coe_i  (coe_i[i]  ),
                    .acc_i  (acc_o[i-1]),
                    .acc_o  (fir_o     )
                );
            end else begin
                acc_reg #(
                    .DATA_WIDTH (DATA_WIDTH),
                    .COE_WIDTH  (COE_WIDTH )
                ) i_areg_n (
                    .clk_i  (clk_i     ), 
                    .arstn_i(arstn_i   ),
                    .en_i   (reg_en    ),
                    .reg_i  (reg_o[i-1]),
                    .reg_o  (reg_o[i]  ),
                    .coe_i  (coe_i[i]  ),
                    .acc_i  (acc_o[i-1]),
                    .acc_o  (acc_o[i]  )
                );
            end
        end
    endgenerate

    always @(posedge clk_i or negedge arstn_i) begin
        if (~arstn_i) begin
            m_axis.tdata <= '0;
            fir_i        <= '0;
        end else begin 
            if (s_axis.tready & s_axis.tvalid) begin
                fir_i <= s_axis.tdata;
            end 
            if ((m_axis.tready & m_axis.tvalid) || (fir_cnt == COE_NUM - 1)) begin
                m_axis.tdata <= fir_o;
            end
        end
    end

    always_ff @(posedge clk_i or negedge arstn_i) begin
        if (~arstn_i) begin
            s_axis.tready <= 1'b0;
            m_axis.tvalid <= 1'b0;
            reg_en        <= 1'b0;
            fir_cnt       <= '0;
        end else begin
            if ((s_axis.tready & s_axis.tvalid) || (m_axis.tready & m_axis.tvalid)) begin
                reg_en  <= 1'b1;
                if (fir_cnt == COE_NUM - 1) begin
                    fir_cnt <= '0;    
                end else begin 
                    fir_cnt <= fir_cnt + 1'b1;
                end
            end
            if (fir_cnt == COE_NUM - 1) begin
                m_axis.tvalid <= 1'b1;
            end 
            if (s_axis.tvalid) begin
                s_axis.tready <= 1'b1;
            end
        end
    end

endmodule
