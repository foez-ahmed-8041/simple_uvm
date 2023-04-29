`include "uvm_macros.svh"

import uvm_pkg::*;

class adder_env extends uvm_env;    

    ////////////////////////////////////////
    // UVM FACTORY REGISTRATION
    ////////////////////////////////////////

    `uvm_component_utils (adder_env)

    ////////////////////////////////////////
    // CLASS INSTANTIATIONS
    ////////////////////////////////////////

    adder_agent agent;
    adder_scbd scbd;
   
    ////////////////////////////////////////
    // FUNCTIONS
    ////////////////////////////////////////

    function new (string name = "adder_env", uvm_component parent = null);
      super.new (name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        agent = adder_agent::type_id::create($sformatf("agent"), this);
        scbd = adder_scbd::type_id::create($sformatf("scbd"), this);
    endfunction

    function void connect_phase (uvm_phase phase);
        agent.mon.mon_analysis_port.connect(scbd.m_analysis_imp);
    endfunction

endclass