
interface regs_cr_if;

  logic clk;
  logic rstn;

  initial begin
    clk <= 0;
    forever begin
      #5ns clk <= !clk;
    end
  end

  initial begin
    #20ns; 
    rstn <= 1;
    #40ns; 
    rstn <= 0;
    #40ns;
    rstn <= 1;
  end

endinterface: regs_cr_if
