module open_MIPS(
    // input port  
    input               clk,
    input               rst,
    input               inst_rom_data_out_i,

    // output port
    output reg [31 : 0] inst_rom_addr_in_o, 
    output reg          inst_rom_ce_o, 
);

/***************************************************
* IF STAGE
***************************************************/
    // PC module
    reg  [31 : 0] if_cur_pc_i_r; 
    
    wire [31 : 0] if_pc_next_pc_o_w; 
    
    wire [31 : 0] if_id_pc_o_w;
    wire [31 : 0] if_id_inst_o_w;
    
    //always @(*) begin
    //    if (rst == 1'b0) begin
    //        if_pc_cur_pc_i_r <= 0; 
    //    end else begin
    //        if_pc_cur_pc_i_r <= if_pc_next_pc_o_w; 
    //    end
    //end
    
    if_pc IF_PC(
        // input port  
        .clk(clk),
        .rst(rst),
        .if_pc_cur_pc_i(rst ? if_pc_next_pc_o_w : 32'b0),
        
        // output port  
        .if_pc_ce_o(inst_rom_ce_o),
        .if_pc_cur_pc_o(inst_rom_addr_in_o),
        .if_pc_next_pc_o(if_pc_next_pc_o_w)
    );
    
    // IF-ID
    if_id IF_ID(
        // input port  
        .clk(clk),
        .rst(rst),
        .if_id_pc_i(if_cur_pc_o_w),
        .if_id_inst_i(inst_rom_data_out_i),
        
        // output port  
        .if_id_pc_o(if_id_pc_o_w),
        .if_id_inst_o(if_id_inst_o_w) 
    );
    
/***************************************************
* ID STAGE
***************************************************/
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
    
    id_regfile ID_REGFILE(
        // input port 
        .clk(clk),
        .rst(rst),
        .id_regfile_we_i(id_decode_we_o_w), 
        .id_regfile_waddr_i(id_decode_waddr_o_w),
        .id_regfile_wdata_i(0),
        .id_regfile_re_1_i(id_decode_re_1_o_w),
        .id_regfile_raddr_1_i(id_decode_raddr_1_o_w), 
        .id_regfile_re_2_i(id_decode_re_2_o_w),
        .id_regfile_raddr_2_i(id_decode_raddr_2_o_w), 
        
        // output port  
        .id_regfile_rdata_1_o(id_regfile_rdata_1_o_w),
        .id_regfile_rdata_2_o(id_regfile_rdata_2_o_w)
    );
endmodule

