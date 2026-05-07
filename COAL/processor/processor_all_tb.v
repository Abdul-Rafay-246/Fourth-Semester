`timescale 1ns/1ps

module processor_all_tb;
    reg clk;
    reg reset;

    processor uut(
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("processor_all_tb.vcd");
        $dumpvars(0, processor_all_tb);

        clk = 0;
        reset = 1;

        // Program to test all supported instructions:
        // addi, add, sub, and, or, sw, lw, beq
        uut.instr_mem[0]  = 32'h00C00093; // addi x1, x0, 12
        uut.instr_mem[1]  = 32'h00500113; // addi x2, x0, 5
        uut.instr_mem[2]  = 32'h002081B3; // add  x3, x1, x2
        uut.instr_mem[3]  = 32'h40208233; // sub  x4, x1, x2
        uut.instr_mem[4]  = 32'h0020F2B3; // and  x5, x1, x2
        uut.instr_mem[5]  = 32'h0020E333; // or   x6, x1, x2
        uut.instr_mem[6]  = 32'h00302023; // sw   x3, 0(x0)
        uut.instr_mem[7]  = 32'h00002383; // lw   x7, 0(x0)
        uut.instr_mem[8]  = 32'h00338463; // beq  x7, x3, 8
        uut.instr_mem[9]  = 32'h06300413; // addi x8, x0, 99 (should skip)
        uut.instr_mem[10] = 32'h00100493; // addi x9, x0, 1

        #12;
        reset = 0;

        #140;

        $display("x1 = %0d", uut.regs[1]);
        $display("x2 = %0d", uut.regs[2]);
        $display("x3 = %0d", uut.regs[3]);
        $display("x4 = %0d", uut.regs[4]);
        $display("x5 = %0d", uut.regs[5]);
        $display("x6 = %0d", uut.regs[6]);
        $display("x7 = %0d", uut.regs[7]);
        $display("x8 = %0d", uut.regs[8]);
        $display("x9 = %0d", uut.regs[9]);
        $display("memory[0] = %0d", uut.data_mem[0]);

        if (uut.regs[1] == 12 &&
            uut.regs[2] == 5 &&
            uut.regs[3] == 17 &&
            uut.regs[4] == 7 &&
            uut.regs[5] == 4 &&
            uut.regs[6] == 13 &&
            uut.regs[7] == 17 &&
            uut.regs[8] == 0 &&
            uut.regs[9] == 1 &&
            uut.data_mem[0] == 17)
            $display("ALL INSTRUCTIONS TEST PASSED");
        else
            $display("ALL INSTRUCTIONS TEST FAILED");

        $finish;
    end
endmodule
