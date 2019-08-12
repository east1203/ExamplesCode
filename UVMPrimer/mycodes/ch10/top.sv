
module top;
import tinyalu_pkg::*;

`include "tinyalu_macros.sv"

tinyalu DUT (.A(bfm.A), .B(bfm.B), .op(bfm.op), 
                .clk(bfm.clk), .reset_n(bfm.reset_n), 
                .start(bfm.start), .done(bfm.done), .result(bfm.result));

testbench tb;
tinyalu_bfm bfm();

initial begin
$display("@ 0%t : [top] start top",$time);
  tb = new(bfm);
  tb.execute();
$display("@ 0%t : [top] end top",$time);
end
initial begin
$vcdpluson;
end
endmodule


