module prefix_adder_32 #( //Time delay for this one is (t = O(2log(n)-1))
    parameter w = 32 )(
    input [w-1: 0] a, b, 
    input cin,
    output [w-1 : 0] sum,
    output cout
);
    wire [w-1: 0] g, p;
    assign g = a&b; //generate 
    assign p = a^b; //propogate

    wire [w:0] c; //carry
    assign c[0] = cin; 

    //Black-cell implementation for 32-bit in 5 stages
    wire [w-1:0] g1,p1,g2,p2,g3,p3,g4,p4,g5,p5;
    genvar i;
    generate 
        //stage 1
        for(i = 1; i<w; i=i+2) begin
            black_cell ins1(g[i], p[i], g[i-1], p[i-1], g1[i], p1[i]);
        end
        //stage 2
        for(i = 3; i<w; i=i+4) begin
            black_cell ins2(g1[i], p1[i], g1[i-2], p1[i-2], g2[i], p2[i]);
        end
        //stage 3
        for(i = 7; i<w; i=i+8) begin
            black_cell ins3(g2[i], p2[i], g2[i-4], p2[i-4], g3[i], p3[i]);
        end
        //stage 4
        for(i = 15; i<w; i=i+16)begin
            black_cell ins4(g3[i], p3[i], g3[i-8], p3[i-8], g4[i], p4[i]);
        end
        //stage 5 
        for(i = 31; i<w; i=i+32)begin
            black_cell ins5(g4[i], p4[i], g4[i-16], p4[i-16], g5[i], p5[i]);
        end
    endgenerate

    //grey-cell implementation in 6 stages for 32-bit for essential cells
    grey_cell gc1(g[0], p[0], c[0], c[1]); //stage 1 for 0 bit
    grey_cell gc2(g1[1], p1[1], c[0], c[2]); //stage 2 for 2 bit
    grey_cell gc3(g2[3], p2[3], c[0], c[4]); //stage 3 for 4 bit
    grey_cell gc4(g3[7], p3[7], c[0], c[8]); //stage 4 for 8 bit
    grey_cell gc5(g4[15], p4[15], c[0], c[16]); //stage 5 for 16 bit
    grey_cell gc6(g5[31], p5[31], c[0], c[32]); //stage 6 for 32 bit

    //non-essential carry cells implementation derived from the previous carry
    genvar j;
    generate
        for(j = 1; j<w; j=j+1) begin//for c[3]
            if((j!=1) && (j!=3) && (j!=7) && (j!=15) && (j!=31))
                grey_cell gc7(g[j], p[j], c[j], c[j+1]);
        end
    endgenerate

    assign sum = p ^ c[w-1 : 0];
    assign cout = c[w];
endmodule

/*Implementation of Brent kung architecture for prefix-adder because this has less wiring congestion and is easy to synthesis.
compared to other architecture as they have high wiring but the performance is great as well on other architecture. 
other architectures such as kogge-stone or Han-Carlson. Other models are fan-out heavy models comapred to this one*/

module black_cell ( //also known as reduction block
    input g2, p2, g1, p1,
    output g_out, p_out
);
    assign g_out = g2 | (p2 & g1);
    assign p_out = p2 & p1;
    
endmodule

module grey_cell ( //also known as expansion block
    input g2, p2, g1,
    output g_out
);
    assign g_out = g2 | (p2 & g1);
    
endmodule

