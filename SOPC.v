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
