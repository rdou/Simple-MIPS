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
                    alu_logicout = ex_alu_rdata_1_i | ex_alu_ext_imm_i;
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
                    id_decode_raddr_2_o = 5'h0;
                    id_decode_waddr_o   = id_decode_inst_i[20 : 16];
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

module if_id(
    // input port
    input               clk,
    input               rst,
    input      [31 : 0] if_id_pc_i,
    input      [31 : 0] if_id_inst_i,

    // output port
    output reg [31 : 0] if_id_pc_o,
    output reg [31 : 0] if_id_inst_o
);

    always @(posedge clk) begin
        if (rst == 1'b0) begin
            if_id_pc_o   <= 32'h0;
            if_id_inst_o <= 32'h0;
        end else begin
            if_id_pc_o   <= if_id_pc_i;
            if_id_inst_o <= if_id_inst_i;
        end
    end
endmodule

module inst_rom(
    // input port
    input  [31 : 0] inst_rom_addr_in_i,
    input           inst_rom_ce_i,

    // output port
    output reg [31 : 0] inst_rom_data_out_o
);

    reg [31 : 0] inst_rom [0 : 1023];

    initial $readmemh ("inst_rom.data", inst_rom);

    always @(*) begin
        if (inst_rom_ce_i == 1'b0) begin
            inst_rom_data_out_o = 32'b0;
        end else begin
           inst_rom_data_out_o = inst_rom[inst_rom_addr_in_i[11 : 2]];
        end
    end
endmodule

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

module if_pc(
    // input port
    input               clk,
    input               rst,
    input      [31 : 0] if_pc_cur_pc_i,

    // output port
    output reg          if_pc_ce_o,
    output reg [31 : 0] if_pc_cur_pc_o,
    output reg [31 : 0] if_pc_next_pc_o
);

    always @(posedge clk) begin
        if (rst == 1'b0) begin
            if_pc_ce_o      <= 4'h0;
            if_pc_next_pc_o <= 32'h0;
            if_pc_cur_pc_o  <= 32'h0; 
        end else begin
            if_pc_ce_o      <= 4'h1;
            if_pc_cur_pc_o  <= if_pc_cur_pc_i;
            if_pc_next_pc_o <= if_pc_cur_pc_i + 4'h4;
        end
    end
endmodule

module id_regfile(
    // input port
    input               clk,
    input               rst,
    input               id_regfile_we_i,
    input      [4 : 0]  id_regfile_waddr_i,
    input      [31 : 0] id_regfile_wdata_i,
    input               id_regfile_re_1_i,
    input      [4 : 0]  id_regfile_raddr_1_i,
    input               id_regfile_re_2_i,
    input      [4 : 0]  id_regfile_raddr_2_i,

    // output port
    output reg [31 : 0] id_regfile_rdata_1_o,
    output reg [31 : 0] id_regfile_rdata_2_o
);
    reg [31 : 0] regfile [0 : 31];

    always @(posedge clk) begin
        if (rst != 1'b1) begin
          regfile[0] <= 32'h0;
        end
        if (rst == 1'b1) begin
            if (id_regfile_we_i == 1'b1 && id_regfile_waddr_i != 5'b0) begin
                regfile[id_regfile_waddr_i] <= id_regfile_wdata_i;
            end
        end
    end
	
    always @(*) begin
        if (rst != 1'b1) begin
            id_regfile_rdata_1_o = 32'h0000000;
        end else if (id_regfile_re_1_i != 1'b1) begin
            id_regfile_rdata_1_o = 32'h0000000;
        end else if (id_regfile_raddr_1_i != id_regfile_waddr_i || ((id_regfile_raddr_1_i == id_regfile_waddr_i) && id_regfile_we_i == 1'b0)) begin
            id_regfile_rdata_1_o = regfile[id_regfile_raddr_1_i];
        end else begin
            id_regfile_rdata_1_o = 32'h00000000;
        end
    end

    always @(*) begin
        if (rst != 1'b1) begin
            id_regfile_rdata_2_o = 32'h0000000;
        end else if (id_regfile_re_2_i != 1'b1) begin
            id_regfile_rdata_2_o = 32'h0000000;
        end else if (id_regfile_raddr_2_i != id_regfile_waddr_i) begin
          id_regfile_rdata_2_o = regfile[id_regfile_raddr_2_i];
        end else if (id_regfile_we_i == 1'b1) begin
            id_regfile_rdata_2_o = id_regfile_wdata_i;
        end else begin
            id_regfile_rdata_2_o = regfile[id_regfile_raddr_2_i];
        end
    end
endmodule


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

module SOPC(
    input clk,
    input rst
);

    wire [31 : 0] inst_rom_addr_w;
    wire [31 : 0] inst_rom_data_w;
    wire inst_rom_ce_w;

    inst_rom INST_ROM(
        // input port
        .inst_rom_addr_in_i(inst_rom_addr_w),
        .inst_rom_ce_i(inst_rom_ce_w),

        // output port
        .inst_rom_data_out_o(inst_rom_data_w)
    );

    open_MIPS OPEN_MIPS(
        // input port
        .clk(clk),
        .rst(rst),
        .inst_rom_data_out_i(inst_rom_data_w),

        // output port
        .inst_rom_addr_in_o(inst_rom_addr_w),
        .inst_rom_ce_o(inst_rom_ce_w)
    );
endmodule

`timescale 1ns/10ps

interface test2dut();
    logic rst;
endinterface

module top();
    reg clk;

    test2dut test2dut_if();

/*`ifdef DUMP_FSDB
    initial begin
        $fsdbDumpfile("test.fsdb");
        $fsdbDumpvars;
    end
`endif*/
  	initial begin
      	$dumpfile("dump.vcd"); 
      	$dumpvars;
    end

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    test sopc_test(test2dut_if);

    SOPC sopc_top(
        .clk(clk),
        .rst(test2dut_if.rst)
    );
endmodule

program test(test2dut intf);
    initial begin
        intf.rst = 0;
        #15
        intf.rst = 1;
        #200
        $finish;
    end
endprogram

