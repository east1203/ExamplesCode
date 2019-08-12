
module design_race;

logic clk;
logic rstn;
logic [3:0] a;
logic [3:0] b;
int clk_cnt;

  initial begin
    clk <= 0;
    forever begin
      #5ns clk <= !clk;
    end
  end

  initial begin
    #10ns; 
    rstn <= 1;
    #10ns; 
    rstn <= 0;
    #10ns;
    rstn <= 1;
  end

  always @(posedge clk or negedge rstn) begin
    if(rstn == 0) begin
      a <= 0;
      b <= 0;
    end
    else begin
      a <= a + 1;
      b <= a;
      $display("@%0t a=%0d, b=%0d", $time, a, b);

    end
  end


endmodule
