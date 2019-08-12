

interface regs_ini_if; 

  logic        clk;
  logic        rstn;
  logic [ 1:0] cmd;
  logic [ 7:0] cmd_addr; 
  logic [31:0] cmd_data_w;
  logic [31:0] cmd_data_r;

endinterface: regs_ini_if
