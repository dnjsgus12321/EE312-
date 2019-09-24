`timescale 1ns / 100ps

module ALU(A,B,OP,C,Cout);

	input [15:0]A;
	input [15:0]B;
	input [3:0]OP;
	output [15:0]C;
	output Cout;
	

	//TODO
	reg [15:0] C;  //Declaring output as a register
	reg Cout;     //Declaring overflow flag as a register
	wire [14:0] A_15, B_15; //Truncated 15-bit version of A, B
	assign A_15 = A[14:0];
	assign B_15 = B[14:0];
	reg [16:0] big_outcome; //17-bit outcome of the operation between A,B
	reg [15:0] small_outcome; //16-bit outcome of the operation between
				  //A_15, B_15
	reg C_in, C_out; //Carry_in, Carry_out

	//The operations.
	//Arithmetic Overflow happens when C_in != C_out
	always@(*)
	begin
		Cout = 0;
		case(OP)
		4'b0000:  //16-bit addition
		begin
			C = A + B;
			big_outcome = {1'b0,A} + {1'b0,B};
			small_outcome = {1'b0,A_15} + {1'b0,B_15};
			C_out = big_outcome[16];
			C_in = small_outcome[15];
			Cout = C_in + C_out; 
		end
		4'b0001:  //16-bit subtraction
		begin
			C = A - B;
			big_outcome = {1'b0,A} - {1'b0,B};
			small_outcome = {1'b0,A_15} - {1'b0,B_15};
			C_out = big_outcome[16];
			C_in = small_outcome[15];
			Cout = C_in + C_out;
		end
		4'b0010:  //16-bit and
			C = A & B;
		4'b0011:  //16-bit or
			C = A | B;
		4'b0100:  //16-bit nand
			C = ~(A & B);
		4'b0101:  //16-bit nor
			C = ~(A | B);
		4'b0110:  //16-bit xor
			C = A ^ B;
		4'b0111:  //16-bit xnor
			C = ~(A ^ B);
		4'b1000:  //Identity
			C = A;
		4'b1001:  //16-bit not
			C = ~A;
		4'b1010:  //Logical right shift
			C = A >> 1;
		4'b1011:  //Arithmetic right shift
		begin
			C = A >>> 1;
			C[15] = C[14]; //The sign bit should be preserved
		end
		4'b1100:  //Rotate right
			C = {A[0],A[15:1]};
		4'b1101:  //Logical left shift
			C = A << 1;			
		4'b1110:  //Arithmetic left shift
			C = A <<< 1;
		4'b1111:  //Rotate left
			C = {A[14:0],A[15]};	
		endcase

	end

endmodule
