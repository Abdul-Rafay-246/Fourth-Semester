`timescale 1ns/1ps

module processor_all_tb;
    reg clk;
    reg reset;

    // Extra signals for easy viewing in GTKWave
    wire [31:0] x1;
    wire [31:0] x2;
    wire [31:0] x3;
    wire [31:0] x4;
    wire [31:0] x5;
    wire [31:0] x6;
    wire [31:0] x7;
    wire [31:0] x8;
    wire [31:0] x9;
    wire [31:0] x10;
    wire [31:0] mem0;
    wire [31:0] mem1;

    processor uut(
        .clk(clk),
        .reset(reset)
    );

    assign x1 = uut.regs[1];
    assign x2 = uut.regs[2];
    assign x3 = uut.regs[3];
    assign x4 = uut.regs[4];
    assign x5 = uut.regs[5];
    assign x6 = uut.regs[6];
    assign x7 = uut.regs[7];
    assign x8 = uut.regs[8];
    assign x9 = uut.regs[9];
    assign x10 = uut.regs[10];
    assign mem0 = uut.data_mem[0];
    assign mem1 = uut.data_mem[1];

    always #5 clk = ~clk;

    initial begin
        $dumpfile("processor_all_tb.vcd");
        $dumpvars(0, processor_all_tb);

        clk = 0;
        reset = 1;

        // Program:
        // Store two values in memory, load them back,
        // then use the loaded values for add, sub, and, or.
        uut.instr_mem[0]  = 32'h00C00093; // addi x1, x0, 12
        uut.instr_mem[1]  = 32'h00500113; // addi x2, x0, 5
        uut.instr_mem[2]  = 32'h00102023; // sw   x1, 0(x0)
        uut.instr_mem[3]  = 32'h00202223; // sw   x2, 4(x0)
        uut.instr_mem[4]  = 32'h00002183; // lw   x3, 0(x0)
        uut.instr_mem[5]  = 32'h00402203; // lw   x4, 4(x0)
        uut.instr_mem[6]  = 32'h004182B3; // add  x5, x3, x4
        uut.instr_mem[7]  = 32'h40418333; // sub  x6, x3, x4
        uut.instr_mem[8]  = 32'h0041F3B3; // and  x7, x3, x4
        uut.instr_mem[9]  = 32'h0041E433; // or   x8, x3, x4
        uut.instr_mem[10] = 32'h00528463; // beq  x5, x5, 8
        // uut.instr_mem[11] = 32'h06300493; // addi x9, x0, 99 (should skip)
        uut.instr_mem[12] = 32'h00100513; // addi x10, x0, 1

        #12;
        reset = 0;

        #180;

        $display("x1 = %0d", uut.regs[1]);
        $display("x2 = %0d", uut.regs[2]);
        $display("x3 = %0d", uut.regs[3]);
        $display("x4 = %0d", uut.regs[4]);
        $display("x5 = %0d", uut.regs[5]);
        $display("x6 = %0d", uut.regs[6]);
        $display("x7 = %0d", uut.regs[7]);
        $display("x8 = %0d", uut.regs[8]);
        $display("x9 = %0d", uut.regs[9]);
        $display("x10 = %0d", uut.regs[10]);
        $display("memory[0] = %0d", uut.data_mem[0]);
        $display("memory[1] = %0d", uut.data_mem[1]);

        if (uut.regs[1] == 12 &&
            uut.regs[2] == 5 &&
            uut.regs[3] == 12 &&
            uut.regs[4] == 5 &&
            uut.regs[5] == 17 &&
            uut.regs[6] == 7 &&
            uut.regs[7] == 4 &&
            uut.regs[8] == 13 &&
            uut.regs[9] == 0 &&
            uut.regs[10] == 1 &&
            uut.data_mem[0] == 12 &&
            uut.data_mem[1] == 5)
            $display("ALL INSTRUCTIONS TEST PASSED");
        else
            $display("ALL INSTRUCTIONS TEST FAILED");

        $finish;
    end
endmodule
