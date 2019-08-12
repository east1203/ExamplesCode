

class car;
  bit start = 0; 

  task launch();
    start = 1;
    $display("car is launched");
  endtask

  task move();
    wait(start == 1);
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
