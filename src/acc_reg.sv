/* verilator lint_off TIMESCALEMOD */
module acc_reg #(
    parameter DATA_WIDTH = 16,
    parameter COE_WIDTH  = 16
) (
    input  logic                         clk_i,
    input  logic                         arstn_i,
    input  logic                         en_i,
    input  logic signed [COE_WIDTH-1:0]  coe_i,
    input  logic signed [DATA_WIDTH-1:0] acc_i,
    input  logic signed [DATA_WIDTH-1:0] reg_i,
    output logic signed [DATA_WIDTH-1:0] reg_o,
    output logic signed [DATA_WIDTH-1:0] acc_o
);

    always_ff @(posedge clk_i or negedge arstn_i) begin
        if (~arstn_i) begin
            reg_o <= '0;
        end else if (en_i) begin
            reg_o <= reg_i;
        end 
    end

    always_ff @(posedge clk_i or negedge arstn_i) begin
        if (~arstn_i) begin
            acc_o <= '0;
        end else if (en_i) begin
            acc_o <= acc_i + (reg_i * coe_i);
        end
    end

endmodule
