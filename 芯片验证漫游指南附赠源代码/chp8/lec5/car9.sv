
class car;
  semaphore key;

  function new();
    key = new(0);
  endfunction

  task stall;
    $display("car::stall started");
    #1ns;
    key.put();
    key.get();
    $display("car::stall finished");
  endtask

  task park;
    key.get();
    $display("car::park started");
    #1ns;
    key.put();
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
