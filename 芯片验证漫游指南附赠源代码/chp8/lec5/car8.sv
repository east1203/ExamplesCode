
class car;
  event e_stall;
  event e_park;

  task stall;
    $display("car::stall started");
    #1ns;
    -> e_stall;
    @e_park;
    $display("car::stall finished");
  endtask

  task park;
    @e_stall;
    $display("car::park started");
    #1ns;
    -> e_park;
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
