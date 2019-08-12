module proc_case1;
  process p1;
  process p2;
  task t1();
    p1 = process::self();
    $display("@%0t t1 started", $time);
    #15ns;
    $display("@%0t t1 running", $time);
    #15ns;
    $display("@%0t t1 finished", $time);
  endtask
  task t2();
    p2 = process::self();
    $display("@%0t t2 started", $time);
    #20ns;
    $display("@%0t t2 finished", $time);
  endtask

  initial begin
    fork: thread_trigger
      t1();
      t2();
    join_none
    fork
      begin
        #5ns; 
        p1.suspend();
        $display("@%0t t1 state is %s", $time, p1.status());
      end
      begin
        #5ns; 
        p2.kill();
        $display("@%0t t2 state is %s", $time, p2.status());
      end
    join
    #20ns;
    p1.resume();
  end
endmodule




