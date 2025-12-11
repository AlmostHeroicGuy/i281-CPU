module pcupdatelogic (
    input wire [5:0] current_pc,
    input wire [5:0] offset_in,
    input wire c2_mux_select,
    output wire [5:0] next_pc_address
);

    wire [5:0] pc_plus_1;
    assign pc_plus_1 = current_pc + 6'd1;

    wire [5:0] pc_plus_1_plus_offset;
    
    assign pc_plus_1_plus_offset = pc_plus_1 + $signed(offset_in);

    assign next_pc_address = c2_mux_select ? pc_plus_1_plus_offset : pc_plus_1;

endmodule