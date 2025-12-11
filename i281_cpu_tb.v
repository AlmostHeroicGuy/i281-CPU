`timescale 1ns / 1ps

module i281_cpu_tb;

    // TB Signals
    reg clk;
    reg reset;
    reg [15:0] Switches;

    // Simulation Parameters
    parameter CLK_PERIOD = 10;

    // Clock Generation
    initial begin
        clk = 1'b0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Instantiate DUT
    i281_cpu DUT (
        .Clock(clk),      
        .Reset(reset),
        .Switches(Switches)
    );

    // Simulation Execution
    initial begin
        // Initialize simulation environment
        $display("Starting i281 CPU Bubble Sort Testbench");
        $dumpfile("i281_cpu.vcd");         // VCD filename
        $dumpvars(0, i281_cpu_tb);         // Dump all signals in this testbench

        // 1. System Initialization
        reset    = 1'b1;
        Switches = 16'h0000;               // Can preload switches if needed

        # (CLK_PERIOD * 2);                // Keep reset high for 2 cycles

        // 2. Deassert Reset (Start Execution)
        reset = 1'b0;
        $display("\n Reset Deasserted. Program starts");

        // 3. Run CPU for 1500 cycles
        repeat (1500) @(posedge clk);

        // 4. Verification — PRINT DMEM
        #1;  // allow registers to settle

        DUT.dmem.print_dmem_contents();

        # (CLK_PERIOD);
        $display("\n Simulation Complete");
        $finish;
    end

endmodule