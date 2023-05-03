`include "uvm_macros.svh"

import uvm_pkg::*;

class adder_base_test extends uvm_test;    

    ////////////////////////////////////////
    // UVM FACTORY REGISTRATION
    ////////////////////////////////////////

    `uvm_component_utils (adder_base_test)

    ////////////////////////////////////////
    // CLASS INSTANTIATIONS
    ////////////////////////////////////////

    adder_env env;
   
    ////////////////////////////////////////
    // FUNCTIONS
    ////////////////////////////////////////

    function new (string name = "adder_base_test", uvm_component parent = null);
      super.new (name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        env = adder_env::type_id::create($sformatf("env"), this);
    endfunction    

    ////////////////////////////////////////
    // TASKS
    ////////////////////////////////////////

    task run_phase (uvm_phase phase);
        uvm_top.print_topology();
    endtask

    task apply_reset();
        tb_top.apply_reset();
    endtask

    task start_clock();
        tb_top.start_clock();
    endtask

    task delay (int x);
        repeat (x) @ (posedge tb_top.clk_i);
    endtask

    task wait_cooldown(int wcnt = 10);
        int cnt;
        cnt = 0;
        while (cnt<wcnt) begin
            cnt++;
            @ (posedge tb_top.intf.clk_i);
            if (tb_top.intf.inA_valid & tb_top.intf.inA_ready) cnt = 0;
            if (tb_top.intf.inB_valid & tb_top.intf.inB_ready) cnt = 0;
            if (tb_top.intf.out_valid & tb_top.intf.out_ready) cnt = 0;
        end
    endtask

endclass