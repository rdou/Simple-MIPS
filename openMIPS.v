module open_MIPS(
    // input port
    input               clk,
    input               rst,
    input      [31 : 0] inst_rom_data_out_i,

    // output port
    output reg [31 : 0] inst_rom_addr_in_o,
    output reg          inst_rom_ce_o
);

/***************************************************
* Reg/Wire Declaration
***************************************************/
    // IF stage
    wire [31 : 0] if_pc_cur_pc_o_w;
    wire [31 : 0] if_pc_cur_wb_pc_o_w; 
    wire [31 : 0] if_pc_next_pc_o_w;
    wire          if_pc_ce_o_w; 
    wire [31 : 0] if_id_pc_o_w;
    wire [31 : 0] if_id_inst_o_w;

    // ID stage
    wire          id_decode_re_1_o_w;
    wire          id_decode_re_2_o_w;
    wire [4 : 0]  id_decode_raddr_1_o_w;
    wire [4 : 0]  id_decode_raddr_2_o_w;
    wire          id_decode_we_o_w;
    wire [4 : 0]  id_decode_waddr_o_w;
    wire [31 : 0] id_decode_ext_imm_w;
    wire [7 : 0]  id_decode_aluop_o_w;
    wire [2 : 0]  id_decode_alusel_o_w;

    wire [31 : 0] id_regfile_rdata_1_o_w;
    wire [31 : 0] id_regfile_rdata_2_o_w;

    wire [7 : 0]  id_ex_aluop_o_w;
    wire [2 : 0]  id_ex_alusel_o_w;
    wire [31 : 0] id_ex_rdata_1_o_w;
    wire [31 : 0] id_ex_rdata_2_o_w;
    wire [31 : 0] id_ex_ext_imm_o_w;
    wire [4 : 0]  id_ex_waddr_o_w;
    wire          id_ex_we_o_w;

    // EX stage
    wire [31 : 0] ex_alu_wdata_o_w;
    wire [4 : 0]  ex_alu_waddr_o_w;
    wire          ex_alu_we_o_w;

    wire [31 : 0] ex_mem_wdata_o_w;
    wire [4 : 0]  ex_mem_waddr_o_w;
    wire          ex_mem_we_o_w;

    // MEM stage
  	wire [31 : 0] mem_data_mem_wdata_o_w;
  	wire [4 : 0]  mem_data_mem_waddr_o_w;
	wire          mem_data_mem_we_o_w;

    wire [31 : 0] mem_wb_wdata_o_w;
    wire [4 : 0]  mem_wb_waddr_o_w;
    wire          mem_wb_we_o_w;

/***************************************************
* IF STAGE
***************************************************/
    // PC module
    assign if_pc_cur_wb_pc_o_w = rst ? if_pc_next_pc_o_w : 32'b0; 
    
    always @(*) begin
        inst_rom_ce_o = if_pc_ce_o_w; 
    end
    
    always @(*) begin 
        inst_rom_addr_in_o = if_pc_cur_pc_o_w; 
    end

    if_pc IF_PC(
        // input port
        .clk(clk),
        .rst(rst),
        .if_pc_cur_pc_i(if_pc_cur_wb_pc_o_w),

        // output port
        .if_pc_ce_o(if_pc_ce_o_w),
        .if_pc_cur_pc_o(if_pc_cur_pc_o_w),
        .if_pc_next_pc_o(if_pc_next_pc_o_w)
    );

    // IF-ID
    if_id IF_ID(
        // input port
        .clk(clk),
        .rst(rst),
        .if_id_pc_i(if_pc_cur_pc_o_w),
        .if_id_inst_i(inst_rom_data_out_i),

        // output port
        .if_id_pc_o(if_id_pc_o_w),
        .if_id_inst_o(if_id_inst_o_w)
    );

/***************************************************
* ID STAGE
***************************************************/

    // ID Decoder
    id_decode ID_DECODE(
        // input port
        .rst(rst),
        .id_decode_pc_i(if_id_pc_o_w),
        .id_decode_inst_i(if_id_inst_o_w),

        // output port
        .id_decode_re_1_o(id_decode_re_1_o_w),
        .id_decode_re_2_o(id_decode_re_2_o_w),
        .id_decode_raddr_1_o(id_decode_raddr_1_o_w),
        .id_decode_raddr_2_o(id_decode_raddr_2_o_w),
        .id_decode_we_o(id_decode_we_o_w),
        .id_decode_waddr_o(id_decode_waddr_o_w),
        .id_decode_ext_imm(id_decode_ext_imm_w),
        .id_decode_aluop_o(id_decode_aluop_o_w),
        .id_decode_alusel_o(id_decode_alusel_o_w)
    );

    // ID Register File
    id_regfile ID_REGFILE(
        // input port
        .clk(clk),
        .rst(rst),
        .id_regfile_we_i(mem_wb_we_o_w),
        .id_regfile_waddr_i(mem_wb_waddr_o_w),
        .id_regfile_wdata_i(mem_wb_wdata_o_w),
        .id_regfile_re_1_i(id_decode_re_1_o_w),
        .id_regfile_raddr_1_i(id_decode_raddr_1_o_w),
        .id_regfile_re_2_i(id_decode_re_2_o_w),
        .id_regfile_raddr_2_i(id_decode_raddr_2_o_w),

        // output port
        .id_regfile_rdata_1_o(id_regfile_rdata_1_o_w),
        .id_regfile_rdata_2_o(id_regfile_rdata_2_o_w)
    );

    id_ex ID_EX(
        // input port
        .clk(clk),
        .rst(rst),
        .id_ex_aluop_i(id_decode_aluop_o_w),
        .id_ex_alusel_i(id_decode_alusel_o_w),
        .id_ex_rdata_1_i(id_regfile_rdata_1_o_w),
        .id_ex_rdata_2_i(id_regfile_rdata_2_o_w),
        .id_ex_ext_imm_i(id_decode_ext_imm_w),
        .id_ex_waddr_i(id_decode_waddr_o_w),
        .id_ex_we_i(id_decode_we_o_w),

        // output port
        .id_ex_aluop_o(id_ex_aluop_o_w),
        .id_ex_alusel_o(id_ex_alusel_o_w),
        .id_ex_rdata_1_o(id_ex_rdata_1_o_w),
        .id_ex_rdata_2_o(id_ex_rdata_2_o_w),
        .id_ex_ext_imm_o(id_ex_ext_imm_o_w),
        .id_ex_waddr_o(id_ex_waddr_o_w),
        .id_ex_we_o(id_ex_we_o_w)
    );

/***************************************************
* EX STAGE
***************************************************/
    ex_alu EX_ALU(
        // input port
        .rst(rst),
        .ex_alu_aluop_i(id_ex_aluop_o_w),
        .ex_alu_alusel_i(id_ex_alusel_o_w),
        .ex_alu_rdata_1_i(id_ex_rdata_1_o_w),
        .ex_alu_rdata_2_i(id_ex_rdata_2_o_w),
        .ex_alu_ext_imm_i(id_ex_ext_imm_o_w),
        .ex_alu_waddr_i(id_ex_waddr_o_w),
        .ex_alu_we_i(id_ex_we_o_w),

        // output port
        .ex_alu_wdata_o(ex_alu_wdata_o_w),
        .ex_alu_waddr_o(ex_alu_waddr_o_w),
        .ex_alu_we_o(ex_alu_we_o_w)
    );

    ex_mem EX_MEM(
        // input port
        .clk(clk),
        .rst(rst),
      	.ex_mem_wdata_i(ex_alu_wdata_o_w),
        .ex_mem_waddr_i(ex_alu_waddr_o_w),
        .ex_mem_we_i(ex_alu_we_o_w),

        // output port
        .ex_mem_wdata_o(ex_mem_wdata_o_w),
        .ex_mem_waddr_o(ex_mem_waddr_o_w),
        .ex_mem_we_o(ex_mem_we_o_w)
    );

/***************************************************
* MEM STAGE
***************************************************/
    mem_data_mem MEM_DATA_MEM(
        // input port
        .rst(rst),
        .mem_data_mem_wdata_i(ex_mem_wdata_o_w),
        .mem_data_mem_waddr_i(ex_mem_waddr_o_w),
        .mem_data_mem_we_i(ex_mem_we_o_w),

        // output port
	     .mem_data_mem_wdata_o(mem_data_mem_wdata_o_w),
	     .mem_data_mem_waddr_o(mem_data_mem_waddr_o_w),
	     .mem_data_mem_we_o(mem_data_mem_we_o_w)
    );

    mem_wb MEM_WB(
        // input port
        .clk(clk),
        .rst(rst),
        .mem_wb_wdata_i(mem_data_mem_wdata_o_w),
        .mem_wb_waddr_i(mem_data_mem_waddr_o_w),
        .mem_wb_we_i(mem_data_mem_we_o_w),

        // output port
        .mem_wb_wdata_o(mem_wb_wdata_o_w),
        .mem_wb_waddr_o(mem_wb_waddr_o_w),
        .mem_wb_we_o(mem_wb_we_o_w)
    );
endmodule
