module fork_case4;
  task t1();
    $display("t1 start");
    #15ns;
    $display("@%0t t1 finish", $time);
  endtask
  task t2();
    $display("t2 start");
    #20ns;
    $display("t2 finish");
    $display("@%0t t2 finish", $time);
  endtask
  task t3();
    $display("t3 start");
    #10ns;
    $display("@%0t t3 finish", $time);
  endtask

  initial begin
    fork
      t1();
    join_none
    fork
      t2();
    join_none
    fork
      t3();
    join_none
    #12ns $display("@%0t disable all descendant fork threads", $time);
    disable fork;
  end
endmodule




