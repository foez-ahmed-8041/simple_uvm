`include "my_defs.svh"
`include "uvm_macros.svh"

import uvm_pkg::*;

class adder_dvr extends uvm_driver #(adder_seq_item);    

    ////////////////////////////////////////
    // UVM FACTORY REGISTRATION
    ////////////////////////////////////////

    `uvm_component_utils (adder_dvr)

    ////////////////////////////////////////
    // INTERFACE INSTANTIATIONS
    ////////////////////////////////////////

    virtual top_adder_fifo_intf #(.DATA_IN_WIDTH(`DATA_IN_WIDTH)) intf;

    ////////////////////////////////////////
    // CLASS INSTANTIATIONS
    ////////////////////////////////////////

    local mailbox #(adder_seq_item) dvr_in_A = new ();
    local mailbox #(adder_seq_item) dvr_in_B = new ();
    local mailbox #(adder_seq_item) dvr_in_O = new ();
   
    ////////////////////////////////////////
    // FUNCTIONS
    ////////////////////////////////////////

    function new (string name = "adder_dvr", uvm_component parent = null);
      super.new (name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        if (!uvm_config_db #(virtual top_adder_fifo_intf #(.DATA_IN_WIDTH(`DATA_IN_WIDTH)))::get(null, "*", "intf", intf)) begin
            $display("FATAL %s %0d", `__FILE__, `__LINE__);
            $finish;
        end
    endfunction

    task run_phase (uvm_phase phase);
    
        fork

            forever begin
                adder_seq_item item;
                adder_seq_item item_A;
                adder_seq_item item_B;
                adder_seq_item item_O;
                seq_item_port.get_next_item(item);
                item_A = new item;
                item_B = new item;
                item_O = new item;
                dvr_in_A.put(item_A);
                dvr_in_B.put(item_B);
                dvr_in_O.put(item_O);
                seq_item_port.item_done();
            end

            forever begin
                adder_seq_item item;
                dvr_in_A.get(item);
                // PORAY repeat ($urandom_range(d_min, d_max)) @ (posedge intf.clk_i);
                intf.inA       <= item.inA;
                intf.inA_valid <= '1;
                do @ (posedge intf.clk_i);
                while (intf.inA_ready !== '1);
                intf.inA_valid <= '0;
            end

            forever begin
                adder_seq_item item;
                dvr_in_B.get(item);
                // PORAY repeat ($urandom_range(d_min, d_max)) @ (posedge intf.clk_i);
                intf.inB       <= item.inB;
                intf.inB_valid <= '1;
                do @ (posedge intf.clk_i);
                while (intf.inB_ready !== '1);
                intf.inB_valid <= '0;
            end

            forever begin
                adder_seq_item item;
                dvr_in_O.get(item);
                // PORAY repeat ($urandom_range(d_min, d_max)) @ (posedge intf.clk_i);
                intf.out_ready <= '1;
                do @ (posedge intf.clk_i);
                while (intf.out_valid !== '1);
                intf.out_ready <= '0;
            end

        join_none

    endtask

endclass