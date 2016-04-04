module id_ex(
    input               clk, 
    input               rst, 
    input [7 : 0]       id_ex_aluop_i,
    input [2 : 0]       id_ex_alusel_i,
    input [31 : 0]      id_ex_rdata_1_i,
    input [31 : 0]      id_ex_rdata_2_i,
    input [31 : 0]      id_ex_ext_imm_i,
    input [4 : 0]       id_ex_waddr_i,
    input               id_ex_we_i,
    
    output reg [7 : 0]  id_ex_aluop_o,
    output reg [2 : 0]  id_ex_alusel_o,
    output reg [31 : 0] id_ex_rdata_1_o,
    output reg [31 : 0] id_ex_rdata_2_o,
    output reg [31 : 0] id_ex_ext_imm_o,
    output reg [4 : 0]  id_ex_waddr_o,
    output reg          id_ex_we_o
);

    always @(posedge clk) begin
        if (rst == 1'b0) begin
            id_ex_aluop_o   <= 8'b0;
            id_ex_alusel_o  <= 3'b0;
            id_ex_rdata_1_o <= 32'b0;
            id_ex_rdata_2_o <= 32'b0;
            id_ex_ext_imm_o <= 32'b0;
            id_ex_waddr_o   <= 5'b0;
            id_ex_we_o      <= 1'b0;
        end else begin
            id_ex_aluop_o   <= id_ex_aluop_i;    
            id_ex_alusel_o  <= id_ex_alusel_i; 
            id_ex_rdata_1_o <= id_ex_rdata_1_i;
            id_ex_rdata_2_o <= id_ex_rdata_2_i;
            id_ex_ext_imm_o <= id_ex_ext_imm_i;
            id_ex_waddr_o   <= id_ex_waddr_i;
            id_ex_we_o      <= id_ex_we_i;
        end 
    end
endmodule
