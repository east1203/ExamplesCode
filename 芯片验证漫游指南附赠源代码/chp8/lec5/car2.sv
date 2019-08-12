

class car;
  event start;

  task launch();
    -> start;
    $display("car is launched");
  endtask

  task move();
    wait(start.triggered);
    $display("car is moving");
  endtask

  task drive();
    fork
      this.launch();
      this.move();
    join
  endtask
endclass

module road;
initial begin
  automatic car byd = new();
  byd.drive();
end
endmodule
