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
        end else if (id_regfile_raddr_1_i != id_regfile_waddr_i) begin
            id_regfile_rdata_1_o = regfile[id_regfile_raddr_1_i];
        end else if (id_regfile_we_i == 1'b1) begin
            id_regfile_rdata_1_o = id_regfile_wdata_i;
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
            id_regfile_rdata_2_o = 32'h00000000;
        end
    end 
endmodule
