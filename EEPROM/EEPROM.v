`define ENTRY 3'b000
`define LOAD_DATA 3'b001
`define LOAD_MEM 3'b010
`define WRITE_PULSE 3'b011
`define WRITE_MEM 3'b100
`define EXIT 3'b101
//###################################

`define TOTAL_MEM_SIZE 63
`define WRITE_DATA_COUNT 5000000	// 50000000
`define WRITE_PULSE_COUNT 5000

module EEPROM(clk, reset, address, data, OE, WR);

input clk, reset;
output reg [12:0] address;
output reg [7:0] data;
output reg OE, WR;

reg [7:0] data_mem [`TOTAL_MEM_SIZE:0];	//[8191:0];	// Data memory

integer count1 = 0;
integer count2 = 0;

reg [5:0]select;
reg [5:0]sel;

initial
begin
address = 0;
select = 6'b000000;
OE = 0;
WR = 0;
count1 = 0;
select = 0;
sel = `ENTRY;
(* ram_init_file = "DataMem.txt" *)
$readmemb("DataMem.txt", data_mem);
end

always @(posedge clk)
begin
	 case(sel)  
      `ENTRY:
			begin
				if(!reset)
					begin
					address = 0;
					select = 6'b000000;
					count1 = 0;
					select = 0;
					end
				if(count1 > `WRITE_DATA_COUNT)
					begin
					count1 = 0;
					sel = `LOAD_DATA;
					end
				else
					begin
					count1 = count1 + 1'b1;
					end
			end
      `LOAD_DATA:
			begin
			if(select == 0)
				data = data_mem[select];
			else if((select > 0) && (select <= `TOTAL_MEM_SIZE))
				begin
				address = address + 1'b1;
				data = data_mem[select];
				end
			else if(select > `TOTAL_MEM_SIZE)
				begin
			sel = `EXIT;
				end
			select = select + 1'b1;
			WR = 1;
			sel = `WRITE_PULSE;
			end
      `WRITE_PULSE:
			begin
				if(count1 > `WRITE_PULSE_COUNT)
					begin
					count1 = 0;
					WR = 0;
					sel = `ENTRY;
					end
				else
					begin
					count1 = count1 + 1'b1;
					end
			end
      `EXIT:
			begin
			end
      default:
			begin
			sel = `ENTRY;
			end     
    endcase  
end

endmodule




























