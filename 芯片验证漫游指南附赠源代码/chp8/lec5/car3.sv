

class car;
  event e_start;
  event e_speedup;
  int speed = 0;

  task launch();
    -> e_start;
    $display("car is launched");
  endtask

  task move();
    wait(e_start.triggered);
    $display("car is moving");
  endtask

  task speedup();
    #10ns;
    -> e_speedup;
  endtask

  task display();
    forever begin
      @e_speedup;
      speed++;
      $display("speed is %0d", speed);
    end
  endtask

  task drive();
    fork
      this.launch();
      this.move();
      this.display();
    join_none
  endtask
endclass

module road;
initial begin
  automatic car byd = new();
  byd.drive();
  byd.speedup();
  byd.speedup();
  byd.speedup();
end
endmodule
