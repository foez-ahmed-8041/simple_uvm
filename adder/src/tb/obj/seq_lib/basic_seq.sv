class basic_seq extends uvm_sequence #(adder_seq_item);

    `uvm_object_utils(basic_seq)

    function new(string name="basic_seq");
        super.new(name);
    endfunction

    virtual task body();

        for (int i = 0; i < 25; i++)
        begin
            adder_seq_item itm = adder_seq_item::type_id::create("itm");
            start_item(itm);
            itm.randomize();
            finish_item(itm);
        end

    endtask

endclass