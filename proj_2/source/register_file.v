// Name: register_file.v
// Module: REGISTER_FILE_32x32
// Input:  DATA_W : Data to be written at address ADDR_W
//         ADDR_W : Address of the memory location to be written
//         ADDR_R1 : Address of the memory location to be read for DATA_R1
//         ADDR_R2 : Address of the memory location to be read for DATA_R2
//         READ    : Read signal
//         WRITE   : Write signal
//         CLK     : Clock signal
//         RST     : Reset signal
// Output: DATA_R1 : Data at ADDR_R1 address
//         DATA_R2 : Data at ADDR_R1 address
//
// Notes: - 32 bit word accessible dual read register file having 32 regsisters.
//        - Reset is done at -ve edge of the RST signal
//        - Rest of the operation is done at the +ve edge of the CLK signal
//        - Read operation is done if READ=1 and WRITE=0
//        - Write operation is done if WRITE=1 and READ=0
//        - X is the value at DATA_R* if both READ and WRITE are 0 or 1
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Feb 24, 2020	Ryan Tran	tranryanp@gmail.com	Register file implemented
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module REGISTER_FILE_32x32(DATA_R1, DATA_R2, ADDR_R1, ADDR_R2, 
                            DATA_W, ADDR_W, READ, WRITE, CLK, RST);

// input list
input READ, WRITE, CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_W;
input [`REG_ADDR_INDEX_LIMIT:0] ADDR_R1, ADDR_R2, ADDR_W;

// output list
output [`DATA_INDEX_LIMIT:0] DATA_R1;
output [`DATA_INDEX_LIMIT:0] DATA_R2;

// simulator internal storage for data
reg [`DATA_INDEX_LIMIT:0] addr_return1;
reg [`DATA_INDEX_LIMIT:0] addr_return2;

// default case: return z if no read
assign DATA_R1 = (READ === 1'b1 && WRITE === 1'b0) ? addr_return1 : {`DATA_WIDTH{1'bz}};
assign DATA_R2 = (READ === 1'b1 && WRITE === 1'b0) ? addr_return2 : {`DATA_WIDTH{1'bz}};

// 32x32 memory storage
reg [`DATA_INDEX_LIMIT:0] reg_32x32 [0:`REG_INDEX_LIMIT];

// initial value for reset
integer i;

// sets all registers as 0
initial
begin
        for(i = 0; i <= `REG_INDEX_LIMIT; i = i + 1)
            reg_32x32[i]={ `DATA_WIDTH{1'b0} };
end

always @ (negedge RST or posedge CLK)
begin
	if (RST === 1'b0) // reset on negative edge of RST
		for (i = 0; i <= `REG_INDEX_LIMIT; i = i + 1)
   			reg_32x32[i] = { `DATA_WIDTH{1'b0} };
	else
	begin
		if (READ === 1'b1 && WRITE === 1'b0) // if read
		begin
			addr_return1 = reg_32x32[ADDR_R1];	// return content of address ADDR_R1
			addr_return2 = reg_32x32[ADDR_R2];	// and address ADDR_R2
		end
		else if (READ === 1'b0 && WRITE === 1'b1)	// else if write
			reg_32x32[ADDR_W] = DATA_W;	// place DATA_W in address ADDR_W
	end // only handles read or write; doesnt handle read, write = 00 or 11
		
end
endmodule
