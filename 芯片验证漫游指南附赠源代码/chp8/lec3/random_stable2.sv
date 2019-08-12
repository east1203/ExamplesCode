module m1;
//initial begin: proc1
//  $display("m1::proc1 randnum %0d", $urandom_range(0, 100));
//end
initial begin: proc2
//$display("m1::proc2.sub1 randnum %0d", $urandom_range(0, 100));
  $display("m1::proc2.sub2 randnum %0d", $urandom_range(0, 100));
//$display("m1::proc2.sub3 randnum %0d", $urandom_range(0, 100));
end
//initial begin: proc3
//  $display("m1::proc3 randnum %0d", $urandom_range(0, 100));
//end
endmodule

module top;
m1 i1();
endmodule
