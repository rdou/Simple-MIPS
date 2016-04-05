module ex_mem(
    // input port
    input               clk,
    input               rst,
    input      [31 : 0] ex_mem_wdata_i,
    input      [4 : 0]  ex_mem_waddr_i,
    input               ex_mem_we_i,

    // outport
    output reg [31 : 0] ex_mem_wdata_o,
    output reg [4 : 0]  ex_mem_waddr_o,
    output reg          ex_mem_we_o
);

    always @(posedge clk) begin
        if (rst == 1'b0) begin
            ex_mem_wdata_o <= 32'b0;
            ex_mem_waddr_o <= 5'b0;
            ex_mem_we_o    <= 1'b0;
        end else begin
            ex_mem_wdata_o <= ex_mem_wdata_i;
            ex_mem_waddr_o <= ex_mem_waddr_i;
            ex_mem_we_o    <= ex_mem_we_i;
        end
    end
endmodule
