module alu_ctrl_32 (
    input [1:0] aluop,
    input [2:0] func3, 
    input [6:0] func7,
    output reg [3:0] alu_ctrl
);

    always @(*) begin
        alu_ctrl = 4'd0; 

        case(aluop)
            2'b00 : alu_ctrl = 4'd0; // LOAD / STORE (ADD)
            2'b01 : begin // BRANCH INSTRUCTIONS
                case(func3)
                    3'b000: alu_ctrl = 4'd13; // BEQ
                    3'b001: alu_ctrl = 4'd14; // BNEQ
                    3'b100: alu_ctrl = 4'd11; // BLT
                    3'b101: alu_ctrl = 4'd12; // BGE
                    3'b110: alu_ctrl = 4'd12; // BLTU 
                    3'b111: alu_ctrl = 4'd12; // BGEU 
                    default: alu_ctrl = 4'd0;
                endcase
            end
            2'b10 : begin // R-TYPE INSTRUCTIONS
                case(func3)
                    3'b000: alu_ctrl = (func7[5]) ? 4'd1 : 4'd0; // SUB : ADD
                    3'b111: alu_ctrl = 4'd2; // AND
                    3'b110: alu_ctrl = 4'd3; // OR
                    3'b100: alu_ctrl = 4'd4; // XOR
                    3'b001: alu_ctrl = 4'd8; // SLL
                    3'b101: alu_ctrl = (func7[5]) ? 4'd10 : 4'd9; // SRA : SRL
                    3'b010: alu_ctrl = 4'd11; // SLT
                    3'b011: alu_ctrl = 4'd12; // SLTU
                    default: alu_ctrl = 4'd0;
                endcase
            end
            default: alu_ctrl = 4'd0;
        endcase
    end
    
endmodule