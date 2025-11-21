module alu_32 #(
    parameter w = 32
) (
    input [w-1:0] a,b,
    input [3:0] alu_ctrl,
    output cout, neg, overflow, zero,
    output reg [w-1 : 0]res
);
    wire [w-1:0] add_res;
    wire add_overflow;
    add_32 ins(.a(a), .b(b), .sub_in(alu_ctrl[0]), .res(add_res), .carry(cout), .overflow(add_overflow));

    assign overflow = (alu_ctrl <= 4'd1) ? add_overflow : 0; //this is to check the overflow from shift operations. Make them zero for shift operations

    always @(*) begin
        case(alu_ctrl)
            4'b0000 : res = add_res; //lsb got to be 0 to add 
            4'b0001 : res = add_res; //got to be 1 to sub
            4'd2 : res = a&b; //AND
            4'd3 : res = a|b; //OR
            4'd4 : res = a^b; //XOR
            4'd5 : res = a~^b; //XNOR;
            4'd6 : res = ~(a|b); //NOR
            4'd7 : res = ~(a&b); //NAND
            4'd8 : res = a << b[4:0]; //shift logical left
            4'd9 : res = a >> b[4:0]; //shift logical right
            4'd10 : res = $signed(a) >>> b[4:0]; //arithmetic right shift 
            4'd11 : res = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; //Set less than (SLT)
            4'd12 : res = (a<b) ? 32'd1 : 32'd0; //unsigned Set less than (SLTU)
            4'd13 : res = (a == b) ? 32'd1 : 32'd0; //Set equal 
            4'd14 : res = (a != b) ? 32'd1 : 32'd0; //set not equal
            default : res = 0;
        endcase
    end

    assign zero = (res == 32'd0);
    assign neg = (res[w-1]); //signed bit : 1 if result is negative
    
endmodule

