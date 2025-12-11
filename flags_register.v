module flags_register (
    input wire clk,
    input wire reset,
    input wire c14_write_en,         // C14: Flags Write Enable
    
    // Flag inputs from ALU's output Muxes
    input wire in_carry,             // ALU-generated Carry flag
    input wire in_overflow,          // ALU-generated Overflow flag
    input wire in_negative,          // ALU-generated Negative flag
    input wire in_zero,              // ALU-generated Zero flag
    
    // Flag outputs to the Control Logic
    output wire out_carry,
    output wire out_overflow,
    output wire out_negative,
    output wire out_zero
);

    // The register array for the four flags: {N, Z, C, O}
    reg carry_flag_reg;
    reg overflow_flag_reg;
    reg negative_flag_reg;
    reg zero_flag_reg;
	 
    always @(posedge clk) begin
        if (reset) begin
            // Reset to 0000
            carry_flag_reg <= 1'b0;
            overflow_flag_reg <= 1'b0;
            negative_flag_reg <= 1'b0;
            zero_flag_reg <= 1'b0;
        end else if (c14_write_en) begin
            // Load new values if C14 is high
            carry_flag_reg <= in_carry;
            overflow_flag_reg <= in_overflow;
            negative_flag_reg <= in_negative;
            zero_flag_reg <= in_zero;
        end else begin
            // Hold current values
            carry_flag_reg <= carry_flag_reg;
            overflow_flag_reg <= overflow_flag_reg;
            negative_flag_reg <= negative_flag_reg;
            zero_flag_reg <= zero_flag_reg;
        end
    end

    // Assign outputs
    assign out_carry = carry_flag_reg;
    assign out_overflow = overflow_flag_reg;
    assign out_negative = negative_flag_reg;
    assign out_zero = zero_flag_reg;

endmodule