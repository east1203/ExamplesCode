
class car;
  mailbox mb;

  function new();
    mb = new(1);
  endfunction

  task stall;
    int val = 0;
    $display("car::stall started");
    #1ns;
    mb.put(val);
    mb.get(val);
    $display("car::stall finished");
  endtask

  task park;
    int val = 0;
    mb.get(val);
    $display("car::park started");
    #1ns;
    mb.put(val);
    $display("car::park finished");
  endtask

  task drive();
    fork
      this.stall();
      this.park();
    join_none
  endtask
endclass

module road;
car byd = new();
initial begin
  byd.drive();
end
endmodule
