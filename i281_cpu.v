module i281_cpu (
    // Global Signals
    input wire Clock,
    input wire Reset,
	 input wire [15:0] Switches // Assuming 0 for normal operation, or an input for BIOS
);

    // Instruction Fetch Wires (Code Memory)
    wire [5:0] pc_out_cm_addr;
    wire [15:0] instr_out;
    wire c1_imem_write_enable;
    wire [5:0] cm_write_select = 6'd0; // Assuming 0 for normal operation, or an input for BIOS

    // Instruction Decode Wires (OpCode Decoder)
    wire [7:0] OpCode_Field = instr_out[15:8];
    wire OP_NOOP, OP_INPUTC, OP_INPUTCF, OP_INPUTD, OP_INPUTDF, OP_MOVE, OP_LOADI_LOADP,
         OP_ADD, OP_ADDI, OP_SUB, OP_SUBI, OP_LOAD, OP_LOADF, OP_STORE, OP_STOREF,
         OP_SHIFTL, OP_SHIFTR, OP_CMP, OP_JUMP, OP_BRE_BRZ, OP_BRNE_BRNZ, OP_BRG, OP_BRGE;
    wire X1, X0, Y1, Y0;

    // Control Unit Wires (Control)
    wire c2_program_counter_mux, c3_program_counter_write_en;
    wire c4_registers_port0_select1, c5_registers_port0_select0;
    wire c6_registers_port1_select1, c7_registers_port1_select0;
    wire c8_registers_write_select1, c9_registers_write_select0;
    wire c10_registers_write_enable;
    wire c11_alu_source_mux;
    wire c12_alu_select1, c13_alu_select0;
    wire c14_flags_write_enable;
    wire c15_alu_result_mux;
    wire c16_dmem_input_mux;
    wire c17_dmem_write_enable;
    wire c18_reg_writeback_mux;

    // PC and PC Update Logic Wires
    wire [5:0] next_pc_address;
    wire [5:0] offset_in = instr_out[5:0]; // The 6 low bits of the instruction (I5-I0) are the offset for PC Update

    // Register File Wires
    wire [7:0] port0_data; // To ALU Port A
    wire [7:0] port1_data; // To ALU Source Mux (C11)
    wire [7:0] reg_writeback_data; // Output from C18 Reg Writeback Mux

    // ALU Wires
    wire [7:0] alu_input_B; // Output from C11 ALU Source Mux
    wire [7:0] alu_result;
    wire flag_negative, flag_zero, flag_carry, flag_overflow;

    // Flags Register Wires
    wire out_carry, out_overflow, out_negative, out_zero; // To Control Unit (CF, ZF, NF, OF)

    // Data Memory Wires
    wire [7:0] dmem_data_out;

    // Mux Wires
    wire [7:0] alu_result_mux_out; // Output of C15 ALU Result Mux
    wire [7:0] dmem_input_mux_out; // Output of C16 DMEM Input Mux



    // 1. Code Memory
    CodeMemory CM (
        .clk(Clock),
        .addr_cm(pc_out_cm_addr), // PC Out (6 bits)
        .we_cm(c1_imem_write_enable), // C1
        .data_in_cm(Switches),
        .write_sel(cm_write_select),
        .instr_out(instr_out)
    );

    // 2. OpCode Decoder
    opcode_decoder OD (
        .OpCode_Field(OpCode_Field), // I15-I8

        .OP_NOOP(OP_NOOP), .OP_INPUTC(OP_INPUTC), .OP_INPUTCF(OP_INPUTCF),
        .OP_INPUTD(OP_INPUTD), .OP_INPUTDF(OP_INPUTDF), .OP_MOVE(OP_MOVE),
        .OP_LOADI_LOADP(OP_LOADI_LOADP), .OP_ADD(OP_ADD), .OP_ADDI(OP_ADDI),
        .OP_SUB(OP_SUB), .OP_SUBI(OP_SUBI), .OP_LOAD(OP_LOAD),
        .OP_LOADF(OP_LOADF), .OP_STORE(OP_STORE), .OP_STOREF(OP_STOREF),
        .OP_SHIFTL(OP_SHIFTL), .OP_SHIFTR(OP_SHIFTR), .OP_CMP(OP_CMP),
        .OP_JUMP(OP_JUMP), .OP_BRE_BRZ(OP_BRE_BRZ), .OP_BRNE_BRNZ(OP_BRNE_BRNZ),
        .OP_BRG(OP_BRG), .OP_BRGE(OP_BRGE),

        .X1(X1), .X0(X0), // I11, I10
        .Y1(Y1), .Y0(Y0)  // I9, I8
    );

    // 3. Control Unit
    control CU (
        // OpCode Lines
        .OP_NOOP(OP_NOOP), .OP_INPUTC(OP_INPUTC), .OP_INPUTCF(OP_INPUTCF),
        .OP_INPUTD(OP_INPUTD), .OP_INPUTDF(OP_INPUTDF), .OP_MOVE(OP_MOVE),
        .OP_LOADI_LOADP(OP_LOADI_LOADP), .OP_ADD(OP_ADD), .OP_ADDI(OP_ADDI),
        .OP_SUB(OP_SUB), .OP_SUBI(OP_SUBI), .OP_LOAD(OP_LOAD),
        .OP_LOADF(OP_LOADF), .OP_STORE(OP_STORE), .OP_STOREF(OP_STOREF),
        .OP_SHIFTL(OP_SHIFTL), .OP_SHIFTR(OP_SHIFTR), .OP_CMP(OP_CMP),
        .OP_JUMP(OP_JUMP), .OP_BRE_BRZ(OP_BRE_BRZ), .OP_BRNE_BRNZ(OP_BRNE_BRNZ),
        .OP_BRG(OP_BRG), .OP_BRGE(OP_BRGE),

        // Register Select Bits
        .X1(X1), .X0(X0), .Y1(Y1), .Y0(Y0),

        // Flag Bits (ZF, NF, OF, CF)
        .ZF(out_zero), // Zero Flag
        .NF(out_negative), // Negative Flag
        .OF(out_overflow), // Overflow Flag
		  .CF(out_carry), // Carry Flag

        // Output Control Signals (C1-C18)
        .c1_imem_write_enable(c1_imem_write_enable),
        .c2_program_counter_mux(c2_program_counter_mux),
        .c3_program_counter_write_en(c3_program_counter_write_en),
        .c4_registers_port0_select1(c4_registers_port0_select1),
        .c5_registers_port0_select0(c5_registers_port0_select0),
        .c6_registers_port1_select1(c6_registers_port1_select1),
        .c7_registers_port1_select0(c7_registers_port1_select0),
        .c8_registers_write_select1(c8_registers_write_select1),
        .c9_registers_write_select0(c9_registers_write_select0),
        .c10_registers_write_enable(c10_registers_write_enable),
        .c11_alu_source_mux(c11_alu_source_mux),
        .c12_alu_select1(c12_alu_select1),
        .c13_alu_select0(c13_alu_select0),
        .c14_flags_write_enable(c14_flags_write_enable),
        .c15_alu_result_mux(c15_alu_result_mux),
        .c16_dmem_input_mux(c16_dmem_input_mux),
        .c17_dmem_write_enable(c17_dmem_write_enable),
        .c18_reg_writeback_mux(c18_reg_writeback_mux)
    );

    // 4. PC Update Logic
    pcupdatelogic PCUL (
        .current_pc(pc_out_cm_addr), // PC Out (6 bits)
        .offset_in(offset_in), // I5-I0 of instruction (6 low bits)
        .c2_mux_select(c2_program_counter_mux), // C2
        .next_pc_address(next_pc_address) // To PC Input
    );

    // 5. Program Counter (PC)
    pc PC (
        .clk(Clock),
        .reset(Reset),
        .c3_write_en(c3_program_counter_write_en), // C3
        .in_pc(next_pc_address), // Output of PC Update Logic
        .pc_out(pc_out_cm_addr) // To Code Memory Address and PC Update Logic
    );

    // 6. Register File
    registerfile RF (
        .clk(Clock),
        .reset(Reset),
        .c10_write_en(c10_registers_write_enable),
        .c8c9_write_sel({c8_registers_write_select1, c9_registers_write_select0}),
        .c4c5_read0_sel({c4_registers_port0_select1, c5_registers_port0_select0}),
        .c6c7_read1_sel({c6_registers_port1_select1, c7_registers_port1_select0}),

        .data_in(reg_writeback_data), // Output of C18 Reg Writeback Mux

        .port0_data(port0_data), // To ALU Port A
        .port1_data(port1_data) // To ALU Source Mux (C11)
    );

    // 7. ALU Source Mux (C11)
    // Selects between Register Port 1 (port1_data) and I7-I0 (instr_out[7:0])
    assign alu_input_B = c11_alu_source_mux ? instr_out[7:0] : port1_data;

    // 8. ALU
    alu ALU (
        .data_A(port0_data), // Register Port 0
        .data_B(alu_input_B), // Output of C11 Mux
        .c12_select1(c12_alu_select1),
        .c13_select0(c13_alu_select0),
        .alu_result(alu_result), // To C15 ALU Result Mux
        .flag_negative(flag_negative),
        .flag_zero(flag_zero),
        .flag_carry(flag_carry),
        .flag_overflow(flag_overflow)
    );

    // 9. Flags Register
    flags_register FR (
        .clk(Clock),
        .reset(Reset),
        .c14_write_en(c14_flags_write_enable), // C14

        .in_carry(flag_carry),
        .in_overflow(flag_overflow),
        .in_negative(flag_negative),
        .in_zero(flag_zero),

        .out_carry(out_carry),
        .out_overflow(out_overflow),
        .out_negative(out_negative), // NF to Control Unit
        .out_zero(out_zero) // ZF to Control Unit
    );
	 
    assign alu_result_mux_out = c15_alu_result_mux ? instr_out[7:0] : alu_result;
    assign dmem_input_mux_out = c16_dmem_input_mux ? Switches[7:0] : port1_data; // Using I7-I0 as the 'Switches' placeholder input

    // 12. Data Memory
    dmem dmem (
        .Clock(Clock),
        .ReadSelect(alu_result_mux_out[3:0]),
        .DataOut(dmem_data_out), // To C15 ALU Result Mux

        .WriteEn(c17_dmem_write_enable), // C17
        .WriteSelect(alu_result_mux_out[3:0]),
        .DataIn(dmem_input_mux_out) // Output of C16 DMEM Input Mux
    );

    assign reg_writeback_data = c18_reg_writeback_mux ? dmem_data_out : alu_result_mux_out;

endmodule