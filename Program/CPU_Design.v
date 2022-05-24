`define ADD 6'b000000
`define SUB 6'b000001
`define CALL 6'b000010
`define JMP 6'b000011	// Unconditional Jump
`define OR 6'b000100
`define AND 6'b000101
`define JNZ 6'b000110	//Jump on Zero
`define XOR 6'b000111
`define JNC 6'b001000	//Jump on Carry
`define MVI 6'b001001
`define ADI 6'b001010
`define SUBI 6'b001011
`define ORI 6'b001100
`define ANI 6'b001101
`define RET 6'b001110
`define HLT 6'b111111

module CPU_Design(clk, reset, accumulator, carry, parity, sign, zero);

input clk;
input reset;
output reg [5:0] accumulator;
// Flags
output reg carry;	//If addition accumulator is greater than 8 bit then the Carry Flag will set(1).
output reg parity;	//This flag is set to set(1) when there is even number of one bits in accumulator, and to reset(0) when there is odd number of one bits.
output reg sign;	//This flag is set(1) when the accumulator of an arithmetic operation has a 1 in the most significant bit (msb).
output reg zero;	//This flag is set(1) when the accumulator of an arithmetic operation is zero.

reg [11:0] prog_mem [63:0];	// Program memory
reg [5:0] data_mem [63:0];	// Data memory
reg [11:0] inst;
reg [5:0] PC,SP;	//PCess Line

integer count;

always @(posedge clk)
begin
	if(!reset)
	begin
	accumulator = 6'b000000;
	carry = 0;
	parity <= 0;
	sign <= 0;
	zero <= 0;
	count <= 0;
	PC = 6'b000000;
	SP=6'b111111;	
	end
	count <= count + 1'b1;
	if(count > 50000000)
	begin
		count <= 0;
		inst = prog_mem[PC];
		if(inst[11:6] != `HLT)
		begin
			PC = PC + 1'b1;
			case(inst[11:6])
			`ADD: 
			begin
				{carry, accumulator} = accumulator + data_mem[inst[5:0]];
				parity <= ~^accumulator;
				sign <= accumulator[5];
				zero <= ~|accumulator;
			end
			`SUB:
			begin
				accumulator = accumulator - data_mem[inst[5:0]];
				carry = 0;
				parity <= ~^accumulator;
				sign <= accumulator[5];
				zero <= ~|accumulator;
			end
			`CALL:	
			begin
				prog_mem[SP] = PC;
				SP = SP - 1'b1;
				PC = inst[5:0];
			end
			`JMP:	PC = inst[5:0];
			`OR:	
			begin
				accumulator = accumulator | data_mem[inst[5:0]];
				carry = 0;
				parity <= ~^accumulator;
				sign <= accumulator[5];
				zero <= ~|accumulator;
			end
			`AND:	
			begin
				accumulator = accumulator & data_mem[inst[5:0]];
				carry = 0;
				parity <= ~^accumulator;
				sign <= accumulator[5];
				zero <= ~|accumulator;
			end
			`JNZ:	if(!zero) PC = inst[5:0];
			`XOR:	
			begin
				accumulator = accumulator ^ data_mem[inst[5:0]];
				carry = 0;
				parity <= ~^accumulator;
				sign <= accumulator[5];
				zero <= ~|accumulator;
			end
			`JNC:	if(!carry) PC = inst[5:0];
			`MVI:	
			begin
				accumulator = inst[5:0];
				carry = 0;
				parity <= ~^accumulator;
				sign <= accumulator[5];
				zero <= ~|accumulator;
			end
			`ADI:	
			begin
				{carry, accumulator} = accumulator + inst[5:0];
				parity <= ~^accumulator;
				sign <= accumulator[5];
				zero <= ~|accumulator;
			end
			`SUBI:
			begin
				accumulator = accumulator - inst[5:0];
				carry = 0;
				parity <= ~^accumulator;
				sign <= accumulator[5];
				zero <= ~|accumulator;
			end
			`ORI:	
			begin
				accumulator = accumulator | inst[5:0];
				carry = 0;
				parity <= ~^accumulator;
				sign <= accumulator[5];
				zero <= ~|accumulator;
			end
			`ANI:	
			begin
				accumulator = accumulator & inst[5:0];
				carry = 0;
				parity <= ~^accumulator;
				sign <= accumulator[5];
				zero <= ~|accumulator;
			end
			`RET:	
			begin
				SP = SP + 1'b1;
				PC = prog_mem[SP];
			end
			endcase
		end
	end
end

initial
begin
(* ram_init_file = "DataMem.txt" *)
$readmemb("DataMem.txt", data_mem);
(* ram_init_file = "ProgMem.txt" *)
$readmemb("ProgMem.txt", prog_mem);

count <= 0;
PC = 6'b000000;
SP=6'b111111;
carry = 0;
parity <= 0;
sign <= 0;
zero <= 0;
end

endmodule