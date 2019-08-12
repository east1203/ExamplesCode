

interface slv_ini_if(
  input rstn,
  input clk 
);
  import slv_pkg::slv_trans;


  logic valid;
  logic [31:0] data;
  logic ready;

  slv_trans mon_fifo[$];

  clocking ck_mon @(posedge clk);
    default input #1step output #1ps;
    input valid;
    input data;
    input ready;
  endclocking

  function void put_trans(slv_trans t);
    mon_fifo.push_back(t);
    $display("slv_ini_if::mon_fifo size is %0d", mon_fifo.size());
  endfunction
endinterface
