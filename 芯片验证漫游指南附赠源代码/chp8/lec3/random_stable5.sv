class c1;
rand int randnum;
int hist[$];
constraint cstr1 {randnum inside {[0:10]};};
constraint cstr2 {!(randnum inside {hist});};
function void post_randomize();
  hist.push_back(randnum);
endfunction
endclass


module m1;

initial begin
c1 i1;
i1 = new();
  repeat(10) begin
    assert(i1.randomize());
    $display("m1::proc2.i1 randnum %0d", i1.randnum);
  end
end
endmodule

