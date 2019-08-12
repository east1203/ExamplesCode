module fork_case2;
  task t1();
    #15ns;
    $display("t1 is leaving");
  endtask

  task tkill();
    #10ns;
    $display("@%0t kill thread_trigger", $time);
    disable thread_trigger;
    $display("I am still alive");
  endtask

  initial begin
    $display("fork:thread_trigger start");
    fork: thread_trigger
      t1();
      tkill();
    join_none
    $display("fork:thread_trigger finish");
  end
endmodule

