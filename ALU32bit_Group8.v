/*------------------------------------------------------------------------------*
 * 	Group members:																*
 *  ---------------																*
 * 	E/12/190																	*
 *	E/12/193																	*
 *	E/12/206																	*
/*------------------------------------------------------------------------------*/

// 1 bit logical unit for AND and OR

module AND_OR_1bit(Out, A, B, Operation);
   
	input [1:0] Operation;
	input  A, B;
	output Out;

	assign Out = Operation? A|B : A&B;
endmodule
     
// 1 bit logical unit for AND and OR
module ADDER_1bit(OUT, COUT, A, B, CIN);
   
	output OUT, COUT;
	input  A, B, CIN;
	wire w1,w2,w3;

	and (w1, CIN, A);
	and (w2, CIN, B);
	and (w3, A, B);

	or (COUT, w1,w2,w3);
	xor (OUT, A, B);
endmodule

     
// inverter
module Inverter(Out, Input, Invert);
	input Input, Invert;
	output Out;

	assign Out = Invert ? ~Input : Input;
endmodule


// 1 bit ALU
module ALU_1bit(Result, CarryOut, a, b, aInvert, bInvert, CarryIn, Operation);

	input a, b, aInvert, bInvert, CarryIn;
	input [1:0] Operation;
	output Result, CarryOut;
	wire wa, wb, wAnd, wOr, wAdder;
	wire outA, outB;

	Inverter invA(wa, a, aInvert);
	Inverter invB(wb, b, bInvert);
	AND_OR_1bit andor1bit(outA,wa,wb, Operation);
	ADDER_1bit adder1bit(outB, CarryOut, wa, wb, CarryIn);

	assign Result = Operation<2?outA:outB;

endmodule


// 32-bit ALU
module TheALU (Result, CarryOut, a, b, aInvert, bInvert, CarryIn, Operation);
	input [31:0] a,b;
	input [1:0] Operation;
	input aInvert, bInvert, CarryIn;
	output [31:0] Result;
	output CarryOut;

	genvar i;
    generate
		for( i = 0; i <= 31; i = i +1 )
			ALU_1bit onebitAlu(Result[i], CarryOut, a[i], b[i], aInvert, bInvert, CarryIn, Operation);
    endgenerate

endmodule


// Test beds
module stimulus;
	wire[31:0] Result;
	wire CarryOut;
	reg [31:0] a,b;
	reg [1:0] Operation;
	reg aInvert, bInvert, CarryIn;

	TheALU theALU(Result, CarryOut, a, b, aInvert, bInvert, CarryIn, Operation); 

	initial
	begin
		#0 a = 0;
		#0 b = 1;
		#0 aInvert = 0;
		#0 bInvert = 0;
		#0 CarryIn = 0;
		#0 Operation = 0;
		#1 $display("At %2t, a=%0d b=%0d Operation=%d\tResult: %0d" ,$time,a,b,Operation, Result);
		#0 aInvert = 1;
		#1 $display("At %2t, a=%0d b=%0d Operation=%d\tResult: %0d" ,$time,a,b,Operation, Result);
		#0 aInvert = 0;
		#5 Operation = 1;
		#1 $display("At %2t, a=%0d b=%0d Operation=%d\tResult: %0d" ,$time,a,b,Operation, Result);
		#5 Operation = 2;
		#1 $display("At %2t, a=%0d b=%0d Operation=%d\tResult: %0d" ,$time,a,b,Operation, Result);

		#0 a = 20;
		#0 b = 10;
		#1 $display("At %2t, a=%0d b=%0d Operation=%d\tResult: %0d" ,$time,a,b,Operation, Result);
		#20 $finish;
	end

	// initial
	// $monitor("%2t, Result = %d",$time, Result);
	// 

endmodule