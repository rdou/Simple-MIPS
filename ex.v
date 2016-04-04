module ex_alu(
    // input port
    input           rst,
    input  [7 : 0]  ex_alu_aluop_i,
    input  [2 : 0]  ex_alu_alusel_i,
    input  [31 : 0] ex_alu_rdata_1_i,
    input  [31 : 0] ex_alu_rdata_2_i,
    input  [31 : 0] ex_alu_ext_imm_i,
    input  [4 : 0]  ex_alu_waddr_i,
    input           ex_alu_we_i,

    // output port
    output reg [31 : 0] ex_alu_wdata_o,
    output reg [4 : 0]  ex_alu_waddr_o,
    output reg          ex_alu_we_o
);

    reg [31 : 0] alu_logicout;

    always @(*) begin
        if (rst == 1'b0) begin
            alu_logicout = 32'b0;
        end else begin
            case (ex_alu_aluop_i)
                8'b00100101 : begin
                    alu_logicout = ex_alu_rdata_1_i | ex_alu_rdata_2_i;
                end

                default : begin
                    alu_logicout = 32'b0;
                end
            endcase
        end
    end

    always @(*) begin
        if (rst == 1'b0) begin
            ex_alu_waddr_o = 32'b0;
            ex_alu_we_o    = 1'b0;
        end else begin
            ex_alu_waddr_o = ex_alu_waddr_i;
            ex_alu_we_o    = ex_alu_we_i;
            case (ex_alu_alusel_i)
                3'b001 : begin
                    ex_alu_wdata_o = alu_logicout;
                end

                default : begin
                    ex_alu_wdata_o = 32'b0;
                end
            endcase
        end
    end
endmodule
