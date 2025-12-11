module control (
    input wire OP_NOOP, OP_INPUTC, OP_INPUTCF, OP_INPUTD, OP_INPUTDF, OP_MOVE,
    input wire OP_LOADI_LOADP, OP_ADD, OP_ADDI, OP_SUB, OP_SUBI, OP_LOAD,
    input wire OP_LOADF, OP_STORE, OP_STOREF, OP_SHIFTL, OP_SHIFTR, OP_CMP,
    input wire OP_JUMP, OP_BRE_BRZ, OP_BRNE_BRNZ, OP_BRG, OP_BRGE,
    input wire X1, X0, Y1, Y0,
    input wire ZF, NF, OF, CF,

    output wire c1_imem_write_enable,
    output wire c2_program_counter_mux,
    output wire c3_program_counter_write_en,
    output wire c4_registers_port0_select1,
    output wire c5_registers_port0_select0,
    output wire c6_registers_port1_select1,
    output wire c7_registers_port1_select0,
    output wire c8_registers_write_select1,
    output wire c9_registers_write_select0,
    output wire c10_registers_write_enable,
    output wire c11_alu_source_mux,
    output wire c12_alu_select1,
    output wire c13_alu_select0,
    output wire c14_flags_write_enable,
    output wire c15_alu_result_mux,
    output wire c16_dmem_input_mux,
    output wire c17_dmem_write_enable,
    output wire c18_reg_writeback_mux
);

    wire B1_condition = ZF;
    wire B2_condition = ~ZF;
    wire B3_condition = ~ZF & (NF ~^ OF);
    wire B4_condition = (NF ~^ OF);

    
    assign c1_imem_write_enable = OP_INPUTC | OP_INPUTCF;
    assign c2_program_counter_mux = 
        OP_JUMP | 
        (OP_BRE_BRZ & B1_condition) | 
        (OP_BRNE_BRNZ & B2_condition) |
        (OP_BRG & B3_condition) |
        (OP_BRGE & B4_condition);
    assign c3_program_counter_write_en = 1'b1;
    assign c4_registers_port0_select1 = (OP_INPUTCF & X1) | (OP_INPUTDF & X1) | (OP_MOVE & Y1) |
	 (OP_ADD & X1) | (OP_ADDI & X1) | (OP_SUB & X1) | (OP_SUBI & X1) | (OP_LOADF & Y1) | (OP_STOREF & Y1) |
	 (OP_SHIFTL & X1) | (OP_SHIFTR & X1) | (OP_CMP & X1);	 
    assign c5_registers_port0_select0 = (OP_INPUTCF & X0) | (OP_INPUTDF & X0) | (OP_MOVE & Y0) |
	 (OP_ADD & X0) | (OP_ADDI & X0) | (OP_SUB & X0) | (OP_SUBI & X0) | (OP_LOADF & Y0) | (OP_STOREF & Y0) |
	 (OP_SHIFTL & X0) | (OP_SHIFTR & X0) | (OP_CMP & X0);
    assign c6_registers_port1_select1 = (OP_ADD & Y1) | (OP_SUB & Y1) | (OP_CMP & Y1) | (OP_STOREF & X1) | (OP_STORE & X1);
    assign c7_registers_port1_select0 = (OP_ADD & Y0) | (OP_SUB & Y0) | (OP_CMP & Y0) | (OP_STOREF & X0) | (OP_STORE & X0);
    assign c8_registers_write_select1 = (OP_LOADI_LOADP & X1) | (OP_ADD & X1) | (OP_ADDI & X1) | (OP_SUB & X1) |
	 (OP_SUBI & X1) | (OP_LOAD & X1) | (OP_LOADF & X1) | (OP_SHIFTL & X1) | (OP_SHIFTR & X1) | (OP_MOVE & X1);
    assign c9_registers_write_select0 = (OP_LOADI_LOADP & X0) | (OP_ADD & X0) | (OP_ADDI & X0) | (OP_SUB & X0) |
	 (OP_SUBI & X0) | (OP_LOAD & X0) | (OP_LOADF & X0) | (OP_SHIFTL & X0) | (OP_SHIFTR & X0) | (OP_MOVE & X0);
    assign c10_registers_write_enable = OP_MOVE | OP_LOADI_LOADP | OP_ADD | OP_ADDI | OP_SUB | OP_SUBI | OP_LOAD |
	 OP_LOADF | OP_SHIFTL | OP_SHIFTR; 
    assign c11_alu_source_mux = OP_INPUTCF | OP_INPUTDF | OP_MOVE | OP_LOADF | OP_ADDI | OP_SUBI | OP_STOREF;
    assign c12_alu_select1 = OP_INPUTCF | OP_INPUTDF | OP_MOVE | OP_ADD | OP_ADDI | OP_SUB | OP_SUBI | OP_LOADF |
	 OP_STOREF | OP_CMP;
    assign c13_alu_select0 = OP_SUB | OP_SUBI | OP_SHIFTR | OP_CMP;
    assign c14_flags_write_enable = OP_ADD | OP_ADDI | OP_SUB | OP_SUBI | OP_SHIFTL | OP_SHIFTR | OP_CMP;
    assign c15_alu_result_mux = OP_INPUTC | OP_INPUTD | OP_LOADI_LOADP | OP_LOAD | OP_STORE;
    assign c16_dmem_input_mux = OP_INPUTD | OP_INPUTDF;
    assign c17_dmem_write_enable = OP_INPUTD | OP_INPUTDF | OP_STORE | OP_STOREF;
    assign c18_reg_writeback_mux = OP_LOAD | OP_LOADF;

endmodule