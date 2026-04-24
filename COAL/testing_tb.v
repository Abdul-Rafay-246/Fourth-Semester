`timescale 1ns/1ps

module hello_tb;

    reg A;
    wire B;

    // Instantiate the module
    hello uut (
        .A(A),
        .B(B)
    );

    initial begin
        $dumpfile("testing_tb.vcd");
        $dumpvars(0, hello_tb);

        $display("Time\tA\tB");
        $monitor("%0t\t%b\t%b", $time, A, B);

        // Test cases
        A = 0; #10;
        A = 1; #10;
        A = 0; #10;
        A = 1; #10;

        $finish;
    end

endmodule
