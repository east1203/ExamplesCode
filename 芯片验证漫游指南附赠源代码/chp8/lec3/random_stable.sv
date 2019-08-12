module m1;
initial $display("m1::proc1 randnum %0d", $urandom_range(0, 100));
initial $display("m1::proc2 randnum %0d", $urandom_range(0, 100));
endmodule

module m2;
initial $display("m2::proc1 randnum %0d", $urandom_range(0, 100));
initial $display("m2::proc2 randnum %0d", $urandom_range(0, 100));
endmodule


module top;
m1 i1();
m2 i2();
endmodule
