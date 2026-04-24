`timescale 1ns/1ps

module processor_tb;
    reg clk;
    reg reset;

    processor uut(
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("processor_tb.vcd");
        $dumpvars(0, processor_tb);

        clk = 0;
        reset = 1;

        // Program:
        // x1 = 5
        // x2 = 10
        // x3 = x1 + x2 = 15
        // memory[0] = x3
        // x4 = memory[0] = 15
        // if x4 == x3, skip next instruction
        // x5 = 99  (should be skipped)
        // x6 = 7
        uut.instr_mem[0] = 32'h00500093; // addi x1, x0, 5
        uut.instr_mem[1] = 32'h00A00113; // addi x2, x0, 10
        uut.instr_mem[2] = 32'h002081B3; // add  x3, x1, x2
        uut.instr_mem[3] = 32'h00302023; // sw   x3, 0(x0)
        uut.instr_mem[4] = 32'h00002203; // lw   x4, 0(x0)
        uut.instr_mem[5] = 32'h00320463; // beq  x4, x3, 8
        uut.instr_mem[6] = 32'h06300293; // addi x5, x0, 99
        uut.instr_mem[7] = 32'h00700313; // addi x6, x0, 7

        #12;
        reset = 0;

        #100;

        $display("x1 = %0d", uut.regs[1]);
        $display("x2 = %0d", uut.regs[2]);
        $display("x3 = %0d", uut.regs[3]);
        $display("x4 = %0d", uut.regs[4]);
        $display("x5 = %0d", uut.regs[5]);
        $display("x6 = %0d", uut.regs[6]);
        $display("memory[0] = %0d", uut.data_mem[0]);

        if (uut.regs[3] == 15 &&
            uut.regs[4] == 15 &&
            uut.regs[5] == 0 &&
            uut.regs[6] == 7 &&
            uut.data_mem[0] == 15)
            $display("TEST PASSED");
        else
            $display("TEST FAILED");

        $finish;
    end
endmodule
