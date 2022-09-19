`define ADD_B 8'b00000000
`define ADD_C 8'b00000001
`define ADD_M 8'b00000010
`define SUB_B 8'b00000011
`define SUB_C 8'b00000100
`define SUB_M 8'b00000101
`define OR_B 8'b00000110
`define OR_C 8'b00000111
`define OR_M 8'b00001000
`define AND_B 8'b00001001
`define AND_C 8'b00001010
`define AND_M 8'b00001011
`define XOR_B 8'b00001100
`define XOR_C 8'b00001101
`define XOR_M 8'b00001110
`define JMP 8'b00001111
`define JMP_C 8'b00010000
`define JMP_P 8'b00010001
`define JMP_S 8'b00010010
`define JMP_Z 8'b00010011
`define CALL 8'b00010100
`define CALL_C 8'b00010101
`define CALL_P 8'b00010110
`define CALL_S 8'b00010111
`define CALL_Z 8'b00011000
`define RET 8'b00011001
`define RL 8'b00011010
`define RR 8'b00011011
`define OUT 8'b00011100
`define INC_A 8'b00011101
`define INC_B 8'b00011110
`define INC_C 8'b00011111
`define DRC_A 8'b00100000
`define DRC_B 8'b00100001
`define DRC_C 8'b00100010
`define CLR_A 8'b00100011
`define CLR_B 8'b00100100
`define CLR_C 8'b00100101
`define CPL_A 8'b00100110
`define CPL_B 8'b00100111
`define CPL_C 8'b00101000
`define ADI 8'b00101011
`define SBI 8'b00101100
`define ORI 8'b00101101
`define ANI 8'b00101110
`define XRI 8'b00101111
`define MOV_AB 8'b00110000
`define MOV_BC 8'b00110001
`define MOV_CB 8'b00110010
`define MOV_AC 8'b00110011
`define MVI_A 8'b00110100
`define MVI_B 8'b00110101
`define MVI_C 8'b00110110
`define PUSH 8'b00110111
`define POP 8'b00111000
`define HLT 8'b11111111
//###########################################

module CPU_EEPROM(clk, reset, PC, Data, Out, carry, parity, sign, zero);

/********************************************************/
input clk, reset;

output reg [12:0] PC;
input [7:0] Data;

output reg [7:0] Out;

// Flags
output reg carry;	//If addition accumulator is greater than 8 bit then the Carry Flag will set(1).
output reg parity;	//This flag is set to set(1) when there is even number of one bits in accumulator, and to reset(0) when there is odd number of one bits.
output reg sign;	//This flag is set(1) when the accumulator of an arithmetic operation has a 1 in the most significant bit (msb).
output reg zero;	//This flag is set(1) when the accumulator of an arithmetic operation is zero.

//####################################
integer count = 0;
reg update = 0;
/*********************************************************/
reg [7:0] A;
reg [7:0] B;
reg [7:0] C;
/*********************************************************/
reg [12:0] Stack_mem [15:0];	// Stack memory
reg [7:0] inst;
reg [3:0] SP;

//######################################
initial
begin
count = 0;
update = 0;
A = 8'b00000000;
B = 8'b00000000;
C = 8'b00000000;
Out = 8'b00000000;
carry = 0;
parity <= 0;
sign <= 0;
zero <= 0;
PC = 13'b0000000000000;
SP = 4'b1111;
end
//######################################
always @(posedge clk)
begin
	if(!reset)
	begin
	count = 0;
	update = 0;
	A = 8'b00000000;
	B = 8'b00000000;
	C = 8'b00000000;
	Out = 8'b00000000;
	carry = 0;
	parity <= 0;
	sign <= 0;
	zero <= 0;
	PC = 13'b0000000000000;
	SP = 13'b1111;
	end
	count = count + 1'b1;
	if(count > 50000000)
	begin
		count = 0;
		if(!update)
			inst = Data;
		if(inst != `HLT)
		begin
			if(!update)
				PC = PC + 1'b1;
			case(inst)
			`ADD_B: 
			begin
				{carry, A} = A + B;
				parity <= ~^A;
				sign <= A[7];
				zero <= ~| A;
			end
			`ADD_C: 
			begin
				{carry, A} = A + C;
				parity <= ~^A;
				sign <= A[7];
				zero <= ~| A;
			end
			`ADD_M: 
			begin
				if(update)
					begin
						Stack_mem[SP] = PC;
						PC = {B[4:0], C};
						{carry, A} = A + Data;
						parity <= ~^A;
						sign <= A[7];
						zero <= ~| A;
						PC = Stack_mem[SP];
						update = 0;
					end
					else
					begin
						update = 1;
					end
			end
			`SUB_B: 
			begin
				A = A - B;
				carry = 0;
				parity <= ~^A;
				sign <= A[7];
				zero <= ~| A;
			end
			`SUB_C: 
			begin
				A = A - C;
				carry = 0;
				parity <= ~^A;
				sign <= A[7];
				zero <= ~| A;
			end
			`SUB_M: 
			begin
				if(update)
					begin
						Stack_mem[SP] = PC;
						PC = {B[4:0], C};
						A = A - Data;
						carry = 0;
						parity <= ~^A;
						sign <= A[7];
						zero <= ~| A;
						PC = Stack_mem[SP];
						update = 0;
					end
					else
					begin
						update = 1;
					end
			end
			`OR_B: 
			begin
				A = A | B;
				carry = 0;
				parity <= ~^A;
				sign <= A[7];
				zero <= ~| A;
			end
			`OR_C: 
			begin
				A = A | C;
				carry = 0;
				parity <= ~^A;
				sign <= A[7];
				zero <= ~| A;
			end
			`OR_M: 
			begin
				if(update)
					begin
						Stack_mem[SP] = PC;
						PC = {B[4:0], C};
						A = A | Data;
						carry = 0;
						parity <= ~^A;
						sign <= A[7];
						zero <= ~| A;
						PC = Stack_mem[SP];
						update = 0;
					end
					else
					begin
						update = 1;
					end
			end
			`AND_B: 
			begin
				A = A & B;
				carry = 0;
				parity <= ~^A;
				sign <= A[7];
				zero <= ~| A;
			end
			`AND_C: 
			begin
				A = A & C;
				carry = 0;
				parity <= ~^A;
				sign <= A[7];
				zero <= ~| A;
			end
			`AND_M: 
			begin
				if(update)
					begin
						Stack_mem[SP] = PC;
						PC = {B[4:0], C};
						A = A & Data;
						carry = 0;
						parity <= ~^A;
						sign <= A[7];
						zero <= ~| A;
						PC = Stack_mem[SP];
						update = 0;
					end
					else
					begin
						update = 1;
					end
			end
			`XOR_B: 
			begin
				A = A ^ B;
				carry = 0;
				parity <= ~^A;
				sign <= A[7];
				zero <= ~| A;
			end
			`XOR_C: 
			begin
				A = A ^ C;
				carry = 0;
				parity <= ~^A;
				sign <= A[7];
				zero <= ~| A;
			end
			`XOR_M: 
			begin
				if(update)
					begin
						Stack_mem[SP] = PC;
						PC = {B[4:0], C};
						A = A ^ Data;
						carry = 0;
						parity <= ~^A;
						sign <= A[7];
						zero <= ~| A;
						PC = Stack_mem[SP];
						update = 0;
					end
					else
					begin
						update = 1;
					end
			end
			`JMP:
			begin
				PC = {B[4:0], C};
			end
			`JMP_C:
			begin
				if(carry)
				begin
					PC = {B[4:0], C};
				end
			end
			`JMP_P:
			begin
				if(parity)
				begin
					PC = {B[4:0], C};
				end
			end
			`JMP_S:
			begin
				if(sign)
				begin
					PC = {B[4:0], C};
				end
			end
			`JMP_Z:
			begin
				if(zero)
				begin
					PC = {B[4:0], C};
				end
			end
			`CALL:
			begin
				Stack_mem[SP] = PC;
				SP = SP - 1'b1;
				PC = {B[4:0], C};
			end
			`CALL_C:
			begin
				if(carry)
				begin
					Stack_mem[SP] = PC;
					SP = SP - 1'b1;
					PC = {B[4:0], C};
				end
			end
			`CALL_P:
			begin
				if(parity)
				begin
					Stack_mem[SP] = PC;
					SP = SP - 1'b1;
					PC = {B[4:0], C};
				end
			end
			`CALL_S:
			begin
				if(sign)
				begin
					Stack_mem[SP] = PC;
					SP = SP - 1'b1;
					PC = {B[4:0], C};
				end
			end
			`CALL_Z:
			begin
				if(zero)
				begin
					Stack_mem[SP] = PC;
					SP = SP - 1'b1;
					PC = {B[4:0], C};
				end
			end
			`RET:	
			begin
				SP = SP + 1'b1;
				PC = Stack_mem[SP];
			end
			`RL:	
			begin
				A = {A[6:0], A[7]};
				carry = 0;
				parity <= ~^A;
				sign <= A[7];
				zero <= ~| A;
			end
			`RR:	
			begin
				A = {A[0], A[7:1]};
				carry = 0;
				parity <= ~^A;
				sign <= A[7];
				zero <= ~| A;
			end
			`OUT:	
			begin
				Out = A;
			end
			`INC_A:	
			begin
				{carry, A} = A + 1'b1;
				parity <= ~^A;
				sign <= A[7];
				zero <= ~| A;
			end
			`INC_B:	
			begin
				B = B + 1'b1;
			end
			`INC_C:	
			begin
				C = C + 1'b1;
			end
			`DRC_A:	
			begin
				A = A - 1'b1;
				carry = 0;
				parity <= ~^A;
				sign <= A[7];
				zero <= ~| A;
			end
			`DRC_B:	
			begin
				B = B - 1'b1;
			end
			`DRC_C:	
			begin
				C = C - 1'b1;
			end
			`CLR_A:	
			begin
				A = 0;
				carry = 0;
				parity <= 0;
				sign <= 0;
				zero <= 0;
			end
			`CLR_B:	
			begin
				B = 0;
			end
			`CLR_C:	
			begin
				C = 0;
			end
			`CPL_A:	
			begin
				A = ~A;
				carry = 0;
				parity <= ~^A;
				sign <= A[7];
				zero <= ~| A;
			end
			`CPL_B:	
			begin
				B = ~B;
			end
			`CPL_C:	
			begin
				C = ~C;
			end
			`CPL_A:	
			begin
				A = ~A;
				carry = 0;
				parity <= ~^A;
				sign <= A[7];
				zero <= ~| A;
			end
			`CPL_A:	
			begin
				A = ~A;
				carry = 0;
				parity <= ~^A;
				sign <= A[7];
				zero <= ~| A;
			end
			`CPL_A:	
			begin
				A = ~A;
				carry = 0;
				parity <= ~^A;
				sign <= A[7];
				zero <= ~| A;
			end
			`ADI:
			begin
				if(update)
					begin
						{carry, A} = A + Data;
						parity <= ~^A;
						sign <= A[7];
						zero <= ~| A;
						PC = PC + 1'b1;
						update = 0;
					end
					else
					begin
						update = 1;
					end
			end
			`SBI: 
			begin
				if(update)
					begin
						A = A - Data;
						carry = 0;
						parity <= ~^A;
						sign <= A[7];
						zero <= ~| A;
						PC = PC + 1'b1;
						update = 0;
					end
					else
					begin
						update = 1;
					end
			end
			`ORI: 
			begin
				if(update)
					begin
						A = A | Data;
						carry = 0;
						parity <= ~^A;
						sign <= A[7];
						zero <= ~| A;
						PC = PC + 1'b1;
						update = 0;
					end
					else
					begin
						update = 1;
					end
			end
			`ANI: 
			begin
				if(update)
					begin
						A = A & Data;
						carry = 0;
						parity <= ~^A;
						sign <= A[7];
						zero <= ~| A;
						PC = PC + 1'b1;
						update = 0;
					end
					else
					begin
						update = 1;
					end
			end
			`XRI: 
			begin
				if(update)
					begin
						A = A ^ Data;
						carry = 0;
						parity <= ~^A;
						sign <= A[7];
						zero <= ~| A;
						PC = PC + 1'b1;
						update = 0;
					end
					else
					begin
						update = 1;
					end
			end
			`MOV_AB: 
			begin
				A = B;
				carry = 0;
				parity <= ~^A;
				sign <= A[7];
				zero <= ~| A;
			end
			`MOV_BC: 
			begin
				B = C;
			end
			`MOV_CB: 
			begin
				C = B;
			end
			`MOV_AC: 
			begin
				A = C;
				carry = 0;
				parity <= ~^A;
				sign <= A[7];
				zero <= ~| A;
			end
			`MVI_A:
			begin
				if(update)
				begin
					A = Data;
					carry = 0;
					parity <= ~^A;
					sign <= A[7];
					zero <= ~| A;
					PC = PC + 1'b1;
					update = 0;
				end
				else
				begin
					update = 1;
				end
			end
			`MVI_B:
			begin
				if(update)
					begin
						B = Data;
						PC = PC + 1'b1;
						update = 0;
					end
					else
					begin
						update = 1;
					end
			end
			`MVI_C:
			begin
				if(update)
					begin
						C = Data;
						PC = PC + 1'b1;
						update = 0;
					end
					else
					begin
						update = 1;
					end
			end
			`PUSH:	
			begin
				// No Code.
			end
			`POP:	
			begin
				// No Code.
			end
			endcase
		end
	end
end

endmodule
