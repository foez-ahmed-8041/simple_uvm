`include "uvm_macros.svh"

import uvm_pkg::*;

class adder_agent extends uvm_agent;    

    ////////////////////////////////////////
    // UVM FACTORY REGISTRATION
    ////////////////////////////////////////

    `uvm_component_utils (adder_agent)

    ////////////////////////////////////////
    // CLASS INSTANTIATIONS
    ////////////////////////////////////////

    uvm_sequencer #(adder_seq_item) sqr;
    adder_dvr                 dvr;
    adder_mon                 mon;
   
    ////////////////////////////////////////
    // FUNCTIONS
    ////////////////////////////////////////

    function new (string name = "adder_agent", uvm_component parent = null);
      super.new (name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        sqr = uvm_sequencer #(adder_seq_item)::type_id::create($sformatf("sqr"), this);
        dvr = adder_dvr::type_id::create($sformatf("dvr"), this);
        mon = adder_mon::type_id::create($sformatf("mon"), this);
    endfunction

    function void connect_phase (uvm_phase phase);
        dvr.seq_item_port.connect(sqr.seq_item_export);
    endfunction

endclass