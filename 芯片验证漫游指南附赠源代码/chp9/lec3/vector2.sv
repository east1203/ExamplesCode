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
      repeat(3) begin
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
vector slv_vec[3];
vector reg_vec;
vector fmt_vec;
stimulator slv_stm[3];
stimulator reg_stm;
stimulator fmt_stm;
event build_end_e;
event connect_end_e;
initial begin: build
  foreach(slv_vec[i]) slv_vec[i] = new();
  reg_vec = new();
  fmt_vec = new();
  foreach(slv_stm[i]) slv_stm[i] = new();
  reg_stm = new();
  fmt_stm = new();
  -> build_end_e;
end

initial begin: connect
  wait(build_end_e.triggered());
  foreach(slv_vec[i]) slv_vec[i].put_port = slv_stm[i].get_port;
  reg_vec.put_port = reg_stm.get_port;
  fmt_vec.put_port = fmt_stm.get_port;
  ->connect_end_e;
end

initial begin: run
  wait(connect_end_e.triggered());
  fork
    foreach(slv_stm[i]) slv_stm[i].run();
    reg_stm.run();
    fmt_stm.run();
  join_none
  reg_vec.run();
  fork
    fmt_vec.run();
  join_none
  fork
    foreach(slv_vec[i]) slv_vec[i].run(); 
  join_none
end
endmodule
