`include "my_defs.svh"

class adder_rsp_item extends adder_seq_item;
    
    `uvm_object_utils(adder_seq_item)

    bit [`DATA_IN_WIDTH:0] out;

    function string to_string();
        string txt;
        txt = super.to_string();
        $sformat(txt, "%s out:0x%h ", txt, out);
        return txt;
    endfunction 

    function new(string name = "adder_rsp_item");
        super.new(name);
    endfunction

endclass