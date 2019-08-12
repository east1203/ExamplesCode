

class car;
  semaphore key;

  function new();
    key = new(1);
  endfunction

  task get_on(string p);
    $display("%s is waiting for the key", p);
    key.get();
    #1ns;
    $display("%s got on the car", p);
  endtask

  task get_off(string p);
    $display("%s got off the car", p);
    key.put();
    #1ns;
    $display("%s returned the key", p);
  endtask
endclass

module family;
car byd = new();
string p1 = "husband";
string p2 = "wife";
initial begin
  fork 
    begin
      byd.get_on(p1);
      byd.get_off(p1);
    end
    begin
      byd.get_on(p2);
      byd.get_off(p2);
    end
  join
end
endmodule
