
class scoreboard;

virtual tinyalu_bfm bfm;

function new (virtual tinyalu_bfm b);
     bfm = b;
   endfunction : new

task execute();
  shortint result_predict;
  $display("@ 0%t : [scoreboard] scoreboard is executed beginning !!!",$time);
  forever begin
    @(posedge bfm.done);
    case(bfm.op)
     add_op:  result_predict = bfm.A + bfm.B;
     and_op:  result_predict = bfm.A & bfm.B;
     xor_op:  result_predict = bfm.A ^ bfm.B;
     mul_op:  result_predict = bfm.A * bfm.B;
    endcase

    if(bfm.op!=no_op && bfm.op!=rst_op)
      if (result_predict != bfm.result)
               $error ("FAILED: A: %0h  B: %0h  op: %s result: %0h",
                       bfm.A, bfm.B, bfm.op_set.name(), bfm.result);
  end
  $display("@ 0%t : [scoreboard] scoreboard is executed ending !!!",$time);

endtask

endclass


