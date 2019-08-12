

class car;
  int tmp_q[$];
  int spd_q[$];
  int fuel_q[$];
  int sample_period;

  function new();
    sample_period = 10;
  endfunction

  task sensor_tmp;
    int tmp;
    forever begin
      std::randomize(tmp) with {tmp >= 80 && tmp <= 100;};
      tmp_q.push_back(tmp);
      #sample_period;
    end
  endtask

  task sensor_spd;
    int spd;
    forever begin
      std::randomize(spd) with {spd>= 50 && spd <= 60;};
      spd_q.push_back(spd);
      #sample_period;
    end
  endtask

  task sensor_fuel;
    int fuel;
    forever begin
      std::randomize(fuel) with {fuel>= 30 && fuel <= 35;};
      fuel_q.push_back(fuel);
      #sample_period;
    end
  endtask

  task drive();
    fork
      sensor_tmp();
      sensor_spd();
      sensor_fuel();
      display("temperature", tmp_q);
      display("speed", spd_q);
      display("feul", fuel_q);
    join_none
  endtask

  task display(string name, ref int q[$]);
    int val;
    forever begin
      wait(q.size() > 0);
      val = q.pop_front();
      $display("car::%s is %0d", name, val);
    end
  endtask
endclass

module road;
car byd = new();
initial begin
  byd.drive();
end
endmodule
