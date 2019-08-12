module counter(input clk);
  bit [3:0] cnt;

  always @(posedge clk) begin
    cnt <= cnt + 1;
    $display("@%0t DUT cnt = %0d", $time, cnt);
  end
endmodule

program dsample(input clk);

  initial begin
    forever begin
      @(posedge clk); 
      $display("@%0t TB cnt = %0d", $time, dut.cnt);
    end
  end
endprogram


module tb;
bit clk1;
bit [3:0] cnt;

  initial begin
    forever #5ns clk1 <= !clk1;
  end

  counter dut(clk1);
  dsample spl(clk1);
endmodule
