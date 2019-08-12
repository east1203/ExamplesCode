

class car;
  mailbox tmp_mb;
  mailbox spd_mb;
  mailbox fuel_mb;
  int sample_period;

  function new();
    sample_period = 10;
    tmp_mb = new();
    spd_mb = new();
    fuel_mb = new();
  endfunction

  task sensor_tmp;
    int tmp;
    forever begin
      std::randomize(tmp) with {tmp >= 80 && tmp <= 100;};
      tmp_mb.put(tmp);
      #sample_period;
    end
  endtask

  task sensor_spd;
    int spd;
    forever begin
      std::randomize(spd) with {spd>= 50 && spd <= 60;};
      spd_mb.put(spd);
      #sample_period;
    end
  endtask

  task sensor_fuel;
    int fuel;
    forever begin
      std::randomize(fuel) with {fuel>= 30 && fuel <= 35;};
      fuel_mb.put(fuel);
      #sample_period;
    end
  endtask

  task drive();
    fork
      sensor_tmp();
      sensor_spd();
      sensor_fuel();
      display(tmp_mb, "temperature");
      display(spd_mb, "speed");
      display(fuel_mb, "feul");
    join_none
  endtask

  task display(mailbox mb, string name="mb");
    int val;
    forever begin
      mb.peek(val);
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
