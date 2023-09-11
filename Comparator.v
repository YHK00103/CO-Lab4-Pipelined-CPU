//0713216

module Comparator(
    src1_i,
	src2_i,
	compare_o
	);
     
//I/O ports
input  [32-1:0]   src1_i;
input  [32-1:0]	 src2_i;
output          	 compare_o;

//Internal Signals
wire    	 compare_o;

//Parameter
    
//Main function
 assign compare_o = (src1_i == src2_i) ? 1'b1 : 1'b0;

endmodule





                    
                    