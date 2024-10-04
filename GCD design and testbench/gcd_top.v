module gcd_top #( 
    parameter number_width = 16
)(
  input clk,
  input rst,
  input gcd_start,
  input [number_width - 1 : 0 ] A_in,
  input [number_width - 1 : 0 ] B_in,
  output [number_width - 1 : 0 ] res,
  output GCD_done

);

/*Interconnection definitions*/
wire ld_A_top;
wire ld_B_top;
wire MUXA_top;
wire MUXB_top;
wire res_en_top;
wire [1:0] compare_signal;


/*Instantiation*/ 
gcd_controller fsm_controller (
    .clk(clk),
    .rst(rst),
  /*input signals to controller*/
  .start(gcd_start),
  .compare_st(compare_signal),
  /*output signals from controller*/
  .ld_A(ld_A_top),
  .ld_B(ld_B_top),
  .MUXA(MUXA_top),
  .MUXB(MUXB_top),
  .res_en(res_en_top),
  /*GCD finished operation signals*/
  .GCD_done(GCD_done)
);

  gcd_dp #(.number_width(number_width)) datapath (
    .clk(clk), 
    .rst(rst),
  /*Input values*/  
  .A(A_in),
  .B(B_in),
  /*Input signals from controller*/
  .ld_A(ld_A_top),
  .ld_B(ld_B_top),
  .MUXA(MUXA_top),
  .MUXB(MUXB_top),
  .res_en(res_en_top),
  /* Outputs of datapath */
  .compare_state(compare_signal),
  .res(res)
);
    
endmodule