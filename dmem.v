module dmem (
    input  wire        Clock,          
    // Asynchronous Read Port
    input  wire [3:0]  ReadSelect,     // 4-bit read address
    output wire [7:0]  DataOut,        // 8-bit output

    // Synchronous Write Port
    input  wire        WriteEn,        // Write enable
    input  wire [3:0]  WriteSelect,    // 4-bit write address
    input  wire [7:0]  DataIn          // 8-bit data to write
);
    
    reg [7:0] memory [0:15];

    // Load from external file
    initial begin
        $readmemh("dmem.mem", memory);   // HEX format
        // OR use $readmemb("dmem.mem", memory); for BINARY format
    end

    // Asynchronous Read
    assign DataOut = memory[ReadSelect];

    // Synchronous Write
    always @(posedge Clock) begin
        if (WriteEn) begin
            memory[WriteSelect] <= DataIn;
        end
    end

    // Debug print task
    task print_dmem_contents;
        integer i;
        begin
            $display("\n=======================================================");
            $display("--- Final Data Memory Contents ---");
            $display("=======================================================");
            $display(" Addr | Data (Binary) | Data (Dec) | Data (Hex)");
            
            for (i = 0; i <= 15; i = i + 1) begin
                $display(" 0x%0h | %b | %0d | 0x%0h", 
                    i, memory[i], memory[i], memory[i]);
            end
            $display("=======================================================");
        end
    endtask
endmodule
