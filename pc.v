module pc (
    input wire clk,
    input wire reset,
    input wire c3_write_en,
    input wire [5:0] in_pc,
    output wire [5:0] pc_out
);

    reg [5:0] pc_reg;

    always @(posedge clk) begin
        if (reset) begin
            pc_reg <= 6'b100000;
        end else if (c3_write_en) begin
            pc_reg <= in_pc;
        end else begin
            pc_reg <= pc_reg; 
        end
    end

    assign pc_out = pc_reg;

endmodule 