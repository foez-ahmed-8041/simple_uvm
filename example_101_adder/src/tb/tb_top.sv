`include "my_defs.svh"
`include "uvm_macros.svh"

module tb_top;

    import uvm_pkg::*;

    ///////////////////////////////////////////////////////////////////////////
    // markup
    ///////////////////////////////////////////////////////////////////////////

    initial $display ("%c[7;38m TEST STARTED %c[0m", 27, 27);
    final   $display ("%c[7;38m TEST ENDED %c[0m", 27, 27);

    ///////////////////////////////////////////////////////////////////////////
    // imports
    ///////////////////////////////////////////////////////////////////////////

    ///////////////////////////////////////////////////////////////////////////
    // Localparam
    ///////////////////////////////////////////////////////////////////////////

    ///////////////////////////////////////////////////////////////////////////
    // signals
    ///////////////////////////////////////////////////////////////////////////

    logic clk_i  ;
    logic arst_n ;

    ///////////////////////////////////////////////////////////////////////////
    // interface
    ///////////////////////////////////////////////////////////////////////////

    top_adder_fifo_intf #(.DATA_IN_WIDTH(`DATA_IN_WIDTH)) intf (
        .clk_i  (clk_i ), 
        .arst_n (arst_n) 
    );

    ///////////////////////////////////////////////////////////////////////////
    // dut
    ///////////////////////////////////////////////////////////////////////////

    top_adder_fifo #(
        .DATA_IN_WIDTH ( `DATA_IN_WIDTH )
    ) top_adder_fifo_dut (
        .clk_i            ( intf.clk_i            ),
        .arst_n           ( intf.arst_n           ),
        .inA        ( intf.inA        ),
        .inA_valid  ( intf.inA_valid  ),
        .inA_ready  ( intf.inA_ready  ),
        .inB        ( intf.inB        ),
        .inB_valid  ( intf.inB_valid  ),
        .inB_ready  ( intf.inB_ready  ),
        .out              ( intf.out              ),
        .out_valid ( intf.out_valid ),
        .out_ready ( intf.out_ready )
    );

    ///////////////////////////////////////////////////////////////////////////
    // methods
    ///////////////////////////////////////////////////////////////////////////

    task apply_reset ();
        clk_i                 = 1 ;
        arst_n                = 1 ;
        #100                      ;
        arst_n                = 0 ;
        intf.inA_valid  = 0 ;
        intf.inB_valid  = 0 ;
        intf.out_ready = 0 ;
        #100                      ;
        arst_n                = 1 ;
        #100                      ;
    endtask

    task start_clock ();
        fork
            forever begin
                clk_i = 1; #5;
                clk_i = 0; #5;
            end
        join_none
    endtask

    ///////////////////////////////////////////////////////////////////////////
    // procedurals
    ///////////////////////////////////////////////////////////////////////////

    initial begin
        
        $dumpfile("raw.vcd");
        $dumpvars;

        $display("%0d", `DATA_IN_WIDTH);

        uvm_config_db #(virtual top_adder_fifo_intf #(.DATA_IN_WIDTH(`DATA_IN_WIDTH)))::set(null, "*", "intf", intf);

        start_clock();

        run_test ("simple_test");
        
        $finish;
    end

endmodule