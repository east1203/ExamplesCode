


module clocking1;
  bit vld;
  bit grt;
  bit clk;

  clocking ck @(posedge clk);
    default input #3ns output #3ns;
    input vld;
    output grt;
  endclocking

  initial forever #5ns clk <= !clk;

  initial begin: drv_vld
    $display("$%0t vld initial value is %d", $time, vld);
    #3ns  vld = 1; $display("$%0t vld is assigned %d", $time, vld);
    #10ns vld = 0; $display("$%0t vld is assigned %d", $time, vld);
    #8ns  vld = 1; $display("$%0t vld is assigned %d", $time, vld);
  end

  initial forever 
    @ck $display("$%0t vld is sampled as %d at sampling time $%0t", $time, vld, $time);
  initial forever 
    @ck $display("$%0t ck.vld is sampled as %d at sampling time $%0t", $time, ck.vld, $time-3);
endmodule




module clocking2;
  bit vld;
  bit grt;
  bit clk;

  clocking ck @(posedge clk);
    default input #3ns output #3ns;
    input vld;
    output grt;
  endclocking

  initial forever #5ns clk <= !clk;

  initial begin: drv_grt
    $display("$%0t grt initial value is %d", $time, grt);
    @ck  ck.grt <= 1; $display("$%0t grt is assigned 1", $time);
    @ck  ck.grt <= 0; $display("$%0t grt is assigned 0", $time);
    @ck  ck.grt <= 1; $display("$%0t grt is assigned 1", $time);
  end

  initial forever 
    @grt $display("$%0t grt is driven as %d", $time, grt);
endmodule
