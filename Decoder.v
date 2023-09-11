//0713216

//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Luke
//----------------------------------------------
//Date:        2010/8/16
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	Compare_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	MemRead_o,
	MemWrite_o,
	MemtoReg_o,
	Flush_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;
input             Compare_i;
// input  [6-1:0] function_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;

output         MemRead_o;
output         MemWrite_o;
output         MemtoReg_o;
output         Flush_o;
// output         Jump_o;
// output        Jr_o;
 
//Internal Signals
wire    [3-1:0] ALU_op_o;
wire            ALUSrc_o;
wire            RegWrite_o;
wire            RegDst_o;
wire            Branch_o;

wire            MemRead_o;
wire            MemWrite_o;
wire            MemtoReg_o;
wire            Flush_o;
// wire            Jump_o;
// wire            Jr_o;

//opcode
//000 000 <= R-type (add, sub, and, or slt, jal)
//001 000 <= addi
//001 010 <= slti
//000 100 <= beq
//100 011 <= lw
//101 011 <= sw
//000 010 <= jump
//000 011 <= jal

//Parameter
//1: R-type;  0: oterwise
assign RegDst_o = (instr_op_i == 6'b000000) ? 1'b1 : 1'b0;                                                      

//1: R-type, addi, lw, slti;  0: beq
assign RegWrite_o = ((instr_op_i == 6'b000000) || (instr_op_i == 6'b001000) || (instr_op_i == 6'b100011)  || (instr_op_i == 6'b001010)) ? 1'b1 : 1'b0;    

//1: beq;   0: oterwise
assign Branch_o = (instr_op_i == 6'b000100) ? 1'b1 : 1'b0; 

//1: addi, slti, lw, sw;   0: otherwise
assign ALUSrc_o = (instr_op_i == 6'b001000 || instr_op_i == 6'b001010  || instr_op_i == 6'b100011 || instr_op_i == 6'b101011) ? 1'b1 : 1'b0; 
 
//1: lw;  0: otherwise
assign MemRead_o = (instr_op_i == 6'b100011) ? 1'b1 : 1'b0;

//1: sw;  0: otherwise
assign MemWrite_o = (instr_op_i == 6'b101011) ? 1'b1 : 1'b0;

//1: lw;  0: otherwise
assign MemtoReg_o = (instr_op_i == 6'b100011) ? 1'b1 : 1'b0;

//1: beq ^ compare=1;  0 : otherwise
assign Flush_o = (instr_op_i == 6'b000100 && Compare_i == 1) ? 1'b1 : 1'b0;

/*
//1: jump, jal;  0: otherwise
assign Jump_o= (instr_op_i == 6'b000010 || instr_op_i == 6'b000011) ? 1'b1 : 1'b0;

//1:Jr  0:otherwise
assign Jr_o = (instr_op_i == 6'b000000 && function_i == 6'b001000) ? 1'b1 : 1'b0;
*/

//ALU_op_o
//010 <= R-type
//000 <= addi
//011 <= slti
//001 <= beq
//100 <= lw
//101 <= sw
//110 <= jal
//111 <= otherwise (jump)

assign ALU_op_o = (instr_op_i == 6'b000000) ? 3'b010 :                                      //010 <= R-type
                                (instr_op_i == 6'b001000) ? 3'b000 :                                      //000 <= addi
								(instr_op_i == 6'b001010) ? 3'b011 :                                      //011 <= slti
								(instr_op_i == 6'b000100) ? 3'b001 :                                      //001 <= beq
								(instr_op_i == 6'b100011) ? 3'b100 :                                      //100 <= lw
								(instr_op_i == 6'b101011) ? 3'b101 : 3'b111;                          //101 <= sw 
							//	(instr_op_i == 6'b000011) ? 3'b110 : 3'b111;                           //110 <= jal    111 <= otherwise (jump)                                    

//Main function

endmodule





                    
                    