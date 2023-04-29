`include "my_defs.svh"
`include "uvm_macros.svh"

import uvm_pkg::*;

class adder_scbd extends uvm_scoreboard;    

    ////////////////////////////////////////
    // UVM FACTORY REGISTRATION
    ////////////////////////////////////////

    `uvm_component_utils (adder_scbd)

    //////////////////////////////////////////////////////////////////////////////////
    // SIGNALS
    //////////////////////////////////////////////////////////////////////////////////

    adder_rsp_item rsp_Q[$];
    int PASS;
    int FAIL;

    //////////////////////////////////////////////////////////////////////////////////
    // ANALYSIS PORTS
    //////////////////////////////////////////////////////////////////////////////////

    uvm_analysis_imp #(adder_rsp_item, adder_scbd) m_analysis_imp;
   
    ////////////////////////////////////////
    // FUNCTIONS
    ////////////////////////////////////////

    function new (string name = "adder_scbd", uvm_component parent = null);
      super.new (name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        m_analysis_imp = new ($sformatf("m_analysis_imp"), this);
    endfunction

    function void write (adder_rsp_item rsp);
        rsp_Q.push_back(rsp);
    endfunction

    function void extract_phase (uvm_phase phase);
        adder_rsp_item item;
        PASS = 0;
        FAIL = 0;
        while (rsp_Q.size()) begin
            item = rsp_Q.pop_front();
            if ((item.inA + item.inB) == item.out) begin 
                PASS++; 
                $display ("%c[0;32m PASSED %3d + %3d = %3d %c[0m", 27, item.inA, item.inB, item.out, 27);
            end
            else begin 
                FAIL++;
                $display ("%c[0;31m FAILED %3d + %3d = %3d %c[0m", 27, item.inA, item.inB, item.out, 27);
            end
        end
        if (FAIL) $write("%c[7;31m", 27);
        else      $write("%c[7;32m", 27);
        $display("%0d/%0d PASSED%c[0m", PASS, PASS + FAIL, 27);
    endfunction

endclass