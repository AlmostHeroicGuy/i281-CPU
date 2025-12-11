module opcode_decoder (
    input wire [7:0] OpCode_Field, // OpCode_Field[7] = I15, OpCode_Field[0] = I8

    // 23 One-Hot OpCode Outputs
    output wire OP_NOOP,
    output wire OP_INPUTC,
    output wire OP_INPUTCF,
    output wire OP_INPUTD,
    output wire OP_INPUTDF,
    output wire OP_MOVE,
    output wire OP_LOADI_LOADP,
    output wire OP_ADD,
    output wire OP_ADDI,
    output wire OP_SUB,
    output wire OP_SUBI,
    output wire OP_LOAD,
    output wire OP_LOADF,
    output wire OP_STORE,
    output wire OP_STOREF,
    output wire OP_SHIFTL,
    output wire OP_SHIFTR,
    output wire OP_CMP,
    output wire OP_JUMP,
    output wire OP_BRE_BRZ,
    output wire OP_BRNE_BRNZ,
    output wire OP_BRG,
    output wire OP_BRGE,

    // 4 Register Select Outputs (Sub-Select)
    output wire X1, // I11 (OpCode_Field[3])
    output wire X0, // I10 (OpCode_Field[2])
    output wire Y1, // I9 (OpCode_Field[1])
    output wire Y0  // I8 (OpCode_Field[0])
);

    // Primary Decoder Select Inputs (I15:I12)
    wire [3:0] w_main_sel = OpCode_Field[7:4];
    
    // Primary Decoder Outputs (y0 through y15)
    reg [15:0] y_main;
    
    // Secondary Decoder Select Inputs
    // w1, w0 for 2-to-4 decoders (I11:I10)
    wire [1:0] w_secondary_sel = OpCode_Field[1:0]; 
    // w0 for 1-to-2 decoder (I8)
    wire w_shift_sel = OpCode_Field[0];
    
    // Secondary Decoder Outputs
    reg [3:0] y_input_group;
    reg [1:0] y_shift_group;
    reg [3:0] y_branch_group;
    
    
    // Register Select Passthrough (I11:I8)
    // Directly connects the lowest 4 bits of the 8-bit input to the register select outputs 
    assign X1 = OpCode_Field[3];
    assign X0 = OpCode_Field[2];
    assign Y1 = OpCode_Field[1];
    assign Y0 = OpCode_Field[0];


    // Main 4-to-16 Decoder Logic (Combinational)
    // Decodes the high 4 bits (I15:I12) into 16 one-hot outputs (y_main[0] through y_main[15])
    always @(w_main_sel) begin
        y_main = 16'h0000;
        case (w_main_sel)
            4'h0: y_main[0] = 1'b1;
            4'h1: y_main[1] = 1'b1;
            4'h2: y_main[2] = 1'b1;
            4'h3: y_main[3] = 1'b1;
            4'h4: y_main[4] = 1'b1;
            4'h5: y_main[5] = 1'b1;
            4'h6: y_main[6] = 1'b1;
            4'h7: y_main[7] = 1'b1;
            4'h8: y_main[8] = 1'b1;
            4'h9: y_main[9] = 1'b1;
            4'hA: y_main[10] = 1'b1;
            4'hB: y_main[11] = 1'b1;
            4'hC: y_main[12] = 1'b1;
            4'hD: y_main[13] = 1'b1;
            4'hE: y_main[14] = 1'b1;
            4'hF: y_main[15] = 1'b1;
            default: y_main = 16'h0000;
        endcase
    end
    
    // Secondary 2-to-4 Decoder (INPUTC/F/D/DF Group)
    // Enabled by y_main[1]
    always @(y_main, w_secondary_sel) begin
        y_input_group = 4'h0;
        if (y_main[1]) begin // Enabled by y_main[1]
            case (w_secondary_sel)
                2'b00: y_input_group[0] = 1'b1; // INPUTC
                2'b01: y_input_group[1] = 1'b1; // INPUTCF
                2'b10: y_input_group[2] = 1'b1; // INPUTD
                2'b11: y_input_group[3] = 1'b1; // INPUTDF
            endcase
        end
    end

    // Secondary 1-to-2 Decoder (SHIFTL/R Group)
    // Enabled by y_main[12]
    always @(y_main, w_shift_sel) begin
        y_shift_group = 2'h0;
        if (y_main[12]) begin // Enabled by y_main[12]
            case (w_shift_sel)
                1'b0: y_shift_group[0] = 1'b1; // SHIFTL
                1'b1: y_shift_group[1] = 1'b1; // SHIFTR
            endcase
        end
    end

    // Secondary 2-to-4 Decoder (BRANCH Group)
    // Enabled by y_main[14]
    always @(y_main, w_secondary_sel) begin
        y_branch_group = 4'h0;
        if (y_main[15]) begin // Enabled by y_main[14]
            case (w_secondary_sel)
                2'b00: y_branch_group[0] = 1'b1; // BRE/BRZ
                2'b01: y_branch_group[1] = 1'b1; // BRNE/BRNZ
                2'b10: y_branch_group[2] = 1'b1; // BRG
                2'b11: y_branch_group[3] = 1'b1; // BRGE
            endcase
        end
    end


    // Final 23 OpCode Assignment
    // Connects the decoder tree outputs to the 23 final one-hot outputs.
    assign OP_NOOP      = y_main[0];
    assign OP_INPUTC    = y_input_group[0];
    assign OP_INPUTCF   = y_input_group[1];
    assign OP_INPUTD    = y_input_group[2];
    assign OP_INPUTDF   = y_input_group[3];
    assign OP_MOVE      = y_main[2];
    assign OP_LOADI_LOADP = y_main[3];
    assign OP_ADD       = y_main[4];
    assign OP_ADDI      = y_main[5];
    assign OP_SUB       = y_main[6];
    assign OP_SUBI      = y_main[7];
    assign OP_LOAD      = y_main[8];
    assign OP_LOADF     = y_main[9];
    assign OP_STORE     = y_main[10];
    assign OP_STOREF    = y_main[11];
    assign OP_SHIFTL    = y_shift_group[0];
    assign OP_SHIFTR    = y_shift_group[1];
    assign OP_CMP       = y_main[13];
    assign OP_JUMP      = y_main[14];
    assign OP_BRE_BRZ   = y_branch_group[0];
    assign OP_BRNE_BRNZ = y_branch_group[1];
    assign OP_BRG       = y_branch_group[2];
    assign OP_BRGE      = y_branch_group[3];

endmodule