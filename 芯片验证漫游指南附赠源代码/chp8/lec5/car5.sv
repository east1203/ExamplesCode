
class carkeep;
  int key = 1;
  string q[$];
  string user;

  task keep_car();
    fork
      forever begin
        wait(q.size() != 0 && key != 0);
        user = q.pop_front();
        key--;
      end
    join_none;
  endtask

  task get_key(string p);
    q.push_back(p);
    wait(user == p);
  endtask

  task put_key(string p);
    if(user == p) begin
      user = "none";
      key++;
    end
  endtask
endclass

class car;
  carkeep keep;

  function new();
    keep = new();
  endfunction

  task drive();
    keep.keep_car();
  endtask

  task get_on(string p);
    $display("%s is waiting for the key", p);
    keep.get_key(p);
    #1ns;
    $display("%s got on the car", p);
  endtask

  task get_off(string p);
    $display("%s got off the car", p);
    keep.put_key(p);
    #1ns;
    $display("%s returned the key", p);
  endtask
endclass

module family;
car byd = new();
string p1 = "husband";
string p2 = "wife";
initial begin
  byd.drive();
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
