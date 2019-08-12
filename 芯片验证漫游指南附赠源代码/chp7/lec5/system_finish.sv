module counter(input clk);
  bit [3:0] cnt;

  always @(posedge clk) begin
    cnt <= cnt + 1;
  end
endmodule

module tb;
bit clk;

  initial begin
    forever #5ns clk <= !clk;
  end

  counter dut(clk);

  initial begin
    #500ns;
    $finish();
    //$stop();
  end
endmodule







