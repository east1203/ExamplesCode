class c1;
rand int randnum;
constraint cstr {randnum inside {[0:100]};};
endclass


module m1;
//initial begin: proc1
//  $display("m1::proc1 randnum %0d", $urandom_range(0, 100));
//end

initial begin: proc2
c1 i1;
//$display("m1::proc2.sub1 randnum %0d", $urandom_range(0, 100));
i1 = new();
assert(i1.randomize());
$display("m1::proc2.i1 randnum %0d", i1.randnum);
end

endmodule

