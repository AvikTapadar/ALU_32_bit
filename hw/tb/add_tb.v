module tb_add_32;
    reg  [31:0] a, b;
    reg         sub_in;
    wire [31:0] res;
    wire        carry, overflow;

    // Instantiate DUT (Device Under Test)
    add_32 uut (.a(a), .b(b), .sub_in(sub_in), .res(res), .carry(carry), .overflow(overflow));

    reg [32:0] ref;

    initial begin
        $dumpfile("tb_add.vcd");
        $dumpvars(0, tb_add_32);

        $display("=== Testing 32-bit Add/Sub using prefix_adder_32 ===");
        $display("Time\tSub\tA\t\tB\t\tResult\t\tExpected\tCarry\tOverflow");

        // Test both add and subtract randomly
        repeat (10) begin
            a      = $urandom;
            b      = $urandom;
            sub_in = $urandom % 2;
            #1;

            ref = sub_in ? (a - b) : (a + b);

            $display("%0t\t%b\t%h\t%h\t%h\t%h\t%b\t%b",
                     $time, sub_in, a, b, res, ref[31:0], carry, overflow);

            if (res !== ref[31:0])
                $display("Mismatch detected!");
            else
                $display("Correct result");
        end

        $display("Simulation complete!");
        $finish;
    end
endmodule