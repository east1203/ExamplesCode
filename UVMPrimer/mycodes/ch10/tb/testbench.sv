

class testbench;

virtual tinyalu_bfm bfm;
tester tester_h;
scoreboard scb_h;
coverage cov_h;

function new(virtual tinyalu_bfm b);
  bfm = b;
endfunction

task execute();
$display("@ %0t : [testbench] testbench is executed beginning !!! ",$time);
  tester_h = new(bfm);
  scb_h = new(bfm);
  cov_h = new(bfm);
  fork
    tester_h.execute();
    scb_h.execute();
    cov_h.execute();
  join_none
$display("@ %0t : [testbench] testbench is executed ending !!! ",$time);
endtask:execute

endclass:testbench


