class tester;

virtual tinyalu_bfm bfm;



function new(virtual tinyalu_bfm b);
  bfm = b;
endfunction

protected function operation_t get_op();
  bit[2:0] choice;
  choice = $random;
  case(choice)
   3'b000:  return no_op;
   3'b001:  return add_op;
   3'b010:  return and_op;
   3'b011:  return xor_op;
   3'b100:  return mul_op;
   3'b101:  return no_op;
   3'b110:  return rst_op;
   3'b111:  return rst_op;
  endcase
endfunction

protected function byte unsigned get_data();
  bit[1:0] rdm;
  rdm =$random;
  case(rdm)
    2'b00: return 8'h00;
    2'b11:  return 8'hff;
    default: return $random;
  endcase
endfunction

task execute();
  byte         unsigned        iA;
  byte         unsigned        iB;
  shortint     unsigned        result;
  operation_t                  op_set;
  
  $display("@ 0%t : [tester] tester is executed beginning !!!",$time);
  bfm.reset_alu();
  iA = get_data();
  iB = get_data();
  op_set = rst_op;
  bfm.send_op(iA,iB,op_set,result);
  op_set = mul_op;
  bfm.send_op(iA,iB,op_set,result);
  bfm.send_op(iA,iB,op_set,result);
  op_set = rst_op;
  bfm.send_op(iA,iB,op_set,result);
  repeat(10) begin
    iA = get_data();
    iB = get_data();
    op_set = get_op();
    bfm.send_op(iA,iB,op_set,result);
    $display("@ %0t : [tester] %2h %6s %2h = %4h",$time,iA, op_set.name(), iB, result); 
  end
    $finish;


  $display("@ %0t : [tester] tester is executed ending !!!",$time);
endtask


endclass


