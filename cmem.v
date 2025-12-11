module CodeMemory (
    input wire clk,
    input wire [5:0] addr_cm,   // 6-bit Address from PC
    input wire we_cm,           // C1 (Write Enable)
    input wire [15:0] data_in_cm, // 16-bit data to write
	 input wire [5:0] write_sel,
    output wire [15:0] instr_out // 16-bit Instruction read out
);

// Memory declaration (64 x 16 bits)
reg [15:0] c_mem [0:63]; 

// Read Port (Asynchronous read)
assign instr_out = c_mem[addr_cm];

// Conditional Write Port (Synchronous write)
always @(posedge clk) begin
    if (we_cm) begin
        c_mem[addr_cm] <= data_in_cm;
    end
end

initial begin
    
    // Address 0-15: BIOS Code Memory Low 
   
    c_mem[0] = 16'b0000000000000000;
    c_mem[1] = 16'b1110000000011110;
    c_mem[2] = 16'b0000000000000000;
    c_mem[3] = 16'b0000000000000000;
    c_mem[4] = 16'b0000000000000000;
    c_mem[5] = 16'b0000000000000000;
    c_mem[6] = 16'b0000000000000000;
    c_mem[7] = 16'b0000000000000000;
    c_mem[8] = 16'b0000000000000000;
    c_mem[9] = 16'b0000000000000000;
    c_mem[10] = 16'b0000000000000000;
    c_mem[11] = 16'b0000000000000000;
    c_mem[12] = 16'b0000000000000000;
    c_mem[13] = 16'b0000000000000000;
    c_mem[14] = 16'b0000000000000000;
    c_mem[15] = 16'b0000000000000000;

    
    // Address 16-31: BIOS Code Memory High
    
    c_mem[16] = 16'b0000000000000000;
    c_mem[17] = 16'b0000000000000000;
    c_mem[18] = 16'b0000000000000000;
    c_mem[19] = 16'b0000000000000000;
    c_mem[20] = 16'b0000000000000000;
    c_mem[21] = 16'b0000000000000000;
    c_mem[22] = 16'b0000000000000000;
    c_mem[23] = 16'b0000000000000000;
    c_mem[24] = 16'b0000000000000000;
    c_mem[25] = 16'b0000000000000000;
    c_mem[26] = 16'b0000000000000000;
    c_mem[27] = 16'b0000000000000000;
    c_mem[28] = 16'b0000000000000000;
    c_mem[29] = 16'b0000000000000000;
    c_mem[30] = 16'b0000000000000000;
    c_mem[31] = 16'b0000000000000000;

   
    // Address 32-47: User Code Memory Low
   
    c_mem[32] = 16'b0011000000000000;
    c_mem[33] = 16'b1000110000001000;
    c_mem[34] = 16'b0011010000000000;
    c_mem[35] = 16'b1101001100000000;
    c_mem[36] = 16'b1111001100001110;
    c_mem[37] = 16'b1000110000001000;
    c_mem[38] = 16'b0110110000000000;
    c_mem[39] = 16'b1101011100000000;
    c_mem[40] = 16'b1111001100001000;
    c_mem[41] = 16'b1001100100000000;
    c_mem[42] = 16'b1001110100000001;
    c_mem[43] = 16'b1101111000000000;
    c_mem[44] = 16'b1111001100000010;
    c_mem[45] = 16'b1011110100000000;
    c_mem[46] = 16'b1011100100000001;
    c_mem[47] = 16'b0101010000000001;

    
    // Address 48-63: User Code Memory High
    
    c_mem[48] = 16'b1110000011110100;
    c_mem[49] = 16'b0101000000000001;
    c_mem[50] = 16'b1110000011101110;
    c_mem[51] = 16'b0000000000000000;
    c_mem[52] = 16'b0000000000000000;
    c_mem[53] = 16'b0000000000000000;
    c_mem[54] = 16'b0000000000000000;
    c_mem[55] = 16'b0000000000000000;
    c_mem[56] = 16'b0000000000000000;
    c_mem[57] = 16'b0000000000000000;
    c_mem[58] = 16'b0000000000000000;
    c_mem[59] = 16'b0000000000000000;
    c_mem[60] = 16'b0000000000000000;
    c_mem[61] = 16'b0000000000000000;
    c_mem[62] = 16'b0000000000000000;
    c_mem[63] = 16'b0000000000000000;


end

endmodule



