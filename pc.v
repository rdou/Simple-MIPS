module if_pc(
    // input port 
    input               clk,
    input               rst,
    input      [31 : 0] if_cur_pc_i,
    
    // output port 
    output reg          if_pc_ce_o, 
    output reg [31 : 0] if_cur_pc_o,
    output reg [31 : 0] if_next_pc_o
);
    
    always @(posedge clk) begin
        if (rst == 1'b0) begin
            if_pc_ce_o   <= 4'h0;
            if_next_pc_o <= 32'h0; 
        end else begin
            if_pc_ce_o   <= 4'h1;
            if_next_pc_o <= if_cur_pc_i + 4'h4; 
        end
    end
endmodule : if_pc
