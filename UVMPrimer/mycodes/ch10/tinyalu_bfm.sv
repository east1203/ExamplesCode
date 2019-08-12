
// time : 2019-01-12

interface tinyalu_bfm;
import tinyalu_pkg::*;

bit clk;
bit reset_n;
byte unsigned A;
byte unsigned B;
wire [2:0] op;
bit start;
wire done;
wire [15:0] result;
operation_t  op_set;

assign op = op_set;
initial begin
  clk = 0;
  forever #10 clk = ~clk;
end

task reset_alu();
  reset_n = 0;
  @(negedge clk);
  @(negedge clk);
  reset_n = 1;
  start = 0;
endtask

task send_op(input byte iA, input byte iB, input operation_t iop, output shortint alu_result);
  if(iop == rst_op) begin
    @(negedge clk);
    reset_n = 0;
    start = 0;
    @(negedge clk);
    #1;
    reset_n = 1;
  end
  else begin
    @(negedge clk);
    A = iA;
    B = iB;
    op_set = iop;
    start = 1;
    if(iop==no_op) begin
      @(posedge clk);
      #1;
      start = 0;
    end
    else begin
      do 
        @(negedge clk);
      while(done==0);
      start = 0;
    end
  end

alu_result = result;
endtask


endinterface

