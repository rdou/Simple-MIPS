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
