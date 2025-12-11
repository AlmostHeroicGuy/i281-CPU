module alu (
    input wire [7:0] data_A,
    input wire [7:0] data_B,
    input wire c12_select1,          
    input wire c13_select0,          
    output wire [7:0] alu_result,
    output wire flag_negative,
    output wire flag_zero,
    output wire flag_carry,
    output wire flag_overflow
);

    // Adder/Subtractor Calculations
    wire [7:0] sum_sub_result;
    
    assign sum_sub_result = data_A + (c13_select0 ? (~data_B + 8'd1) : data_B); 
    
    // Carry and Overflow Calculation
    wire [8:0] sum_extended;
    
    assign sum_extended = {1'b0, data_A} + 
                          (c13_select0 ? {1'b0, ~data_B} : {1'b0, data_B}) + 
                          (c13_select0 ? 9'd1 : 9'd0);

    wire carry_out;       // C8
    wire overflow_out;    // C7 XOR C8

    assign carry_out = sum_extended[8];       
    wire sign_A = data_A[7];
    wire sign_B = c13_select0 ? ~data_B[7] : data_B[7]; // Effective sign of B
    wire sign_R = sum_sub_result[7];

    assign overflow_out = (sign_A & sign_B & ~sign_R) | (~sign_A & ~sign_B & sign_R);

    // Internal Shifter Calculations
    wire [7:0] shift_result;
    
    // Shift Left (C13=0) or Shift Right (C13=1)
    assign shift_result = c13_select0 ? (data_A >> 1) : (data_A << 1);

    // Bit shifted out
    wire shift_out = c13_select0 ? data_A[0] : data_A[7];

    // Final Result and Flags
    assign alu_result = c12_select1 ? sum_sub_result : shift_result;

    assign flag_negative = alu_result[7]; 
    assign flag_zero = ~(|alu_result);
    assign flag_carry = c12_select1 ? carry_out : shift_out;
    assign flag_overflow = c12_select1 ? overflow_out : 1'b0; 

endmodule