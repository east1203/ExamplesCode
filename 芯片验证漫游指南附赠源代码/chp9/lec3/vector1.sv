
class trans;
  rand bit [7:0] addr;
  rand bit [31:0] data_arr[];
  rand int size;
  constraint c1 {soft size inside {4, 8, 16};
                 data_arr.size() == size;};
endclass

class vector;
  mailbox #(trans) put_port;
  trans t;

  task run();
    fork
      forever begin
        gen_trans();
        put_trans();
      end
    join_none
  endtask
  function void gen_trans();
    t = new();
    t.randomize();
    $display("@%0t vector:: generated one trans", $time);
  endfunction
  task put_trans();
    put_port.put(t);
    $display("@%0t vector:: put one trans", $time);
  endtask
endclass

class stimulator;
  mailbox #(trans) get_port;
  trans t;

  function new();
    get_port = new(1);
  endfunction

  task run();
    fork
      forever begin
        get_trans();
        drive();
      end
    join
  endtask
  task drive();
    #5ns;
    $display("@%0t stim:: drive the trans", $time);
  endtask
  task get_trans();
    get_port.get(t);
    $display("@%0t stim:: got one trans", $time);
  endtask
endclass


module tb;
vector v;
stimulator s;
event build_end_e;
event connect_end_e;
initial begin: build
  v = new();
  s = new();
  -> build_end_e;
end

initial begin: connect
  wait(build_end_e.triggered());
  v.put_port = s.get_port;
  ->connect_end_e;
end

initial begin: run
  wait(connect_end_e.triggered());
  fork 
    v.run();
    s.run();
  join_none
end
endmodule
