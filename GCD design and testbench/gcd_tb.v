`define SET 1
`define RESET 0
`define LOGIC_HIGH 1
`define LOGIC_LOW 0
`timescale 1ns/1ps
module gcd_tb;
/*Setting clock*/
  parameter clk_period = 10;
  reg clk = `RESET;
  always #(clk_period/2) clk = ~ clk;
  
  /*inputs and outputs declarations*/
  parameter number_width_tb = 16;

  reg rst_tb;
  reg gcd_start_tb;
  reg [number_width_tb - 1 : 0 ] A_in_tb;
  reg  [number_width_tb - 1 : 0 ] B_in_tb;
  wire [number_width_tb - 1 : 0 ] res_tb;
  wire GCD_done_tb;
  
  /*gcd instance*/
  gcd_top #(.number_width(number_width_tb)) gcd_top_tb (
    .clk(clk),
    .rst(rst_tb),
    .gcd_start(gcd_start_tb),
    .A_in(A_in_tb),
    .B_in(B_in_tb),
    .res(res_tb),
    .GCD_done(GCD_done_tb)
);
  
/*Task description: Task to reset GCD FSM control unit*/
  task reset_GCD_FSMController;
  begin
    rst_tb = `SET;
    #(clk_period)
    rst_tb = `RESET;
    end
  endtask
  

/*Task description: Task to set the two numbers on which the GCD will be done*/
  task gcd (
    input [number_width_tb - 1 : 0 ] num_1,
    input [number_width_tb - 1 : 0 ] num_2
  );
  begin
    A_in_tb = num_1;
    B_in_tb = num_2;  
    #(clk_period);
    gcd_start_tb = `SET;
    wait (GCD_done_tb == `LOGIC_HIGH);
    #(clk_period)  /*Delay so GCD can reset*/
    $display("The gretest common divisor is %d", res_tb);
    end
  endtask

  always @(posedge GCD_done_tb)begin
  reset_GCD_FSMController();
  gcd_start_tb = `RESET;
  end

initial begin
  
/*Reseting the FSM controller state*/
reset_GCD_FSMController();

gcd(24,8); /*The answer should be 6*/

/*Proven outputs*/
gcd(45,30); /*The answer should be 15*/
gcd(30,45); /*The answer should be 15*/

/*Equal case*/
gcd(45,45); /*The answer should be 45*/
gcd(45,9); /*The answer should be 45*/
#(clk_period);
 $finish;
end

endmodule