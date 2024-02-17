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

reg [40:0]count = 0;

reg [5:0]select;
reg [5:0]sel;

initial
begin
	address = 0;
	select = 6'b000000;
	OE = 0;
	WR = 0;
	count = 0;
	sel = `ENTRY;
	(* ram_init_file = "DataMem.txt" *)
	$readmemb("DataMem.txt", data_mem);
end

always @(posedge clk)
begin
if(!reset)
	begin
		address = 0;
		select = 6'b000000;
		OE = 0;
		WR = 0;
		count = 0;
		sel = `ENTRY;
	end
	case(sel)  
		`ENTRY:
			begin				
				if(count > `WRITE_DATA_COUNT)
					begin
					count = 0;
					sel = `LOAD_DATA;
					end
				else
					begin
					count = count + 1'b1;
					end
			end
		`LOAD_DATA:
			begin
			if(select == 0)
			begin
				data = data_mem[select];
				select = select + 1'b1;
				WR = 1;
				sel = `WRITE_PULSE;
			end
			else if((select > 0) && (select <= `TOTAL_MEM_SIZE))
				begin
				address = address + 1'b1;
				data = data_mem[select];
				select = select + 1'b1;
				WR = 1;
				sel = `WRITE_PULSE;
				end
			else
				begin				
				OE = 1;
				sel = `EXIT;
				end
			end
		`WRITE_PULSE:
			begin
				if(count > `WRITE_PULSE_COUNT)
					begin
					count = 0;
					WR = 0;
					sel = `ENTRY;
					end
				else
					begin
					count = count + 1'b1;
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
