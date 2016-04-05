`timescale 1ns/10ps

interface test2dut();
    logic rst; 
endinterface 

module top();
    reg clk;
    
    test2dut test2dut_if();
     
`ifdef DUMP_FSDB
    initial begin
        $fsdbDumpfile("test.fsdb");
        $fsdbDumpvars;
    end
`endif

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
