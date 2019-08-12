
module fork_case1;
  event e1, e2, e3;
  task t1;
    #15ns;
    $display("t1 is leaving");
    -> e1;
  endtask
  task t2;
    #20ns;
    $display("t2 is leaving");
    -> e2;
  endtask
  task t3;
    #10ns;
    $display("t3 is leaving");
    -> e3;
  endtask

  initial begin
    $display("fork:thread_trigger start");
    fork: thread_trigger
      t1();
      t2();
      t3();
    join_none
    $display("fork:thread_trigger finish");
    $display("fork:thread_monitor start");
    fork: thread_monitor
      @e1 $display("bye to t1");
      @e2 $display("bye to t2");
      @e3 $display("bye to t3");
    join
    $display("fork:thread_monitor finish");
  end
endmodule
