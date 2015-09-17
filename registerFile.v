module registerfile (Read1,Read2,WriteReg,WriteData,RegWrite,Data1,Data2,clock);
	input [5:0] Read1,Read2,WriteReg;
	input [31:0] WriteData;
	input RegWrite,	clock;
	output [31:0] Data1, Data2; 
	reg [31:0] RF [31:0];
	assign Data1 = RF[Read1];
	assign Data2 = RF[Read2];
	always begin
	@(posedge clock) 
		if (RegWrite) RF[WriteReg] <=	WriteData;
	end
endmodule

module stimulus;
	reg [5:0] Read1,Read2,WriteReg;
	reg [31:0] WriteData;
	reg RegWrite,	clock; 
	output [31:0] Data1, Data2; 
	reg [31:0] RF [31:0];

	registerfile file(Read1,Read2,WriteReg,WriteData,RegWrite,Data1,Data2,clock);

	always
	begin
		#1 clock = 1; 
		#0	$display("%5d %5d %8d %9d %8d %5d %5d %5d", Read1,Read2,WriteReg,WriteData,RegWrite,Data1,Data2,clock);
		#1 clock = 0;
		#0	$display("%5d %5d %8d %9d %8d %5d %5d %5d", Read1,Read2,WriteReg,WriteData,RegWrite,Data1,Data2,clock);
	end

	initial
	begin
		/////////////////////////////////////////
		#0 	Read1 = 0;
		#0	Read2 = 1;
		#0	WriteReg = 1;
		#0	WriteData = 12;
		#0	RegWrite = 1;
		
		/////////////////////////////////////////
		#2 	Read1 = 1;
		#0	Read2 = 0;
		#0	WriteReg = 0;
		#0	WriteData = 123;
		#0	RegWrite = 1;
		/////////////////////////////////////////
		#2 	Read1 = 0;
		#0	Read2 = 1;
		#0	WriteReg = 0;
		#0	WriteData = 256;
		#0	RegWrite = 1;
		/////////////////////////////////////////
		#2 	Read1 = 1;
		#0	Read2 = 0;
		#0	WriteReg = 0;
		#0	WriteData = 123;
		#0	RegWrite = 1;
		#2 	$finish;
	end

	initial
		#0	$display("Read1 Read2 WriteReg WriteData RegWrite Data1 Data2 clock");
	// $monitor("%2t, Result = %d",$time, Result);


endmodule