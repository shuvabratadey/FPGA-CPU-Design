# FPGA-CPU-Design
# Designed A CPU using ALTERA FPGA using Verilog HDL.
# This are the Full Instruction set of my CPU.
---------------------------------------------------------------
Inst   | Opcode   |   Description
---------------------------------------------------------------
ADD_B  | 00000000 | Add Acc with B Reg
ADD_C  | 00000001 | Add Acc with C Reg
ADD_M  | 00000010 | Add Acc with the address location which holds BC Reg pair
SUB_B  | 00000011 | Sub Acc with B Reg
SUB_C  | 00000100 | Sub Acc with C Reg
SUB_M  | 00000101 | Sub Acc with the address location which holds BC Reg pair
OR_B   | 00000110 | Or Acc with B Reg
OR_C   | 00000111 | Or Acc with C Reg
OR_M   | 00001000 | Or Acc with the address location which holds BC Reg pair
AND_B  | 00001001 | And Acc with B Reg
AND_C  | 00001010 | And Acc with C Reg
AND_M  | 00001011 | And Acc with the address location which holds BC Reg pair
XOR_B  | 00001100 | Xor Acc with B Reg
XOR_C  | 00001101 | Xor Acc with C Reg
XOR_M  | 00001110 | Xor Acc with the address location which holds BC Reg pair
JMP    | 00001111 | Jump to the Location
JMP_C  | 00010000 | If Carry then Jump to the Location
JMP_P  | 00010001 | If Parity then Jump to the Location
JMP_S  | 00010010 | If Sign then Jump to the Location
JMP_Z  | 00010011 | If Zero then Jump to the Location
CALL   | 00010100 | Call the Location
CALL_C | 00010101 | If Carry Call the Location
CALL_P | 00010110 | If Parity Call the Location
CALL_S | 00010111 | If Sign Call the Location
CALL_Z | 00011000 | If Zero Call the Location
RET    | 00011001 |	Return to the Location
RL     | 00011010 |	Rotate Accumulator Left
RR     | 00011011 |	Rotate Accumulator Right
OUT    | 00011100 | Output
INC_A  | 00011101 | Increment Accumulator by 1
INC_B  | 00011110 | Increment B Reg by 1
INC_C  | 00011111 | Increment C Reg by 1
DRC_A  | 00100000 | Decrement Accumulator by 1
DRC_B  | 00100001 | Decrement B Reg by 1
DRC_C  | 00100010 | Decrement C Reg by 1
CLR_A  | 00100011 | Clear Accumulator
CLR_B  | 00100100 | Clear B Reg
CLR_C  | 00100101 | Clear C Reg
CPL_A  | 00100110 | Complement  Accumulator
CPL_B  | 00100111 | Complement B Reg
CPL_C  | 00101000 | Complement C Reg
ADI    | 00101011 | Add Immediate
SBI    | 00101100 | Sub immediate
ORI    | 00101101 | Or immediate 
ANI    | 00101110 | And immediate
XRI    | 00101111 | Xor immediate
MOV_AB | 00110000 | MOV B to A
MOV_BC | 00110001 | MOV C to B
MOV_CB | 00110010 | MOV C to B
MOV_AC | 00110011 | MOV C to A
MVI_A  | 00110100 | MOV A immediate
MVI_B  | 00110101 | MOV B immediate
MVI_C  | 00110110 | MOV C immediate
PUSH   | 00110111 | PUSH Stack_Pointer
POP    | 00111000 | POP Stack_Pointer
HLT    | 11111111 | Halt CPU
---------------------------------------------------------------
# This CPU is based on harvard architecture, so there is two types of memory one is program memory and another one is data memory.
# This is the picture of the program and data memory.
![Memory](https://github.com/shuvabratadey/FPGA-CPU-Design/blob/main/Pictures/Memorys.JPG)
# This are some instructions written by the user.

![ASM](https://github.com/shuvabratadey/FPGA-CPU-Design/blob/main/Pictures/ASM_Code.JPG)

# After converting this code to binary and put it into the EEPROM.
![EEPROM](https://github.com/shuvabratadey/FPGA-CPU-Design/blob/main/FPGA%20EEPROM/EEPROM.jpg)
#It will start to execute.
# YouTube Link:- https://youtu.be/it-jdhMR7sY
# This is the Picture of the FPGA Board while it Executing this instructions.
![CPU 1](https://github.com/shuvabratadey/FPGA-CPU-Design/blob/main/Pictures/FPGA_1.jpg)
![CPU 2](https://github.com/shuvabratadey/FPGA-CPU-Design/blob/main/Pictures/FPGA_2.jpg)
# Data Port and Flag Register.
![LED_Display](https://github.com/shuvabratadey/FPGA-CPU-Design/blob/main/FPGA%20EEPROM/LED_Display.jpg)
# This is the Full Circuit Configuration.
![Full_Circuit](https://github.com/shuvabratadey/FPGA-CPU-Design/blob/main/FPGA%20EEPROM/Full_Board.jpg)
# [Please see the codes for better understanding.](https://github.com/shuvabratadey/FPGA-CPU-Design/blob/main/Program/CPU_Design.v)
