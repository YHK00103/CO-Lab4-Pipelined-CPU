//0713216

`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
    rst_i
    );
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/
/**** IF stage ****/
wire  [31:0] MUX1_out;
wire  [31:0] PC_out;
wire  [63:0] IF_ID_in;

/**** ID stage ****/
wire [63:0]   IF_ID_out;
wire [116:0] ID_EX_in;
wire [31:0]   MUX2_out;
wire [31:0]   MUX3_out;
wire [31:0]   shifter_out;
wire [31:0]   Adder2_out;

//control signal


/**** EX stage ****/
wire [116:0] ID_EX_out;
wire [74:0] EX_MEM_in;
wire [31:0]   MUX4_out;


//control signal
wire [3:0]  ALU_control_output;
wire          Compare;


/**** MEM stage ****/
wire [74:0] EX_MEM_out;
wire [70:0] MEM_WB_in;


//control signal


/**** WB stage ****/
wire [70:0] MEM_WB_out;
wire [31:0] MUX6_out;


//control signal


/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux1(
	    .data0_i(IF_ID_in[63:32]),
        .data1_i(Adder2_out),
        .select_i(ID_EX_in[114] & Compare),
        .data_o(MUX1_out)
);

ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(MUX1_out), 
	    .pc_out_o(PC_out)
);

Instruction_Memory IM(
		.addr_i(PC_out),  
	    .instr_o(IF_ID_in[31:0])    
);
			
Adder Add_pc(               //Adder1
		.src1_i(32'd4),     
	    .src2_i(PC_out),     
	    .sum_o(IF_ID_in[63:32]) 
);

		
Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
	  .clk_i(clk_i),
      .rst_i(rst_i),
      .data_i(IF_ID_in),
      .data_o(IF_ID_out)
);



//Instantiate the components in ID stage
MUX_2to1 #(.size(32)) Mux2(
	    .data0_i(IF_ID_out[63:32]),
        .data1_i(32'd0),
        .select_i(ID_EX_out[106]),
        .data_o(MUX2_out)
);

MUX_2to1 #(.size(32)) Mux3(
	    .data0_i(IF_ID_out[31:0]),
        .data1_i(32'd0),
        .select_i(ID_EX_out[106]),
        .data_o(MUX3_out)
);

Adder Adder2(               
		.src1_i(MUX2_out),     
	    .src2_i(shifter_out),     
	    .sum_o(Adder2_out) 
);

Shift_Left_Two_32 Shifter(
        .data_i(ID_EX_in[41:10]),
        .data_o(shifter_out)
);

Reg_File RF(
		.clk_i(clk_i),      
	    .rst_i(rst_i) , 
        .RSaddr_i(MUX3_out[25:21]) ,  
        .RTaddr_i(MUX3_out[20:16]) ,  
        .RDaddr_i(MEM_WB_out[4:0]) ,  
        .RDdata_i(MUX6_out)  , 
        .RegWrite_i (MEM_WB_out[70]),
        .RSdata_o(ID_EX_in[105:74]) ,  
        .RTdata_o(ID_EX_in[73:42])  
);

Comparator Com(
        .src1_i(ID_EX_in[105:74]),
	    .src2_i(ID_EX_in[73:42]),
	    .compare_o(Compare)
);

Decoder Control(
        .instr_op_i(IF_ID_out[31:26]), 
        .Compare_i(Compare),
       
        .RegWrite_o(ID_EX_in[116]),
        .MemtoReg_o(ID_EX_in[115]),
        
        .Branch_o(ID_EX_in[114]),
        .MemRead_o(ID_EX_in[113]),
        .MemWrite_o(ID_EX_in[112]),
         
	    .RegDst_o(ID_EX_in[111]),
        .ALU_op_o(ID_EX_in[110:108]),
        .ALUSrc_o(ID_EX_in[107]), 
        .Flush_o(ID_EX_in[106])
);

Sign_Extend Sign_Extend(
         .data_i(MUX3_out[15:0]),
        .data_o(ID_EX_in[41:10])
);	

assign ID_EX_in[9:5] = MUX3_out[20:16];
assign ID_EX_in[4:0] = MUX3_out[15:11];

Pipe_Reg #(.size(117)) ID_EX(
      .clk_i(clk_i),
      .rst_i(rst_i),
      .data_i(ID_EX_in),
      .data_o(ID_EX_out)
);


//Instantiate the components in EX stage	   
ALU ALU(
        .src1_i(ID_EX_out[105:74]),
        .src2_i(MUX4_out),
        .ctrl_i(ALU_control_output),
        .result_o(EX_MEM_in[68:37]),
        .zero_o(EX_MEM_in[69])
);
		
ALU_Ctrl ALU_Control(
        .funct_i(ID_EX_out[15:10]),   
        .ALUOp_i(ID_EX_out[110:108]),   
        .ALUCtrl_o(ALU_control_output) 
);

MUX_2to1 #(.size(32)) Mux4(
        .data0_i(ID_EX_out[73:42]),
        .data1_i(ID_EX_out[41:10]),
        .select_i(ID_EX_out[107]),
        .data_o(MUX4_out)
);
		
MUX_2to1 #(.size(5)) Mux5(
        .data0_i(ID_EX_out[9:5]),
        .data1_i(ID_EX_out[4:0]),
        .select_i(ID_EX_out[111]),
        .data_o(EX_MEM_in[4:0])
);

assign EX_MEM_in[74:70] = ID_EX_out[116:112];
assign EX_MEM_in[36:5] = ID_EX_out[73:42];

Pipe_Reg #(.size(75)) EX_MEM(
      .clk_i(clk_i),
      .rst_i(rst_i),
      .data_i(EX_MEM_in),
      .data_o(EX_MEM_out)
);


//Instantiate the components in MEM stage
Data_Memory DM(
         .clk_i(clk_i), 
        .addr_i(EX_MEM_out[68:37]),
        .data_i(EX_MEM_out[36:5]),
        .MemRead_i(EX_MEM_out[71]),
        .MemWrite_i(EX_MEM_out[70]),
        .data_o(MEM_WB_in[68:37])
);

assign MEM_WB_in[70:69] = EX_MEM_out[74:73];
assign MEM_WB_in[36:5] = EX_MEM_out[68:37];
assign MEM_WB_in[4:0] = EX_MEM_out[4:0];

Pipe_Reg #(.size(71)) MEM_WB(
      .clk_i(clk_i),
      .rst_i(rst_i),
      .data_i(MEM_WB_in),
      .data_o(MEM_WB_out)
);


//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux6(
        .data0_i(MEM_WB_out[36:5]),
        .data1_i(MEM_WB_out[68:37]),
        .select_i(MEM_WB_out[69]),
        .data_o(MUX6_out)
);

/****************************************
signal assignment
****************************************/

endmodule

