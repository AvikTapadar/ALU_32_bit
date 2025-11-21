module add_32 #(parameter w = 32)(
    input [w-1 : 0] a, b,
    input sub_in,
    output [w-1 : 0] res,
    output carry, overflow
);
    wire [w-1 : 0] b_bar = sub_in ? ~b : b; 
    wire cin = sub_in; //using sub_in as cin value cause if we add then sub_in = 0 or else sub_in = 1 as carry in should be.

    assign overflow = (a[w-1] ^ b[w-1] ^ sub_in) & (res[w-1] ^ a[w-1]); //for overflow condition I got to have sign of a=~b and also sign of res != a 

    prefix_adder_32 add_sub(.a(a), .b(b_bar), .cin(cin), .sum(res), .cout(carry));

endmodule
