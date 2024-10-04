module gcd_dp #( 
    parameter number_width = 16
)(
   input clk, rst,
  /*Input values*/  
  input [number_width - 1 : 0 ] A,
  input [number_width - 1 : 0 ] B,
  /*Input signals from controller*/
  input ld_A,
  input ld_B,
  input MUXA,
  input MUXB,
  input res_en, 
  /* Outputs of datapath */
  output [1:0] compare_state,
  output [number_width - 1 : 0 ] res
);

/*Internal connections and regesters*/
reg [number_width - 1 : 0 ] REG_A, REG_B, REG_res;
wire [number_width - 1 : 0 ] MUX_A_out, MUX_B_out;
wire [number_width - 1 : 0 ] Subtractor_A_out, Subtractor_B_out, GCD_result;

always @(posedge clk) begin
    if(rst) begin
        REG_A <=0;
        REG_B <=0;
        REG_res <=0;
    end
    else begin
        if(ld_A == 1)begin
            REG_A <= MUX_A_out;
        end
        if(ld_B == 1)begin
            REG_B <= MUX_B_out;
        end
        if(res_en == 1) begin
            REG_res <= GCD_result;
        end
    end
end

assign res = REG_res;
/*compare states*/
localparam [1:0] greater = 0,
                smaller = 1,
                equal = 2,
                notequal = 3;

/*REG_A and REG_B MUXS */
assign MUX_A_out = (MUXA == 1)? A : Subtractor_A_out;
assign MUX_B_out = (MUXB == 1)? B : Subtractor_B_out;

/*Subtractors */
assign Subtractor_A_out = REG_A - REG_B;
assign Subtractor_B_out = REG_B - REG_A;

/*Comparator*/
gcd_dp_comparator #(number_width) comparator (
    .comp1(REG_A),
    .comp2(REG_B),
    .compare_result(compare_state),
    .res(GCD_result)
);

endmodule