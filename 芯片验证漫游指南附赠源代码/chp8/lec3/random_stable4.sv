class c1;
rand int randnum;
constraint cstr {randnum inside {[0:100]};};
function new(int seed);
  srandom(seed);
endfunction
endclass


module m1;
initial begin: proc1
  process::self.srandom(10);
  $display("m1::proc1 randnum %0d", $urandom_range(0, 100));
end

initial begin: proc2
c1 i1;
i1 = new(10);
assert(i1.randomize());
$display("m1::proc2.i1 randnum %0d", i1.randnum);
end
endmodule

