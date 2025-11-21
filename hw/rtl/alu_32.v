module alu_32 #(
    parameter w = 32
) (
    input [w-1:0] a,b,
    input [3:0] alu_ctrl,
    output cout, neg, overflow, zero,
    output reg [w-1 : 0] res
);
    wire [w-1:0] add_res;
    wire add_overflow;
    wire sub_mode;

    assign sub_mode = alu_ctrl[0] | (alu_ctrl == 4'd11) | (alu_ctrl == 4'd12);

    add_32 ins(.a(a), .b(b), .sub_in(sub_mode), .res(add_res), .carry(cout), .overflow(add_overflow));

    assign overflow = (alu_ctrl <= 4'd1) ? add_overflow : 1'b0; 

    always @(*) begin
        case(alu_ctrl)
            4'b0000 : res = add_res; // ADD
            4'b0001 : res = add_res; // SUB
            4'd2 : res = a & b; //AND
            4'd3 : res = a | b; // OR
            4'd4 : res = a ^ b; //XOR
            4'd5 : res = a ~^ b; //XNOR
            4'd6 : res = ~(a | b); //NOR
            4'd7 : res = ~(a & b); //NAND
            4'd8 : res = a << b[4:0]; // SLL
            4'd9 : res = a >> b[4:0]; //SRL
            4'd10 : res = $signed(a) >>> b[4:0]; //SRA
            4'd11 : res = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0; //SLT
            4'd12 : res = (a < b) ? 32'd1 : 32'd0; //SLTU
            4'd13 : res = (a == b) ? 32'd1 : 32'd0; //BEQ
            4'd14 : res = (a != b) ? 32'd1 : 32'd0; //BNEQ
            default : res = 32'bx; //EASIER FOR SYNTHESIS
        endcase
    end

    assign zero = (res == 32'd0);
    assign neg = (res[w-1]); 
    
endmodule

