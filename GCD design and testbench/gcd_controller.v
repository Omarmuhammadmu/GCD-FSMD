`define LOGIC_LOW 0
`define LOGIC_HIGH 1
`define ENABLE 1
`define DISABLE 0

module gcd_controller (

  input clk,
  input rst,
  /*input signals to controller*/
  input start,
  input [1:0] compare_st,
  /*output signals from controller*/
  output reg ld_A,
  output reg ld_B,
  output reg MUXA,
  output reg MUXB,
  output reg res_en,
  /*GCD finished operation signals*/
  output reg GCD_done
);

parameter state_reg_width = 3;
parameter [state_reg_width - 1 :0] start_polling_state = 0,
                                   load_input_state = 1,
                                   Is_A_equal_B_state = 2,
                                   A_gt_B_state = 3,
                                   A_lt_B_state = 4,
                                   A_eq_B_state = 5;
    
reg [state_reg_width - 1 :0] curr_state, next_state;

/*compare states*/
parameter [1:0] greater = 0,
                smaller = 1,
                equal = 2,
                notequal = 3;


/*State register*/
always @(posedge clk) begin
  if(rst) begin
        curr_state <= start_polling_state;
    end
    else begin
        curr_state <= next_state; 
    end
end

/*State logic*/
always @(*) begin
    /*Default values*/
  MUXA = `LOGIC_HIGH;
  MUXB = `LOGIC_HIGH;
  ld_A = `LOGIC_LOW;
  ld_B = `LOGIC_LOW;
  res_en = `DISABLE;
  GCD_done = `LOGIC_LOW;

case(curr_state)
    start_polling_state:begin

      if(start == `LOGIC_HIGH) begin
            next_state = load_input_state;
        end
        else begin
            next_state = start_polling_state;
        end
    end
    load_input_state: begin
        MUXA = `LOGIC_HIGH;
        MUXB = `LOGIC_HIGH;
        ld_A = `LOGIC_HIGH;
        ld_B = `LOGIC_HIGH;

        next_state = Is_A_equal_B_state;

    end
                
    Is_A_equal_B_state: begin
        if(compare_st == equal) begin
            next_state = A_eq_B_state;
        end
      else if(compare_st == greater) begin
            next_state = A_gt_B_state;
        end
      else begin
            next_state = A_lt_B_state;
      end
    end

  A_eq_B_state: begin
    res_en = `ENABLE;
    GCD_done = `ENABLE;
    next_state = start_polling_state;
    end

  A_gt_B_state: begin
        /*LOGIC signals*/
        MUXA = `LOGIC_LOW;
        ld_A = `LOGIC_HIGH;
        /*Set next state*/
        next_state = Is_A_equal_B_state;

    end

    A_lt_B_state: begin
        /*LOGIC signals*/
        MUXB = `LOGIC_LOW;
        ld_B = `LOGIC_HIGH;
        /*Set next state*/
        next_state = Is_A_equal_B_state;
    end

    endcase
end      
endmodule