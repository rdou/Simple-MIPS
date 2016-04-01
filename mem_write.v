module mem_wb(
    // input port
    input               clk,
    input               rst,
    input      [31 : 0] mem_wb_wdata_i,
	input      [4 : 0]  mem_wb_waddr_i,
	input               mem_wb_we_i,

    // ouput port
    output reg [31 : 0] mem_wb_wdata_o,
    output reg [4 : 0]  mem_wb_waddr_o,
    output reg          mem_wb_we_o
);

    always @(posedge clk) begin
        if (rst == 1'b0) begin
            mem_wb_wdata_o <= 32'b0;
            mem_wb_waddr_o <= 5'b0;
            mem_wb_we_o    <= 1'b0;
        end else begin
            mem_wb_wdata_o <= mem_wb_wdata_i;
            mem_wb_waddr_o <= mem_wb_waddr_i;
            mem_wb_we_o    <= mem_wb_we_i;
        end
    end
endmodule
