/* verilator lint_off TIMESCALEMOD */
module areg #(
    parameter DATA_WIDTH = 16
) (
    input  logic                  clk_i,
    input  logic                  arstn_i,
    input  logic                  en_i,
    input  logic [DATA_WIDTH-1:0] data_i,
    output logic [DATA_WIDTH-1:0] data_o
);

    always_ff @(posedge clk_i or negedge arstn_i) begin
        if (~arstn_i) begin
            data_o <= '0;
        end else if (en_i) begin
            data_o <= data_i;
        end 
    end

endmodule
