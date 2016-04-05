module inst_rom(
    // input port  
    input  [31 : 0] inst_rom_addr_in_i,
    input           inst_rom_ce_i,
    
    // output port
    output reg [31 : 0] inst_rom_data_out_o 
); 

    reg [31 : 0] inst_rom [0 : 1023];

    initial $readmemh ("/proj/crptohw1/wa/rdou/tutorial/mips/inst_rom.data", inst_rom);
    
    always @(*) begin
        if (inst_rom_ce_i == 1'b0) begin
            inst_rom_data_out_o = 32'b0;
        end else begin
           inst_rom_data_out_o = inst_rom[inst_rom_addr_in_i[11 : 2]]; 
        end
    end
endmodule
