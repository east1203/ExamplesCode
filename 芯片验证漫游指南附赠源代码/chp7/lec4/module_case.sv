module counter(input clk);
  bit [3:0] cnt;

  always @(posedge clk) begin
    cnt <= cnt + 1;
    $display("@%0t DUT cnt = %0d", $time, cnt);
  end
endmodule

module tb1;
bit clk1;
bit [3:0] cnt;

  initial begin
    forever #5ns clk1 <= !clk1;
  end

  counter dut(clk1);

  always @(posedge clk1) begin
    $display("@%0t TB cnt = %0d", $time, dut.cnt);
  end
endmodule

module tb2;
bit clk1;
bit clk2;
bit [3:0] cnt;

  initial begin
    forever #5ns clk1 <= !clk1;
  end

  always @(clk1) begin
    clk2 <= clk1;
  end

  counter dut(clk1);

  always @(posedge clk2) begin
    $display("@%0t TB cnt = %0d", $time, dut.cnt);
  end
endmodule





