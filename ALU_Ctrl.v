//0713216

//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
wire       [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation

//function field
//100 000 <= add
//100 010 <= sub
//100 100 <= and
//100 101 <= or
//101 010 <= slt
//011 000 <= jr
//110 000 <= mult

//ALU_op_o
//010 <= R-type
//000 <= addi
//011 <= slti
//001 <= beq
//100 <= lw
//101 <= sw
//110 <= jal
//111 <= otherwise (jump, jal)

assign ALUCtrl_o = (ALUOp_i == 3'b010 && funct_i == 6'b100000) ? 4'b0010 :                            //add = 2
                                (ALUOp_i == 3'b010 && funct_i == 6'b100010) ? 4'b0110 :                            //sub = 6
                                (ALUOp_i == 3'b010 && funct_i == 6'b100100) ? 4'b0000 :                            //and = 0
                                (ALUOp_i == 3'b010 && funct_i == 6'b100101) ? 4'b0001 :                            //or = 1
                                (ALUOp_i == 3'b010 && funct_i == 6'b101010) ? 4'b0111 :                             //slt = 7    
                                (ALUOp_i == 3'b010 && funct_i == 6'b011000) ? 4'b1100 :                             //mult = 12
                                (ALUOp_i == 3'b000) ? 4'b1000 :                                                                     //addi = 8
                                (ALUOp_i == 3'b011) ? 4'b0101 :                                                                      //slti = 5
                                (ALUOp_i == 3'b001) ? 4'b1010 :                                                                      //beq = 10
                    //          (ALUOp_i == 3'b110) ? 4'b0011 :                                                                       //jal = 3
                                ((ALUOp_i == 3'b100) || (ALUOp_i == 3'b101)) ? 4'b0010 : 4'b1111;                //lw = sw = add = 2

endmodule     





                    
                    