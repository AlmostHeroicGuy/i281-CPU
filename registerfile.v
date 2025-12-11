module registerfile (
    input wire clk,                  
    input wire reset,
    input wire c10_write_en,         // C10: Global Write Enable
    input wire [1:0] c8c9_write_sel, // C8C9: 2-bit Write Select (00=A, 01=B, 10=C, 11=D)
    input wire [1:0] c4c5_read0_sel, // C4C5: 2-bit Port 0 Read Select
    input wire [1:0] c6c7_read1_sel, // C6C7: 2-bit Port 1 Read Select

    // Data Input (8-bit)
    input wire [7:0] data_in,        // Data to be written into the selected register (from Reg Writeback Mux C18)

    // Data Outputs (8-bit)
    output wire [7:0] port0_data,    // Output from Port 0 (to ALU Port A)
    output wire [7:0] port1_data     // Output from Port 1 (to ALU Source Mux C11)
);

    // Internal Register Declarations (Registers A, B, C, D are 8-bit)
    reg [7:0] reg_A = 8'h00; // 00000000
    reg [7:0] reg_B = 8'h00; // 00000000
    reg [7:0] reg_C = 8'h00; // 00000000
    reg [7:0] reg_D = 8'h00; // 00000000

    // Synchronous Write Logic (Write Enable C10 and Write Select C8C9)
    always @(posedge clk) begin
        if (reset) begin
            // Reset all registers to zero
            reg_A <= 8'h00;
            reg_B <= 8'h00;
            reg_C <= 8'h00;
            reg_D <= 8'h00;
        end else if (c10_write_en) begin
            // Check which register is selected for writing (C8C9)
            case (c8c9_write_sel)
                2'b00: reg_A <= data_in; // Write to Register A
                2'b01: reg_B <= data_in; // Write to Register B
                2'b10: reg_C <= data_in; // Write to Register C
                2'b11: reg_D <= data_in; // Write to Register D
                default: ; // Do nothing
            endcase
        end
    end

    // Combinational Read Logic: Port 0 (Read Select C4C5)
    // Implements the 4-to-1 multiplexer for Port 0     
	 assign port0_data = 
        (c4c5_read0_sel == 2'b00) ? reg_A :   // Read A
        (c4c5_read0_sel == 2'b01) ? reg_B :   // Read B
        (c4c5_read0_sel == 2'b10) ? reg_C :   // Read C
        (c4c5_read0_sel == 2'b11) ? reg_D :   // Read D
        8'hXX; // Should not happen

    // Combinational Read Logic: Port 1 (Read Select C6C7)
    // Implements the 4-to-1 multiplexer for Port 1     
	 assign port1_data = 
        (c6c7_read1_sel == 2'b00) ? reg_A :   // Read A
        (c6c7_read1_sel == 2'b01) ? reg_B :   // Read B
        (c6c7_read1_sel == 2'b10) ? reg_C :   // Read C
        (c6c7_read1_sel == 2'b11) ? reg_D :   // Read D
        8'hXX; // Should not happen

endmodule