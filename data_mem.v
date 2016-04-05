module mem_data_mem(
    // input port
    input               rst,
    input [31 : 0]      mem_data_mem_wdata_i,
    input [4 : 0]       mem_data_mem_waddr_i,
    input               mem_data_mem_we_i,

    // output port
	output reg [31 : 0] mem_data_mem_wdata_o,
	output reg [4 : 0]  mem_data_mem_waddr_o,
	output reg          mem_data_mem_we_o
);

    always @(*) begin
	    if(rst == 1'b0) begin
	        mem_data_mem_wdata_o  = 32'b0;
            mem_data_mem_waddr_o = 5'b0;
	        mem_data_mem_we_o    = 1'b0;
        end else begin
	        mem_data_mem_wdata_o  = mem_data_mem_wdata_i;
            mem_data_mem_waddr_o = mem_data_mem_waddr_i;
	        mem_data_mem_we_o    = mem_data_mem_we_i;
        end
	end
endmodule
