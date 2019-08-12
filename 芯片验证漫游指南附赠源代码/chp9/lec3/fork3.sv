module fork_case3;
  int i;
  int id = 0;
  task t1();
    $display("t1[%0d] start", id);
    id++;
    #15ns;
    $display("t1[%0d] finish", id);
  endtask

  task tkill();
    #10ns;
    $display("@%0t kill thread_trigger", $time);
    disable thread_trigger;
  endtask


  initial begin
    for(i=0; i<3; i++) begin
      fork: thread_trigger
        t1();
      join_none
    end
    tkill();
  end
endmodule




