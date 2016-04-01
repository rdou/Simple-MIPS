module id_ex(
    input               clk, 
    input               rst, 
    input [7 : 0]       aluop_i,
    input [2 : 0]       alusel_i,
    input [31 : 0]      rdata_1_i,
    input [31 : 0]      rdata_2_i,
    input [31 : 0]      ext_imm_i,
    input [4 : 0]       waddr_i,
    input               we_i,
    
    output reg [7 : 0]  aluop_o,
    output reg [2 : 0]  alusel_o,
    output reg [31 : 0] rdata_1_o,
    output reg [31 : 0] rdata_2_o,
    output reg [31 : 0] ext_imm_o,
    output reg [4 : 0]  waddr_o,
    output reg          we_o
);

    always @(posedge clk) begin
        if (rst == 1'b0) begin
            aluop_o   <= 8'b0;
            alusel_o  <= 3'b0;
            rdata_1_o <= 32'b0;
            rdata_2_o <= 32'b0;
            ext_imm_o <= 32'b0;
            waddr_o   <= 5'b0;
            we        <= 1'b0;
        end else begin
            aluop_o   <= aluop_i;    
            alusel_o  <= alusel_i; 
            rdata_1_o <= rdata_1_i;
            rdata_2_o <= rdata_2_i;
            ext_imm_o <= ext_imm_i;
            waddr_o   <= waddr_i;
            we        <= we_i;
        end 
    end
endmodule
