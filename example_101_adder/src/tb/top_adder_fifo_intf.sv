interface top_adder_fifo_intf #(
    parameter DATA_IN_WIDTH = 0
) (
    input logic clk_i,
    input logic arst_n
); 

    logic [DATA_IN_WIDTH-1:0] inA       ;
    logic                     inA_valid ;
    logic                     inA_ready ;
    logic [DATA_IN_WIDTH-1:0] inB       ;
    logic                     inB_valid ;
    logic                     inB_ready ;
    logic [DATA_IN_WIDTH:0]   out             ;
    logic                     out_valid;
    logic                     out_ready;

endinterface