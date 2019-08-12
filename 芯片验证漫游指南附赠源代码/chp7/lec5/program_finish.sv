module counter(input clk);
  bit [3:0] cnt;

  always @(posedge clk) begin
    cnt <= cnt + 1;
  end
endmodule


program pgm1;
  initial begin: proc1
    #100ns;
    $display("@%0t p1.proc1 finished", $time);
  end

  initial begin: proc2
    #200ns;
    $display("@%0t p1.proc2 finished", $time);
  end
endprogram

program pgm2;
  initial begin: proc1
    #700ns;
    $display("@%0t p2.proc1 finished", $time);
    $exit();
  end

  initial begin: proc2
    forever begin
      #300ns;
      $display("@%0t p2.proc2 loop", $time);
    end
  end
endprogram


module tb;
bit clk;

  initial begin
    forever #5ns clk <= !clk;
  end

  counter dut(clk);
  pgm1 p1();
  pgm2 p2();

endmodule





