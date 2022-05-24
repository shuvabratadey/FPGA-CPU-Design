# FPGA-CPU-Design
Designed A CPU using ALTERA FPGA using Verilog HDL.
# This are Some instructions of my CPU.
![CPU](https://github.com/shuvabratadey/esp32-Smart-Watch/blob/main/pictures/CLOCK.jpg)
This CPU is based on harvard architecture, so there is two types of memory one is program memory and another one is data memory.
# This is the picture of the program and data memory.
![CPU](https://github.com/shuvabratadey/esp32-Smart-Watch/blob/main/pictures/CLOCK.jpg)
# This are some instructions written by the user. 

MVI 02
ADI 28
ORI 3F
ADD 00 ==> 1
JMP 08


ANI 00
ORI 3F
HLT

# After converting this code to binary and put in the program memory of my cpu, It will start to execute. 
# This is the Picture of the FPGA Board while it Executing this instructions.
![CPU](https://github.com/shuvabratadey/esp32-Smart-Watch/blob/main/pictures/CLOCK.jpg)
# Please see the codes for better understanding.
