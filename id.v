module id_decode(
    input               rst,
    input      [31 : 0] id_decode_pc_i,
    input      [31 : 0] id_decode_inst_i,

    output reg          id_decode_re_1_o,
    output reg          id_decode_re_2_o,
    output reg [4 : 0]  id_decode_raddr_1_o,
    output reg [4 : 0]  id_decode_raddr_2_o,
    output reg          id_decode_we_o,
    output reg [4 : 0]  id_decode_waddr_o,
    output reg [31 : 0] id_decode_ext_imm,
    output reg [7 : 0]  id_decode_aluop_o,
    output reg [2 : 0]  id_decode_alusel_o
);

    always @(*) begin
        if (rst == 1'b0) begin
            id_decode_re_1_o    = 1'b0;
            id_decode_re_2_o    = 1'b0;
            id_decode_raddr_1_o = 5'b0;
            id_decode_raddr_2_o = 5'b0;
            id_decode_we_o      = 1'b0;
            id_decode_waddr_o   = 5'b0;
            id_decode_aluop_o   = 8'b0;
            id_decode_alusel_o  = 3'b0;
            id_decode_ext_imm   = 32'b0;
        end else begin
            case (id_decode_inst_i[31 : 26])
                6'b001101: begin
                    id_decode_aluop_o   = 8'b00100101;
                    id_decode_alusel_o  = 3'b001;
                    id_decode_raddr_1_o = id_decode_inst_i[25 : 21];
                    id_decode_raddr_2_o = id_decode_inst_i[20 : 16];
                    id_decode_waddr_o   = id_decode_inst_i[15 : 11];
                    id_decode_re_1_o    = 1'b1;
                    id_decode_re_2_o    = 1'b0;
                    id_decode_we_o      = 1'b1;
                    id_decode_ext_imm   = {16'b0, id_decode_inst_i[15 : 0]};
                end

                default: begin
                    id_decode_aluop_o   = 8'b0;
                    id_decode_alusel_o  = 3'b0;
                    id_decode_raddr_1_o = id_decode_inst_i[25 : 21];
                    id_decode_raddr_2_o = id_decode_inst_i[20 : 16];
                    id_decode_waddr_o   = id_decode_inst_i[15 : 11];
                    id_decode_re_1_o    = 1'b0;
                    id_decode_re_2_o    = 1'b0;
                    id_decode_we_o      = 1'b0;
                    id_decode_ext_imm   = 32'b0;
                end
            endcase
        end
    end
endmodule
