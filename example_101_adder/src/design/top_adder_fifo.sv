module top_adder_fifo #(
    parameter DATA_IN_WIDTH = 8
) (
    input  logic                     clk_i,
    input  logic                     arst_n,

    input  logic [DATA_IN_WIDTH-1:0] inA,
    input  logic  					 inA_valid,
    output logic   				     inA_ready,
    
    input  logic [DATA_IN_WIDTH-1:0] inB,
    input  logic 					 inB_valid,
    output logic  				     inB_ready,
    
    output logic [DATA_IN_WIDTH:0]   out,
    output logic                     out_valid,
    input  logic                     out_ready
    
 );

    logic [DATA_IN_WIDTH-1:0] in_A;
    logic  					  inA_out_valid;
    logic  					  inA_out_ready;
    logic [DATA_IN_WIDTH-1:0] in_B;
    logic  					  inB_out_valid;
    logic  					  inB_out_ready;
    logic [DATA_IN_WIDTH:0]   out_in;
    logic  					  out_in_valid;
    logic  					  out_in_ready;

    
    adder #( 
        .DATA_IN_WIDTH ( DATA_IN_WIDTH )
    ) ins0 (
        .clk_i      ( clk_i         ),
        .arst_n     ( arst_n        ),
        .in_A       ( in_A          ),
        .in_A_valid ( inA_out_valid ),
        .in_A_ready ( inA_out_ready ),
        .in_B       ( in_B          ),
        .in_B_valid ( inB_out_valid ),
        .in_B_ready ( inB_out_ready ),
        .out        ( out_in        ),
        .out_valid  ( out_in_valid  ),
        .out_ready  ( out_in_ready  )
    );
    

    fifo #(
        .DATA_WIDTH ( DATA_IN_WIDTH ),
        .DEPTH      ( 4            )
    ) ins1 (
        .clk_i          ( clk_i         ),
        .arst_n         ( arst_n        ),
        .data_in        ( inA           ),
        .data_in_valid  ( inA_valid     ),
        .data_in_ready  ( inA_ready     ),
        .data_out       ( in_A          ),
        .data_out_valid ( inA_out_valid ),
        .data_out_ready ( inA_out_ready )
    );
 
    fifo #(
        .DATA_WIDTH ( DATA_IN_WIDTH ),
        .DEPTH      ( 4            )
    ) ins2 (
        .clk_i          ( clk_i         ),
        .arst_n         ( arst_n        ),
        .data_in        ( inB           ),
        .data_in_valid  ( inB_valid     ),
        .data_in_ready  ( inB_ready     ),
        .data_out       ( in_B          ),
        .data_out_valid ( inB_out_valid ),
        .data_out_ready ( inB_out_ready )
    );
    
    fifo #(
        .DATA_WIDTH ( DATA_IN_WIDTH+1 ),
        .DEPTH      ( 4               )
    ) ins3 (
        .clk_i          ( clk_i        ),
        .arst_n         ( arst_n       ),
        .data_in        ( out_in       ),
        .data_in_valid  ( out_in_valid ),
        .data_in_ready  ( out_in_ready ),
        .data_out       ( out          ),
        .data_out_valid ( out_valid    ),
        .data_out_ready ( out_ready    )
    );


endmodule
