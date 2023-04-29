`include "my_defs.svh"
`include "uvm_macros.svh"

import uvm_pkg::*;

class adder_mon extends uvm_monitor;    

    ////////////////////////////////////////
    // UVM FACTORY REGISTRATION
    ////////////////////////////////////////

    `uvm_component_utils (adder_mon)

    ////////////////////////////////////////
    // INTERFACE INSTANTIATIONS
    ////////////////////////////////////////

    virtual top_adder_fifo_intf #(.DATA_IN_WIDTH(`DATA_IN_WIDTH)) intf;

    ////////////////////////////////////////
    // ANALYSIS PORTS{{{
    ////////////////////////////////////////

    uvm_analysis_port #(adder_rsp_item) mon_analysis_port;
    local mailbox #(adder_rsp_item) mon_in_A = new ();
    local mailbox #(adder_rsp_item) mon_in_B = new ();
    local mailbox #(adder_rsp_item) mon_in_O = new ();
   
    ////////////////////////////////////////
    // FUNCTIONS
    ////////////////////////////////////////

    function new (string name = "adder_mon", uvm_component parent = null);
      super.new (name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        mon_analysis_port = new ("mon_analysis_port", this);
        if (!uvm_config_db #(virtual top_adder_fifo_intf #(.DATA_IN_WIDTH(`DATA_IN_WIDTH)))::get(null, "*", "intf", intf)) begin
            $display("FATAL %s %0d", `__FILE__, `__LINE__);
            $finish;
        end
    endfunction

    
    task run_phase (uvm_phase phase);
    
        fork

            forever begin
                @ (posedge intf.clk_i);
                if (intf.inA_valid & intf.inA_ready) begin
                    adder_rsp_item item;
                    item = new ();
                    item.inA = intf.inA;
                    mon_in_A.put(item);
                end
            end

            forever begin
                @ (posedge intf.clk_i);
                if (intf.inB_valid & intf.inB_ready) begin
                    adder_rsp_item item;
                    item = new ();
                    item.inB = intf.inB;
                    mon_in_B.put(item);
                end
            end

            forever begin
                @ (posedge intf.clk_i);
                if (intf.out_valid & intf.out_ready) begin
                    adder_rsp_item item;
                    item = new ();
                    item.out = intf.out;
                    mon_in_O.put(item);
                end
            end

            forever begin
                adder_rsp_item item_A;
                adder_rsp_item item_B;
                adder_rsp_item item_O;
                adder_rsp_item item;
                item = new ();
                mon_in_A.get(item_A);
                mon_in_B.get(item_B);
                mon_in_O.get(item_O);
                item.inA = item_A.inA;
                item.inB = item_B.inB;
                item.out = item_O.out;
                mon_analysis_port.write(item);
            end

        join_none

    endtask


endclass